#include "graph.h"

#include <vector>
#include <set>
#include <bits/stdc++.h>

using namespace std;


NodeId Graph::bfs_validation(const NodeId root_id, const vector<BfsValue>& bfs_result) {
    vector<BfsValue> local_bfs_result(_vtx_num, -1);
    bfs_origin_core(root_id, local_bfs_result);
    store_bfs_result("./tmp_bfs_validation.txt", local_bfs_result);
    NodeId errs_count = 0;
    for (NodeId node_id = 0; node_id < _vtx_num; node_id++) {
        if (bfs_result[node_id] != local_bfs_result[node_id]) {
            errs_count++;
        }
    }
    return errs_count;
}

void Graph::bfs_set_level_validation() {
    fprintf(stderr, "[INFO] Graph bfs set level start\n");
    double start = clock();
    int failed_num = 0;
    vector<int> failed_vec(_vtx_num, 0);
    FILE* fp = fopen("./failed_vtx_num.txt", "w");
    int iteration_num = 1000;
    for (NodeId root_id = 0; root_id < iteration_num; root_id++) {
        vector<BfsValue> local_bfs_result_set_level(_vtx_num, -1);
        push_pull(root_id, local_bfs_result_set_level);
        failed_vec[root_id] = bfs_validation(root_id, local_bfs_result_set_level);
        if (failed_vec[root_id] > 0) {
            fprintf(fp, "%d %d\n", root_id, failed_vec[root_id]);
            failed_num++;
        }
    }
    fclose(fp);
    fprintf(stderr, "[INFO] SetLevel - failed_num: %d\n", failed_num);
    fprintf(stderr, "[INFO] Graph bfs set level complete, time: %.3f\n", (clock() - start) / CLOCKS_PER_SEC);
}