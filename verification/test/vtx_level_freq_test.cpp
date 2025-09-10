#include "graph.h"
#include "util.h"

#include <bits/stdc++.h>
#include <string>

using namespace std;

int main() {
    Graph g;
    g.set_edge_filter_flag(true);
    g.set_sort_mode(Graph::SortMode::SrcIdAscending);

    Filename all_filename;
    // if (check_file_exist(all_filename.graph_filename.c_str())) {
    if (false) {
        g.load(all_filename.graph_filename.c_str());
    } else {
        g.preprocess(all_filename.csr_offs_filename.c_str(),
            all_filename.csr_dsts_filename.c_str(), all_filename.graph_filename.c_str());
        g.store(all_filename.graph_filename.c_str());
    }

    g.sort_edge();

    vector<pair<NodeId, NodeId>> vtx_level_freq_vec(g.get_vtx_num(), {0, 0});
    g.count_vtx_level_freq(3, vtx_level_freq_vec);
    g.store_vtx_level_freq(all_filename.bfs_vtx_level_freq_filename.c_str(), vtx_level_freq_vec);
    g.store_top_vtx_level_freq(all_filename.bfs_top_vtx_level_freq_filename.c_str());
    g.bfs_set_level_validation();

    return 0;
}