/******************************************************************************
 * skip_mcas.c
 * 
 * Skip lists, allowing concurrent update by use of MCAS primitive.
 * 
 * Copyright (c) 2001-2003, K A Fraser
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

#define __SET_IMPLEMENTATION__

#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "portable_defns.h"
#include "ptst.h"
#include "set.h"

#define MCAS_MARK(_v) ((unsigned long)(_v) & 3)

#define PROCESS(_v, _pv)                        \
  while ( MCAS_MARK(_v) ) {                     \
    mcas_fixup((void **)(_pv), _v);             \
    (_v) = *(_pv);                              \
  }

#define WALK_THRU(_v, _pv)                      \
  if ( MCAS_MARK(_v) ) (_v) = read_barrier_lite((void **)(_pv));

/* Pull in the MCAS implementation. */
#include "mcas.c"

/*
 * SKIP LIST
 */

/*typedef struct node_st node_t;
//typedef struct set_st set_t;
typedef VOLATILE node_t *sh_node_pt;

struct node_st
{
    int        level;
    setkey_t  k;
    setval_t  v;
    sh_node_pt next[1];
};*/
/*
struct set_st
{
    node_t head;
};*/

static int gc_id[NUM_LEVELS];

/*
 * PRIVATE FUNCTIONS
 */

/*
 * Random level generator. Drop-off rate is 0.5 per level.
 * Returns value 1 <= level <= NUM_LEVELS.
 */
static int get_level(ptst_t *ptst)
{
    unsigned long r = rand_next(ptst);
    int l = 1;
    r = (r >> 4) & ((1 << (NUM_LEVELS-1)) - 1);
    while ( (r & 1) ) { l++; r >>= 1; }
    return(l);
}


/*
 * Allocate a new node, and initialise its @level field.
 * NB. Initialisation will eventually be pushed into garbage collector,
 * because of dependent read reordering.
 */
static node_t *alloc_node(ptst_t *ptst)
{
    int l;
    node_t *n;
    l = get_level(ptst);
    n = (node_t *)(gc_alloc(ptst, gc_id[l - 1]));
    n->level = l;
    return(n);
}


/* Free a node to the garbage collector. */
static void free_node(ptst_t *ptst, sh_node_pt n)
{
    gc_free(ptst, (void *)n, gc_id[n->level - 1]);
}


/*
 * Search for first non-deleted node, N, with key >= @k at each level in @l.
 * RETURN VALUES:
 *  Array @pa: @pa[i] is non-deleted predecessor of N at level i
 *  Array @na: @na[i] is N itself, which should be pointed at by @pa[i]
 *  MAIN RETURN VALUE: same as @na[0].
 */
//extern "C" {
sh_node_pt search_predecessors(
    set_t *l, setkey_t k, sh_node_pt *pa, sh_node_pt *na)
{
    sh_node_pt x, x_next;
    setkey_t  x_next_k;
    int        i;
    void **tmp_next;
    void **tmp_nexti;

    RMB();

    x = &l->head;
    for ( i = NUM_LEVELS - 1; i >= 0; i-- )
    {
        for ( ; ; )
        {
            READ_FIELD(x_next, x->next[i]);
            //WALK_THRU(x_next, &x->next[i]);

            //READ_FIELD(x_next_k, x_next->k);
            //WALK_THRU(x_next, &x_nexti);
	    READ_FIELD(tmp_next, (void**)(&x_next));           //tmp_next = (void*)(x_next);
	    READ_FIELD(tmp_nexti, (void**)(&x->next[i]));
            //MB();	    //tmp_nexti = (void*)(x->next[i]); 
            WALK_THRU(*tmp_next, tmp_nexti);
            //MB();	    //tmp_nexti = (void*)(x->next[i]); 
	    READ_FIELD(x_next, (sh_node_pt)(*tmp_next));     //x_next = (sh_node_pt)(tmp_next);
	    READ_FIELD(x->next[i], (sh_node_pt)(*tmp_nexti));    //x->next[i] = (sh_node_pt)(tmp_nexti);
            //MB();	    //tmp_nexti = (void*)(x->next[i]); */
            READ_FIELD(x_next_k, x_next->k);
            //MB();	    //tmp_nexti = (void*)(x->next[i]); 
            if ( x_next_k >= k ) break;

            x = x_next;
        }

        if ( pa ) pa[i] = x;
        if ( na ) na[i] = x_next;
    }

    return(x_next);
}
//}

