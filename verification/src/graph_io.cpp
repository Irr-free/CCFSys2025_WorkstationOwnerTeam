#include "graph.h"

#include <bits/stdc++.h>

using namespace std;

bool Graph::load(const char* filename) {
    fprintf(stderr, "[INFO] Graph load start\n");

    assert(_vtx_num == 0);
    assert(_edge_num == 0);
    assert(_nodes_vec.size() == 0);
    assert(_edges_vec.size() == 0);

    double start = clock();
    FILE* fp = fopen(filename, "r");
    if (fp == nullptr) {
        fprintf(stderr, "[ERROR] Failed to open %s\n", filename);
        return false;
    }
    fscanf(fp, "%d %d", &_vtx_num, &_edge_num);
    for (NodeId i = 0; i < _vtx_num; i++) _nodes_vec.push_back(Node(i));
    NodeId src_id, dst_id;
    EdgeId edge_id = 0;
    while (fscanf(fp, "%d %d", &src_id, &dst_id) > 0) {
        _edges_vec.push_back(Edge(edge_id++, &_nodes_vec[src_id], &_nodes_vec[dst_id]));
        _nodes_vec[src_id]._out_neighbors.push_back(dst_id);
        _nodes_vec[dst_id]._in_neighbors.push_back(src_id);
    }
    // update node status
    _outlier_vtx_num = 0;
    for (NodeId i = 0; i < _vtx_num; i++) {
        _nodes_vec[i].update_degree();
        _outlier_vtx_num += _nodes_vec[i].is_outlier() ? 1 : 0;
    }
    assert(_edge_num == _edges_vec.size());
    fprintf(stderr, "[INFO] Graph load - Vertex: %d, Edge = %d\n", _vtx_num, _edge_num);
    fprintf(stderr, "[INFO] Graph load - Outlier Vertex: %d\n", _outlier_vtx_num);
    fprintf(stderr, "[INFO] Graph load complete, time: %.3f\n", (clock() - start) / CLOCKS_PER_SEC);
    return true;
}

bool Graph::store(const char* filename) {
    fprintf(stderr, "[INFO] Graph store start\n");

    assert(_vtx_num > 0);
    assert(_edge_num > 0);
    assert(_nodes_vec.size() > 0 && _vtx_num == _nodes_vec.size());
    assert(_edges_vec.size() > 0 && _edge_num == _edges_vec.size());

    double start = clock();
    FILE* fp = fopen(filename, "w");
    if (fp == nullptr) {
        fprintf(stderr, "[ERROR] Failed to open %s\n", filename);
        return false;
    }
    fprintf(fp, "%d %d\n", _vtx_num, _edge_num);
    for (EdgeId i = 0; i < _edge_num; i++) {
        fprintf(fp, "%d %d\n", _edges_vec[i].get_src_id(), _edges_vec[i].get_dst_id());
    }
    fprintf(stderr, "[INFO] Vertex: %d, Edge = %d\n", _vtx_num, _edge_num);
    fprintf(stderr, "[INFO] Graph store complete, time: %.3f\n", (clock() - start) / CLOCKS_PER_SEC);
    return true;
}

bool Graph::store_sort_edge(const char* filename) {
    FILE* fp = fopen(filename, "w");
    if (fp == nullptr) {
        fprintf(stderr, "[ERROR] Failed to open %s\n", filename);
        return false;
    }
    fprintf(fp, "%d %d\n", _vtx_num, _edge_num);
    for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
        for (auto src_id : _nodes_vec[node_id]._in_neighbors) {
            fprintf(fp, "%d %d %d\n", src_id, node_id, _nodes_vec[src_id]._degree);
        }
    }
    fclose(fp);
    return true;
}

bool Graph::store_bfs_result(const char* filename, vector<BfsValue>& bfs_result) {
    FILE* fp = fopen(filename, "w");
    if (fp == nullptr) {
        fprintf(stderr, "[ERROR] Failed to open %s\n", filename);
        return false;
    }
    for (NodeId i = 0; i < _vtx_num; i++) {
        fprintf(fp, "%d\n", bfs_result[i]);
    }
    fclose(fp);
    return true;
}

bool Graph::store_vtx_level_freq(const char* filename, std::vector<pair<NodeId, NodeId>>& vtx_level_freq_vec)  {
    FILE* fp = fopen(filename, "w");
    if (fp == nullptr) {
        fprintf(stderr, "[ERROR] Failed to open %s\n", filename);
        return false;
    }
    for (NodeId i = 0; i < _vtx_num; i++) {
        fprintf(fp, "%d %d\n", vtx_level_freq_vec[i].first, vtx_level_freq_vec[i].second);
    }
    fclose(fp);
    return true;
}

bool Graph::store_top_vtx_level_freq(const char* filename)  {
    FILE* fp = fopen(filename, "w");
    if (fp == nullptr) {
        fprintf(stderr, "[ERROR] Failed to open %s\n", filename);
        return false;
    }
    for (NodeId i = 0; i < _set_level_vtx_vec.size(); i++) {
        fprintf(fp, "%d\n", _set_level_vtx_vec[i]);
    }
    fclose(fp);
    return true;
}