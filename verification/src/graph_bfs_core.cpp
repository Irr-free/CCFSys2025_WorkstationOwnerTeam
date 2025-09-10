#include "graph.h"

#include <vector>
#include <set>
#include <bits/stdc++.h>

using namespace std;

long long Graph::notify_pull(NodeId root_id, vector<BfsValue>& bfs_result) {
    vector<BfsValue> prev_depth_vec(_vtx_num, -1);
    vector<BfsValue> depth_vec(_vtx_num, -1);
    set<NodeId> active_vtx_set[2] = {{root_id}};
    int cu_frontier = 0;
    assert(active_vtx_set[cu_frontier].size() == 1);
    prev_depth_vec[root_id] = 0;
    depth_vec[root_id] = 0;
    for (auto node_id : _set_level_vtx_vec) {
        prev_depth_vec[node_id] = _level;
        depth_vec[node_id] = _level;
    }
    long long edges_traversal_count = 0;
    while (active_vtx_set[cu_frontier].size() > 0) {
        for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
            // pull
            if (prev_depth_vec[node_id] == -1) {
                long long edges_traversal_per_node = 0;
                for (NodeId src_id : _nodes_vec[node_id]._in_neighbors) {
                    edges_traversal_per_node++;
                    if (active_vtx_set[cu_frontier].count(src_id) > 0) {
                        depth_vec[node_id] = prev_depth_vec[src_id] + 1;
                        int next_frontier = (cu_frontier + 1) % 2;
                        active_vtx_set[next_frontier].insert(node_id);
                        edges_traversal_count += edges_traversal_per_node;
                        break;
                    }
                }
            }
        }
        active_vtx_set[cu_frontier].clear();
        cu_frontier = (cu_frontier + 1) % 2;
        for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
            prev_depth_vec[node_id] = depth_vec[node_id];
        }
    }
    for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
        bfs_result[node_id] = depth_vec[node_id];
    }
    return edges_traversal_count;
}

long long Graph::push_pull(NodeId root_id, vector<BfsValue>& bfs_result) {
    vector<BfsValue> prev_depth_vec(_vtx_num, -1);
    vector<BfsValue> depth_vec(_vtx_num, -1);
    set<NodeId> active_vtx_set[2] = {{root_id}};
    int cu_frontier = 0;
    assert(active_vtx_set[cu_frontier].size() == 1);
    prev_depth_vec[root_id] = 0;
    depth_vec[root_id] = 0;
    for (auto node_id : _set_level_vtx_vec) {
        prev_depth_vec[node_id] = _level;
        depth_vec[node_id] = _level;
    }
    long long edges_traversal_count = 0;
    EdgeId active_edges = _nodes_vec[root_id]._degree;
    const int PUSH = 0, PULL = 1;
    auto bfs_mode = [&]() {
        if (active_edges * 10 > _edge_num) return PULL;
        return PUSH;
    };
    auto push_core = [&]() {
        active_edges = 0;
        int next_frontier = (cu_frontier + 1) % 2;
        for (auto node_id : active_vtx_set[cu_frontier]) {
            for (auto dst_id : _nodes_vec[node_id]._out_neighbors) {
                edges_traversal_count++;
                if (prev_depth_vec[dst_id] == -1) {
                    depth_vec[dst_id] = prev_depth_vec[node_id] + 1;
                    if (active_vtx_set[next_frontier].insert(dst_id).second) {
                        active_edges += _nodes_vec[dst_id]._degree;
                    }
                }
            }
        }
    };
    auto pull_core = [&]() {
        active_edges = 0;
        int next_frontier = (cu_frontier + 1) % 2;
        for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
            if (prev_depth_vec[node_id] == -1) {
                for (auto src_id : _nodes_vec[node_id]._in_neighbors) {
                    edges_traversal_count++;
                    // if (prev_depth_vec[src_id] != -1) {
                    if (active_vtx_set[cu_frontier].count(src_id) > 0) {
                        depth_vec[node_id] = prev_depth_vec[src_id] + 1;
                        active_vtx_set[next_frontier].insert(node_id);
                        active_edges += _nodes_vec[node_id]._degree;
                        break;
                    }
                }
            }
        }
    };
    int iteration_num = 0;
    while (active_vtx_set[cu_frontier].size() > 0) {
        switch(bfs_mode()) {
            case PUSH: {
                // fprintf(stderr, "now_iteration: %d PUSH %ld %d %lld\n",
                //     iteration_num++, active_vtx_set[cu_frontier].size(), active_edges, edges_traversal_count);
                push_core();
                break;
            }
            case PULL: {
                // fprintf(stderr, "now_iteration: %d PULL %ld %d %lld\n",
                //    iteration_num++, active_vtx_set[cu_frontier].size(), active_edges, edges_traversal_count);
                pull_core();
                break;
            }
        }
        for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
            prev_depth_vec[node_id] = depth_vec[node_id];
        }
        active_vtx_set[cu_frontier].clear();
        cu_frontier = (cu_frontier + 1) % 2;
    }
    for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
        bfs_result[node_id] = depth_vec[node_id];
    }
    return edges_traversal_count;
}

void Graph::bfs_origin_core(NodeId root_id, vector<BfsValue>& bfs_res) {
    assert(bfs_res.size() == _vtx_num);
    bfs_res[root_id] = 0;
    bool vtx_update = true;
    int level = 0;
    while (vtx_update) {
        vtx_update = false;
        for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
            if (bfs_res[node_id] != -1 && bfs_res[node_id] <= level) continue;
            for (auto src_id : _nodes_vec[node_id]._in_neighbors) {
                if (bfs_res[src_id] == -1) continue;
                if (bfs_res[node_id] == -1) {
                    bfs_res[node_id] = bfs_res[src_id] + 1;
                    vtx_update = true;
                } else if (bfs_res[src_id] + 1 < bfs_res[node_id]) {
                    vtx_update = true;
                    bfs_res[node_id] = bfs_res[src_id] + 1;
                }
            }
        }
        level++;
    }
}

void Graph::push(NodeId root_id, vector<BfsValue>& bfs_res) {
    assert(bfs_res.size() == _vtx_num);
    bfs_res[root_id] = 0;
    vector<bool> visited_map(_vtx_num, false);
    visited_map[root_id] = true;

    set<NodeId> active_vtx_set[2] = {{root_id}};
    int cu_frontier = 0;
    assert(active_vtx_set[cu_frontier].size() == 1);
    while(active_vtx_set[cu_frontier].size() > 0) {
        int next_frontier = (cu_frontier + 1) % 2;
        for (auto node_id : active_vtx_set[cu_frontier]) {
            for (auto dst_id : _nodes_vec[node_id]._out_neighbors) {
                if (visited_map[dst_id] == false) {
                    visited_map[dst_id] = true;
                    bfs_res[dst_id] = bfs_res[node_id] + 1;
                    active_vtx_set[next_frontier].insert(dst_id);
                }
            }
        }
        active_vtx_set[cu_frontier].clear();
        cu_frontier = next_frontier;
    };
}