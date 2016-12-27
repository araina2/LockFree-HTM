#ifndef __SET_H__
#define __SET_H__
#include<intel_defns.h>


typedef unsigned long setkey_t;
typedef void         *setval_t;

typedef struct node_st node_t;
typedef struct set_st set_t;
typedef VOLATILE node_t *sh_node_pt;

struct node_st
{
    int        level;
    setkey_t  k;
    setval_t  v;
    sh_node_pt next[1];
};

struct set_st
{
    node_t head;
};


/*struct node_st
{
    setkey_t k;
    setval_t v;
    node_t *l, *r;
};

struct set_st
{
    node_t root;
    node_t sentinel;
};*/

#ifdef __SET_IMPLEMENTATION__

/*************************************
 * INTERNAL DEFINITIONS
 */

/* Fine for 2^NUM_LEVELS nodes. */
#define NUM_LEVELS 20


/* Internal key values with special meanings. */
#define INVALID_FIELD   (0)    /* Uninitialised field value.     */
#define SENTINEL_KEYMIN ( 1UL) /* Key value of first dummy node. */
#define SENTINEL_KEYMAX (~0UL) /* Key value of last dummy node.  */


/*
 * Used internally be set access functions, so that callers can use
 * key values 0 and 1, without knowing these have special meanings.
 */
#define CALLER_TO_INTERNAL_KEY(_k) ((_k) + 2)


/*
 * SUPPORT FOR WEAK ORDERING OF MEMORY ACCESSES
 */

#ifdef WEAK_MEM_ORDER

/* Read field @_f into variable @_x. */
#define READ_FIELD(_x,_f)                                       \
do {                                                            \
    (_x) = (_f);                                                \
    if ( (_x) == INVALID_FIELD ) { RMB(); (_x) = (_f); }        \
    assert((_x) != INVALID_FIELD);                              \
} while ( 0 )

#else

/* Read field @_f into variable @_x. */
#define READ_FIELD(_x,_f) ((_x) = (_f))

#endif


#else

/*************************************
 * PUBLIC DEFINITIONS
 */

/*
 * Key range accepted by set functions.
 * We lose three values (conveniently at top end of key space).
 *  - Known invalid value to which all fields are initialised.
 *  - Sentinel key values for up to two dummy nodes.
 */
#define KEY_MIN  ( 0U)
#define KEY_MAX  ((~0U) - 3)

//typedef void set_t; /* opaque */

void _init_set_subsystem(void);

/*
 * Allocate an empty set.
 */
set_t *set_alloc(void);

/*
 * Add mapping (@k -> @v) into set @s. Return previous mapped value if
 * one existed, or NULL if no previous mapping for @k existed.
 * 
 * If @overwrite is FALSE, then if a mapping already exists it is not
 * modified, and the existing value is returned unchanged. It is possible
 * to see if the value was changed by observing if the return value is NULL.
 */
setval_t set_update(set_t *s, setkey_t k, setval_t v, int overwrite);

/*
 * Remove mapping for key @k from set @s. Return value associated with
 * removed mapping, or NULL is there was no mapping to delete.
 */
setval_t set_remove(set_t *s, setkey_t k);

/*
 * Look up mapping for key @k in set @s. Return value if found, else NULL.
 */
setval_t set_lookup(set_t *s, setkey_t k);

#endif /* __SET_IMPLEMENTATION__ */


#endif /* __SET_H__ */