static setval_t finish_delete(sh_node_pt x, sh_node_pt *preds)
{
    per_thread_state_t *mcas_ptst = get_ptst();
    CasDescriptor_t *cd;
    int level, i, ret = FALSE;
    sh_node_pt x_next;
    setkey_t x_next_k;
    setval_t v;
    void **tmp_next, **tmp_nexti;

    READ_FIELD(level, x->level);

    //printf("\nIn the finish delete function\n");
    cd = new_val_descriptor(mcas_ptst, (level << 1) + 1);
    cd->status = STATUS_IN_PROGRESS;
    cd->length = (level << 1) + 1;
    
    /* First, the deleted node's value field. */
    READ_FIELD(v, x->v);
    PROCESS(v, &x->v);
    if ( v == NULL ) goto fail;
    cd->entries[0].ptr = (void **)&x->v;
    cd->entries[0].old = v;
    cd->entries[0].new_val = NULL;

    for ( i = 0; i < level; i++ )
    {
        READ_FIELD(x_next, x->next[i]);
        //PROCESS(x_next, &x->next[i]);
	READ_FIELD(tmp_next, (void **)(&x->next));//tmp_next = (void*)(x->next);
	READ_FIELD(tmp_nexti, (void **)(&x->next[i]));//tmp_nexti = (void*)(x->next[i]);
        //MB();	    //tmp_nexti = (void*)(x->next[i]); 
        PROCESS(*tmp_next, tmp_nexti);
        //MB();	    //tmp_nexti = (void*)(x->next[i]); 
	READ_FIELD(x_next, (sh_node_pt)(*tmp_next));//x_next = (sh_node_pt)(tmp_next);
	READ_FIELD(x->next[i], (sh_node_pt)(*tmp_nexti));//x->next[i] = (sh_node_pt)(tmp_nexti);
        MB();	    //tmp_nexti = (void*)(x->next[i]); 
        READ_FIELD(x_next_k, x_next->k);
        MB();	    //tmp_nexti = (void*)(x->next[i]); 
        if ( x->k > x_next_k ) { v = NULL; goto fail; }
        cd->entries[i      +1].ptr = (void **)&x->next[i];
        cd->entries[i      +1].old = (void *)(x_next);
        cd->entries[i      +1].new_val = (void *)(preds[i]);
        cd->entries[i+level+1].ptr = (void **)&preds[i]->next[i];
        cd->entries[i+level+1].old = (void *)(x);
        cd->entries[i+level+1].new_val = (void *)(x_next);
    }
    
    ret = mcas0(mcas_ptst, cd);
    if ( ret == 0 ) v = NULL;

 fail:
    rc_down_descriptor(cd);
    return v;
}


/*
 * PUBLIC FUNCTIONS
 */

set_t *set_alloc(void)
{
    set_t *l;
    node_t *n;
    int i;

    static int mcas_inited = 0;
    if ( !CASIO(&mcas_inited, 0, 1) ) mcas_init();

    n = (node_t *)(malloc(sizeof(*n) + (NUM_LEVELS-1)*sizeof(node_t *)));
    memset(n, 0, sizeof(*n) + (NUM_LEVELS-1)*sizeof(node_t *));
    n->k = SENTINEL_KEYMAX;

    /*
     * Set the forward pointers of final node to other than NULL,
     * otherwise READ_FIELD() will continually execute costly barriers.
     * Note use of 0xfc -- that doesn't look like a marked value!
     */
    memset(n->next, 0xfc, NUM_LEVELS*sizeof(node_t *));

    l = (set_t *)(malloc(sizeof(*l) + (NUM_LEVELS-1)*sizeof(node_t *)));
    l->head.k = SENTINEL_KEYMIN;
    l->head.level = NUM_LEVELS;
    for ( i = 0; i < NUM_LEVELS; i++ )
    {
        l->head.next[i] = n;
    }

    return(l);
}


