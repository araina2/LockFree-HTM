/******************************************************************************
 * mcas.c
 * 
 * MCAS implemented as described in:
 *  A Practical Multi-Word Compare-and-Swap Operation
 *  Timothy Harris, Keir Fraser and Ian Pratt
 *  Proceedings of the IEEE Symposium on Distributed Computing, Oct 2002
 * 
 * Copyright (c) 2002-2003, K A Fraser
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <sys/resource.h>
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

typedef struct CasDescriptor CasDescriptor_t;
typedef struct CasEntry CasEntry_t;
typedef struct per_thread_state_t per_thread_state_t;

extern int num_threads;

#define ARENA_SIZE 40960

struct per_thread_state_t
{
    int              id;
    CasDescriptor_t *next_descriptor;
    void            *arena;
    void            *arena_lim;
};


static pthread_key_t mcas_ptst_key;

typedef struct pad128 { char pad[128]; } pad128_t;


/* CAS descriptors. */

#define STATUS_IN_PROGRESS  0
#define STATUS_SUCCEEDED    1
#define STATUS_FAILED       2
#define STATUS_ABORTED      3

struct CasEntry {
    void **ptr;
    void *old;
    void *new_val;
};

struct CasDescriptor {
    int              status;
    int              length;
    CasDescriptor_t *pt[MAX_THREADS];
    volatile int              rc;
    CasDescriptor_t *fc; /* free chain */
    CasEntry_t       entries[1];
};

/* Marked pointers. */
typedef unsigned long long ptr_int;
#ifndef MARK_IN_PROGRESS
#define MARK_IN_PROGRESS 1
#endif
#ifndef MARK_PTR_TO_CD
#define MARK_PTR_TO_CD   2
#endif

#define get_markedness(p) (((ptr_int) (p)) & 3)
#define get_unmarked_reference(p) ((void *) (((ptr_int) (p)) & (~3)))
#define get_marked_reference(p,m) ((void *) (((ptr_int) (p)) | m))

static bool_t mcas0 (per_thread_state_t *ptst, CasDescriptor_t *cd);
static per_thread_state_t *get_ptst (void);

pad128_t p0; /* I'm worried these important RO vars might be false shared */
static int cas_sz;
static int num_ptrs = 1024;
static int ptr_mult = 1;
pad128_t p1;

static void *ALLOC(int size)
{
    void *a = calloc(1, size);
    if ( a == NULL ) abort();
    return a;
}

static void *ALLOC_ALONE (int size)
{
    int ps = sysconf(_SC_PAGESIZE);
    int req = ps + size + ps;
    char *res = (char*)(ALLOC(req));
    return (void *)(res + ps);
}

static int next_thread_id = 0;
static per_thread_state_t *ptsts = NULL;

//extern "C" {

static void new_val_arena (per_thread_state_t *ptst, int size)
{
    ptst->arena = (void*)(ALLOC(size));
    if ( !ptst->arena ) abort();
    ptst->arena_lim = (((char *) ptst->arena) + size);
}

static per_thread_state_t *get_ptst (void)
{
    per_thread_state_t *result;
    int r;

    result = (per_thread_state_t *) pthread_getspecific(mcas_ptst_key);

    if ( result == NULL )
    {
        int my_id;
        int largest = sysconf(_SC_PAGESIZE);

        if ( largest < sizeof (per_thread_state_t) )
            largest = sizeof (per_thread_state_t);

        ALLOC (largest);
        result = (per_thread_state_t *)(ALLOC (largest));
        ALLOC (largest);

        do { my_id = next_thread_id; }
        while ( CASIO (&next_thread_id, my_id, my_id + 1) != my_id );

        result->id = my_id;
        ptsts = result;

        new_val_arena(result, ARENA_SIZE);

        r = pthread_setspecific(mcas_ptst_key, result);
        assert(r == 0);
    }

    return result;
}

static void release_descriptor (CasDescriptor_t *cd)
{
    per_thread_state_t *ptst = get_ptst ();	
    cd->fc = ptst->next_descriptor;
    ptst->next_descriptor = cd;
}

