#include "graph.h"
#include "util.h"

#include <bits/stdc++.h>
#include <string>

using namespace std;

int main() {
    FILE* fp = fopen("./verilog_code.txt", "w");
    if (fp == nullptr) {
        cout << "failed" << endl;
    }
    cout << "su" << endl;
    for (int i = 7; i < 32; i++) {
        fprintf(fp, "assign AXI_0%d_ARADDR = hbm_read_addr[(%d + 1) * HBM_AWIDTH_PER_CHANNEL - 1 : %d * HBM_AWIDTH_PER_CHANNEL];\n", i, i, i);
        fprintf(fp, "assign AXI_0%d_ARBURST = AXI_0%d_ARADDR[1 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_ARID = AXI_0%d_ARADDR[5 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_ARLEN = AXI_0%d_ARADDR[7 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_ARSIZE = AXI_0%d_ARADDR[2 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_ARVALID = AXI_0%d_ARADDR[0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_AWADDR = hbm_write_addr[(%d + 1) * HBM_AWIDTH_PER_CHANNEL - 1 : %d * HBM_AWIDTH_PER_CHANNEL];\n", i, i, i);
        fprintf(fp, "assign AXI_0%d_AWBURST = AXI_0%d_AWADDR[1 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_AWID = AXI_0%d_AWADDR[5 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_AWLEN = AXI_0%d_AWADDR[7 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_AWSIZE = AXI_0%d_AWADDR[2 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_AWVALID = AXI_0%d_AWADDR[0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_RREADY = AXI_0%d_ARADDR[0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_BREADY = AXI_0%d_ARADDR[0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_WDATA = hbm_write_data[(%d + 1) * HBM_DWIDTH_PER_CHANNEL - 1 : %d * HBM_DWIDTH_PER_CHANNEL];\n", i, i, i);
        fprintf(fp, "assign AXI_0%d_WLAST = AXI_0%d_WDATA[0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_WSTRB = AXI_0%d_WDATA[31 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_WVALID = AXI_0%d_WDATA[0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_ARCACHE = AXI_0%d_WDATA[3 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_AWCACHE = AXI_0%d_WDATA[3 : 0];\n", i, i);
        fprintf(fp, "assign AXI_0%d_AWPROT = AXI_0%d_WDATA[2 : 0];\n", i, i);
        fprintf(fp, "assign hbm_read_data[(%d + 1) * HBM_DWIDTH_PER_CHANNEL - 1 : %d * HBM_DWIDTH_PER_CHANNEL] = AXI_0%d_RDATA;\n", i, i, i);
    }
    fclose(fp);
    return 0;
}