#include "graph.h"

#include <vector>
#include <bits/stdc++.h>

using namespace std;

bool Graph::preprocess(const char* csr_offs_filename, const char* csr_dsts_filename, const char* graph_filename) {
    fprintf(stderr, "[INFO] Graph preprocess start\n");
    double start = clock();
    _csr.load(csr_offs_filename, csr_dsts_filename);
    assert(_csr._offsets_vec.size() > 0);
    assert(_csr._dsts_vec.size() > 0);
    for (NodeId i = 0; i < _csr._offsets_vec.size(); i++) _nodes_vec.push_back(Node(i));
    if (_edge_filter_flag) {
        EdgeId edge_id = 0;
        for (NodeId i = 0; i < _csr._offsets_vec.size(); i++) {
            vector<bool> visited_map(_csr._offsets_vec.size(), false);
            visited_map[i] = true;
            for (Offset off = _csr._offsets_vec[i]; off < _csr._offsets_vec[i + 1]; off++) {
                NodeId dst_id = _csr._dsts_vec[off];
                if (visited_map[dst_id]) continue;
                else {
                    visited_map[dst_id] = true;
                    _edges_vec.push_back(Edge(edge_id++, &_nodes_vec[dst_id], &_nodes_vec[i]));
                    _nodes_vec[dst_id]._out_neighbors.push_back(i);
                    _nodes_vec[i]._in_neighbors.push_back(dst_id);
                }
            }
        }
    } else {
        EdgeId edge_id = 0;
        for (NodeId i = 0; i < _csr._offsets_vec.size(); i++) {
            for (Offset off = _csr._offsets_vec[i]; off < _csr._offsets_vec[i + 1]; off++) {
                NodeId dst_id = _csr._dsts_vec[off];
                _edges_vec.push_back(Edge(edge_id++, &_nodes_vec[dst_id], &_nodes_vec[i]));
                _nodes_vec[dst_id]._out_neighbors.push_back(i);
                _nodes_vec[i]._in_neighbors.push_back(dst_id);
            }
        }
    }
    _vtx_num = _nodes_vec.size();
    _edge_num = _edges_vec.size();
    // update node status
    _outlier_vtx_num = 0;
    for (NodeId i = 0; i < _vtx_num; i++) {
        _nodes_vec[i].update_degree();
        _outlier_vtx_num += _nodes_vec[i].is_outlier() ? 1 : 0;
    }
    fprintf(stderr, "[INFO] Preprocess - Vertex: %d, Edge: %d\n", _vtx_num, _edge_num);
    fprintf(stderr, "[INFO] Preprocess - Outlier Vertex: %d\n", _outlier_vtx_num);
    fprintf(stderr, "[INFO] Graph preprocess complete, time: %.3f\n", (clock() - start) / CLOCKS_PER_SEC);
    return true;
}

void Graph::sort_edge() {
    fprintf(stderr, "[INFO] Sort edge start\n");
    double start = clock();
    switch(_sort_mode) {
        case Graph::SortMode::None: {
            fprintf(stderr, "[INFO] SortMode: None\n");
            break;
        }
        case Graph::SortMode::SrcIdAscending: {
            fprintf(stderr, "[INFO] SortMode: SrcIdAscending\n");
            auto sort_by_src_id_ascending = [&](NodeId id1, NodeId id2) -> bool {
                return id1 < id2;
            };
            for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
                sort(_nodes_vec[node_id]._in_neighbors.begin(),
                    _nodes_vec[node_id]._in_neighbors.end(), sort_by_src_id_ascending);
                sort(_nodes_vec[node_id]._out_neighbors.begin(),
                    _nodes_vec[node_id]._out_neighbors.end(), sort_by_src_id_ascending);
            }
            break;
        }
        case Graph::SortMode::SrcDegreeDescending: {
            fprintf(stderr, "[INFO] SortMode: SrcDegreeDescending\n");
            auto sort_by_src_degree_descending = [&](NodeId id1, NodeId id2) -> bool {
                return _nodes_vec[id1]._degree > _nodes_vec[id2]._degree;
            };
            for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
                sort(_nodes_vec[node_id]._in_neighbors.begin(),
                    _nodes_vec[node_id]._in_neighbors.end(), sort_by_src_degree_descending);
                sort(_nodes_vec[node_id]._out_neighbors.begin(),
                    _nodes_vec[node_id]._out_neighbors.end(), sort_by_src_degree_descending);
            }
            break;
        }
    }
    fprintf(stderr, "[INFO] Sort edge complete, time: %.3f\n", (clock() - start) / CLOCKS_PER_SEC);
}

void Graph::count_vtx_level_freq(const int level, vector<pair<NodeId, NodeId>>& vtx_level_freq_vec) {
    fprintf(stderr, "[INFO] Count vertex level start\n");
    double start = clock();
    vector<BfsValue> bfs_res_push_pull(_vtx_num, -1);
    for (NodeId i = 0; i < _vtx_num; i++) vtx_level_freq_vec[i] = {i, 0};
    for (NodeId root_id = 0; root_id < _vtx_num; root_id++) {
        push_pull(root_id, bfs_res_push_pull);
        for (NodeId i = 0; i < _vtx_num; i++) {
            if (bfs_res_push_pull[i] == level) vtx_level_freq_vec[i].second++;
        }
    }
    auto sort_func = [&](pair<NodeId, NodeId>& p1, pair<NodeId, NodeId>& p2) -> bool {
        return p1.second > p2.second;
    };
    sort(vtx_level_freq_vec.begin(), vtx_level_freq_vec.end(), sort_func);
    // filter top vtx
    for (auto p : vtx_level_freq_vec) {
        if (p.second * 100 > (_vtx_num - _outlier_vtx_num) * 81) {
            _set_level_vtx_vec.push_back(p.first);
        }
    }
    _level = level;
    fprintf(stderr, "[INFO] Count vertex level complete, time: %.3f\n", (clock() - start) / CLOCKS_PER_SEC);
}