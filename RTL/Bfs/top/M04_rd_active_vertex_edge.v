`timescale 1ns / 1ps

`include "accelerator.vh"

module rd_active_vertex_edge #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_OFF_AWIDTH = `V_OFF_AWIDTH,
    V_OFF_DWIDTH = `V_OFF_DWIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    HBM_AWIDTH = `HBM_AWIDTH,
    HBM_EDGE_MASK = `HBM_EDGE_MASK,
    FIRST_EDGE_BRAM_AWIDTH = `FIRST_EDGE_BRAM_AWIDTH,
    CORE_NUM = `CORE_NUM
) (
    input                               clk,
    input [CORE_NUM - 1 : 0]            rst,
    input [CORE_NUM - 1 : 0]                    front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       front_active_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    front_active_v_value,
    input [CORE_NUM - 1 : 0]                    front_active_v_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    front_active_v_valid,
    input [CORE_NUM * V_OFF_DWIDTH - 1 : 0] front_active_v_loffset,
    input [CORE_NUM * V_OFF_DWIDTH - 1 : 0] front_active_v_roffset,
    input [CORE_NUM - 1 : 0]                front_offset_valid,
    input [CORE_NUM - 1 : 0]            front_iteration_end,
    input [CORE_NUM - 1 : 0]            front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]            combine_stage_full,
    input [CORE_NUM - 1 : 0]            bram_stage_full,

    output reg [CORE_NUM - 1 : 0]       next_rst,
    output [CORE_NUM - 1 : 0]           stage_full,
    output [CORE_NUM * HBM_AWIDTH - 1 : 0]      rd_hbm_edge_addr,
    output [CORE_NUM * HBM_EDGE_MASK - 1 : 0]   rd_hbm_edge_mask,
    output [CORE_NUM - 1 : 0]                   hbm_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      hbm_active_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   hbm_active_v_value,
    output [CORE_NUM - 1 : 0]                   rd_hbm_edge_valid,
    output [CORE_NUM * FIRST_EDGE_BRAM_AWIDTH - 1 : 0] rd_bram_edge_addr,
    output [CORE_NUM - 1 : 0]                   bram_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      bram_active_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   bram_active_v_value,
    output [CORE_NUM - 1 : 0]                   rd_bram_edge_valid,
    output [CORE_NUM - 1 : 0]           iteration_end,
    output [CORE_NUM - 1 : 0]           iteration_end_valid
);

    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                next_rst[i] <= rst[i];
            end
            rd_active_vertex_edge_single #(.CORE_ID(i)) RD_ACTIVE_VERTEX_EDGE_SINGLE (
                .clk                            (clk),
                .rst                            (rst[i]),
                .front_push_flag                (front_push_flag[i]),
                .front_active_v_id              (front_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .front_active_v_value           (front_active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .front_active_v_pull_first_flag (front_active_v_pull_first_flag[i]),
                .front_active_v_valid           (front_active_v_valid[i]),
                .front_active_v_loffset         (front_active_v_loffset[(i + 1) * V_OFF_DWIDTH - 1 : i * V_OFF_DWIDTH]),
                .front_active_v_roffset         (front_active_v_roffset[(i + 1) * V_OFF_DWIDTH - 1 : i * V_OFF_DWIDTH]),
                .front_offset_valid             (front_offset_valid[i]),
                .front_iteration_end            (front_iteration_end[i]),
                .front_iteration_end_valid      (front_iteration_end_valid[i]),
                .combine_stage_full             (combine_stage_full[i]),
                .bram_stage_full                (bram_stage_full[i]),

                .stage_full                     (stage_full[i]),
                .rd_hbm_edge_addr               (rd_hbm_edge_addr[(i + 1) * HBM_AWIDTH - 1 : i * HBM_AWIDTH]),
                .rd_hbm_edge_mask               (rd_hbm_edge_mask[(i + 1) * HBM_EDGE_MASK - 1 : i * HBM_EDGE_MASK]),
                .hbm_push_flag                  (hbm_push_flag[i]),
                .hbm_active_v_id                (hbm_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .hbm_active_v_value             (hbm_active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .rd_hbm_edge_valid              (rd_hbm_edge_valid[i]),
                .rd_bram_edge_addr              (rd_bram_edge_addr[(i + 1) * FIRST_EDGE_BRAM_AWIDTH - 1 : i * FIRST_EDGE_BRAM_AWIDTH]),
                .bram_push_flag                (bram_push_flag[i]),
                .bram_active_v_id             (bram_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .bram_active_v_value            (bram_active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .rd_bram_edge_valid             (rd_bram_edge_valid[i]),
                .iteration_end                  (iteration_end[i]),
                .iteration_end_valid            (iteration_end_valid[i])
            );
        end
    endgenerate

endmodule

module rd_active_vertex_edge_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_OFF_AWIDTH = `V_OFF_AWIDTH,
    V_OFF_DWIDTH = `V_OFF_DWIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    HBM_AWIDTH = `HBM_AWIDTH,
    HBM_EDGE_MASK = `HBM_EDGE_MASK,
    CORE_ID = 0,
    CACHELINE_LEN_WIDTH = `CACHELINE_LEN_WIDTH,
    CACHELINE_LEN = `CACHELINE_LEN,
    FIRST_EDGE_BRAM_AWIDTH = `FIRST_EDGE_BRAM_AWIDTH,
    FIFO_SIZE_WIDTH = `FIFO_SIZE_WIDTH,
    CORE_NUM = `CORE_NUM,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH
) (
    input                           clk,
    input                           rst,
    input                           front_push_flag,
    input [V_ID_WIDTH - 1 : 0]      front_active_v_id,
    input [V_VALUE_WIDTH - 1 : 0]   front_active_v_value,
    input                           front_active_v_pull_first_flag,
    input                           front_active_v_valid,
    input [V_OFF_DWIDTH - 1 : 0]    front_active_v_loffset,
    input [V_OFF_DWIDTH - 1 : 0]    front_active_v_roffset,
    input                           front_offset_valid,
    input                           front_iteration_end,
    input                           front_iteration_end_valid,
    input                           combine_stage_full,
    input                           bram_stage_full,

    output                          stage_full,
    output reg [HBM_AWIDTH - 1 : 0]     rd_hbm_edge_addr,
    output reg [HBM_EDGE_MASK - 1 : 0]  rd_hbm_edge_mask,
    output reg                          hbm_push_flag,
    output reg [V_ID_WIDTH - 1 : 0]     hbm_active_v_id,
    output reg [V_VALUE_WIDTH - 1 : 0]  hbm_active_v_value,
    output reg                          rd_hbm_edge_valid,
    output reg [FIRST_EDGE_BRAM_AWIDTH - 1 : 0] rd_bram_edge_addr,
    output reg                                  bram_push_flag,
    output reg [V_ID_WIDTH - 1 : 0]             bram_active_v_id,
    output reg [V_VALUE_WIDTH - 1 : 0]          bram_active_v_value,
    output reg                                  rd_bram_edge_valid,
    output reg                          iteration_end,
    output reg                          iteration_end_valid
    // output reg                         stage_full_3,
    // output reg [HBM_AWIDTH - 1 : 0]     rd_hbm_edge_addr_3,
    // output reg [HBM_EDGE_MASK - 1 : 0]  rd_hbm_edge_mask_3,
    // output reg                          hbm_push_flag_3,
    // output reg [V_ID_WIDTH - 1 : 0]     hbm_active_v_id_3,
    // output reg [V_VALUE_WIDTH - 1 : 0]  hbm_active_v_value_3,
    // output reg                          rd_hbm_edge_valid_3,
    // output reg [FIRST_EDGE_BRAM_AWIDTH - 1 : 0] rd_bram_edge_addr_3,
    // output reg                                  bram_push_flag_3,
    // output reg [V_ID_WIDTH - 1 : 0]             bram_active_v_id_3,
    // output reg [V_VALUE_WIDTH - 1 : 0]          bram_active_v_value_3,
    // output reg                                  rd_bram_edge_valid_3,
    // output reg                          iteration_end_3,
    // output reg                          iteration_end_valid_3
);

    wire active_v_id_buffer_empty, active_v_id_buffer_full;
    wire [FIFO_SIZE_WIDTH - 1 : 0] active_v_id_datacount, active_v_offset_buffer_datacount;
    wire active_v_offset_buffer_empty, active_v_offset_buffer_full;
    reg [V_OFF_DWIDTH - 1 : 0] now_loffset;
    wire [V_OFF_DWIDTH - 1 : 0] active_v_loffset_top, active_v_roffset_top;
    wire [V_ID_WIDTH - 1 : 0] active_v_id_top;
    wire [V_VALUE_WIDTH - 1 : 0] active_v_value_top;
    wire push_flag_top;
    wire pull_first_flag_top;
    wire read_signal_1, read_signal_2, read_signal;

    assign stage_full = active_v_id_buffer_full;
    assign read_signal_1 = !active_v_offset_buffer_empty && pull_first_flag_top && !bram_stage_full;
    assign read_signal_2 = !active_v_offset_buffer_empty && !pull_first_flag_top && !combine_stage_full && ((!push_flag_top && active_v_loffset_top + 1 == active_v_roffset_top) || ((now_loffset >> CACHELINE_LEN_WIDTH) > (active_v_roffset_top >> CACHELINE_LEN_WIDTH) && ((active_v_loffset_top >> CACHELINE_LEN_WIDTH) == (active_v_roffset_top >> CACHELINE_LEN_WIDTH))) || ((now_loffset >> CACHELINE_LEN_WIDTH) == active_v_roffset_top >> CACHELINE_LEN_WIDTH));
    assign read_signal = read_signal_1 || read_signal_2;
