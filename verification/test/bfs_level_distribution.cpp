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

    int iteration_num = 1000;
    for (NodeId root_id = 0; root_id < iteration_num; root_id++) {
        vector<BfsValue> local_bfs_result(_vtx_num, -1);
        push_pull(root_id, local_bfs_result);
        if (bfs_validation(root_id, local_bfs_result_set_level) > 0) {

        }
        if (failed_vec[root_id] > 0) {
            fprintf(fp, "%d %d\n", root_id, failed_vec[root_id]);
            failed_num++;
        }
    }

    return 0;
}