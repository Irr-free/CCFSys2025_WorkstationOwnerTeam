`timescale 1ns / 1ps

`include "accelerator.vh"

module vtx_bram #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VTX_BRAM_AWIDTH = `VTX_BRAM_AWIDTH,
    VTX_BRAM_DWIDTH = `VTX_BRAM_DWIDTH,
    ITERATION_DWIDTH = `ITERATION_DWIDTH,
    INVALID_PULL_VALUE = `INVALID_PULL_VALUE,
    CORE_NUM = `CORE_NUM,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH,
    HBM_DWIDTH_PER_CORE = `HBM_DWIDTH_PER_CORE,
    PSEUDO_CHANNEL_NUM = `PSEUDO_CHANNEL_NUM
) (
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    rst,
    input                                       transfer_bram,
    input [PSEUDO_CHANNEL_NUM - 1 : 0]          hbm_write_full,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]  rd_addr_src,
    input [CORE_NUM - 1 : 0]                    rd_valid_src,
    input [CORE_NUM - 1 : 0]                    wr_push_flag_dst,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       wr_addr_dst,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    wr_v_value_dst,
    input [CORE_NUM - 1 : 0]                    wr_pull_first_flag_dst,
    input [CORE_NUM - 1 : 0]                    wr_valid_dst,
    input [CORE_NUM - 1 : 0]                    front_iteration_end,
    input [CORE_NUM - 1 : 0]                    front_iteration_end_valid,
    input [CORE_NUM * ITERATION_DWIDTH - 1 : 0] front_iteration_id,
    input [V_ID_WIDTH - 1 : 0]                  front_root_id,

    output reg [CORE_NUM - 1 : 0]               next_rst,
    output                                      transfer_done,
    output [CORE_NUM * HBM_DWIDTH_PER_CORE - 1 : 0] wb_bfs_data,
    output [PSEUDO_CHANNEL_NUM - 1 : 0] wb_bfs_valid,
    output [CORE_NUM * VTX_BRAM_DWIDTH - 1 : 0]   src_recv_update_v_value,
    output [CORE_NUM - 1 : 0]                   src_recv_update_v_valid,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      backend_active_v_id,
    output [CORE_NUM - 1 : 0]                   backend_active_v_updated,
    output [CORE_NUM - 1 : 0]                   backend_active_v_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   backend_active_v_valid,
    output [CORE_NUM - 1 : 0]                   iteration_end,
    output [CORE_NUM - 1 : 0]                   iteration_end_valid
);

    wire [VTX_BRAM_AWIDTH : 0] tmp_rd_addr [0 : CORE_NUM - 1];
    wire [CORE_NUM - 1 : 0] tmp_rd_addr_valid;
    wire [VTX_BRAM_AWIDTH - 1 : 0] tmp_wr_addr [0 : CORE_NUM - 1];
    wire [VTX_BRAM_DWIDTH - 1 : 0] tmp_wr_data [0 : CORE_NUM - 1];
    wire [CORE_NUM - 1 : 0] tmp_wr_addr_valid;
    wire [VTX_BRAM_DWIDTH - 1 : 0] tmp_bram_data [0 : CORE_NUM - 1];
    reg [CORE_NUM - 1 : 0] tmp_bram_data_valid [0 : 1];
    reg [CORE_NUM - 1 : 0] tmp_bram_addr_check [0 : 1];
    reg [VTX_BRAM_AWIDTH - 1 : 0] local_transfer_addr [0 : 2];
    reg local_transfer_valid [0 : 2];
    reg local_lock;
    reg [CORE_NUM - 1 : 0] write_root;
    integer j;
    
    assign transfer_done = (local_transfer_addr[2] == {VTX_BRAM_AWIDTH{1'b1}});
    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            assign wb_bfs_data[(i + 1) * HBM_DWIDTH_PER_CORE - 1 : i * HBM_DWIDTH_PER_CORE] =
                {tmp_bram_data[i], local_transfer_addr[2], {CORE_NUM_WIDTH{1'b0}}} + i;
        end
        for (i = 0; i < PSEUDO_CHANNEL_NUM; i = i + 1) begin
            assign wb_bfs_valid[i] = local_transfer_valid[2];
        end
    endgenerate

    always @ (posedge clk) begin
        next_rst <= rst;
    end
    
    wire hbm_write = !hbm_write_full[0] && !hbm_write_full[1] && !hbm_write_full[2] && !hbm_write_full[3];
    
    always @ (posedge clk) begin
        if (rst) begin
            local_transfer_addr[0] <= 0;
            local_transfer_valid[0] <= 0;
            local_lock <= 1;
        end else begin
            if (transfer_bram && local_lock) begin
                local_transfer_addr[0] <= 0;
                local_transfer_valid[0] <= 1'b1;
                local_lock <= 0;
            end
            else if (transfer_bram && local_transfer_addr[0] < {VTX_BRAM_AWIDTH{1'b1}} && hbm_write) begin
                local_transfer_addr[0] <= local_transfer_addr[0] + 1;
                local_transfer_valid[0] <= 1'b1;
            end else begin
                local_transfer_valid[0] <= 0;
            end
        end
        local_transfer_addr[2] <= local_transfer_addr[1];
        local_transfer_addr[1] <= local_transfer_addr[0];
        local_transfer_valid[2] <= local_transfer_valid[1];
        local_transfer_valid[1] <= local_transfer_valid[0];
    end

    generate
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            vtx_bram_single VTX_BRAM_SINGLE (
                .clk                (clk),
                .rst                (rst[i]),
                .rd_addr_src        (rd_addr_src[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .rd_valid_src       (rd_valid_src[i]),
                .wr_push_flag_dst   (wr_push_flag_dst[i]),
                .wr_addr_dst        (wr_addr_dst[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .wr_v_value_dst     (wr_v_value_dst[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .wr_pull_first_flag_dst (wr_pull_first_flag_dst[i]),
                .wr_valid_dst       (wr_valid_dst[i]),
                .front_iteration_end(front_iteration_end[i]),
                .front_iteration_end_valid  (front_iteration_end_valid[i]),
                .front_iteration_id (front_iteration_id[(i + 1) * ITERATION_DWIDTH - 1 : i * ITERATION_DWIDTH]),
                .tmp_bram_data                  (tmp_bram_addr_check[1][i] ? INVALID_PULL_VALUE : tmp_bram_data[i]),
                .tmp_bram_data_valid            (tmp_bram_data_valid[1][i]),

                .tmp_rd_addr                    (tmp_rd_addr[i]),
                .tmp_rd_addr_valid              (tmp_rd_addr_valid[i]),
                .tmp_wr_addr                    (tmp_wr_addr[i]),
                .tmp_wr_data                    (tmp_wr_data[i]),
                .tmp_wr_addr_valid              (tmp_wr_addr_valid[i]),
                .src_recv_update_v_value        (src_recv_update_v_value[(i + 1) * VTX_BRAM_DWIDTH - 1 : i * VTX_BRAM_DWIDTH]),
                .src_recv_update_v_valid        (src_recv_update_v_valid[i]),
                .backend_active_v_id            (backend_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .backend_active_v_updated       (backend_active_v_updated[i]),
                .backend_active_v_pull_first_flag   (backend_active_v_pull_first_flag[i]),
                .backend_active_v_valid         (backend_active_v_valid[i]),
                .iteration_end                  (iteration_end[i]),
                .iteration_end_valid            (iteration_end_valid[i])
            );

            vtx_bram_ip_single VTX_BRAM_IP_SINGLE (
                .clka       (clk),
                .ena        (!rst[i]),
                .wea        (tmp_wr_addr_valid[i] || write_root[i]),
                .addra      (write_root[i] ? {{4{1'b0}},front_root_id >> CORE_NUM_WIDTH} :{{4{1'b0}},tmp_wr_addr[i]}),
                .dina       (tmp_wr_data[i]),
                .clkb       (clk),
                .enb        (!rst[i]),
                .addrb      (transfer_bram ? {{4{1'b0}},local_transfer_addr[0]} : {{4{1'b0}},tmp_rd_addr[i]}),
                .doutb      (tmp_bram_data[i])
            );
        end
    endgenerate

    always @ (posedge clk) begin
        tmp_bram_data_valid[0] <= tmp_rd_addr_valid;
        tmp_bram_data_valid[1] <= tmp_bram_data_valid[0];
    end
    
    always @ (posedge clk) begin
        for (j = 0; j < CORE_NUM; j = j + 1) begin
            tmp_bram_addr_check[0][j] <= (tmp_rd_addr[j] == {(VTX_BRAM_AWIDTH + 1){1'b1}});
            tmp_bram_addr_check[1][j] <= tmp_bram_addr_check[0][j];
        end
    end
    
    always @ (posedge clk) begin
        if(rst) begin
            for(j = 0; j < CORE_NUM; j = j + 1) begin
                if(front_root_id[CORE_NUM_WIDTH - 1 : 0] == j)begin
                    write_root [j] <= 1;
                end else begin
                    write_root [j] <= 0;
                end
            end
        end
        else  begin
            write_root <= 0;
        end
    end
endmodule

module vtx_bram_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VTX_BRAM_AWIDTH = `VTX_BRAM_AWIDTH,
    VTX_BRAM_DWIDTH = `VTX_BRAM_DWIDTH,
    ITERATION_DWIDTH = `ITERATION_DWIDTH,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH,
    INVALID_BFS_VALUE = `INVALID_BFS_VALUE,
    FIFO_SIZE_WIDTH = `FIFO_SIZE_WIDTH,
    CORE_NUM = `CORE_NUM
) (
    input                   clk,
    input                   rst,
    input [V_ID_WIDTH - 1 : 0] rd_addr_src,
    input                           rd_valid_src,
    input                           wr_push_flag_dst,
    input [V_ID_WIDTH - 1 : 0]      wr_addr_dst,
    input [V_VALUE_WIDTH - 1 : 0]   wr_v_value_dst,
    input                           wr_pull_first_flag_dst,
    input                           wr_valid_dst,
    input                           front_iteration_end,
    input                           front_iteration_end_valid,
    input [ITERATION_DWIDTH - 1 : 0]front_iteration_id,
    input [VTX_BRAM_DWIDTH - 1 : 0] tmp_bram_data,
    input                           tmp_bram_data_valid,

    output reg [VTX_BRAM_AWIDTH : 0]    tmp_rd_addr,
    output reg                              tmp_rd_addr_valid,
    output reg [VTX_BRAM_AWIDTH - 1 : 0]    tmp_wr_addr,
    output reg [VTX_BRAM_DWIDTH - 1 : 0]    tmp_wr_data,
    output reg                              tmp_wr_addr_valid,
    output reg [VTX_BRAM_DWIDTH - 1 : 0]  src_recv_update_v_value,
    output reg                          src_recv_update_v_valid,
    output reg [V_ID_WIDTH - 1 : 0] backend_active_v_id,
    output reg                      backend_active_v_updated,
    output reg                      backend_active_v_pull_first_flag,
    output reg                      backend_active_v_valid,
    output reg                      iteration_end,
    output reg                      iteration_end_valid
);
    wire [V_ID_WIDTH - 1 : 0] bram_addr_top;
    wire push_flag_top;
    wire [V_VALUE_WIDTH - 1 : 0] v_value_top;
    wire pull_first_flag_top;
    wire buffer_empty, buffer_full;
    wire [FIFO_SIZE_WIDTH - 1 : 0] buffer_datacount;
    wire write_signal, read_signal;

    assign write_signal = rd_valid_src || (wr_valid_dst && wr_push_flag_dst);
    assign read_signal = tmp_bram_data_valid;

    bram_addr_fifo_ft BRAM_ADDR_FIFO_FT (
    // custom_fifo_ft #(.FIFO_DWIDTH(22), .FIFO_AWIDTH(2)) BRAM_ADDR_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (rd_valid_src ? 0 : wr_addr_dst),
        .wr_en      (write_signal),
        .rd_en      (read_signal),
        .dout       (bram_addr_top),
        .almost_full(buffer_full),
        .full       (),
        .empty      (buffer_empty),
        .data_count (buffer_datacount),
        .valid      ()
    );

    push_flag_fifo_ft PUSH_FLAG_FIFO_FT (
    // custom_fifo_ft #(.FIFO_DWIDTH(22), .FIFO_AWIDTH(2)) BRAM_ADDR_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (rd_valid_src ? 0 : wr_push_flag_dst),
        .wr_en      (write_signal),
        .rd_en      (read_signal),
        .dout       (push_flag_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    active_v_value_fifo_ft ACTIVE_V_VALUE_FIFO_FT (
    // custom_fifo_ft #(.FIFO_DWIDTH(20), .FIFO_AWIDTH(2)) ACTIVE_V_VALUE_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (rd_valid_src ? 0 : wr_v_value_dst),
        .wr_en      (write_signal),
        .rd_en      (read_signal),
        .dout       (v_value_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    pull_first_flag_fifo_ft PULL_FIRST_FLAG_FIFO_FT (
    // custom_fifo_ft #(.FIFO_DWIDTH(20), .FIFO_AWIDTH(2)) ACTIVE_V_VALUE_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (rd_valid_src ? 0 : wr_pull_first_flag_dst),
        .wr_en      (write_signal),
        .rd_en      (read_signal),
        .dout       (pull_first_flag_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    always @ (posedge clk) begin
        if (rst) begin
            tmp_rd_addr <= 0;
            tmp_rd_addr_valid <= 0;
        end else begin
            if (rd_valid_src) begin
                tmp_rd_addr <= rd_addr_src == {V_ID_WIDTH{1'b1}} ? rd_addr_src : (rd_addr_src >> CORE_NUM_WIDTH);
                tmp_rd_addr_valid <= 1;
            end else begin
                if (wr_valid_dst && wr_push_flag_dst) begin
                    tmp_rd_addr <= wr_addr_dst >> CORE_NUM_WIDTH;
                    tmp_rd_addr_valid <= 1;
                end else begin
                    tmp_rd_addr <= 0;
                    tmp_rd_addr_valid <= 0;
                end
            end
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            tmp_wr_addr <= 0;
            tmp_wr_data <= 0;
            tmp_wr_addr_valid <= 0;

            src_recv_update_v_value <= 0;
            src_recv_update_v_valid <= 0;

            backend_active_v_id <= 0;
            backend_active_v_updated <= 0;
            backend_active_v_pull_first_flag <= 0;
            backend_active_v_valid <= 0;
        end else begin
            if (wr_valid_dst && !wr_push_flag_dst) begin
                if (wr_v_value_dst != INVALID_BFS_VALUE && wr_v_value_dst <= front_iteration_id) begin
                    tmp_wr_addr <= wr_addr_dst >> CORE_NUM_WIDTH;
                    tmp_wr_data <= wr_v_value_dst + 1;
                    tmp_wr_addr_valid <= 1;

                    backend_active_v_id <= wr_addr_dst;
                    backend_active_v_updated <= 1;
                    backend_active_v_pull_first_flag <= wr_pull_first_flag_dst;
                    backend_active_v_valid <= 1;
                end else begin
                    tmp_wr_addr <= 0;
                    tmp_wr_data <= 0;
                    tmp_wr_addr_valid <= 0;

                    backend_active_v_id <= wr_addr_dst;
                    backend_active_v_updated <= 0;
                    backend_active_v_pull_first_flag <= wr_pull_first_flag_dst;
                    backend_active_v_valid <= 1;
                end
            end else begin
                if (tmp_bram_data_valid && push_flag_top) begin
                    if (tmp_bram_data > v_value_top || tmp_bram_data == INVALID_BFS_VALUE) begin
                        tmp_wr_addr <= bram_addr_top >> CORE_NUM_WIDTH;
                        tmp_wr_data <= v_value_top;
                        tmp_wr_addr_valid <= 1;

                        backend_active_v_id <= bram_addr_top;
                        backend_active_v_updated <= 1;
                        backend_active_v_pull_first_flag <= pull_first_flag_top;
                        backend_active_v_valid <= 1;
                    end else begin
                        tmp_wr_addr <= 0;
                        tmp_wr_data <= 0;
                        tmp_wr_addr_valid <= 0;

                        backend_active_v_id <= bram_addr_top;
                        backend_active_v_updated <= 0;
                        backend_active_v_pull_first_flag <= pull_first_flag_top;
                        backend_active_v_valid <= 1;
                    end
                end else begin
                    tmp_wr_addr <= 0;
                    tmp_wr_data <= 0;
                    tmp_wr_addr_valid <= 0;

                    backend_active_v_id <= 0;
                    backend_active_v_updated <= 0;
                    backend_active_v_pull_first_flag <= 0;
                    backend_active_v_valid <= 0;
                end
            end

            if (tmp_bram_data_valid && !push_flag_top) begin
                src_recv_update_v_value <= tmp_bram_data;
                src_recv_update_v_valid <= 1;
            end else begin
                src_recv_update_v_value <= 0;
                src_recv_update_v_valid <= 0;
            end
        end
    end

    always @ (posedge clk) begin
        if (!rst && front_iteration_end && front_iteration_end_valid && buffer_empty && !buffer_datacount) begin
            iteration_end <= 1;
            iteration_end_valid <= 1;
        end else begin
            iteration_end <= 0;
            iteration_end_valid <= 0;
        end
    end

endmodule