#include "graph.h"

#include <bits/stdc++.h>

bool Csr::load(const char* offs_filename, const char* dsts_filename) {
    fprintf(stderr, "[INFO] Csr load start\n");
    double start = clock();
    FILE* offs_fp = fopen(offs_filename, "r");
    if (offs_fp == nullptr) {
        fprintf(stderr, "[ERROR] Failed to open %s\n", offs_filename);
        return false;
    }
    FILE* dsts_fp = fopen(dsts_filename, "r");
    if (dsts_fp == nullptr) {
        fprintf(stderr, "[ERROR] Failed to open %s\n", dsts_filename);
        return false;
    }
    Offset off;
    NodeId dst;
    while (fscanf(offs_fp, "%d", &off) > 0) {
        _offsets_vec.push_back(off);
    }
    while (fscanf(dsts_fp, "%d", &dst) > 0) {
        _dsts_vec.push_back(dst);
    }
    fclose(offs_fp);
    fclose(dsts_fp);
    fprintf(stderr, "[INFO] Csr - Vertex: %ld, Edge: %ld\n", _offsets_vec.size(), _dsts_vec.size());
    fprintf(stderr, "[INFO] Csr load complete, time: %.3f\n", (clock() - start) / CLOCKS_PER_SEC);
    return true;
}

bool Csr::is_empty() {
    return _offsets_vec.size() == 0 && _dsts_vec.size() == 0;
}