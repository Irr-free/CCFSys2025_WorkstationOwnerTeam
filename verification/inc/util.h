#ifndef _UTIL_H
#define _UTIL_H

#include <string>

using std::string;

class Filename {
public:
    const string prefix_graph500 = "/home/zjlab/Projects/graph500accelerator/tools/graph500-newreference/";
    const string prefix_accelerator = "/home/zjlab/Projects/graph500accelerator/";
    const string suffix = "20.txt";
    string csr_offs_filename;
    string csr_dsts_filename;
    string csr_bfs_filename;
    const string graph_filename = prefix_accelerator + "verification/data/graph_" + suffix;
    const string degree_filename = prefix_accelerator + "verification/build/degree_" + suffix;
    const string sort_edge_filename = prefix_accelerator + "verification/build/sort_edge_" + suffix;
    const string bfs_result_notify_pull_filename = prefix_accelerator + "verification/build/bfs_result_notify_pull_" + suffix;
    const string bfs_result_push_pull_filename = prefix_accelerator + "verification/build/bfs_result_push_pull_" + suffix;
    const string bfs_vtx_level_freq_filename = prefix_accelerator + "verification/build/bfs_vtx_level_freq_" + suffix;
    const string bfs_top_vtx_level_freq_filename = prefix_accelerator + "verification/build/bfs_top_vtx_level_freq_" + suffix;
    Filename() {
        char* tmpfile = getenv("TMPFILE");
        csr_offs_filename = string(tmpfile) + "_off.txt";
        csr_dsts_filename = string(tmpfile) + "_dst.txt";
        csr_bfs_filename = string(tmpfile) + "_bfs.txt";
    }
};

static bool check_file_exist(const char* filename) {
    FILE* fp = fopen(filename, "r");
    if (fp == nullptr) {
        return false;
    }
    fclose(fp);
    return true;
}

#endif