// //clk 1
//     wire                      stage_full;
//     reg [HBM_AWIDTH - 1 : 0]     rd_hbm_edge_addr;
//     reg [HBM_EDGE_MASK - 1 : 0]  rd_hbm_edge_mask;
//     reg                          hbm_push_flag;
//     reg [V_ID_WIDTH - 1 : 0]     hbm_active_v_id;
//     reg [V_VALUE_WIDTH - 1 : 0]  hbm_active_v_value;
//     reg                          rd_hbm_edge_valid;
//     reg [FIRST_EDGE_BRAM_AWIDTH - 1 : 0] rd_bram_edge_addr;
//     reg                                  bram_push_flag;
//     reg [V_ID_WIDTH - 1 : 0]             bram_active_v_id;
//     reg [V_VALUE_WIDTH - 1 : 0]          bram_active_v_value;
//     reg                                  rd_bram_edge_valid;
//     reg                          iteration_end;
//     reg                          iteration_end_valid;
// //clk 2
//     reg                      stage_full_1;
//     reg [HBM_AWIDTH - 1 : 0]     rd_hbm_edge_addr_1;
//     reg [HBM_EDGE_MASK - 1 : 0]  rd_hbm_edge_mask_1;
//     reg                          hbm_push_flag_1;
//     reg [V_ID_WIDTH - 1 : 0]     hbm_active_v_id_1;
//     reg [V_VALUE_WIDTH - 1 : 0]  hbm_active_v_value_1;
//     reg                          rd_hbm_edge_valid_1;
//     reg [FIRST_EDGE_BRAM_AWIDTH - 1 : 0] rd_bram_edge_addr_1;
//     reg                                  bram_push_flag_1;
//     reg [V_ID_WIDTH - 1 : 0]             bram_active_v_id_1;
//     reg [V_VALUE_WIDTH - 1 : 0]          bram_active_v_value_1;
//     reg                                  rd_bram_edge_valid_1;
//     reg                          iteration_end_1;
//     reg                          iteration_end_valid_1;
// //clk 3
//     reg                      stage_full_2;
//     reg [HBM_AWIDTH - 1 : 0]     rd_hbm_edge_addr_2;
//     reg [HBM_EDGE_MASK - 1 : 0]  rd_hbm_edge_mask_2;
//     reg                          hbm_push_flag_2;
//     reg [V_ID_WIDTH - 1 : 0]     hbm_active_v_id_2;
//     reg [V_VALUE_WIDTH - 1 : 0]  hbm_active_v_value_2;
//     reg                          rd_hbm_edge_valid_2;
//     reg [FIRST_EDGE_BRAM_AWIDTH - 1 : 0] rd_bram_edge_addr_2;
//     reg                                  bram_push_flag_2;
//     reg [V_ID_WIDTH - 1 : 0]             bram_active_v_id_2;
//     reg [V_VALUE_WIDTH - 1 : 0]          bram_active_v_value_2;
//     reg                                  rd_bram_edge_valid_2;
//     reg                          iteration_end_2;
//     reg                          iteration_end_valid_2;

    push_flag_fifo_ft PUSH_FLAG_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag),
        .wr_en      (front_active_v_valid),
        .rd_en      (read_signal),
        .dout       (push_flag_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    active_v_id_fifo_ft ACTIVE_V_ID_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_id),
        .wr_en      (front_active_v_valid),
        .rd_en      (read_signal),
        .dout       (active_v_id_top),
        .prog_full  (active_v_id_buffer_full),
        .full       (),
        .empty      (active_v_id_buffer_empty),
        .data_count (active_v_id_datacount),
        .valid      ()
    );

    active_v_value_fifo_ft ACTIVE_V_VALUE_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_value),
        .wr_en      (front_active_v_valid),
        .rd_en      (read_signal),
        .dout       (active_v_value_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    active_v_offset_fifo_ft ACTIVE_V_LOFFSET_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_loffset),
        .wr_en      (front_offset_valid),
        .rd_en      (read_signal),
        .dout       (active_v_loffset_top),
        .almost_full(active_v_offset_buffer_full),
        .full       (),
        .empty      (active_v_offset_buffer_empty),
        .data_count (active_v_offset_buffer_datacount),
        .valid      ()
    );

    active_v_offset_fifo_ft ACTIVE_V_ROFFSET_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_roffset),
        .wr_en      (front_offset_valid),
        .rd_en      (read_signal),
        .dout       (active_v_roffset_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    pull_first_flag_fifo_ft PULL_FIRST_FLAG_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_pull_first_flag),
        .wr_en      (front_active_v_valid),
        .rd_en      (read_signal),
        .dout       (pull_first_flag_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    integer i;
    always @ (posedge clk) begin
        if (rst) begin
            now_loffset <= {V_OFF_DWIDTH{1'b1}};

            rd_hbm_edge_addr <= 0;
            rd_hbm_edge_mask <= 0;
            hbm_push_flag <= 0;
            hbm_active_v_id <= 0;
            hbm_active_v_value <= 0;
            rd_hbm_edge_valid <= 0;

            rd_bram_edge_addr <= 0;
            bram_push_flag <= 0;
            bram_active_v_id <= 0;
            bram_active_v_value <= 0;
            rd_bram_edge_valid <= 0;
        end else begin
            if (active_v_offset_buffer_empty) begin
                now_loffset <= {V_OFF_DWIDTH{1'b1}};

                rd_hbm_edge_addr <= 0;
                rd_hbm_edge_mask <= 0;
                hbm_push_flag <= 0;
                hbm_active_v_id <= 0;
                hbm_active_v_value <= 0;
                rd_hbm_edge_valid <= 0;

                rd_bram_edge_addr <= 0;
                bram_push_flag <= 0;
                bram_active_v_id <= 0;
                bram_active_v_value <= 0;
                rd_bram_edge_valid <= 0;
            end else begin
                if (pull_first_flag_top) begin
                    rd_hbm_edge_addr <= 0;
                    rd_hbm_edge_mask <= 0;
                    hbm_push_flag <= 0;
                    hbm_active_v_id <= 0;
                    hbm_active_v_value <= 0;
                    rd_hbm_edge_valid <= 0;
                    if (bram_stage_full) begin
                        rd_bram_edge_addr <= 0;
                        bram_push_flag <= 0;
                        bram_active_v_id <= 0;
                        bram_active_v_value <= 0;
                        rd_bram_edge_valid <= 0;
                    end else begin
                        rd_bram_edge_addr <= active_v_id_top >> CORE_NUM_WIDTH;
                        bram_push_flag <= push_flag_top;
                        bram_active_v_id <= active_v_id_top;
                        bram_active_v_value <= active_v_value_top;
                        rd_bram_edge_valid <= 1;
                    end
                end else begin
                    if (combine_stage_full) begin
                        rd_hbm_edge_addr <= 0;
                        rd_hbm_edge_mask <= 0;
                        hbm_push_flag <= 0;
                        hbm_active_v_id <= 0;
                        hbm_active_v_value <= 0;
                        rd_hbm_edge_valid <= 0;
                    end else begin
                        if (!push_flag_top && active_v_loffset_top + 1 == active_v_roffset_top) begin
                            rd_hbm_edge_addr <= 0;
                            rd_hbm_edge_mask <= 0;
                            hbm_push_flag <= 0;
                            hbm_active_v_id <= 0;
                            hbm_active_v_value <= 0;
                            rd_hbm_edge_valid <= 0;
                            now_loffset <= {V_OFF_DWIDTH{1'b1}};
                        end else if (now_loffset >> CACHELINE_LEN_WIDTH > active_v_roffset_top >> CACHELINE_LEN_WIDTH) begin
                            rd_hbm_edge_addr <= active_v_loffset_top >> CACHELINE_LEN_WIDTH;
                            for (i = 0; i < CACHELINE_LEN; i = i + 1) begin
                                if (i < active_v_loffset_top[CACHELINE_LEN_WIDTH - 1 : 0] || (i >= active_v_roffset_top[CACHELINE_LEN_WIDTH - 1 : 0] && active_v_loffset_top >> CACHELINE_LEN_WIDTH == active_v_roffset_top >> CACHELINE_LEN_WIDTH)) begin
                                    rd_hbm_edge_mask[i] <= 0;
                                end else begin
                                    rd_hbm_edge_mask[i] <= 1;
                                end
                            end
                            hbm_push_flag <= push_flag_top;
                            hbm_active_v_id <= active_v_id_top;
                            hbm_active_v_value <= active_v_value_top;
                            rd_hbm_edge_valid <= active_v_loffset_top < active_v_roffset_top;

                            if (active_v_loffset_top >> CACHELINE_LEN_WIDTH == active_v_roffset_top >> CACHELINE_LEN_WIDTH) begin
                                now_loffset <= {V_OFF_DWIDTH{1'b1}};
                            end else begin
                                now_loffset <= ((active_v_loffset_top >> CACHELINE_LEN_WIDTH) + 1) << CACHELINE_LEN_WIDTH;
                            end
                        end else begin
                            rd_hbm_edge_addr <= now_loffset >> CACHELINE_LEN_WIDTH;
                            for (i = 0; i < CACHELINE_LEN; i = i + 1) begin
                                if (i < now_loffset[CACHELINE_LEN_WIDTH - 1 : 0] || (i >= active_v_roffset_top[CACHELINE_LEN_WIDTH - 1 : 0] && now_loffset >> CACHELINE_LEN_WIDTH == active_v_roffset_top >> CACHELINE_LEN_WIDTH)) begin
                                    rd_hbm_edge_mask[i] <= 0;
                                end else begin
                                    rd_hbm_edge_mask[i] <= 1;
                                end
                            end
                            hbm_push_flag <= push_flag_top;
                            hbm_active_v_id <= active_v_id_top;
                            hbm_active_v_value <= active_v_value_top;
                            rd_hbm_edge_valid <= now_loffset < active_v_roffset_top;

                            if (now_loffset >> CACHELINE_LEN_WIDTH == active_v_roffset_top >> CACHELINE_LEN_WIDTH) begin
                                now_loffset <= {V_OFF_DWIDTH{1'b1}};
                            end else begin
                                now_loffset <= ((now_loffset >> CACHELINE_LEN_WIDTH) + 1) << CACHELINE_LEN_WIDTH;
                            end
                        end
                    end
                    rd_bram_edge_addr <= 0;
                    bram_push_flag <= 0;
                    bram_active_v_id <= 0;
                    bram_active_v_value <= 0;
                    rd_bram_edge_valid <= 0;
                end
            end
        end
    end

    always @ (posedge clk) begin
        if (!rst && front_iteration_end && front_iteration_end_valid && active_v_id_buffer_empty && !active_v_id_datacount) begin
            iteration_end <= 1;
            iteration_end_valid <= 1;
        end else begin
            iteration_end <= 0;
            iteration_end_valid <= 0;
        end
    end
    // //clk1
    // always @ (posedge clk) begin 
    //     stage_full_1 <= stage_full;
    //     rd_hbm_edge_addr_1 <= rd_hbm_edge_addr;
    //     rd_hbm_edge_mask_1 <= rd_hbm_edge_mask;
    //     hbm_push_flag_1 <= hbm_push_flag;
    //     hbm_active_v_id_1 <= hbm_active_v_id;
    //     hbm_active_v_value_1 <= hbm_active_v_value;
    //     rd_hbm_edge_valid_1 <= rd_hbm_edge_valid;
    //     rd_bram_edge_addr_1 <= rd_bram_edge_addr;
    //     bram_push_flag_1 <= bram_push_flag;
    //     bram_active_v_id_1 <= bram_active_v_id;
    //     bram_active_v_value_1 <= bram_active_v_value;
    //     rd_bram_edge_valid_1 <= rd_bram_edge_valid;
    //     iteration_end_1 <= iteration_end;
    //     iteration_end_valid_1 <= iteration_end_valid;
    // end

    // //clk2
    // always @ (posedge clk) begin 
    //     stage_full_2  <= stage_full_1;
    //     rd_hbm_edge_addr_2  <= rd_hbm_edge_addr_1;
    //     rd_hbm_edge_mask_2  <= rd_hbm_edge_mask_1;
    //     hbm_push_flag_2  <= hbm_push_flag_1;
    //     hbm_active_v_id_2  <= hbm_active_v_id_1;
    //     hbm_active_v_value_2  <= hbm_active_v_value_1;
    //     rd_hbm_edge_valid_2  <= rd_hbm_edge_valid_1;
    //     rd_bram_edge_addr_2  <= rd_bram_edge_addr_1;
    //     bram_push_flag_2  <= bram_push_flag_1;
    //     bram_active_v_id_2  <= bram_active_v_id_1;
    //     bram_active_v_value_2  <= bram_active_v_value_1;
    //     rd_bram_edge_valid_2 <= rd_bram_edge_valid_1;
    //     iteration_end_2  <= iteration_end_1;
    //     iteration_end_valid_2  <= iteration_end_valid_1;
    // end

    // //clk3
    // always @ (posedge clk) begin 
    //     stage_full_3 <= stage_full_2;
    //     rd_hbm_edge_addr_3 <= rd_hbm_edge_addr_2;
    //     rd_hbm_edge_mask_3 <= rd_hbm_edge_mask_2;
    //     hbm_push_flag_3 <= hbm_push_flag_2;
    //     hbm_active_v_id_3 <= hbm_active_v_id_2;
    //     hbm_active_v_value_3 <= hbm_active_v_value_2;
    //     rd_hbm_edge_valid_3 <= rd_hbm_edge_valid_2;
    //     rd_bram_edge_addr_3 <= rd_bram_edge_addr_2;
    //     bram_push_flag_3 <= bram_push_flag_2;
    //     bram_active_v_id_3 <= bram_active_v_id_2;
    //     bram_active_v_value_3 <= bram_active_v_value_2;
    //     rd_bram_edge_valid_3 <= rd_bram_edge_valid_2;
    //     iteration_end_3 <= iteration_end_2;
    //     iteration_end_valid_3 <= iteration_end_valid_2;
    // end

endmodule