setval_t set_update(set_t *l, setkey_t k, setval_t v, int overwrite)
{
    unsigned long *check_val = (unsigned long *)&v;
    //printf("\nThe value of v in set_update is %lu\n", *check_val);
    setval_t  ov, new_ov;
    ptst_t    *ptst;
    sh_node_pt preds[NUM_LEVELS], succs[NUM_LEVELS];
    sh_node_pt succ, new_val = NULL;
    int        i, ret;
    per_thread_state_t *mcas_ptst = NULL;
    CasDescriptor_t *cd;

    k = CALLER_TO_INTERNAL_KEY(k);

    //printf("\nComing before critical section\n");
    ptst = critical_enter();
    //printf("\nCame after critical section\n");
    do {
    retry:
        ov = NULL;

        succ = search_predecessors(l, k, preds, succs);
    
        if ( succ->k == k )
        {
            /* Already a @k node in the list: update its mapping. */
            READ_FIELD(new_ov, succ->v);
            do {
                ov = new_ov;
                PROCESS(ov, &succ->v);
                if ( ov == NULL ) goto retry;
            }
            while ( overwrite && ((new_ov = CASPO(&succ->v, ov, v)) != ov) );

            if ( new_val != NULL ) free_node(ptst, new_val);
            goto out;
        }

#ifdef WEAK_MEM_ORDER
        /* Free node from previous attempt, if this is a retry. */
        if ( new_val != NULL ) 
        { 
            free_node(ptst, new_val);
            new_val = NULL;
        }
#endif

        /* Not in the list, so initialise a new node for insertion. */
        if ( new_val == NULL )
        {
            new_val    = alloc_node(ptst);
            new_val->k = k;
            new_val->v = v;
        }

        for ( i = 0; i < new_val->level; i++ )
        {
            new_val->next[i] = succs[i];
        }

        if ( !mcas_ptst ) mcas_ptst = get_ptst();
        //printf("\nIn the skipcas set update function\n");
        cd = new_val_descriptor(mcas_ptst, new_val->level);
        cd->status = STATUS_IN_PROGRESS;
        cd->length = new_val->level;
        for ( i = 0; i < new_val->level; i++ )
        {
            cd->entries[i].ptr = (void **)&preds[i]->next[i];
            cd->entries[i].old = (void *)(succs[i]);
            cd->entries[i].new_val = (void *)(new_val);
        }
        ret = mcas0(mcas_ptst, cd);
        rc_down_descriptor(cd);
    }
    while ( !ret );

 out:
    critical_exit(ptst);
    return(ov);
}


setval_t set_remove(set_t *l, setkey_t k)
{
    setval_t  v = NULL;
    ptst_t    *ptst;
    sh_node_pt preds[NUM_LEVELS], x;

    k = CALLER_TO_INTERNAL_KEY(k);
  
    ptst = critical_enter();
    
    do {
        x = search_predecessors(l, k, preds, NULL);
        if ( x->k > k ) goto out;
    } while ( (v = finish_delete(x, preds)) == NULL );

    free_node(ptst, x);

 out:
    critical_exit(ptst);
    return(v);
}


setval_t set_lookup(set_t *l, setkey_t k)
{
    setval_t  v = NULL;
    ptst_t    *ptst;
    sh_node_pt x;

    k = CALLER_TO_INTERNAL_KEY(k);

    ptst = critical_enter();

    x = search_predecessors(l, k, NULL, NULL);
    if ( x->k == k ) 
    {
        READ_FIELD(v, x->v);
        WALK_THRU(v, &x->v);
    }

    critical_exit(ptst);
    return(v);
}


void _init_set_subsystem(void)
{
    int i;

    for ( i = 0; i < NUM_LEVELS; i++ )
    {
        gc_id[i] = gc_add_allocator(sizeof(node_t) + i*sizeof(node_t *));
    }
    
}
