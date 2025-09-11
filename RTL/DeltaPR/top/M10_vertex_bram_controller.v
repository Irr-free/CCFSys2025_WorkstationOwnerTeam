`timescale 1ns / 1ps

`include "accelerator.vh"

module vtx_ram_controller #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    V_OFF_AWIDTH = `V_OFF_AWIDTH,
    DELTA_BRAM_AWIDTH = `DELTA_BRAM_AWIDTH,
    DELTA_BRAM_DWIDTH = `DELTA_BRAM_DWIDTH,
    PR_URAM_AWIDTH = `PR_URAM_AWIDTH,
    PR_URAM_DWIDTH = `PR_URAM_DWIDTH,
    ITERATION_WIDTH = `ITERATION_WIDTH,
    CORE_NUM = `CORE_NUM,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH,
    HBM_DWIDTH_PER_CORE = `HBM_DWIDTH_PER_CORE,
    PSEUDO_CHANNEL_NUM = `PSEUDO_CHANNEL_NUM,
    ADDED_CONST = `ADDED_CONST,
    BITMAP_COMPRESSED_LENGTH_WIDTH = `BITMAP_COMPRESSED_LENGTH_WIDTH
) (
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    rst,
    input  [32 - 1 : 0]                         one_over_n,
    input  [32 - 1 : 0]                         added_const,
    input  [32 - 1 : 0]                         delta2_value,
    input  [32 - 1 : 0]                         bitmap_compressed_num,
    input  [2 : 0]                              acc_state,
    input                                       uram_rst,
    input                                       transfer_bram,
    input                                       initial_bram,
    input [PSEUDO_CHANNEL_NUM - 1 : 0]          hbm_write_full,
    input [CORE_NUM * V_OFF_AWIDTH - 1 : 0]       rd_addr_src,
    input [CORE_NUM - 1 : 0]                    rd_valid_src,
    input [CORE_NUM * V_OFF_AWIDTH - 1 : 0]       wr_addr_dst,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    wr_v_value_dst,
    input [CORE_NUM - 1 : 0]                    wr_valid_dst,
    input [CORE_NUM - 1 : 0]                    front_iteration_end,
    input [CORE_NUM - 1 : 0]                    front_iteration_end_valid,
    input [CORE_NUM * ITERATION_WIDTH - 1 : 0]  front_iteration_id,

    // to hbm
    output reg [CORE_NUM - 1 : 0]               next_rst,
    output                                      transfer_done,
    output [CORE_NUM * HBM_DWIDTH_PER_CORE - 1 : 0] wb_bfs_data,
    output [PSEUDO_CHANNEL_NUM - 1 : 0] wb_bfs_valid,

    output [CORE_NUM - 1 : 0]                   stage_full,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   src_recv_update_v_value,
    output [CORE_NUM - 1 : 0]                   src_recv_update_v_valid,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      backend_active_v_id,
    output [CORE_NUM - 1 : 0]                   backend_active_v_updated,
    output [CORE_NUM - 1 : 0]                   backend_active_v_valid,
    output [CORE_NUM - 1 : 0]                   iteration_end,
    output [CORE_NUM - 1 : 0]                   iteration_end_valid
);

    // from ram
    wire [DELTA_BRAM_DWIDTH - 1 : 0]    delta1_bram_data [0 : CORE_NUM - 1];
    reg [2 : 0]                         delta1_bram_data_valid [0 : CORE_NUM - 1];
    wire [DELTA_BRAM_DWIDTH - 1 : 0]    delta2_bram_data [0 : CORE_NUM - 1];
    reg [2 : 0]                         delta2_bram_data_valid [0 : CORE_NUM - 1];
    wire [PR_URAM_DWIDTH - 1 : 0]       pr_uram_data [0 : CORE_NUM - 1];
    reg [4 : 0]                         pr_uram_data_valid [0 : CORE_NUM - 1];

    // to ram
    wire [DELTA_BRAM_AWIDTH - 1 : 0]    delta1_bram_rd_addr [0 : CORE_NUM - 1];
    wire                                delta1_bram_rd_valid [0 : CORE_NUM - 1];
    wire [DELTA_BRAM_AWIDTH - 1 : 0]    delta2_bram_rd_addr [0 : CORE_NUM - 1];
    wire                                delta2_bram_rd_valid [0 : CORE_NUM - 1];
    wire [PR_URAM_AWIDTH - 1 : 0]       pr_uram_rd_addr [0 : CORE_NUM - 1];
    wire                                pr_uram_rd_valid [0 : CORE_NUM - 1];
    wire [DELTA_BRAM_AWIDTH - 1 : 0]    delta1_bram_wr_addr [0 : CORE_NUM - 1];
    wire [DELTA_BRAM_DWIDTH - 1 : 0]    delta1_bram_wr_value [0 : CORE_NUM - 1];
    wire                                delta1_bram_wr_valid [0 : CORE_NUM - 1];
    wire [DELTA_BRAM_AWIDTH - 1 : 0]    delta2_bram_wr_addr [0 : CORE_NUM - 1];
    wire [DELTA_BRAM_DWIDTH - 1 : 0]    delta2_bram_wr_value [0 : CORE_NUM - 1];
    wire                                delta2_bram_wr_valid [0 : CORE_NUM - 1];
    wire [PR_URAM_AWIDTH - 1 : 0]       pr_uram_wr_addr [0 : CORE_NUM - 1];
    wire [PR_URAM_DWIDTH - 1 : 0]       pr_uram_wr_value [0 : CORE_NUM - 1];
    wire                                pr_uram_wr_valid [0 : CORE_NUM - 1];

    reg [PR_URAM_AWIDTH : 0] local_transfer_addr [0 : 5];
    reg [PR_URAM_AWIDTH - 1 : 0] initial_uram_addr ;
    reg initial_done;

    reg [20 - 1 : 0] time_count  = {20{1'b0}}; 
    reg time_unlock[0 : 5];

    reg local_transfer_valid [0 : 5];
    reg local_lock;
    
    assign transfer_done = (local_transfer_addr[5] ==  (bitmap_compressed_num << BITMAP_COMPRESSED_LENGTH_WIDTH));
    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            assign wb_bfs_data[(i + 1) * HBM_DWIDTH_PER_CORE - 1 : i * HBM_DWIDTH_PER_CORE] = (local_transfer_addr[5] == (bitmap_compressed_num << BITMAP_COMPRESSED_LENGTH_WIDTH) && time_unlock[5]) ? time_count : pr_uram_data[i];
        end
        for (i = 0; i < PSEUDO_CHANNEL_NUM; i = i + 1) begin
            assign wb_bfs_valid[i] = local_transfer_valid[5];
        end
    endgenerate

    always @ (posedge clk) begin
        next_rst <= rst;
        if (rst) begin
            time_count <= 0;
        end else begin
            if(!transfer_done && acc_state == 2'b10)  begin
                time_count <= time_count + 1;
            end
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            time_unlock[0] <= 0;
        end else begin
            if(local_transfer_addr[0] == ((bitmap_compressed_num << BITMAP_COMPRESSED_LENGTH_WIDTH) - 1) || !transfer_bram)  begin
                time_unlock[0] <= 1;
            end else begin
                time_unlock[0] <= 0;
            end
        end
        time_unlock[1] <= time_unlock[0];
        time_unlock[2] <= time_unlock[1];
        time_unlock[3] <= time_unlock[2];
        time_unlock[4] <= time_unlock[3];
        time_unlock[5] <= time_unlock[4];

    end
    
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
            else if (transfer_bram && local_transfer_addr[0] <= ((bitmap_compressed_num << BITMAP_COMPRESSED_LENGTH_WIDTH) - 1) && !hbm_write_full[0] && !hbm_write_full[1]) begin
                local_transfer_addr[0] <= local_transfer_addr[0] + 1;
                local_transfer_valid[0] <= 1'b1;
            end else begin
                local_transfer_valid[0] <= 0;
            end
        end
        local_transfer_addr[5] <= local_transfer_addr[4];
        local_transfer_addr[4] <= local_transfer_addr[3];
        local_transfer_addr[3] <= local_transfer_addr[2];
        local_transfer_addr[2] <= local_transfer_addr[1];
        local_transfer_addr[1] <= local_transfer_addr[0];
        local_transfer_valid[5] <= local_transfer_valid[4];
        local_transfer_valid[4] <= local_transfer_valid[3];
        local_transfer_valid[3] <= local_transfer_valid[2];
        local_transfer_valid[2] <= local_transfer_valid[1];
        local_transfer_valid[1] <= local_transfer_valid[0];
    end

    always @ (posedge clk) begin
        if(uram_rst) begin
            initial_uram_addr <= 0;
        end else begin
            if(initial_bram && !initial_done) begin
                initial_uram_addr <= initial_uram_addr + 1;
            end
        end
    end

    always @(posedge clk) begin
        if (uram_rst) begin
            initial_done <= 1'b0;
        end
        else begin
            if (&initial_uram_addr) begin
                initial_done <= 1'b1;
            end
        end
    end

    generate
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            vtx_ram_controller_single#(.CORE_ID(i)) VTX_RAM_CONTROLLER_SINGLE (
                .clk                (clk),
                .rst                (rst[i]),
                .rd_addr_src        (rd_addr_src[(i + 1) * V_OFF_AWIDTH - 1 : i * V_OFF_AWIDTH]),
                .rd_valid_src       (rd_valid_src[i]),
                .wr_addr_dst        (wr_addr_dst[(i + 1) * V_OFF_AWIDTH - 1 : i * V_OFF_AWIDTH]),
                .wr_v_value_dst     (wr_v_value_dst[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .wr_valid_dst       (wr_valid_dst[i]),
                .front_iteration_end(front_iteration_end[i]),
                .front_iteration_end_valid  (front_iteration_end_valid[i]),
                .front_iteration_id (front_iteration_id[(i + 1) * ITERATION_WIDTH - 1 : i * ITERATION_WIDTH]),

                .delta1_bram_data               (delta1_bram_data[i]),
                .delta1_bram_data_valid         (delta1_bram_data_valid[i][2]),
                .delta2_bram_data               (delta2_bram_data[i]),
                .delta2_bram_data_valid         (delta2_bram_data_valid[i][2]),
                .pr_uram_data                   (pr_uram_data[i]),
                .pr_uram_data_valid             (pr_uram_data_valid[i][4]),


                .delta1_bram_rd_addr            (delta1_bram_rd_addr[i]),
                .delta1_bram_rd_valid           (delta1_bram_rd_valid[i]),
                .delta2_bram_rd_addr            (delta2_bram_rd_addr[i]),
                .delta2_bram_rd_valid           (delta2_bram_rd_valid[i]),
                .pr_uram_rd_addr                (pr_uram_rd_addr[i]),
                .pr_uram_rd_valid               (pr_uram_rd_valid[i]),
                .delta1_bram_wr_addr            (delta1_bram_wr_addr[i]),
                .delta1_bram_wr_value           (delta1_bram_wr_value[i]),
                .delta1_bram_wr_valid           (delta1_bram_wr_valid[i]),
                .delta2_bram_wr_addr            (delta2_bram_wr_addr[i]),
                .delta2_bram_wr_value           (delta2_bram_wr_value[i]),
                .delta2_bram_wr_valid           (delta2_bram_wr_valid[i]),
                .pr_uram_wr_addr                (pr_uram_wr_addr[i]),
                .pr_uram_wr_value               (pr_uram_wr_value[i]),
                .pr_uram_wr_valid               (pr_uram_wr_valid[i]),

                .stage_full                     (stage_full[i]),
                .src_recv_update_v_value        (src_recv_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .src_recv_update_v_valid        (src_recv_update_v_valid[i]),
                .backend_active_v_id            (backend_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .backend_active_v_updated       (backend_active_v_updated[i]),
                .backend_active_v_valid         (backend_active_v_valid[i]),
                .iteration_end                  (iteration_end[i]),
                .iteration_end_valid            (iteration_end_valid[i])
            );

            // BUG 跑1048576大图需要深度为32768，但U280的BRAM不够用，故将浮点数压缩后四位降低部分精度（涉及改动为din、dout），还是不行，压缩八位
            delta1_bram_ip_single DELTA1_BRAM_IP_SINGLE (
                .clka       (clk),
                .ena        (!uram_rst),
                .wea        ((initial_bram && !initial_done) || delta1_bram_wr_valid[i]),
                .addra      (initial_bram ? initial_uram_addr : delta1_bram_wr_addr[i]),
                .dina       (initial_bram ? {one_over_n[V_VALUE_WIDTH - 1 : 8], {ITERATION_WIDTH{1'b0}}} : delta1_bram_wr_value[i]),
                .clkb       (clk),
                .enb        (!rst[i] ),
                .addrb      (delta1_bram_rd_addr[i]),
                .doutb      (delta1_bram_data[i])
            );

            delta2_bram_ip_single DELTA2_BRAM_IP_SINGLE (
                .clka       (clk),
                .ena        (!uram_rst),
                .wea        ((initial_bram && !initial_done) || delta2_bram_wr_valid[i]),
                .addra      (initial_bram ? initial_uram_addr : delta2_bram_wr_addr[i]),
                .dina       (initial_bram ? {delta2_value[V_VALUE_WIDTH - 1 : 8], {ITERATION_WIDTH{1'b0}}} : delta2_bram_wr_value[i]),
                .clkb       (clk),
                .enb        (!rst[i] ),
                .addrb      (delta2_bram_rd_addr[i]),
                .doutb      (delta2_bram_data[i])
            );

            pr_uram PR_URAM (
                .clk    (clk),
                .we     ((initial_bram && !initial_done) || pr_uram_wr_valid[i]),
                .mem_en (1'b1),
                .din    (initial_bram ? added_const : pr_uram_wr_value[i]),
                .addra  (initial_bram ? initial_uram_addr : pr_uram_wr_addr[i]),
                .addrb  (transfer_bram ? local_transfer_addr[0] : pr_uram_rd_addr[i]),
                .dout   ( pr_uram_data[i])
            );

            always @ (posedge clk) begin
                delta1_bram_data_valid[i][0] <= delta1_bram_rd_valid[i];
                delta1_bram_data_valid[i][1] <= delta1_bram_data_valid[i][0];
                delta1_bram_data_valid[i][2] <= delta1_bram_data_valid[i][1];
                delta2_bram_data_valid[i][0] <= delta2_bram_rd_valid[i];
                delta2_bram_data_valid[i][1] <= delta2_bram_data_valid[i][0];
                delta2_bram_data_valid[i][2] <= delta2_bram_data_valid[i][1];
                pr_uram_data_valid[i][0] <= pr_uram_rd_valid[i];
                pr_uram_data_valid[i][1] <= pr_uram_data_valid[i][0];
                pr_uram_data_valid[i][2] <= pr_uram_data_valid[i][1];
                pr_uram_data_valid[i][3] <= pr_uram_data_valid[i][2];
                pr_uram_data_valid[i][4] <= pr_uram_data_valid[i][3];
            end
        end
    endgenerate
    
endmodule

module vtx_ram_controller_single #(parameter
    CORE_ID = 0,
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    V_OFF_AWIDTH = `V_OFF_AWIDTH,
    DELTA_BRAM_AWIDTH = `DELTA_BRAM_AWIDTH,
    DELTA_BRAM_DWIDTH = `DELTA_BRAM_DWIDTH,
    PR_URAM_AWIDTH = `PR_URAM_AWIDTH,
    PR_URAM_DWIDTH = `PR_URAM_DWIDTH,
    ITERATION_WIDTH = `ITERATION_WIDTH,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH,
    FIFO_SIZE_WIDTH = `FIFO_SIZE_WIDTH,
    CORE_NUM = `CORE_NUM,
    E2 = `E2,
    FLOAT_ADD_DELAY = 18,
    FLOAT_MULTIPLY_DELAY = 5,
    FLOAT_COMPARE_DELAY = 2,
    FLOAT_SUBSTRACT_DELAY = 11
) (
    input                   clk,
    input                   rst,
    input [V_OFF_AWIDTH - 1 : 0]      rd_addr_src,
    input                           rd_valid_src,
    input [V_OFF_AWIDTH - 1 : 0]      wr_addr_dst,
    input [V_VALUE_WIDTH - 1 : 0]   wr_v_value_dst,
    input                           wr_valid_dst,
    input                           front_iteration_end,
    input                           front_iteration_end_valid,
    input [ITERATION_WIDTH - 1 : 0] front_iteration_id,

    // from ram
    input [DELTA_BRAM_DWIDTH - 1 : 0]   delta1_bram_data,
    input                               delta1_bram_data_valid,
    input [DELTA_BRAM_DWIDTH - 1 : 0]   delta2_bram_data,
    input                               delta2_bram_data_valid,
    input [PR_URAM_DWIDTH - 1 : 0]      pr_uram_data,
    input                               pr_uram_data_valid,

    // to ram
    output reg [DELTA_BRAM_AWIDTH - 1 : 0]  delta1_bram_rd_addr ,
    output reg                              delta1_bram_rd_valid,
    output reg [DELTA_BRAM_AWIDTH - 1 : 0]  delta2_bram_rd_addr,
    output reg                              delta2_bram_rd_valid,
    output reg [PR_URAM_AWIDTH - 1 : 0]     pr_uram_rd_addr,
    output reg                              pr_uram_rd_valid,
    output reg [DELTA_BRAM_AWIDTH - 1 : 0]  delta1_bram_wr_addr,
    output reg [DELTA_BRAM_DWIDTH - 1 : 0]  delta1_bram_wr_value,
    output reg                              delta1_bram_wr_valid,
    output reg [DELTA_BRAM_AWIDTH - 1 : 0]  delta2_bram_wr_addr,
    output reg [DELTA_BRAM_DWIDTH - 1 : 0]  delta2_bram_wr_value,
    output reg                              delta2_bram_wr_valid,
    output reg [PR_URAM_AWIDTH - 1 : 0]     pr_uram_wr_addr,
    output reg [PR_URAM_DWIDTH - 1 : 0]     pr_uram_wr_value,
    output reg                              pr_uram_wr_valid,

    output                                  stage_full,
    output reg [V_VALUE_WIDTH - 1 : 0]  src_recv_update_v_value,
    output reg                              src_recv_update_v_valid,
    output reg [V_ID_WIDTH - 1 : 0]         backend_active_v_id,
    output reg                              backend_active_v_updated,
    output reg                              backend_active_v_valid,
    output reg                              iteration_end,
    output reg                              iteration_end_valid
);
    wire [V_OFF_AWIDTH - 1 : 0] wr_delta_addr_top;
    wire [V_VALUE_WIDTH - 1 : 0] wr_delta_value_top;
    wire [V_OFF_AWIDTH - 1 : 0] wr_pr_addr_top;
    wire [V_OFF_AWIDTH - 1 : 0] active_addr_top;
    wire [V_VALUE_WIDTH - 1 : 0]  active_pr_top;
    wire [V_VALUE_WIDTH - 1 : 0] active_delta_top_1, active_delta_top_2;
    wire delta_buffer_empty, pr_buffer_empty;
    wire delta_buffer_full, pr_buffer_full;
    wire active_addr_buffer_empty, active_delta_buffer_empty_0, active_delta_buffer_empty_1, active_pr_buffer_empty;
    reg [V_OFF_AWIDTH - 1 : 0] conflict_check_buffer [0 : FLOAT_ADD_DELAY - 1];
    reg conflict_valid_buffer [0 : FLOAT_ADD_DELAY - 1];
    wire [0 : FLOAT_ADD_DELAY - 1] conflict_array;
    wire conflict;
    wire active_read_signal;
    wire [V_VALUE_WIDTH - 1 : 0] active_data_multiply_result;
    wire active_data_multiply_result_valid;
    wire [V_VALUE_WIDTH - 1 : 0] active_data_substract_result;
    wire active_data_substract_result_valid;
    wire active_data_compare_result, active_data_compare_result_valid;
    reg [V_OFF_AWIDTH - 1 : 0] active_addr_reg [0 : FLOAT_MULTIPLY_DELAY + FLOAT_COMPARE_DELAY + FLOAT_SUBSTRACT_DELAY];
    wire [V_VALUE_WIDTH - 1 : 0] wr_delta1_adder_result;
    wire wr_delta1_adder_result_valid;
    wire [V_VALUE_WIDTH - 1 : 0] wr_delta2_adder_result;
    wire wr_delta2_adder_result_valid;
    wire [V_VALUE_WIDTH - 1 : 0] wr_pr_adder_result;
    wire wr_pr_adder_result_valid;
    wire wr_value_empty;

    reg [DELTA_BRAM_DWIDTH - 1 : 0]   tmp_delta1_bram_data;
    reg [DELTA_BRAM_DWIDTH - 1 : 0]   tmp_delta2_bram_data;

    reg [15 : 0] backend_send, backend_recv;

    reg  [PR_URAM_AWIDTH - 1 : 0]  tmp_pr_uram_rd_addr;
    reg tmp_pr_uram_rd_valid;

    generate
        genvar i;
        for (i = 0; i < FLOAT_ADD_DELAY; i = i + 1) begin
            assign conflict_array[i] = (conflict_check_buffer[i] == wr_delta_addr_top && conflict_valid_buffer[i]);
            // 这里判断如果在FLOAT_ADD_DELAY个时钟内，存在冲突发生，即有相同的地址再次访问，那么就判断有冲突发生
            // pr正确性的要求，需要每次都从bram里面读到最新值，但是浮点加的延迟导致最新值可能还在浮点加法器里面，并没有写回bram，所以必须延迟等它写回bram之后才能读
        end
    endgenerate
    
    assign conflict = !(conflict_array == {FLOAT_ADD_DELAY{1'b0}});
    assign active_read_signal = !active_addr_buffer_empty && !active_delta_buffer_empty_0 && !active_pr_buffer_empty;

    // full信号
    assign stage_full = delta_buffer_full || pr_buffer_full;

    reg [DELTA_BRAM_AWIDTH - 1 : 0] tmp_delta1_bram_rd_addr[ 0 : 1 ] ;
    reg tmp_delta1_bram_rd_valid[ 0 : 1 ] ;
    reg [DELTA_BRAM_AWIDTH - 1 : 0] tmp_delta2_bram_rd_addr[ 0 : 1 ] ;
    reg tmp_delta2_bram_rd_valid[ 0 : 1 ] ;


    // Note: (front_iteration_id[0] && delta1_bram_data_valid) == (!front_iteration_id[0] && delta2_bram_data_valid) == pr_uram_data_valid
    float_adder WR_DELTA1_ADDER (
        .aclk       (clk),
        .s_axis_a_tdata         (wr_delta_value_top),
        .s_axis_a_tvalid        (front_iteration_id[0] && delta1_bram_data_valid),
        .s_axis_b_tdata         (tmp_delta1_bram_data[ITERATION_WIDTH - 1 : 0] == front_iteration_id ? {tmp_delta1_bram_data[DELTA_BRAM_DWIDTH - 1 : ITERATION_WIDTH], 8'h0} : 0),
        .s_axis_b_tvalid        (front_iteration_id[0] && delta1_bram_data_valid),
        .m_axis_result_tdata    (wr_delta1_adder_result),
        .m_axis_result_tvalid   (wr_delta1_adder_result_valid)
    );//更新delta值，如果delta值在当前轮次已经被更新过，则再次更新；否则从0开始更新；

    float_adder WR_DELTA2_ADDER (
        .aclk       (clk),
        .s_axis_a_tdata         (wr_delta_value_top),
        .s_axis_a_tvalid        (!front_iteration_id[0] && delta2_bram_data_valid),
        .s_axis_b_tdata         (tmp_delta2_bram_data[ITERATION_WIDTH - 1 : 0] == front_iteration_id ? {tmp_delta2_bram_data[DELTA_BRAM_DWIDTH - 1 : ITERATION_WIDTH], 8'h0} : 0),
        .s_axis_b_tvalid        (!front_iteration_id[0] && delta2_bram_data_valid),
        .m_axis_result_tdata    (wr_delta2_adder_result),
        .m_axis_result_tvalid   (wr_delta2_adder_result_valid)
    );//更新delta值，如果delta值在当前轮次已经被更新过，则再次更新；否则从0开始更新；更新后加上轮次信息并写回

    float_adder WR_PR_ADDER (
        .aclk       (clk),
        .s_axis_a_tdata         (wr_delta_value_top),
        .s_axis_a_tvalid        (pr_uram_data_valid),
        .s_axis_b_tdata         (pr_uram_data),
        .s_axis_b_tvalid        (pr_uram_data_valid),
        .m_axis_result_tdata    (wr_pr_adder_result),
        .m_axis_result_tvalid   (wr_pr_adder_result_valid)
    );// 更新pagerank值

    wr_delta_addr_fifo_ft WR_DELTA_ADDR_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (wr_addr_dst),
        .wr_en      (wr_valid_dst),
        .rd_en      (!delta_buffer_empty && !conflict), // 地址被存在fifo中，该地址在当前ADD_DELAY个时钟内未被访问，则进行访问
        .dout       (wr_delta_addr_top),
        .prog_full  (delta_buffer_full),
        .full       (),
        .empty      (delta_buffer_empty),
        .valid      ()
    );//这一fifo负责发出地址读取delta_bram和pr_uram的地址

    wr_delta_value_fifo_ft WR_DELTA_VALUE_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (wr_v_value_dst),
        .wr_en      (wr_valid_dst),
        .rd_en      (pr_uram_data_valid),
        .dout       (wr_delta_value_top),
        .full       (),
        .empty      (),
        .valid      ()
    );//wr_delta_value_top表示用于更新pr值和delta值的更新值,也即点的value值

    wr_pr_addr_fifo_ft WR_PR_ADDR_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (wr_addr_dst),
        .wr_en      (wr_valid_dst),
        .rd_en      (wr_pr_adder_result_valid && (wr_delta1_adder_result_valid || wr_delta2_adder_result_valid)),
        .dout       (wr_pr_addr_top),
        .prog_full       (pr_buffer_full),
        .empty      (pr_buffer_empty),
        .valid      ()
    );// 用于将点ID，也即地址进行记录，在写回pr值和delta值时输出；

    float_substract ACTIVE_DATA_SUB (
        .aclk                   (clk),
        .s_axis_a_tdata         (active_pr_top),
        .s_axis_a_tvalid        (active_read_signal),
        .s_axis_b_tdata         ( front_iteration_id == 0 ? 0: active_delta_top_1 ),
        .s_axis_b_tvalid        ( active_read_signal),
        .m_axis_result_tdata    (active_data_substract_result),
        .m_axis_result_tvalid   (active_data_substract_result_valid)
    );// pagerank[src_id].first - (iter_id == 1 ? 0 :next_delta[src_id]) 

    float_multiply ACTIVE_DATA_MULTIPLY (
        .aclk                   (clk),
        .s_axis_a_tdata         (active_data_substract_result),
        .s_axis_a_tvalid        (active_data_substract_result_valid),
        .s_axis_b_tdata         (E2),
        .s_axis_b_tvalid        (active_data_substract_result_valid),
        .m_axis_result_tdata    (active_data_multiply_result),
        .m_axis_result_tvalid   (active_data_multiply_result_valid)
    );//e2 *(pagerank[src_id].first - (iter_id == 1 ? 0 :next_delta[src_id]))

    float_compare ACTIVE_DATA_COMPARE (
        .aclk                   (clk),
        .s_axis_a_tdata         ({1'b0,active_delta_top_2[V_VALUE_WIDTH - 2 : 0]}),
        .s_axis_a_tvalid        (active_data_multiply_result_valid),
        .s_axis_b_tdata         (active_data_multiply_result),
        .s_axis_b_tvalid        (active_data_multiply_result_valid),
        .m_axis_result_tdata    (active_data_compare_result),
        .m_axis_result_tvalid   (active_data_compare_result_valid)
    ); // fabs(next_delta[src_id]) > e2 *(pagerank[src_id].first - (iter_id == 1 ? 0 :next_delta[src_id]))

    active_addr_fifo_ft ACTIVE_ADDR_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (delta2_bram_wr_valid ? delta2_bram_wr_addr : delta1_bram_wr_addr),
        .wr_en      (delta1_bram_wr_valid || delta2_bram_wr_valid),
        .rd_en      (active_read_signal),
        .dout       (active_addr_top),
        .full       (),
        .empty      (active_addr_buffer_empty),
        .valid      ()
    );  // 记录计算pagerank值的点

    active_delta_fifo_ft ACTIVE_DELTA_FIFO_1_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (delta2_bram_wr_valid ? {delta2_bram_wr_value[ DELTA_BRAM_DWIDTH - 1 : ITERATION_WIDTH ], 8'h0} : {delta1_bram_wr_value[ DELTA_BRAM_DWIDTH - 1 : ITERATION_WIDTH ], 8'h0}),
        .wr_en      (delta2_bram_wr_valid || delta1_bram_wr_valid),
        .rd_en      (active_read_signal), //乘法完成后进行比较
        .dout       (active_delta_top_1),
        .full       (),
        .empty      (active_delta_buffer_empty_0),
        .valid      ()
    ); // 存放更新后的next_delta[src_id],用于做差

    active_delta_fifo_ft ACTIVE_DELTA_FIFO_2_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (active_delta_top_1),
        .wr_en      (active_read_signal),
        .rd_en      (active_data_multiply_result_valid), //乘法完成后进行比较
        .dout       (active_delta_top_2),
        .full       (),
        .empty      (active_delta_buffer_empty_1),
        .valid      ()
    ); // 存放更新后的next_delta[src_id]，用于比较

    active_pr_fifo_ft ACTIVE_PR_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        ( pr_uram_wr_value ),
        .wr_en      ( pr_uram_wr_valid ),
        .rd_en      (active_read_signal),
        .dout       (active_pr_top),
        .full       (),
        .empty      (active_pr_buffer_empty),
        .valid      ()
    );// 这里存放从uram读取的pagerank值

    always @ (posedge clk) begin
        if (rst) begin
            backend_send <= 0;
            backend_recv <= 0;
        end else begin
            if (active_read_signal) begin
                backend_send <= backend_send + 1;
            end
            if (active_data_compare_result_valid) begin
                backend_recv <= backend_recv + 1;
            end
        end

        if ( CORE_ID == 3 && wr_valid_dst && wr_addr_dst == 0 ) begin
            $display("3 next_add addr %d result %h",wr_addr_dst,wr_v_value_dst);
        end

        if ( CORE_ID == 23 && wr_valid_dst && wr_addr_dst == 493 ) begin
            $display("15799 next_add addr %d result %h",wr_addr_dst,wr_v_value_dst);
        end
    end
    // 这里是将M2读取的delta值返回到M4
    always @ (posedge clk) begin
        if (rst) begin
            src_recv_update_v_value <= 0;
            src_recv_update_v_valid <= 0;
        end else begin
            if (delta1_bram_data_valid && !front_iteration_id[0]) begin
                src_recv_update_v_value <= {tmp_delta1_bram_data[ DELTA_BRAM_DWIDTH - 1 : ITERATION_WIDTH ], 8'h0};
                src_recv_update_v_valid <= 1;
            end else if (delta2_bram_data_valid && front_iteration_id[0]) begin
                src_recv_update_v_value <= {tmp_delta2_bram_data[ DELTA_BRAM_DWIDTH - 1 : ITERATION_WIDTH ], 8'h0};
                src_recv_update_v_valid <= 1;
            end else begin
                src_recv_update_v_value <= 0;
                src_recv_update_v_valid <= 0;
            end
        end
    end

    integer j;
    always @ (posedge clk) begin
        if (active_read_signal) begin
            active_addr_reg[0] <= active_addr_top;
        end else begin
            active_addr_reg[0] <= 0;    
        end

        for (j = 0; j < FLOAT_MULTIPLY_DELAY + FLOAT_COMPARE_DELAY + FLOAT_SUBSTRACT_DELAY; j = j + 1) begin
            active_addr_reg[j + 1] <= active_addr_reg[j];
        end
        if (rst) begin
            backend_active_v_id <= 0;
            backend_active_v_updated <= 0;
            backend_active_v_valid <= 0;
        end else begin
            if (active_data_compare_result_valid) begin
                backend_active_v_updated <= active_data_compare_result;
                backend_active_v_id <= (active_addr_reg[FLOAT_MULTIPLY_DELAY + FLOAT_COMPARE_DELAY + FLOAT_SUBSTRACT_DELAY ] << CORE_NUM_WIDTH) + CORE_ID;
                backend_active_v_valid <= 1;
                if ( CORE_ID == 23 && active_addr_reg[FLOAT_MULTIPLY_DELAY + FLOAT_COMPARE_DELAY + FLOAT_SUBSTRACT_DELAY ] == 493 ) begin
                    $display("15799 updated compare result %d",active_data_compare_result);
                end
            end else begin
                backend_active_v_id <= 0;
                backend_active_v_updated <= 0;
                backend_active_v_valid <= 0;
            end
        end
    end

    always @ (posedge clk) begin
        if(rst) begin
            tmp_delta1_bram_data <= 0;
            tmp_delta2_bram_data <= 0;
        end else begin
            tmp_delta1_bram_data <= delta1_bram_data;
            tmp_delta2_bram_data <= delta2_bram_data;
        end
    end

    // send rd request
    always @ (posedge clk) begin
        if (rst) begin
            //这里注意修改bram访问时间会同时影响访问cu_delta和访问next_delta的时间，因此通过这里修改要注意修改两处的地方
            delta1_bram_rd_addr <= 0;
            delta1_bram_rd_valid <= 0;

            delta2_bram_rd_addr <= 0;
            delta2_bram_rd_valid <= 0;

            tmp_delta1_bram_rd_addr[0] <= 0;
            tmp_delta1_bram_rd_valid[0] <= 0;

            tmp_delta2_bram_rd_addr[0] <= 0;
            tmp_delta2_bram_rd_valid[0] <= 0;

            tmp_delta1_bram_rd_addr[1] <= 0;
            tmp_delta1_bram_rd_valid[1] <= 0;

            tmp_delta2_bram_rd_addr[1] <= 0;
            tmp_delta2_bram_rd_valid[1] <= 0;

            pr_uram_rd_addr <= 0;
            pr_uram_rd_valid <= 0;
            

            for (j = 0; j < FLOAT_ADD_DELAY; j = j + 1) begin
                conflict_check_buffer[j] <= 0;
                conflict_valid_buffer[j] <= 0;
            end
        end else begin
            // bram与uram相比，慢一个clk
            tmp_delta1_bram_rd_addr[1] <= tmp_delta1_bram_rd_addr[0];
            tmp_delta1_bram_rd_valid[1] <= tmp_delta1_bram_rd_valid[0];
            delta1_bram_rd_addr <= tmp_delta1_bram_rd_addr[1];
            delta1_bram_rd_valid <= tmp_delta1_bram_rd_valid[1];

            tmp_delta2_bram_rd_addr[1] <= tmp_delta2_bram_rd_addr[0];
            tmp_delta2_bram_rd_valid[1] <= tmp_delta2_bram_rd_valid[0];
            delta2_bram_rd_addr <= tmp_delta2_bram_rd_addr[1];
            delta2_bram_rd_valid <= tmp_delta2_bram_rd_valid[1];
            for (j = FLOAT_ADD_DELAY - 1; j > 0; j = j - 1) begin
                conflict_check_buffer[j] <= conflict_check_buffer[j - 1];
                conflict_valid_buffer[j] <= conflict_valid_buffer[j - 1];
            end
            // delta1
            if (!front_iteration_id[0] && rd_valid_src) begin
                tmp_delta1_bram_rd_addr[0] <= rd_addr_src;
                tmp_delta1_bram_rd_valid[0] <= 1;
            end else if (front_iteration_id[0] && !delta_buffer_empty && !conflict) begin
                tmp_delta1_bram_rd_addr[0] <= wr_delta_addr_top;
                tmp_delta1_bram_rd_valid[0] <= 1;
                // 更新delta1值前需要先将delta1的值读出来
            end else begin
                tmp_delta1_bram_rd_addr[0] <= 0;
                tmp_delta1_bram_rd_valid[0] <= 0;
            end
            // delta2
            if (front_iteration_id[0] && rd_valid_src) begin
                tmp_delta2_bram_rd_addr[0] <= rd_addr_src;
                tmp_delta2_bram_rd_valid[0] <= 1;
                // delta2_bram_rd_addr <= rd_addr_src;
                // delta2_bram_rd_valid <= 1;
            end else if (!front_iteration_id[0] && !delta_buffer_empty && !conflict) begin
                tmp_delta2_bram_rd_addr[0] <= wr_delta_addr_top;
                tmp_delta2_bram_rd_valid[0] <= 1;
                // delta2_bram_rd_addr <= wr_delta_addr_top;
                // delta2_bram_rd_valid <= 1;
            end else begin
                tmp_delta2_bram_rd_addr[0] <= 0;
                tmp_delta2_bram_rd_valid[0] <= 0;
                // delta2_bram_rd_addr <= 0; 
                // delta2_bram_rd_valid <= 0;
            end
            // pr
            if (!delta_buffer_empty && !conflict) begin
                pr_uram_rd_addr <= wr_delta_addr_top;
                pr_uram_rd_valid <= 1;
                // wr_delta_addr_top除了发出读取指令外，还把地址加入了检查buffer里，用于防止在ADD_DELAY个时钟内连续访问相同的地址
                conflict_check_buffer[0] <= wr_delta_addr_top;
                conflict_valid_buffer[0] <= 1;
            end else begin
                pr_uram_rd_addr <= 0;
                pr_uram_rd_valid <= 0;
                conflict_check_buffer[0] <= 0;
                conflict_valid_buffer[0] <= 0;
            end
        end
    end

    // send wr request
    always @ (posedge clk) begin
        if (rst) begin
            delta1_bram_wr_addr <= 0;
            delta1_bram_wr_value <= 0;
            delta1_bram_wr_valid <= 0;

            delta2_bram_wr_addr <= 0;
            delta2_bram_wr_value <= 0;
            delta2_bram_wr_valid <= 0;

            pr_uram_wr_addr <= 0;
            pr_uram_wr_value <= 0;
            pr_uram_wr_valid <= 0;
        end else begin

            if (!front_iteration_id[0] && wr_delta2_adder_result_valid) begin
                delta2_bram_wr_addr <= wr_pr_addr_top;
                delta2_bram_wr_value <= {wr_delta2_adder_result[V_VALUE_WIDTH - 1 : 8], front_iteration_id};
                delta2_bram_wr_valid <= 1;
                if( CORE_ID == 3 && wr_pr_addr_top == 0) begin
                    $display("3 delta2 addr %d result  %h",wr_pr_addr_top,wr_delta2_adder_result);
                end

                if( CORE_ID == 23 && wr_pr_addr_top == 493) begin
                    $display("15799 delta2 addr %d result  %h",wr_pr_addr_top,wr_delta2_adder_result);
                end

                delta1_bram_wr_addr <= 0;
                delta1_bram_wr_value <= 0;
                delta1_bram_wr_valid <= 0;
            end else if (front_iteration_id[0] && wr_delta1_adder_result_valid) begin
                delta1_bram_wr_addr <= wr_pr_addr_top;
                delta1_bram_wr_value <= {wr_delta1_adder_result[V_VALUE_WIDTH - 1 : 8], front_iteration_id};
                delta1_bram_wr_valid <= 1;
                if( CORE_ID == 3 && wr_pr_addr_top == 0) begin
                    $display("3 delta1 addr %d result %h",wr_pr_addr_top,wr_delta1_adder_result);
                end
                if( CORE_ID == 23 && wr_pr_addr_top == 493) begin
                    $display("15799 delta1 addr %d result %h",wr_pr_addr_top,wr_delta1_adder_result);
                end

                delta2_bram_wr_addr <= 0;
                delta2_bram_wr_value <= 0;
                delta2_bram_wr_valid <= 0;
            end else begin
                delta1_bram_wr_addr <= 0;
                delta1_bram_wr_value <= 0;
                delta1_bram_wr_valid <= 0;

                delta2_bram_wr_addr <= 0;
                delta2_bram_wr_value <= 0;
                delta2_bram_wr_valid <= 0;
            end
            // pr
            if (wr_pr_adder_result_valid) begin
                pr_uram_wr_addr <= wr_pr_addr_top;
                pr_uram_wr_value <= wr_pr_adder_result;  // 将相加结果写回pagerank_uram
                pr_uram_wr_valid <= 1;
                if( CORE_ID == 3 && wr_pr_addr_top == 0) begin
                    $display("3 pr addr %d result %h",wr_pr_addr_top,wr_pr_adder_result);
                end
                if( CORE_ID == 23 && wr_pr_addr_top == 493) begin
                    $display("15799 pr addr %d result %h",wr_pr_addr_top,wr_pr_adder_result);
                end
            end else begin
                pr_uram_wr_addr <= 0;
                pr_uram_wr_value <= 0;
                pr_uram_wr_valid <= 0;
            end
        end
    end

    always @ (posedge clk) begin
        if (!rst && front_iteration_end && front_iteration_end_valid && active_addr_buffer_empty  && delta_buffer_empty && pr_buffer_empty &&
                active_delta_buffer_empty_0 && active_delta_buffer_empty_1 && active_pr_buffer_empty && backend_send == backend_recv) begin
            iteration_end <= 1;
            iteration_end_valid <= 1;
        end else begin
            iteration_end <= 0;
            iteration_end_valid <= 0;
        end
    end

endmodule

// 为什么pagerank需要用uram存储，uram如何初始化

module pr_uram #(parameter
    AWIDTH = `PR_URAM_AWIDTH,
    DWIDTH = `PR_URAM_DWIDTH,
    NBPIPE = 3
) (
    input clk,
    input we,
    input mem_en,
    input [DWIDTH - 1 : 0] din,
    input [AWIDTH - 1 : 0] addra,
    input [AWIDTH - 1 : 0] addrb,

    output reg [DWIDTH - 1 : 0] dout
);


    //  Xilinx UltraRAM Single Port Read First Mode.  This code implements 
    //  a parameterizable UltraRAM block in read first mode. The behavior of this RAM is 
    //  when data is written, the old memory contents at the write address are 
    //  presented on the output port.
    //
    (* ram_style = "ultra" *)
    reg [DWIDTH - 1:0] mem [(1 << AWIDTH) - 1 : 0];      // Memory Declaration,only 512 for 16384,remember to change!
    // reg [DWIDTH - 1:0] mem [(1 << 9) - 1 : 0];        // Memory Declaration,only 512 for 16384,remember to change!
    reg [DWIDTH - 1:0] memreg;              
    reg [DWIDTH - 1:0] mem_pipe_reg [NBPIPE - 1 : 0];    // Pipelines for memory
    reg mem_en_pipe_reg[NBPIPE : 0];                // Pipelines for memory enable  

    integer          i;


/*
    initial begin
        for (i = 0; i < (1 << AWIDTH); i = i + 1) begin
            mem[i] <= i;
        end
    end
*/


    // RAM : Both READ and WRITE have a latency of one
    always @ (posedge clk) begin
       if(mem_en) begin
           if(we) begin
                mem[addra] <= din;
           end
           memreg <= mem[addrb];
       end
    end

    // The enable of the RAM goes through a pipeline to produce a
    // series of pipelined enable signals required to control the data
    // pipeline.
    always @ (posedge clk) begin
        mem_en_pipe_reg[0] <= mem_en;
        for (i = 0; i < NBPIPE; i = i + 1) begin
            mem_en_pipe_reg[i + 1] <= mem_en_pipe_reg[i];
        end
    end

    // RAM output data goes through a pipeline.
    always @ (posedge clk) begin
        if (mem_en_pipe_reg[0]) begin
            mem_pipe_reg[0] <= memreg;
        end
    end    

    always @ (posedge clk) begin
        for (i = 0; i < NBPIPE - 1; i = i + 1) begin
            if (mem_en_pipe_reg[i + 1]) begin
                mem_pipe_reg[i + 1] <= mem_pipe_reg[i];
            end
        end
    end      

    // Final output register gives user the option to add a reset and
    // an additional enable signal just for the data ouptut
    always @ (posedge clk) begin
        if (mem_en_pipe_reg[NBPIPE]) begin
            dout <= mem_pipe_reg[NBPIPE - 1];
        end
    end
						
endmodule