int rc_delta_descriptor (CasDescriptor_t *cd,
				int delta)
{
    volatile int rc, new_val_rc = cd->rc;
    //MB();

    do {
	   //printf("\nIn the rc_delta_descriptor loop\n") ;
	    //new_val_rc = cd->rc;
	    rc = new_val_rc;
	  // MB(); 
           //CASIO(&cd->rc, rc, rc + delta);
	  //printf("\nThe value of rc, new_val_rc, delta, cd->rc are %llu, %llu,  %llu and %llu\n", rc, new_val_rc, delta, cd->rc) ;
	   //printf("\nThe result of CASIO is %d\n", CASIO (&(cd->rc), rc, rc + delta));
    } while ( (new_val_rc = (CASIO(&cd->rc, rc, rc + delta))) != rc );

    return rc;
}

static void rc_up_descriptor (CasDescriptor_t *cd)
{
    rc_delta_descriptor(cd, 2);
    MB();
}

static void rc_down_descriptor (CasDescriptor_t *cd)
{
    int old_rc, new_val_rc, cur_rc = cd->rc;

    do {
        old_rc = cur_rc;
        new_val_rc = old_rc - 2;
        if ( new_val_rc == 0 ) new_val_rc = 1; else MB();
    }
    while ( (cur_rc = CASIO(&(cd->rc), old_rc, new_val_rc)) != old_rc );

    if ( old_rc == 2 ) 
        release_descriptor(cd);
}

static CasDescriptor_t *new_val_descriptor (per_thread_state_t *ptst, int length)
{
    //printf("\nIn the new_val_descriptor\n");
    CasDescriptor_t *result;
    int i;
				
    CasDescriptor_t **ptr = &(ptst->next_descriptor);
    result = *ptr;
    while ( (result != NULL) && (result->length != length) )
    {
        ptr = &(result->fc);
        result = *ptr;
    }

    if ( result == NULL )
    {
        int alloc_size;

        alloc_size = sizeof (CasDescriptor_t) + 
            ((length - 1) * sizeof (CasEntry_t));

        result = (CasDescriptor_t *) ptst->arena;
        ptst->arena = ((char *) (ptst->arena)) + alloc_size;

        if ( ptst->arena >= ptst->arena_lim )
        {
            new_val_arena(ptst, ARENA_SIZE);
            result = (CasDescriptor_t *) ptst->arena;
            ptst->arena = ((char *) (ptst->arena)) + alloc_size;
        }

        for ( i = 0; i < num_threads; i++ )
            result->pt[i] = result;
  
        result->length = length;
        result->rc = 2;
    }
    else
    {
        *ptr = result->fc;
	MB();
        assert((result->rc & 1) == 1);
	//printf("\nGoing to the rc delta descriptor 1\n");
        rc_delta_descriptor(result, 1); /* clears lowest bit */
    }

    assert(result->length == length);

    return result;
}

static void *read_from_cd (void **ptr, CasDescriptor_t *cd, bool_t get_old)
{
    CasEntry_t *ce;
    int         i;
    int         n;

    n = cd->length;
    for ( i = 0; i < n; i++ )
    {
        ce = &(cd->entries[i]);
        if ( ce->ptr == ptr )
            return get_old ? ce->old : ce->new_val;
    }

    assert(0);
    return NULL;
}

static void *read_barrier_lite (void **ptr)
{
    CasDescriptor_t *cd;
    void            *v;
    int              m;

 retry_read_barrier:
    v = *ptr;
    m = get_markedness(v);

    if ( m == MARK_PTR_TO_CD )
    {
        WEAK_DEP_ORDER_RMB();
        cd = (CasDescriptor_t*)(get_unmarked_reference(v));

        rc_up_descriptor(cd);
        if ( *ptr != v )
        {
            rc_down_descriptor(cd);
            goto retry_read_barrier;
        }

        v = read_from_cd(ptr, cd, (cd->status != STATUS_SUCCEEDED));

        rc_down_descriptor(cd);
    }
    else if ( m == MARK_IN_PROGRESS )
    {
        WEAK_DEP_ORDER_RMB();
        cd = (CasDescriptor_t *)(get_unmarked_reference(v));

        rc_up_descriptor(cd);
        if ( *ptr != v )
        {
            rc_down_descriptor(cd);
            goto retry_read_barrier;
        }

        v = read_from_cd(ptr, cd, (cd->status != STATUS_SUCCEEDED));

        rc_down_descriptor(cd);
    }

    return v;
}

