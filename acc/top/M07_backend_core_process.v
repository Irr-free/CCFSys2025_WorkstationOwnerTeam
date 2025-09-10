`timescale 1ns / 1ps

`include "accelerator.vh"

module backend_core #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VTX_BRAM_AWIDTH = `VTX_BRAM_AWIDTH,
    VTX_BRAM_DWIDTH = `VTX_BRAM_DWIDTH,
    ITERATION_DWIDTH = `ITERATION_DWIDTH,
    CORE_NUM = `CORE_NUM
) (
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    om1_rst,
    input [CORE_NUM - 1 : 0]                    om1_recv_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       om1_recv_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    om1_recv_update_v_value,
    input [CORE_NUM - 1 : 0]                    om1_recv_update_v_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    om1_recv_update_v_valid,
    input [CORE_NUM - 1 : 0]                    om1_recv_iteration_end,
    input [CORE_NUM - 1 : 0]                    om1_recv_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    om2_rst,
    input [CORE_NUM - 1 : 0]                    om2_stage_full,
    input [CORE_NUM - 1 : 0]                    om2_recv_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       om2_recv_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    om2_recv_update_v_value,
    input [CORE_NUM - 1 : 0]                    om2_recv_update_v_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    om2_recv_update_v_valid,
    input [CORE_NUM - 1 : 0]                    om2_recv_iteration_end,
    input [CORE_NUM - 1 : 0]                    om2_recv_iteration_end_valid,
    input [CORE_NUM * VTX_BRAM_DWIDTH - 1 : 0]  vertex_bram_data,
    input [CORE_NUM - 1 : 0]                    vertex_bram_valid,
    input [CORE_NUM * ITERATION_DWIDTH - 1 : 0] om_global_iteration_id,

    output reg [CORE_NUM - 1 : 0]               next_rst1,
    output reg [CORE_NUM - 1 : 0]               next_rst2,
    output [CORE_NUM - 1 : 0]                   source_core_full,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      rd_vertex_bram_addr,
    output [CORE_NUM - 1 : 0]                   rd_vertex_bram_valid,
    output [CORE_NUM - 1 : 0]                   wr_vertex_bram_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      wr_vertex_bram_addr,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   wr_vertex_bram_data,
    output [CORE_NUM - 1 : 0]                   wr_vertex_bram_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   wr_vertex_bram_valid,
    output [CORE_NUM - 1 : 0]                   wr_vertex_bram_iteration_end,
    output [CORE_NUM - 1 : 0]                   wr_vertex_bram_iteration_end_valid,
    output [CORE_NUM - 1 : 0]                   om2_send_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      om2_send_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   om2_send_update_v_value,
    output [CORE_NUM - 1 : 0]                   om2_send_update_v_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   om2_send_update_v_valid,
    output [CORE_NUM - 1 : 0]                   om2_send_iteration_end,
    output [CORE_NUM - 1 : 0]                   om2_send_iteration_end_valid
);

    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                next_rst1[i] <= om1_rst[i];
                next_rst2[i] <= om2_rst[i];
            end
            backend_source_core_single #(.CORE_ID(i)) BACKEND_SOURCE_CORE_SINGLE (
                .clk                    (clk),
                .rst                    (om1_rst[i]),
                .om1_recv_push_flag     (om1_recv_push_flag[i]),
                .om1_recv_update_v_id   (om1_recv_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .om1_recv_update_v_value(om1_recv_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .om1_recv_update_v_pull_first_flag  (om1_recv_update_v_pull_first_flag[i]),
                .om1_recv_update_v_valid(om1_recv_update_v_valid[i]),
                .om1_recv_iteration_end (om1_recv_iteration_end[i]),
                .om1_recv_iteration_end_valid (om1_recv_iteration_end_valid[i]),
                .vertex_bram_data       (vertex_bram_data[(i + 1) * VTX_BRAM_DWIDTH - 1 : i * VTX_BRAM_DWIDTH]),
                .vertex_bram_valid      (vertex_bram_valid[i]),
                .om_global_iteration_id (om_global_iteration_id[(i + 1) * ITERATION_DWIDTH - 1 : i * ITERATION_DWIDTH]),
                .om2_stage_full         (om2_stage_full[i]),

                .source_core_full           (source_core_full[i]),
                .rd_vertex_bram_addr        (rd_vertex_bram_addr[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .rd_vertex_bram_valid       (rd_vertex_bram_valid[i]),
                .om2_send_push_flag         (om2_send_push_flag[i]),
                .om2_send_update_v_id       (om2_send_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .om2_send_update_v_value    (om2_send_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .om2_send_update_v_pull_first_flag  (om2_send_update_v_pull_first_flag[i]),
                .om2_send_update_v_valid    (om2_send_update_v_valid[i]),
                .om2_send_iteration_end     (om2_send_iteration_end[i]),
                .om2_send_iteration_end_valid   (om2_send_iteration_end_valid[i])
            );

            backend_destination_core_single #(.CORE_ID(i)) BACKEND_DESTINATION_CORE_SINGLE (
                .clk                    (clk),
                .rst                    (om2_rst[i]),
                .om2_recv_push_flag     (om2_recv_push_flag[i]),
                .om2_recv_update_v_id   (om2_recv_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .om2_recv_update_v_value(om2_recv_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .om2_recv_update_v_pull_first_flag  (om2_recv_update_v_pull_first_flag[i]),
                .om2_recv_update_v_valid(om2_recv_update_v_valid[i]),
                .om2_recv_iteration_end (om2_recv_iteration_end[i]),
                .om2_recv_iteration_end_valid   (om2_recv_iteration_end_valid[i]),

                .wr_vertex_bram_push_flag   (wr_vertex_bram_push_flag[i]),
                .wr_vertex_bram_addr    (wr_vertex_bram_addr[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .wr_vertex_bram_data    (wr_vertex_bram_data[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .wr_vertex_bram_pull_first_flag (wr_vertex_bram_pull_first_flag[i]),
                .wr_vertex_bram_valid   (wr_vertex_bram_valid[i]),
                .wr_vertex_bram_iteration_end   (wr_vertex_bram_iteration_end[i]),
                .wr_vertex_bram_iteration_end_valid   (wr_vertex_bram_iteration_end_valid[i])
            );
        end
    endgenerate

endmodule

module backend_source_core_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VTX_BRAM_AWIDTH = `VTX_BRAM_AWIDTH,
    VTX_BRAM_DWIDTH = `VTX_BRAM_DWIDTH,
    ITERATION_DWIDTH = `ITERATION_DWIDTH,
    INVALID_PULL_VALUE = `INVALID_PULL_VALUE,
    FIFO_SIZE_WIDTH = `FIFO_SIZE_WIDTH,
    CORE_ID = 0,
    CORE_NUM = `CORE_NUM
) (
    input                   clk,
    input                   rst,
    input                           om1_recv_push_flag,
    input [V_ID_WIDTH - 1 : 0]      om1_recv_update_v_id,
    input [V_VALUE_WIDTH - 1 : 0]   om1_recv_update_v_value,
    input                           om1_recv_update_v_pull_first_flag,
    input                           om1_recv_update_v_valid,
    input                           om1_recv_iteration_end,
    input                           om1_recv_iteration_end_valid,
    input [VTX_BRAM_DWIDTH - 1 : 0] vertex_bram_data,
    input                           vertex_bram_valid,
    input [ITERATION_DWIDTH - 1 : 0]om_global_iteration_id,
    input                           om2_stage_full,

    output                                  source_core_full,
    output reg [V_ID_WIDTH - 1 : 0]    rd_vertex_bram_addr,
    output reg                              rd_vertex_bram_valid,
    output reg                              om2_send_push_flag,
    output reg [V_ID_WIDTH - 1 : 0]         om2_send_update_v_id,
    output reg [V_VALUE_WIDTH - 1 : 0]      om2_send_update_v_value,
    output reg                              om2_send_update_v_pull_first_flag,
    output reg                              om2_send_update_v_valid,
    output reg                              om2_send_iteration_end,
    output reg                              om2_send_iteration_end_valid
);

    wire active_v_id_buffer_empty, active_v_id_buffer_full,vertex_bram_data_buffer_empty;
    wire [FIFO_SIZE_WIDTH - 1 : 0] active_v_id_buffer_datacount;
    wire [V_ID_WIDTH - 1 : 0] v_id_top;
    wire [V_VALUE_WIDTH - 1 : 0] v_value_top;
    wire pull_first_flag_top, push_flag_top;
    wire [VTX_BRAM_DWIDTH - 1 : 0] vertex_bram_data_top;
    wire read_singal;
    
    assign read_singal = (!push_flag_top && !vertex_bram_data_buffer_empty && !active_v_id_buffer_empty && !om2_stage_full) || (push_flag_top && !active_v_id_buffer_empty && !om2_stage_full);
    assign source_core_full = active_v_id_buffer_full;

    active_v_id_fifo_ft ACTIVE_V_ID_FIFO_FT (
    // custom_fifo_ft #(.FIFO_DWIDTH(20), .FIFO_AWIDTH(2)) ACTIVE_V_ID_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (om1_recv_update_v_id),
        .wr_en      (om1_recv_update_v_valid),
        .rd_en      (read_singal),
        .dout       (v_id_top),
        .prog_full  (active_v_id_buffer_full),
        .full       (),
        .empty      (active_v_id_buffer_empty),
        .data_count (active_v_id_buffer_datacount),
        .valid      ()
    );
    
    active_v_value_fifo_ft ACTIVE_V_VALUE_FIFO_FT (
    // custom_fifo_ft #(.FIFO_DWIDTH(20), .FIFO_AWIDTH(2)) ACTIVE_V_ID_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (om1_recv_update_v_value),
        .wr_en      (om1_recv_update_v_valid),
        .rd_en      (read_singal),
        .dout       (v_value_top),
        .full       (),
        .empty      (),
        .valid      ()
    );
    
    pull_first_flag_fifo_ft PULL_FIRST_FLAG_FIFO_FT (
    // custom_fifo_ft #(.FIFO_DWIDTH(20), .FIFO_AWIDTH(2)) ACTIVE_V_ID_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (om1_recv_push_flag),
        .wr_en      (om1_recv_update_v_valid),
        .rd_en      (read_singal),
        .dout       (push_flag_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    push_flag_fifo_ft PUSH_FLAG_FIFO_FT (
    // custom_fifo_ft #(.FIFO_DWIDTH(20), .FIFO_AWIDTH(2)) ACTIVE_V_ID_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (om1_recv_update_v_pull_first_flag),
        .wr_en      (om1_recv_update_v_valid),
        .rd_en      (read_singal),
        .dout       (pull_first_flag_top),
        .full       (),
        .empty      (),
        .valid      ()
    );
    
    vtx_bram_data_fifo_ft VTX_BRAM_DATA_FIFO_FT (
    // custom_fifo_ft #(.FIFO_DWIDTH(20), .FIFO_AWIDTH(2)) ACTIVE_V_ID_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (vertex_bram_data),
        .wr_en      (vertex_bram_valid),
        .rd_en      (read_singal),
        .dout       (vertex_bram_data_top),
        .full       (),
        .empty      (vertex_bram_data_buffer_empty),
        .data_count ()
    );
    
    always @ (posedge clk) begin
        if (rst) begin
            rd_vertex_bram_addr <= 0;
            rd_vertex_bram_valid <= 0;
        end else begin
            if (om1_recv_update_v_valid && !om1_recv_push_flag) begin
                if (om1_recv_update_v_id != om1_recv_update_v_value) begin
                    rd_vertex_bram_addr <= om1_recv_update_v_value;
                end else begin
                    rd_vertex_bram_addr <= {V_ID_WIDTH{1'b1}};
                end
                rd_vertex_bram_valid <= 1;
            end else begin
                rd_vertex_bram_addr <= 0;
                rd_vertex_bram_valid <= 0;
            end
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            om2_send_push_flag <= 0;
            om2_send_update_v_id <= 0;
            om2_send_update_v_value <= 0;
            om2_send_update_v_pull_first_flag <= 0;
            om2_send_update_v_valid <= 0;
        end else begin
            if (read_singal) begin
                if(!push_flag_top)begin
                    om2_send_push_flag <= push_flag_top;
                    om2_send_update_v_id <= v_id_top;
                    om2_send_update_v_value <= (vertex_bram_data_top == INVALID_PULL_VALUE) ? om_global_iteration_id : vertex_bram_data_top ;
                    om2_send_update_v_pull_first_flag <= pull_first_flag_top;
                    om2_send_update_v_valid <= 1;
                end
                else begin
                    om2_send_push_flag <= push_flag_top;
                    om2_send_update_v_id <= v_id_top;
                    om2_send_update_v_value <= v_value_top;
                    om2_send_update_v_pull_first_flag <= pull_first_flag_top;
                    om2_send_update_v_valid <= 1;
                end
            end else begin
                om2_send_push_flag <= 0;
                om2_send_update_v_id <= 0;
                om2_send_update_v_value <= 0;
                om2_send_update_v_pull_first_flag <= 0;
                om2_send_update_v_valid <= 0;
            end
        end
    end

    always @ (posedge clk) begin
        if (!rst && om1_recv_iteration_end && om1_recv_iteration_end_valid && active_v_id_buffer_empty && !active_v_id_buffer_datacount) begin
            om2_send_iteration_end <= 1;
            om2_send_iteration_end_valid <= 1;
        end else begin
            om2_send_iteration_end <= 0;
            om2_send_iteration_end_valid <= 0;
        end
    end

endmodule

module backend_destination_core_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VTX_BRAM_AWIDTH = `VTX_BRAM_AWIDTH,
    VTX_BRAM_DWIDTH = `VTX_BRAM_DWIDTH,
    CORE_ID = 0,
    CORE_NUM = `CORE_NUM
) (
    input                   clk,
    input                   rst,
    input                           om2_recv_push_flag,
    input [V_ID_WIDTH - 1 : 0]      om2_recv_update_v_id,
    input [V_VALUE_WIDTH - 1 : 0]   om2_recv_update_v_value,
    input                           om2_recv_update_v_pull_first_flag,
    input                           om2_recv_update_v_valid,
    input                           om2_recv_iteration_end,
    input                           om2_recv_iteration_end_valid,

    output reg                              wr_vertex_bram_push_flag,
    output reg [V_ID_WIDTH - 1 : 0]         wr_vertex_bram_addr,
    output reg [V_VALUE_WIDTH - 1 : 0]      wr_vertex_bram_data,
    output reg                              wr_vertex_bram_pull_first_flag,
    output reg                              wr_vertex_bram_valid,
    output reg                              wr_vertex_bram_iteration_end,
    output reg                              wr_vertex_bram_iteration_end_valid
);

    always @ (posedge clk) begin
        if (rst) begin
            wr_vertex_bram_push_flag <= 0;
            wr_vertex_bram_addr <= 0;
            wr_vertex_bram_data <= 0;
            wr_vertex_bram_pull_first_flag <= 0;
            wr_vertex_bram_valid <= 0;
        end else begin
            if (om2_recv_update_v_valid) begin
                wr_vertex_bram_push_flag <= om2_recv_push_flag;
                wr_vertex_bram_addr <= om2_recv_update_v_id;
                wr_vertex_bram_data <= om2_recv_update_v_value;
                wr_vertex_bram_pull_first_flag <= om2_recv_update_v_pull_first_flag;
                wr_vertex_bram_valid <= 1;
            end else begin
                wr_vertex_bram_push_flag <= 0;
                wr_vertex_bram_addr <= 0;
                wr_vertex_bram_data <= 0;
                wr_vertex_bram_pull_first_flag <= 0;
                wr_vertex_bram_valid <= 0;
            end
        end
    end

    always @ (posedge clk) begin
        if (!rst && om2_recv_iteration_end && om2_recv_iteration_end_valid && !om2_recv_update_v_valid) begin
            wr_vertex_bram_iteration_end <= 1;
            wr_vertex_bram_iteration_end_valid <= 1;
        end else begin
            wr_vertex_bram_iteration_end <= 0;
            wr_vertex_bram_iteration_end_valid <= 0;
        end
    end
    
endmodule