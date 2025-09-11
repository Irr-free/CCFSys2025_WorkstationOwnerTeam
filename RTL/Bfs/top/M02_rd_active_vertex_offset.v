`timescale 1ns / 1ps

`include "accelerator.vh"

module rd_active_vertex_offset #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_OFF_AWIDTH = `V_OFF_AWIDTH,
    V_OFF_DWIDTH = `V_OFF_DWIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    CORE_NUM = `CORE_NUM
) (
    input                           clk,
    input [CORE_NUM - 1 : 0]        rst,
    input [CORE_NUM - 1 : 0]        front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]   front_active_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    front_active_v_value,
    input [CORE_NUM - 1 : 0]                    front_active_v_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    front_active_v_valid,
    input [CORE_NUM - 1 : 0]                    front_iteration_end,
    input [CORE_NUM - 1 : 0]                    front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    next_stage_full,

    output reg [CORE_NUM - 1 : 0]               next_rst,
    output [CORE_NUM - 1 : 0]                   stage_full,
    output [CORE_NUM - 1 : 0]                   push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      active_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   active_v_value,
    output [CORE_NUM * V_OFF_AWIDTH - 1 : 0]    rd_active_v_offset_addr,
    output [CORE_NUM - 1 : 0]                   active_v_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   active_v_id_valid,
    output [CORE_NUM - 1 : 0]                   iteration_end,
    output [CORE_NUM - 1 : 0]                   iteration_end_valid
);

    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                next_rst[i] <= rst[i];
            end
            rd_active_vertex_offset_single #(.CORE_ID(i)) RD_ACTIVE_VERTEX_OFFSET_SINGLE (
                .clk        (clk),
                .rst        (rst[i]),
                .front_push_flag    (front_push_flag[i]),
                .front_active_v_id  (front_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .front_active_v_value   (front_active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .front_active_v_pull_first_flag (front_active_v_pull_first_flag[i]),
                .front_active_v_valid   (front_active_v_valid[i]),
                .front_iteration_end    (front_iteration_end[i]),
                .front_iteration_end_valid  (front_iteration_end_valid[i]),
                .next_stage_full        (next_stage_full[i]),

                .stage_full             (stage_full[i]),
                .push_flag              (push_flag[i]),
                .active_v_id            (active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .active_v_value         (active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .rd_active_v_offset_addr    (rd_active_v_offset_addr[(i + 1) * V_OFF_AWIDTH - 1 : i * V_OFF_AWIDTH]),
                .active_v_pull_first_flag   (active_v_pull_first_flag[i]),
                .active_v_id_valid      (active_v_id_valid[i]),
                .iteration_end          (iteration_end[i]),
                .iteration_end_valid    (iteration_end_valid[i])
                // .stage_full_3             (stage_full[i]),
                // .push_flag_3              (push_flag[i]),
                // .active_v_id_3            (active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                // .active_v_value_3         (active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                // .rd_active_v_offset_addr_3    (rd_active_v_offset_addr[(i + 1) * V_OFF_AWIDTH - 1 : i * V_OFF_AWIDTH]),
                // .active_v_pull_first_flag_3   (active_v_pull_first_flag[i]),
                // .active_v_id_valid_3      (active_v_id_valid[i]),
                // .iteration_end_3          (iteration_end[i]),
                // .iteration_end_valid_3    (iteration_end_valid[i])
            );
        end
    endgenerate

endmodule

module rd_active_vertex_offset_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_OFF_AWIDTH = `V_OFF_AWIDTH,
    V_OFF_DWIDTH = `V_OFF_DWIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    CORE_NUM = `CORE_NUM,
    CORE_ID = 0,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH
) (
    input                           clk,
    input                           rst,
    input                           front_push_flag,
    input [V_ID_WIDTH - 1 : 0]      front_active_v_id,
    input [V_VALUE_WIDTH - 1 : 0]   front_active_v_value,
    input                           front_active_v_pull_first_flag,
    input                           front_active_v_valid,
    input                           front_iteration_end,
    input                           front_iteration_end_valid,
    input                           next_stage_full,

    output                          stage_full,
    output                          push_flag,
    output  [V_ID_WIDTH - 1 : 0]     active_v_id,
    output  [V_VALUE_WIDTH - 1 : 0]  active_v_value,
    output  [V_OFF_AWIDTH - 1 : 0]   rd_active_v_offset_addr,
    output                         active_v_pull_first_flag,
    output                         active_v_id_valid,
    output reg                      iteration_end,
    output reg                      iteration_end_valid
    // output reg                         stage_full_3,
    // output reg                         push_flag_3,
    // output reg [V_ID_WIDTH - 1 : 0]     active_v_id_3,
    // output reg [V_VALUE_WIDTH - 1 : 0]  active_v_value_3,
    // output reg [V_OFF_AWIDTH - 1 : 0]   rd_active_v_offset_addr_3,
    // output reg                         active_v_pull_first_flag_3,
    // output reg                         active_v_id_valid_3,
    // output reg                      iteration_end_3,
    // output reg                      iteration_end_valid_3
);

    wire active_v_id_buffer_empty, active_v_id_buffer_full;

    //clk0
    // wire                          stage_full;
    // wire                          push_flag;
    // wire [V_ID_WIDTH - 1 : 0]     active_v_id;
    // wire [V_VALUE_WIDTH - 1 : 0]  active_v_value;
    // wire [V_OFF_AWIDTH - 1 : 0]   rd_active_v_offset_addr;
    // wire                          active_v_pull_first_flag;
    // wire                          active_v_id_valid;
    // reg                     iteration_end;
    // reg                      iteration_end_valid;
    //clk1
    // reg                          stage_full_1;
    // reg                          push_flag_1;
    // reg [V_ID_WIDTH - 1 : 0]     active_v_id_1;
    // reg [V_VALUE_WIDTH - 1 : 0]  active_v_value_1;
    // reg [V_OFF_AWIDTH - 1 : 0]   rd_active_v_offset_addr_1;
    // reg                          active_v_pull_first_flag_1;
    // reg                          active_v_id_valid_1;
    // reg                     iteration_end_1;
    // reg                      iteration_end_valid_1;
    // //clk2
    // reg                          stage_full_2;
    // reg                          push_flag_2;
    // reg [V_ID_WIDTH - 1 : 0]     active_v_id_2;
    // reg [V_VALUE_WIDTH - 1 : 0]  active_v_value_2;
    // reg [V_OFF_AWIDTH - 1 : 0]   rd_active_v_offset_addr_2;
    // reg                          active_v_pull_first_flag_2;
    // reg                          active_v_id_valid_2;
    // reg                     iteration_end_2;
    // reg                      iteration_end_valid_2;


    assign rd_active_v_offset_addr = active_v_id >> CORE_NUM_WIDTH;
    assign stage_full = active_v_id_buffer_full;

    push_flag_fifo PUSH_FLAG_FIFO (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag),
        .wr_en      (front_active_v_valid),
        .rd_en      (!next_stage_full && !active_v_id_buffer_empty),
        .dout       (push_flag),
        .full       (),
        .empty      (),
        .valid      ()
    );

    // note : full signal send to front stage has one cycle delay
    active_v_id_fifo ACTIVE_V_ID_FIFO (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_id),
        .wr_en      (front_active_v_valid),
        .rd_en      (!next_stage_full && !active_v_id_buffer_empty),
        .dout       (active_v_id),
        .prog_full  (active_v_id_buffer_full),
        .full       (),
        .empty      (active_v_id_buffer_empty),
        .valid      (active_v_id_valid)
    );

    active_v_value_fifo ACTIVE_V_VALUE_FIFO (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_value),
        .wr_en      (front_active_v_valid),
        .rd_en      (!next_stage_full && !active_v_id_buffer_empty),
        .dout       (active_v_value),
        .full       (),
        .empty      (),
        .valid      ()
    );

    pull_first_flag_fifo PULL_FIRST_FLAG_FIFO (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_pull_first_flag),
        .wr_en      (front_active_v_valid),
        .rd_en      (!next_stage_full && !active_v_id_buffer_empty),
        .dout       (active_v_pull_first_flag),
        .full       (),
        .empty      (),
        .valid      ()
    );

    always @ (posedge clk) begin
        if (!rst && front_iteration_end && front_iteration_end_valid && active_v_id_buffer_empty) begin
            iteration_end <= 1;
            iteration_end_valid <= 1;
        end else begin
            iteration_end <= 0;
            iteration_end_valid <= 0;
        end
    end

    // always @ (posedge clk) begin
    //     stage_full_1 <= stage_full;
    //     push_flag_1 <= push_flag;
    //     active_v_id_1 <= active_v_id;
    //     active_v_value_1 <= active_v_value;
    //     rd_active_v_offset_addr_1 <= rd_active_v_offset_addr;
    //     active_v_pull_first_flag_1 <= active_v_pull_first_flag;
    //     active_v_id_valid_1 <= active_v_id_valid;
    //     iteration_end_1 <= iteration_end;
    //     iteration_end_valid_1 <= iteration_end_valid;
    // end

    // always @ (posedge clk) begin
    //     stage_full_2 <= stage_full_1;
    //     push_flag_2 <= push_flag_1;
    //     active_v_id_2 <= active_v_id_1;
    //     active_v_value_2 <= active_v_value_1;
    //     rd_active_v_offset_addr_2 <= rd_active_v_offset_addr_1;
    //     active_v_pull_first_flag_2 <= active_v_pull_first_flag_1;
    //     active_v_id_valid_2 <= active_v_id_valid_1;
    //     iteration_end_2 <= iteration_end_1;
    //     iteration_end_valid_2 <= iteration_end_valid_1;
    // end

    // always @ (posedge clk) begin
    //     stage_full_3 <= stage_full_2;
    //     push_flag_3 <= push_flag_2;
    //     active_v_id_3 <= active_v_id_2;
    //     active_v_value_3 <= active_v_value_2;
    //     rd_active_v_offset_addr_3 <= rd_active_v_offset_addr_2;
    //     active_v_pull_first_flag_3 <= active_v_pull_first_flag_2;
    //     active_v_id_valid_3 <= active_v_id_valid_2;
    //     iteration_end_3 <= iteration_end_2;
    //     iteration_end_valid_3 <= iteration_end_valid_2;
    // end

endmodule

module global_signal_transfer #(parameter
    ITERATION_DWIDTH = `ITERATION_DWIDTH,
    V_ID_WIDTH = `V_ID_WIDTH,
    POWERLAW_VTX_NUM = `POWERLAW_VTX_NUM,
    
    [32 * 32 - 1 : 0] VERTEX_NOT_READ = {
        32'd798169, 32'd802022, 32'd859188, 32'd737253, 32'd236717, 32'd800651, 32'd884620, 32'd1038374, 32'd246686, 32'd72581,
        32'd514920, 32'd939780, 32'd433575, 32'd644849, 32'd887126, 32'd817258, 32'd812863, 32'd802479, 32'd701232, 32'd798386,
        32'd1030895, 32'd609384, 32'd504066, 32'd426492, 32'd16463, 32'd644226, 32'd506990, 32'd1045487, 32'd628265, 32'd735673,
        32'd507966, 32'd584249
    },
    
    // [32 * 32 - 1 : 0] VERTEX_NOT_READ = {
    //     32'd2472, 32'd1355, 32'd9395, 32'd9636, 32'd1431, 32'd1488, 32'd12919, 32'd6682, 32'd9609, 32'd12355,
    //     32'd13358, 32'd317, 32'd12851, 32'd4939, 32'd10307, 32'd9577, 32'd10330, 32'd3782, 32'd14884, 32'd1842,
    //     32'd2086, 32'd9255, 32'd7582, 32'd12890, 32'd2337, 32'd13303, 32'd10501, 32'd14495, 32'd5712, 32'd7027,
    //     32'd10490, 32'd2990
    // },
    CORE_NUM = `CORE_NUM
) (
    input clk,
    input rst,
    input [POWERLAW_VTX_NUM * 32 - 1 : 0] front_vertex_not_read,
    input [CORE_NUM * ITERATION_DWIDTH - 1 : 0] front_global_iteration_id,
    input [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0] front_global_powerlaw_v_visit,
    input [V_ID_WIDTH - 1 : 0] front_global_root_id,

    output reg [POWERLAW_VTX_NUM * 32 - 1 : 0] next_vertex_not_read,
    output reg [CORE_NUM * ITERATION_DWIDTH - 1 : 0] global_iteration_id,
    output reg [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0] global_powerlaw_v_visit,
    output reg [V_ID_WIDTH - 1 : 0] global_root_id
);
    
    always @ (posedge clk) begin
        if (rst) begin
            global_iteration_id <= 0;
            global_powerlaw_v_visit <= 0;
            next_vertex_not_read <= 'h0;
        end else begin
            global_iteration_id <= front_global_iteration_id;
            global_powerlaw_v_visit <= front_global_powerlaw_v_visit;
            next_vertex_not_read <= front_vertex_not_read;
        end
        global_root_id <= front_global_root_id;
    end

endmodule