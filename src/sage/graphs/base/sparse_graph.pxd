#*****************************************************************************
#       Copyright (C) 2008-2009 Robert L. Miller <rlmillster@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#                  http://www.gnu.org/licenses/
#*****************************************************************************

from .c_graph cimport CGraph, CGraphBackend
cimport cython

cdef struct SparseGraphLLNode:
    int label
    int number
    SparseGraphLLNode *next

cdef struct SparseGraphBTNode:
    int vertex
    int number
    SparseGraphLLNode *labels
    SparseGraphBTNode *left
    SparseGraphBTNode *right

@cython.final
cdef class SparseGraph(CGraph):
    cdef int hash_length
    cdef int hash_mask
    cdef SparseGraphBTNode **vertices
    cdef SparseGraphBTNode **vertices_rev
    cdef bint _directed
    cpdef bint is_directed(self)

    cdef int _add_arc_unsafe(self, int, int, SparseGraphBTNode **) except -1
    cdef int _del_arc_unsafe(self, int, int, SparseGraphBTNode **) except -1
    cdef int _add_arc_label_unsafe(self, int, int, int, SparseGraphBTNode **) except -1
    cdef int add_arc_label_unsafe(self, int, int, int) except -1
    cdef int arc_label_unsafe(self, int, int)
    cpdef int arc_label(self, int u, int v)
    cdef int all_arcs_unsafe(self, int, int, int *, int)
    cdef int _del_arc_label_unsafe(self, int, int, int, SparseGraphBTNode **)
    cdef int del_arc_label_unsafe(self, int, int, int)
    cdef SparseGraphLLNode* arc_labels_unsafe(self, int u, int v)
    cpdef del_arc_label(self, int u, int v, int l)
    cdef int has_arc_label_unsafe(self, int, int, int)
    cpdef bint has_arc_label(self, int u, int v, int l)
    cpdef int out_degree(self, int u)
    cpdef int in_degree(self, int u)
    cdef int out_neighbors_BTNode_unsafe(self, int u, SparseGraphBTNode *** p_pointers)
    cdef list out_arcs_unsafe(self, int u, bint labels)
    cdef int in_neighbors_BTNode_unsafe(self, int u, SparseGraphBTNode *** p_pointers)
    cdef list in_arcs_unsafe(self, int u, bint labels)

cdef class SparseGraphBackend(CGraphBackend):
    cdef int edge_labels_max
    cdef list edge_labels_available_ids
    cdef SparseGraph _cg
    cdef inline int new_edge_label(self, object l)
    cdef inline CGraph cg(self):
        return <CGraph> self._cg
