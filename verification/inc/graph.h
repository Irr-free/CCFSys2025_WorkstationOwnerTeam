#ifndef _H_GRAPH
#define _H_GRAPH

#include <vector>

using NodeId = int;
using EdgeId = int;
using BfsValue = int;
using NodeDegree = int;
using Offset = int;

class Node {
public:
    NodeId _id;
    NodeDegree _degree;
    std::vector<NodeId> _in_neighbors;
    std::vector<NodeId> _out_neighbors;
    Node(NodeId id) : _id(id) {}
    inline void set_id(NodeId id) { _id = id; }
    inline NodeId get_id() { return _id; }
    inline void update_degree() { _degree = _in_neighbors.size(); }
    inline bool is_outlier() { return _in_neighbors.size() == 0; }
};

class Edge {
private:
    EdgeId _edge_id;
    Node* _src_node;
    Node* _dst_node;
public:
    Edge(EdgeId edge_id) : _edge_id(edge_id) { _src_node = nullptr; _dst_node = nullptr; }
    Edge(EdgeId edge_id, Node* src_node, Node* dst_node) :
        _edge_id(edge_id), _src_node(src_node), _dst_node(dst_node) {}
    NodeId get_src_id() { return _src_node->get_id(); }
    NodeId get_dst_id() { return _dst_node->get_id(); }
};

class Csr {
public:
    std::vector<Offset> _offsets_vec;
    std::vector<NodeId> _dsts_vec;
    Csr() { _offsets_vec.resize(0); _dsts_vec.resize(0); }
    bool load(const char* offs_filename, const char* dsts_filename);
    bool is_empty();
    NodeId get_vtx_num() { return _offsets_vec.size(); }
    EdgeId get_edge_num() { return _dsts_vec.size(); }
};

class Graph {
public:
    enum SortMode {None, SrcIdAscending, SrcDegreeDescending};
private:
    NodeId _vtx_num;
    EdgeId _edge_num;
    std::vector<Node> _nodes_vec;
    std::vector<Edge> _edges_vec;
    Csr _csr;
    NodeId _outlier_vtx_num;
    bool _edge_filter_flag;
    SortMode _sort_mode;
    std::vector<NodeId> _set_level_vtx_vec;
    int _level;
public:
    Graph() { _edge_filter_flag = false; _sort_mode = SortMode::None; }
    bool load(const char* graph_filename);
    void set_edge_filter_flag(bool ch) { _edge_filter_flag = ch; }
    void set_sort_mode(SortMode sort_mode) { _sort_mode = sort_mode; }
    bool preprocess(const char* csr_offs_filename, const char* csr_dsts_filename, const char* graph_filename);
    void sort_edge();
    void count_vtx_level_freq(const int level, std::vector<std::pair<NodeId, NodeId>>& vtx_level_freq_vec);
    bool store_vtx_level_freq(const char* filename, std::vector<std::pair<NodeId, NodeId>>& vtx_level_freq_vec);
    bool store_top_vtx_level_freq(const char* filename);
    bool store(const char* graph_filename);
    bool store_sort_edge(const char* filename);
    bool store_bfs_result(const char* filename, std::vector<BfsValue>& bfs_result);
    long long notify_pull(NodeId root_id, std::vector<BfsValue>& bfs_result);
    long long push_pull(NodeId root_id, std::vector<BfsValue>& bfs_result);
    void push(NodeId root_id, std::vector<BfsValue>& bfs_result);
    NodeId get_vtx_num() { return _vtx_num; }
    bool is_outlier(NodeId id) { return _nodes_vec[id].is_outlier(); }
    NodeId get_outlier_vtx_num() { return _outlier_vtx_num; }
    NodeId bfs_validation(const NodeId root_id, const std::vector<BfsValue>& bfs_result);
    void bfs_origin_core(NodeId root_id, std::vector<BfsValue>& bfs_res);
    void bfs_set_level_validation();
};

#endif