static void clean_descriptor (CasDescriptor_t *cd)
{
    int   i;
    void *mcd;
    int   status;

    status = cd->status;
    assert(status == STATUS_SUCCEEDED || status == STATUS_FAILED);

    mcd = get_marked_reference(cd, MARK_PTR_TO_CD);

    if (status == STATUS_SUCCEEDED)
        for ( i = 0; i < cd->length; i++ )
            CASPO (cd->entries[i].ptr, mcd, cd->entries[i].new_val);
    else
        for ( i = 0; i < cd->length; i++ )
            CASPO(cd->entries[i].ptr, mcd, cd->entries[i].old);
}

static bool_t mcas_fixup (void **ptr,
			  void *value_read)
{
    int m;
 //printf("\nIn the mcas_fixup\n");
 retry_mcas_fixup:
    //printf("\nThe value of value_read is %llu\n", (unsigned long long)(value_read));
    m = get_markedness(value_read);
    //printf("\nThe value of m is %d\n", m);
    if ( m == MARK_PTR_TO_CD )
    {
        CasDescriptor_t *helpee;
        helpee = (CasDescriptor_t *)(get_unmarked_reference(value_read));

        rc_up_descriptor(helpee);
        if ( *ptr != value_read ) 
        {
            rc_down_descriptor(helpee);
            value_read = *ptr;
            goto retry_mcas_fixup;
        }

        mcas0(NULL, helpee);

        rc_down_descriptor(helpee);

        return TRUE;
    }
    else if ( m == MARK_IN_PROGRESS )
    {
        CasDescriptor_t *other_cd;

        WEAK_DEP_ORDER_RMB();
        other_cd = *(CasDescriptor_t **)get_unmarked_reference(value_read);

        rc_up_descriptor(other_cd);
        if ( *ptr != value_read )
        {
            rc_down_descriptor(other_cd);
            value_read = *ptr;
            goto retry_mcas_fixup;
        }

        if ( other_cd->status == STATUS_IN_PROGRESS )
            CASPO(ptr,
                  value_read, 
                  get_marked_reference(other_cd, MARK_PTR_TO_CD));
        else
            CASPO(ptr,
                  value_read,
                  read_from_cd(ptr, other_cd, TRUE));

        rc_down_descriptor (other_cd);
        return TRUE;
    }

    return FALSE;
}

static void *read_barrier (void **ptr)
{
    void *v;

    do { v = *ptr; }
    while ( mcas_fixup(ptr, v) );

    return v;
}

