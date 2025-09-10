`timescale 1ns / 1ps

`include "accelerator.vh"

module scheduler #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    CORE_NUM = `CORE_NUM,
    HBM_AWIDTH = `HBM_AWIDTH,
    PSEUDO_CHANNEL_NUM = `PSEUDO_CHANNEL_NUM,
    GROUP_CORE_NUM = `GROUP_CORE_NUM,
    POWERLAW_VTX_NUM = `POWERLAW_VTX_NUM
) (
    input                               clk,
    input [CORE_NUM - 1 : 0]            rst,
    input [CORE_NUM - 1 : 0]                    front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       front_active_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    front_active_v_value,
    input [CORE_NUM - 1 : 0]                    front_active_v_valid,
    input [CORE_NUM - 1 : 0]                    front_iteration_end,
    input [CORE_NUM - 1 : 0]                    front_iteration_end_valid,
    input [CORE_NUM * HBM_AWIDTH - 1 : 0]       hbm_interface_active_v_edge,
    input [CORE_NUM - 1 : 0]                    hbm_interface_active_v_edge_valid,
    input [CORE_NUM - 1 : 0]                    front2_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       front2_active_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    front2_active_v_value,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       front2_active_v_edge,
    input [CORE_NUM - 1 : 0]                    front2_active_v_valid,
    input [CORE_NUM - 1 : 0]                    front2_iteration_end,
    input [CORE_NUM - 1 : 0]                    front2_iteration_end_valid,
    input [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0] front_global_powerlaw_v_visit,
    input [CORE_NUM - 1 : 0]                    next_stage_full,

    output reg [CORE_NUM - 1 : 0]               next_rst,
    output [PSEUDO_CHANNEL_NUM - 1 : 0]         stage_full1,
    output [CORE_NUM - 1 : 0]                   stage_full2,
    output [CORE_NUM - 1 : 0]                   iteration_end,
    output [CORE_NUM - 1 : 0]                   iteration_end_valid,
    output [CORE_NUM - 1 : 0]                   push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   update_v_value,
    output [CORE_NUM - 1 : 0]                   pull_first_flag,
    output [CORE_NUM - 1 : 0]                   update_v_valid
);

    wire [CORE_NUM - 1 : 0] local_stage_full1;

    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                next_rst[i] <= rst[i];
            end
            scheduler_single #(.CORE_ID(i)) SCHEDULER_SINGLE (
                .clk                    (clk),
                .rst                    (rst[i]),
                .front_push_flag        (front_push_flag[i]),
                .front_active_v_id      (front_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .front_active_v_value   (front_active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .front_active_v_valid   (front_active_v_valid[i]),
                .front_iteration_end    (front_iteration_end[i]),
                .front_iteration_end_valid    (front_iteration_end_valid[i]),
                .hbm_interface_active_v_edge    (hbm_interface_active_v_edge[(i + 1) * HBM_AWIDTH - 1 : i * HBM_AWIDTH]),
                .hbm_interface_active_v_edge_valid  (hbm_interface_active_v_edge_valid[i]),
                .front2_push_flag       (front2_push_flag[i]),
                .front2_active_v_id     (front2_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .front2_active_v_value  (front2_active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .front2_active_v_edge   (front2_active_v_edge[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .front2_active_v_valid  (front2_active_v_valid[i]),
                .front2_iteration_end   (front2_iteration_end[i]),
                .front2_iteration_end_valid (front2_iteration_end_valid[i]),
                .front_global_powerlaw_v_visit  (front_global_powerlaw_v_visit[(i + 1) * POWERLAW_VTX_NUM - 1 : i * POWERLAW_VTX_NUM]),
                .next_stage_full        (next_stage_full[i]),

                .stage_full1            (local_stage_full1[i]),
                .stage_full2            (stage_full2[i]),
                .push_flag              (push_flag[i]),
                .update_v_id            (update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .update_v_value         (update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .pull_first_flag        (pull_first_flag[i]),
                .update_v_valid         (update_v_valid[i]),
                .iteration_end          (iteration_end[i]),
                .iteration_end_valid    (iteration_end_valid[i])
            );
        end
        for (i = 0; i < PSEUDO_CHANNEL_NUM; i = i + 1) begin
            assign stage_full1[i] = |local_stage_full1[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM];
        end
   endgenerate

endmodule

module scheduler_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    CORE_ID = 0,
    CORE_NUM = `CORE_NUM,
    FIFO_SIZE_WIDTH = `FIFO_SIZE_WIDTH,
    /*
    [32 * 32 - 1 : 0] VERTEX_NOT_READ = {
        32'd798169, 32'd802022, 32'd859188, 32'd737253, 32'd236717, 32'd800651, 32'd884620, 32'd1038374, 32'd246686, 32'd72581,
        32'd514920, 32'd939780, 32'd433575, 32'd644849, 32'd887126, 32'd817258, 32'd812863, 32'd802479, 32'd701232, 32'd798386,
        32'd1030895, 32'd609384, 32'd504066, 32'd426492, 32'd16463, 32'd644226, 32'd506990, 32'd1045487, 32'd628265, 32'd735673,
        32'd507966, 32'd584249
    },
    */
    [32 * 32 - 1 : 0] VERTEX_NOT_READ = {
        32'd2472, 32'd1355, 32'd9395, 32'd9636, 32'd1431, 32'd1488, 32'd12919, 32'd6682, 32'd9609, 32'd12355,
        32'd13358, 32'd317, 32'd12851, 32'd4939, 32'd10307, 32'd9577, 32'd10330, 32'd3782, 32'd14884, 32'd1842,
        32'd2086, 32'd9255, 32'd7582, 32'd12890, 32'd2337, 32'd13303, 32'd10501, 32'd14495, 32'd5712, 32'd7027,
        32'd10490, 32'd2990
    },
    POWERLAW_VTX_NUM = `POWERLAW_VTX_NUM
) (
    input                               clk,
    input                               rst,
    input                               front_push_flag,
    input [V_ID_WIDTH - 1 : 0]          front_active_v_id,
    input [V_VALUE_WIDTH - 1 : 0]       front_active_v_value,
    input                               front_active_v_valid,
    input                               front_iteration_end,
    input                               front_iteration_end_valid,
    input [V_ID_WIDTH - 1 : 0]          hbm_interface_active_v_edge,
    input                               hbm_interface_active_v_edge_valid,
    input                               front2_push_flag,
    input [V_ID_WIDTH - 1 : 0]          front2_active_v_id,
    input [V_VALUE_WIDTH - 1 : 0]       front2_active_v_value,
    input [V_ID_WIDTH - 1 : 0]          front2_active_v_edge,
    input                               front2_active_v_valid,
    input                               front2_iteration_end,
    input                               front2_iteration_end_valid,
    input [POWERLAW_VTX_NUM - 1 : 0]    front_global_powerlaw_v_visit,
    input                               next_stage_full,

    output                              stage_full1,
    output                              stage_full2,
    output reg                          push_flag,
    output reg [V_ID_WIDTH - 1 : 0]     update_v_id,
    output reg [V_VALUE_WIDTH - 1 : 0]  update_v_value,
    output reg                          pull_first_flag,
    output reg                          update_v_valid,
    output reg                          iteration_end,
    output reg                          iteration_end_valid
);

    wire active_v_edge_buffer1_full, active_v_edge_buffer1_empty;
    wire [FIFO_SIZE_WIDTH - 1 : 0] edge_buffer1_size, edge_buffer2_size;
    wire active_v_edge_buffer2_full, active_v_edge_buffer2_empty;
    wire active_v_id_buffer1_full, active_v_id_buffer1_empty;
    wire [FIFO_SIZE_WIDTH - 1 : 0] active_v_id_buffer1_size;
    wire push_flag_top1, push_flag_top2;
    wire [V_ID_WIDTH - 1 : 0] active_v_id_top1, active_v_id_top2;
    wire [V_VALUE_WIDTH - 1 : 0] active_v_value_top1, active_v_value_top2;
    wire [V_ID_WIDTH - 1 : 0] active_v_edge_top1, active_v_edge_top2;
    wire buffer1_read_signal, buffer2_read_signal;
    wire [POWERLAW_VTX_NUM - 1 : 0] v_edge_top1_is_powerlaw, v_edge_top2_is_powerlaw;

    assign stage_full1 = active_v_id_buffer1_full;
    assign stage_full2 = active_v_edge_buffer2_full;
    assign buffer1_read_signal = !next_stage_full && !active_v_edge_buffer1_empty && !active_v_id_buffer1_empty && edge_buffer1_size > edge_buffer2_size;
    assign buffer2_read_signal = !next_stage_full && !active_v_edge_buffer2_empty && edge_buffer1_size <= edge_buffer2_size;
    generate
        genvar i;
        for (i = 0; i < POWERLAW_VTX_NUM; i = i + 1) begin
            assign v_edge_top1_is_powerlaw[i] = (active_v_edge_top1 == VERTEX_NOT_READ[(i + 1) * 32 - 1 : i * 32]);
            assign v_edge_top2_is_powerlaw[i] = (active_v_edge_top2 == VERTEX_NOT_READ[(i + 1) * 32 - 1 : i * 32]);
        end
    endgenerate

    active_v_edge_fifo_ft ACTIVE_V_EDGE_FIFO1_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (hbm_interface_active_v_edge),
        .wr_en      (hbm_interface_active_v_edge_valid),
        .rd_en      (buffer1_read_signal),
        .dout       (active_v_edge_top1),
        .prog_full        (active_v_edge_buffer1_full),
        .full       (),
        .empty      (active_v_edge_buffer1_empty),
        .data_count (edge_buffer1_size),
        .valid      ()
    );

    active_v_edge_fifo_ft ACTIVE_V_EDGE_FIFO2_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front2_active_v_edge),
        .wr_en      (front2_active_v_valid),
        .rd_en      (buffer2_read_signal),
        .dout       (active_v_edge_top2),
        .prog_full       (active_v_edge_buffer2_full),
        .full       (),
        .empty      (active_v_edge_buffer2_empty),
        .data_count (edge_buffer2_size),
        .valid      ()
    );

    push_flag_fifo_ft PUSH_FLAG_FIFO1_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag),
        .wr_en      (front_active_v_valid),
        .rd_en      (buffer1_read_signal),
        .dout       (push_flag_top1),
        .full       (),
        .empty      (),
        .valid      ()
    );

    push_flag_fifo_ft PUSH_FLAG_FIFO2_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front2_push_flag),
        .wr_en      (front2_active_v_valid),
        .rd_en      (buffer2_read_signal),
        .dout       (push_flag_top2),
        .full       (),
        .empty      (),
        .valid      ()
    );

    active_v_id_fifo_ft ACTIVE_V_ID_FIFO1_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_id),
        .wr_en      (front_active_v_valid),
        .rd_en      (buffer1_read_signal),
        .dout       (active_v_id_top1),
        .prog_full       (active_v_id_buffer1_full),
        .full       (),
        .empty      (active_v_id_buffer1_empty),
        .data_count (active_v_id_buffer1_size),
        .valid      ()
    );

    active_v_id_fifo_ft ACTIVE_V_ID_FIFO2_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front2_active_v_id),
        .wr_en      (front2_active_v_valid),
        .rd_en      (buffer2_read_signal),
        .dout       (active_v_id_top2),
        .full       (),
        .empty      (),
        .valid      ()
    );

    active_v_value_fifo_ft ACTIVE_V_VALUE_FIFO1_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_value),
        .wr_en      (front_active_v_valid),
        .rd_en      (buffer1_read_signal),
        .dout       (active_v_value_top1),
        .full       (),
        .empty      (),
        .valid      ()
    );

    active_v_value_fifo_ft ACTIVE_V_VALUE_FIFO2_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front2_active_v_value),
        .wr_en      (front2_active_v_valid),
        .rd_en      (buffer2_read_signal),
        .dout       (active_v_value_top2),
        .full       (),
        .empty      (),
        .valid      ()
    );

    always @ (posedge clk) begin
        if (rst) begin
            push_flag <= 0;
            update_v_id <= 0;
            update_v_value <= 0;
            pull_first_flag <= 0;
            update_v_valid <= 0;
        end else begin
            if (buffer1_read_signal) begin
                if (push_flag_top1) begin
                    if (active_v_id_top1 == {V_ID_WIDTH{1'b1}}) begin
                        push_flag <= 0;
                        update_v_id <= 0;
                        update_v_value <= 0;
                        pull_first_flag <= 0;
                        update_v_valid <= 0;
                    end else begin
                        push_flag <= push_flag_top1;
                        update_v_id <= active_v_edge_top1;
                        update_v_value <= active_v_value_top1;
                        pull_first_flag <= 0;
                        update_v_valid <= 1;
                    end
                end else begin
                    push_flag <= push_flag_top1;
                    update_v_id <= active_v_id_top1;
                    update_v_value <= (v_edge_top1_is_powerlaw != 0 ? active_v_id_top1 : active_v_edge_top1);
                    pull_first_flag <= 0;
                    update_v_valid <= 1;
                end
            end else begin
                if (!buffer2_read_signal) begin
                    push_flag <= 0;
                    update_v_id <= 0;
                    update_v_value <= 0;
                    pull_first_flag <= 0;
                    update_v_valid <= 0;
                end else begin
                    push_flag <= push_flag_top2;
                    update_v_id <= active_v_id_top2;
                    update_v_value <= (v_edge_top2_is_powerlaw != 0 ? active_v_id_top2 : active_v_edge_top2);
                    pull_first_flag <= 1;
                    update_v_valid <= 1;
                end
            end
        end
    end

    always @ (posedge clk) begin
        if (!rst && front_iteration_end && front_iteration_end_valid && front2_iteration_end && front2_iteration_end_valid && active_v_id_buffer1_empty && !active_v_id_buffer1_size && active_v_edge_buffer2_empty && !edge_buffer2_size) begin
            iteration_end <= 1;
            iteration_end_valid <= 1;
        end else begin
            iteration_end <= 0;
            iteration_end_valid <= 0;
        end
    end
    
endmodule