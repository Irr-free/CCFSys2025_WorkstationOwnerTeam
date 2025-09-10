#include "graph.h"
#include "util.h"

#include <bits/stdc++.h>
#include <string>

using namespace std;

int main_t() {
    Graph g;
    g.set_edge_filter_flag(true);
    g.set_sort_mode(Graph::SortMode::None);

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
    g.store_sort_edge(all_filename.sort_edge_filename.c_str());

    FILE* fp = fopen("/home/zjlab/Projects/graph500accelerator/tools/graph500-newreference/data/graph_19_bfs.txt", "r");
    vector<NodeId> parent_vec(g.get_vtx_num(), -1);
    vector<BfsValue> graph500_bfs_vec(g.get_vtx_num(), -1);
    graph500_bfs_vec[0] = 0;
    for (int i = 0; i < g.get_vtx_num(); i++) {
        fscanf(fp, "%d", &parent_vec[i]);
    }
    bool vertex_update = true;
    while (vertex_update) {
        vertex_update = false;
        for (int i = 0; i < g.get_vtx_num(); i++) {
            if (graph500_bfs_vec[i] == -1 && parent_vec[i] != -1) {
                if (graph500_bfs_vec[parent_vec[i]] != -1) {
                    graph500_bfs_vec[i] = graph500_bfs_vec[parent_vec[i]] + 1;
                    vertex_update = true;
                }
            }
        }
    }

    long long edge_traversal_count_notify_pull = 0;
    long long edge_traversal_count_push_pull = 0;
    int iteration_num = 10000 > g.get_vtx_num() ? g.get_vtx_num() : 10000;
    int skip_iteration_num = 0;
    iteration_num = 1;
    for (int root_id = 0; root_id < iteration_num; root_id++) {
        if (g.is_outlier(root_id)) {
            skip_iteration_num++;
            continue;
        }
        /*
        vector<BfsValue> bfs_res_notify_pull(g.get_vtx_num(), -1);
        long long etc1 = g.notify_pull(root_id, bfs_res_notify_pull);
        if (g.bfs_validation(root_id, bfs_res_notify_pull) > 0) {
            fprintf(stderr, "[ERROR] Notify-pull Bfs result not match\n");
            g.store_bfs_result(all_filename.bfs_result_notify_pull_filename.c_str(), bfs_res_notify_pull);
            return -1;
        }
        edge_traversal_count_notify_pull += etc1;
        */
        vector<BfsValue> bfs_res_push_pull(g.get_vtx_num(), -1);
        long long etc2 = 0;
        g.push(root_id, bfs_res_push_pull);
        g.store_bfs_result(all_filename.bfs_result_push_pull_filename.c_str(), graph500_bfs_vec);
        if (g.bfs_validation(root_id, graph500_bfs_vec) > 0) {
            fprintf(stderr, "[ERROR] Push-pull Bfs result not match\n");
            return -1;
        }
        edge_traversal_count_push_pull += etc2;
    }
    fprintf(stderr, "[INFO] Outlier vertex num: %d\n", g.get_outlier_vtx_num());
    fprintf(stderr, "[INFO] Notify pull traverse edge: %lld, Push pull traverse edge: %lld\n",
        edge_traversal_count_notify_pull, edge_traversal_count_push_pull);
    fprintf(stderr, "[INFO] Notify pull traverse edge per node: %.3f, Push pull traverse edge per node: %.3f\n",
        double(edge_traversal_count_notify_pull) / (iteration_num - skip_iteration_num) / (g.get_vtx_num() - g.get_outlier_vtx_num()),
        double(edge_traversal_count_push_pull) / (iteration_num - skip_iteration_num) / (g.get_vtx_num() - g.get_outlier_vtx_num()));

    return 0;
}

int main_a() {
    FILE* fp = fopen("./kernel_code.txt", "w");
    for (int i = 0; i < 32; i++) {
        fprintf(fp, "  .controller_recv_edge_addr        (HBM_interface_rd_hbm_edge_addr[(%d + 1) * HBM_AWIDTH - 1 : %d * HBM_AWIDTH]),\n", i, i);
        fprintf(fp, "  .controller_recv_edge_addr_valid  (HBM_interface_rd_hbm_edge_valid[%d]),\n", i);
        fprintf(fp, "  .read_stage_full                  (HBM_controller_read_full[%d]),\n", i);
        fprintf(fp, "  .controller_send_edge             (hbm_controller_edge[(%d + 1) * HBM_DWIDTH - 1 : %d * HBM_DWIDTH]),\n", i, i);
        fprintf(fp, "  .controller_send_edge_valid       (hbm_controller_valid[%d]),\n", i);
        fprintf(fp, "  .controller_recv_update_data      (VTX_BRAM_data[(%d + 1) * HBM_DWIDTH - 1 : %d * HBM_DWIDTH]),\n", i, i);
        fprintf(fp, "  .controller_recv_update_addr      (VTX_BRAM_backend_active_v_id[(%d + 1) * HBM_AWIDTH - 1 : %d * HBM_AWIDTH]),\n", i, i);
        fprintf(fp, "  .controller_recv_update_valid     (VTX_BRAM_backend_active_v_id_valid[%d]),\n", i);
        fprintf(fp, "  .write_stage_full                 (1'b0),\n");
        fprintf(fp, "  .write_stage_empty                (ap_done_i[%d])\n", i);
        fprintf(fp, "\n");
    }
    fclose(fp);
    return 0;
}

int main() {
    FILE* fp = fopen("./config.txt", "w");
    for (int i = 0; i < 32; i++) {
        if (i >= 10) {
            fprintf(fp, "--connectivity.sp=acc_kernel_1.m%d_axi:HBM[%d] ", i, i);
        } else {
            fprintf(fp, "--connectivity.sp=acc_kernel_1.m0%d_axi:HBM[%d] ", i, i);
        }
    }
    fprintf(fp, "\n");
    fclose(fp);
    return 0;
}