static bool_t mcas0 (per_thread_state_t *ptst, CasDescriptor_t *cd)
{
  synchronized { // begin synchronized block
    int     i;
    int     n;
    //int     desired_status;
    bool_t  final_success;
    //void   *mcd;
    //void   *dmcd;
    //int     old_status;

    if ( ptst == NULL ) 
        ptst = get_ptst();


    //MB(); /* required for sequential consistency */


    /*if ( cd->status == STATUS_SUCCEEDED )
    {
        //clean_descriptor(cd);
        final_success = TRUE;
        //goto out;
    }
    else if ( cd->status == STATUS_FAILED )
    {
        //clean_descriptor(cd);
        final_success = FALSE;
        //goto out;
    }*/

    /* Attempt to link in all entries in the descriptor. */
    //mcd = get_marked_reference(cd, MARK_PTR_TO_CD);
    //dmcd = get_marked_reference(&(cd->pt[ptst->id]), MARK_IN_PROGRESS);

    //desired_status = STATUS_SUCCEEDED;

 //retry:
    n = cd->length;
    CasEntry_t *ce         = &(cd->entries[0]);
    for (i = 0; i < n; i ++)
    {
        //void       *value_read;// = CASPO(ce->ptr, ce->old, dmcd);
        //value_read = ce->ptr;
	//printf("\nIn the for loop\n");
	if (*(ce->ptr) == ce->old) {
	    //printf("\nComing in the if part\n");	
	    *(ce->ptr) = ce->new_val;
	    final_success = TRUE;
	}
	else {
	    //printf("\nComing in the else part\n");	
	    final_success = FALSE;
	    return final_success;
	}
	ce++;
    }
    return final_success;
    }
}
  //synchronized { // begin synchronized block
    /*int     i;
    int     n;
    int     desired_status;
    bool_t  final_success;
    void   *mcd;
    void   *dmcd;
    int     old_status;

    if ( ptst == NULL ) 
        ptst = get_ptst();*/

    //MB(); /* required for sequential consistency */


    /*if ( cd->status == STATUS_SUCCEEDED )
    {
        clean_descriptor(cd);
        final_success = TRUE;
        goto out;
    }
    else if ( cd->status == STATUS_FAILED )
    {
        clean_descriptor(cd);
        final_success = FALSE;
        goto out;
    }*/

    /* Attempt to link in all entries in the descriptor. */
    /*mcd = get_marked_reference(cd, MARK_PTR_TO_CD);
    dmcd = get_marked_reference(&(cd->pt[ptst->id]), MARK_IN_PROGRESS);

    desired_status = STATUS_SUCCEEDED;

 retry:
    n = cd->length;
    for (i = 0; i < n; i ++)
    {
        CasEntry_t *ce         = &(cd->entries[i]);
        void       *value_read = CASPO(ce->ptr, ce->old, dmcd);

        if ( (value_read != ce->old) &&
             (value_read != dmcd) &&
             (value_read != mcd) )
        {
            if ( mcas_fixup(ce->ptr, value_read) )
                goto retry;
            desired_status = STATUS_FAILED;
            break;
        }*/

        //RMB_NEAR_CAS(); /* ensure check of status occurs after CASPO. */
        /*if ( cd->status != STATUS_IN_PROGRESS )
        {
            CASPO(ce->ptr, dmcd, ce->old);
            break;
        }

        if ( value_read != mcd )
        {
            value_read = CASPO(ce->ptr, dmcd, mcd);
            assert((value_read == dmcd) || 
                   (value_read == mcd) || 
                   (cd->status != STATUS_IN_PROGRESS));
        }
    }*/

    /*
     * All your ptrs are belong to us (or we've been helped and
     * already known to have succeeded or failed).  Try to
     * propagate our desired result into the status field.
     */

    /*
     * When changing to success, we must have all pointer ownerships
     * globally visible. But we get this without a memory barrier, as
     * 'desired_status' is dependent on the outcome of each CASPO
     * to MARK_IN_PROGRESS.
     * 
     * Architectures providing CAS natively all specify that the operation
     * is _indivisible_. That is, the write will be done when the CAS 
     * completes.
     * 
     * Architectures providing LL/SC are even better: any following 
     * instruction in program order is control-dependent on the CAS, because
     * CAS may be retried if SC fails. All we need is that SC gets to point
     * of coherency before producing its result: even Alpha provides this!
     */
    /*WEAK_DEP_ORDER_WMB();
    old_status = CASIO((int *)&cd->status, 
                       STATUS_IN_PROGRESS, 
                       desired_status);*/
    /*
     * This ensures final sequential consistency.
     * Also ensures that the status update is visible before cleanup.
     */
    /*WMB_NEAR_CAS();

    clean_descriptor(cd);
    final_success = (cd->status == STATUS_SUCCEEDED);

 out:
    return final_success;
   //}*/
//}


void mcas_init (void)
{
    int r = pthread_key_create(&mcas_ptst_key, NULL);
    if ( r != 0 ) abort();
}

/***********************************************************************/

bool_t mcas (int n, 
	     void **ptr, void *old, void *new_val,
	     ...)
{
    //printf("\nIn the mcas\n");
    va_list             ap;
    int                 i;
    CasDescriptor_t    *cd;
    CasEntry_t         *ce;
    int                 result = 0;
    per_thread_state_t *ptst = get_ptst();

    cd = new_val_descriptor(ptst, n);

    cd->status = STATUS_IN_PROGRESS;
    cd->length = n;

    ce = cd->entries;
    ce->ptr = ptr;
    ce->old = old;
    ce->new_val = new_val;

    va_start(ap, new_val);
    for ( i = 1; i < n; i++ )
    {
        ce ++;
        ce->ptr = va_arg(ap, void **);
        ce->old = va_arg(ap, void *);
        ce->new_val = va_arg(ap, void *);
    }
    va_end (ap);

    /* Insertion sort. Fail on non-unique pointers. */
    for ( i = 1, ce = &cd->entries[1]; i < n; i++, ce++ )
    {
        int j;
        CasEntry_t *cei, tmp;
        for ( j = i-1, cei = ce-1; j >= 0; j--, cei-- )
            if ( cei->ptr <= ce->ptr ) break;
        if ( cei->ptr == ce->ptr ) goto out;
        if ( ++cei != ce )
        {
            tmp = *ce;
            memmove(cei+1, cei, (ce-cei)*sizeof(CasEntry_t));
            *cei = tmp;
        } 
    }

    result = mcas0(ptst, cd);
    assert(cd->status != STATUS_IN_PROGRESS);

 out:
    rc_down_descriptor (cd);
    return result;
}

//}
