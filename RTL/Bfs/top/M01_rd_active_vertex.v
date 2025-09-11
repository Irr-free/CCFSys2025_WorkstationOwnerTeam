`timescale 1ns / 1ps

`include "accelerator.vh"

module rd_active_vertex #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VTX_NUM_WIDTH = `VTX_NUM_WIDTH,
    CORE_NUM = `CORE_NUM,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH,
    HBM_DWIDTH = `HBM_DWIDTH,
    BITMAP_COMPRESSED_LENGTH = `BITMAP_COMPRESSED_LENGTH,
    DISPATCHER_WIDTH = `CORE_NUM_WIDTH + `BITMAP_COMPRESSED_LENGTH_WIDTH - 9,
    ITERATION_DWIDTH = `ITERATION_DWIDTH
) (
    input                                   clk,
    input                                   rst,
    input                                   vis_bitmap_rst,
    input [V_ID_WIDTH - 1 : 0]              root_id,
    input [31 : 0]                          bitmap_compressed_num,
    // input [CORE_NUM - 1 : 0]                bitmap,
    input [HBM_DWIDTH - 1 : 0]              bitmap,
    input [DISPATCHER_WIDTH - 1 : 0]        loader_counter,
    input                                   bitmap_valid,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]   backend_active_v_id,
    input [CORE_NUM - 1 : 0]                backend_active_v_updated,
    input [CORE_NUM - 1 : 0]                backend_active_v_pull_first_flag,
    input [CORE_NUM - 1 : 0]                backend_active_v_id_valid,
    input [CORE_NUM - 1 : 0]                backend_iteration_end,
    input [CORE_NUM - 1 : 0]                backend_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                next_stage_full,

    output [CORE_NUM - 1 : 0]               transfer_complete,
    output reg [CORE_NUM - 1 : 0]           next_rst,
    output [CORE_NUM - 1 : 0]               iteration_done,
    output [CORE_NUM - 1 : 0]               push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]  active_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   active_v_value,
    output [CORE_NUM - 1 : 0]               active_v_pull_first_flag,
    output [CORE_NUM - 1 : 0]               active_v_id_valid,
    output [CORE_NUM - 1 : 0]               iteration_end,
    output [CORE_NUM - 1 : 0]               iteration_end_valid,
    output [CORE_NUM * ITERATION_DWIDTH - 1 : 0] global_iteration_id,
    output [V_ID_WIDTH - 1 : 0]             global_root_id
);

    wire [CORE_NUM - 1 : 0] bitmap_valid_single;
    wire [BITMAP_COMPRESSED_LENGTH - 1 : 0] bitmap_single [CORE_NUM - 1 : 0];

    assign global_root_id = root_id;
    generate
        genvar i;

        for (i = 0; i < CORE_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                next_rst[i] <= rst;
            end
            rd_active_vertex_single #(.CORE_ID(i)) RD_ACTIVE_VERTEX_SINGLE (
                .clk                    (clk),
                .rst                    (rst),
                .vis_bitmap_rst         (vis_bitmap_rst),
                .root_id                (root_id),
                .bitmap_compressed_num  (bitmap_compressed_num),
                // .bitmap_single          (bitmap[i]),
                // .bitmap_valid           (bitmap_valid),
                .bitmap_single          (bitmap_single[i]),
                .bitmap_valid           (bitmap_valid_single[i]),
                .backend_active_v_id    (backend_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .backend_active_v_updated   (backend_active_v_updated[i]),
                .backend_active_v_pull_first_flag   (backend_active_v_pull_first_flag[i]),
                .backend_active_v_id_valid  (backend_active_v_id_valid[i]),
                .backend_iteration_end      (backend_iteration_end[i]),
                .backend_iteration_end_valid    (backend_iteration_end_valid[i]),
                .next_stage_full            (next_stage_full[i]),

                .transfer_complete          (transfer_complete[i]),
                .iteration_done             (iteration_done[i]),
                .push_flag                  (push_flag[i]),
                .active_v_id                (active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .active_v_value             (active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .active_v_pull_first_flag   (active_v_pull_first_flag[i]),
                .active_v_id_valid          (active_v_id_valid[i]),
                .iteration_end              (iteration_end[i]),
                .iteration_end_valid        (iteration_end_valid[i]),
                .global_iteration_id        (global_iteration_id[(i + 1) * ITERATION_DWIDTH - 1 : i * ITERATION_DWIDTH])
            );
            assign bitmap_valid_single[i] = (loader_counter == (i >> (CORE_NUM_WIDTH - DISPATCHER_WIDTH))) && bitmap_valid;
            assign bitmap_single[i] = bitmap[BITMAP_COMPRESSED_LENGTH * (i % (HBM_DWIDTH / BITMAP_COMPRESSED_LENGTH)) +: BITMAP_COMPRESSED_LENGTH];
        end
    endgenerate

endmodule

module rd_active_vertex_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VTX_NUM_WIDTH = `VTX_NUM_WIDTH,
    CORE_ID = 0,
    CORE_NUM = `CORE_NUM,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH,
    MAX_TASK_NUM = `MAX_TASK_NUM,
    BITMAP_COMPRESSED_LENGTH = `BITMAP_COMPRESSED_LENGTH,
    BITMAP_COMPRESSED_LENGTH_WIDTH = `BITMAP_COMPRESSED_LENGTH_WIDTH,
    // BITMAP_COMPRESSED_NUM = `BITMAP_COMPRESSED_NUM,
    BITMAP_COMPRESSED_NUM_WIDTH = `BITMAP_COMPRESSED_NUM_WIDTH,
    ITERATION_DWIDTH = `ITERATION_DWIDTH,
    MAX_ITERATION_NUM = `MAX_ITERATION_NUM
) (
    input                           clk,
    input                           rst,
    input                           vis_bitmap_rst,
    input [V_ID_WIDTH - 1 : 0]      root_id,
    input [31 : 0]                  bitmap_compressed_num,
    // input                           bitmap_single,
    input [BITMAP_COMPRESSED_LENGTH - 1 : 0]    bitmap_single,
    input                           bitmap_valid,
    input [V_ID_WIDTH - 1 : 0]      backend_active_v_id,
    input                           backend_active_v_updated,
    input                           backend_active_v_pull_first_flag,
    input                           backend_active_v_id_valid,
    input                           backend_iteration_end,
    input                           backend_iteration_end_valid,
    input                           next_stage_full,

    output                          transfer_complete,
    output                          iteration_done,
    output reg                      push_flag,
    output reg [V_ID_WIDTH - 1 : 0] active_v_id,
    output reg [V_VALUE_WIDTH - 1 : 0]  active_v_value,
    output reg                      active_v_pull_first_flag,
    output reg                      active_v_id_valid,
    output reg                      iteration_end,
    output reg                      iteration_end_valid,
    output  [ITERATION_DWIDTH - 1 : 0]   global_iteration_id
    // output reg                      iteration_done_3,
    // output reg                      push_flag_3,
    // output reg [V_ID_WIDTH - 1 : 0] active_v_id_3,
    // output reg [V_VALUE_WIDTH - 1 : 0]  active_v_value_3,
    // output reg                      active_v_pull_first_flag_3,
    // output reg                      active_v_id_valid_3,
    // output reg                      iteration_end_3,
    // output reg                      iteration_end_valid_3,
    // output reg [ITERATION_DWIDTH - 1 : 0]   global_iteration_id_3
);
    reg [31 : 0] BITMAP_COMPRESSED_NUM;
    reg [BITMAP_COMPRESSED_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : 0] local_bitmap_wr_addr;
    reg [ITERATION_DWIDTH - 1 : 0] local_iteration_id;
    reg [BITMAP_COMPRESSED_NUM_WIDTH : 0]   local_init_bitmap_id;
    wire [BITMAP_COMPRESSED_LENGTH - 1 : 0] local_vis_bitmap;
    // CHECK for debug
    wire [BITMAP_COMPRESSED_LENGTH - 1 : 0] local_vis_bitmap_debug;
    reg [BITMAP_COMPRESSED_NUM_WIDTH : 0]   local_vis_bitmap_index;
    reg [BITMAP_COMPRESSED_LENGTH - 1 : 0]      local_vis_bitmap_now;
    reg [BITMAP_COMPRESSED_NUM_WIDTH : 0]   prefetch_addr;
    reg [2 : 0]                                 prefetch_addr_valid; // bram delay
    // set to 0 when detect falling-edge
    reg                                         iteration_lock;
    // control task number in pull mode
    reg [31 : 0]                                local_task_num;
    reg                                         write_root;
    reg                                         local_vis_bitmap_index_lock;//add for let index be 0 in the start of pull id


    // // extension clk0
    // wire                      iteration_done;
    // reg                      push_flag;
    // reg [V_ID_WIDTH - 1 : 0] active_v_id;
    // reg [V_VALUE_WIDTH - 1 : 0]  active_v_value;
    // reg                      active_v_pull_first_flag;
    // reg                      active_v_id_valid;
    // reg                      iteration_end;
    // reg                      iteration_end_valid;
    // wire [ITERATION_DWIDTH - 1 : 0]   global_iteration_id;
    // // extension clk1
    // reg                      iteration_done_1;
    // reg                      push_flag_1;
    // reg [V_ID_WIDTH - 1 : 0] active_v_id_1;
    // reg [V_VALUE_WIDTH - 1 : 0]  active_v_value_1;
    // reg                      active_v_pull_first_flag_1;
    // reg                      active_v_id_valid_1;
    // reg                      iteration_end_1;
    // reg                      iteration_end_valid_1;
    // reg [ITERATION_DWIDTH - 1 : 0]   global_iteration_id_1;
    // // extension clk2
    // reg                      iteration_done_2;
    // reg                      push_flag_2;
    // reg [V_ID_WIDTH - 1 : 0] active_v_id_2;
    // reg [V_VALUE_WIDTH - 1 : 0]  active_v_value_2;
    // reg                      active_v_pull_first_flag_2;
    // reg                      active_v_id_valid_2;
    // reg                      iteration_end_2;
    // reg                      iteration_end_valid_2;
    // reg [ITERATION_DWIDTH - 1 : 0]   global_iteration_id_2;

    
    wire now_active_buffer_id, next_active_buffer_id;
    wire active_buffer1_empty, active_buffer2_empty, now_active_buffer_empty;
    wire [BITMAP_COMPRESSED_LENGTH - 1 : 0] prefetch_buffer_top;
    wire prefetch_buffer_empty, prefetch_buffer_almost_full;
    wire [V_ID_WIDTH - 1 : 0] local_active_buffer1_top, local_active_buffer2_top;
    wire now_push_flag, next_push_flag;
    wire [CORE_NUM_WIDTH - 1 : 0] root_core_id;
    wire [BITMAP_COMPRESSED_NUM_WIDTH - 1 : 0] root_bitmap_id1;
    wire [BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : 0] root_bitmap_id2;
    wire [BITMAP_COMPRESSED_NUM_WIDTH - 1 : 0] backend_v_bitmap_id1;
    wire [BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : 0] backend_v_bitmap_id2;
    wire [BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : 0] pull_first_active_vertex_index;
    wire                                          pull_first_active_vertex_bitmap;

    assign root_core_id = root_id[CORE_NUM_WIDTH - 1 : 0];
    assign root_bitmap_id1 = root_id >> CORE_NUM_WIDTH >> BITMAP_COMPRESSED_LENGTH_WIDTH;
    assign root_bitmap_id2 = root_id[CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : CORE_NUM_WIDTH];
    assign backend_v_bitmap_id1 = backend_active_v_id >> CORE_NUM_WIDTH >> BITMAP_COMPRESSED_LENGTH_WIDTH;
    assign backend_v_bitmap_id2 = backend_active_v_id[CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : CORE_NUM_WIDTH];
    assign now_active_buffer_id = local_iteration_id[0];
    assign next_active_buffer_id = local_iteration_id[0] ^ 1;
    assign now_active_buffer_empty = (now_active_buffer_id ? active_buffer2_empty : active_buffer1_empty);
    assign now_push_flag = (local_iteration_id <= 1 || local_iteration_id >= 5);
    assign next_push_flag = (local_iteration_id <= 0 || local_iteration_id >= 4);
    assign global_iteration_id = local_iteration_id;
    assign iteration_done = (local_iteration_id == MAX_ITERATION_NUM);

    btree_cal_active_vtx_in_bitmap BTREE (
        .bitmap     (local_vis_bitmap_now),

        .index      (pull_first_active_vertex_index),
        .all_visited(pull_first_active_vertex_bitmap)
    );

    // Note: write_width=1, write_depth=2048
    //       read_width=32, read_depth=64
    /*
    vis_bitmap VIS_BITMAP_BRAM_IP_SINGLE (
        .clka       (clk),
        .ena        (!rst),
        .wea        ((local_init_bitmap_id >= BITMAP_COMPRESSED_NUM && backend_active_v_id_valid && backend_active_v_updated) || (local_init_bitmap_id < BITMAP_COMPRESSED_NUM && root_core_id == CORE_ID)),
        .addra      (local_init_bitmap_id >= BITMAP_COMPRESSED_NUM ? backend_active_v_id >> CORE_NUM_WIDTH : root_id >> CORE_NUM_WIDTH),
        .dina       (1'b1),
        .clkb       (clk),
        .enb        (!rst),
        .addrb      (prefetch_addr),
        .doutb      (local_vis_bitmap)
    );//need to add init lonely node bitmap = 1
    */
//    wire [BITMAP_COMPRESSED_LENGTH - 1 : 0] vis_bitmap_self_wea;
//    wire [BITMAP_COMPRESSED_NUM_WIDTH - 1 : 0] vis_bitmap_self_addra;
//    assign vis_bitmap_self_addra = (local_init_bitmap_id >= BITMAP_COMPRESSED_NUM) ? (backend_active_v_id[CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH + BITMAP_COMPRESSED_NUM_WIDTH - 1 : CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH]) : (root_id[CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH + BITMAP_COMPRESSED_NUM_WIDTH - 1 : CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH]);
//    assign vis_bitmap_self_wea = (local_init_bitmap_id >= BITMAP_COMPRESSED_NUM) ? ({{(BITMAP_COMPRESSED_LENGTH - 1){1'b0}}, {backend_active_v_id_valid && backend_active_v_updated}} << backend_active_v_id[CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH : CORE_NUM_WIDTH]) : ({{(BITMAP_COMPRESSED_LENGTH - 1){1'b0}}, root_core_id == CORE_ID} << root_id[CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH : CORE_NUM_WIDTH]);
    
    vis_bitmap VIS_BITMAP (
        .clka   (clk),
        .ena    (!rst),
        .wea    (backend_active_v_id_valid && backend_active_v_updated),
        .addra  (backend_active_v_id >> CORE_NUM_WIDTH),
        .dina   (1'b1),
        .clkb   (clk),
        .enb    (!vis_bitmap_rst),
        .regceb (1'b1),
        .web    (rst ? bitmap_valid : 1'b0),
        .addrb  (rst ? local_bitmap_wr_addr : prefetch_addr),
        .dinb   (bitmap_single),
        .doutb  (local_vis_bitmap)
    );
    //note: root_id is 1 in the initfile 
    // CHECK regceb
    // vis_bitmap_self #(.INIT_FILE(CORE_ID)) VIS_BIMAP_SELF (
    //     .clka(clk),
    //     .wea(backend_active_v_id_valid && backend_active_v_updated),
    //     .addra(backend_active_v_id >> CORE_NUM_WIDTH),
    //     .dina(1'b1),
    //     .clkb(clk),
    //     .rstb(rst),
    //     .enb(!rst),
    //     .addrb(prefetch_addr), 
    //     .regceb(1'b1),
    //     .doutb(local_vis_bitmap_debug)
    // );
    // always @(posedge clk) begin
    //     if (!rst && local_vis_bitmap != local_vis_bitmap_debug) begin
    //         $display("Err: bitmap is 0x%x rather than 0x%x @%t CORE%2d", local_vis_bitmap, local_vis_bitmap_debug, $time, CORE_ID);
    //     end
    // end

    // pull mode : store prefetch bitmap
    prefetch_fifo_ft PREFETCH_FIFO_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (local_vis_bitmap),
        .wr_en      (prefetch_addr_valid[2]),
        .rd_en      (!now_push_flag && local_vis_bitmap_index < BITMAP_COMPRESSED_NUM && local_init_bitmap_id == BITMAP_COMPRESSED_NUM && pull_first_active_vertex_bitmap),
        .dout       (prefetch_buffer_top),
        .full       (),
        .almost_full(),
        .prog_full  (prefetch_buffer_almost_full),
        .empty      (prefetch_buffer_empty),
        .valid      ()
    );

    // BUG 用来存下一轮push激活点的FIFO应该单独弄一个IP，否则改动该FIFO深度会影响同样使用该FIFO的其他模块
    // active_v_id_fifo_ft ACTIVE_V_ID_FIFO1_FT (
    //     .clk        (clk),
    //     .srst       (rst),
    //     .din        (write_root ? root_id : backend_active_v_id),
    //     .wr_en      (write_root || (next_active_buffer_id == 0 && backend_active_v_id_valid && backend_active_v_updated && next_push_flag)),
    //     .rd_en      (now_active_buffer_id == 0 && now_push_flag && !next_stage_full && !active_buffer1_empty && local_init_bitmap_id >= BITMAP_COMPRESSED_NUM),
    //     .dout       (local_active_buffer1_top),
    //     .full       (),
    //     .empty      (active_buffer1_empty),
    //     .data_count (),
    //     .valid      ()
    // );
    next_push_active_v_id_fifo_ft PUSH_ACTIVE_V_ID_FIFO1_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (write_root ? root_id : backend_active_v_id),
        .wr_en      (write_root || (next_active_buffer_id == 0 && backend_active_v_id_valid && backend_active_v_updated && next_push_flag)),
        .rd_en      (now_active_buffer_id == 0 && now_push_flag && !next_stage_full && !active_buffer1_empty && local_init_bitmap_id >= BITMAP_COMPRESSED_NUM),
        .dout       (local_active_buffer1_top),
        .empty      (active_buffer1_empty)
    );

    // active_v_id_fifo_ft ACTIVE_V_ID_FIFO2_FT (
    //     .clk        (clk),
    //     .srst       (rst),
    //     .din        (backend_active_v_id),
    //     .wr_en      (next_active_buffer_id == 1 && backend_active_v_id_valid && backend_active_v_updated && next_push_flag),
    //     .rd_en      (now_active_buffer_id == 1 && now_push_flag && !next_stage_full && !active_buffer2_empty && local_init_bitmap_id >= BITMAP_COMPRESSED_NUM),
    //     .dout       (local_active_buffer2_top),
    //     .full       (),
    //     .empty      (active_buffer2_empty),
    //     .data_count (),
    //     .valid      ()
    // );
    next_push_active_v_id_fifo_ft PUSH_ACTIVE_V_ID_FIFO2_FT (
        .clk        (clk),
        .srst       (rst),
        .din        (backend_active_v_id),
        .wr_en      (next_active_buffer_id == 1 && backend_active_v_id_valid && backend_active_v_updated && next_push_flag),
        .rd_en      (now_active_buffer_id == 1 && now_push_flag && !next_stage_full && !active_buffer2_empty && local_init_bitmap_id >= BITMAP_COMPRESSED_NUM),
        .dout       (local_active_buffer2_top),
        .empty      (active_buffer2_empty)
    );

    always @(posedge clk) begin
        if (vis_bitmap_rst) begin
            BITMAP_COMPRESSED_NUM <= 32'd1024;
        end
        else begin
            BITMAP_COMPRESSED_NUM <= bitmap_compressed_num;
        end
    end

    // load bitmap from HBM
    always @(posedge clk) begin
        if (vis_bitmap_rst) begin
            local_bitmap_wr_addr <= 'h0;
        end
        // CHECK delete the transfer_complete
        else if (bitmap_valid && !transfer_complete) begin
            local_bitmap_wr_addr <= local_bitmap_wr_addr + 1'b1;
        end
    end

    assign transfer_complete = (local_bitmap_wr_addr == ((1 << VTX_NUM_WIDTH) >> (CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH)));

    // write root id to push fifo
    always @ (posedge clk) begin
        if(rst == 1 && root_core_id == CORE_ID) begin
            write_root <= 1;
        end
        else begin
            write_root <= 0;
        end
        if (rst) begin
            iteration_lock <= 1;
        end else begin
            if (backend_iteration_end && backend_iteration_end_valid) begin
                iteration_lock <= 0;
            end else begin
                iteration_lock <= 1;
            end
        end
    end

    // output vid
    // Warning: isolate vertex need to be filter in M3
    always @ (posedge clk) begin
        if (rst || local_init_bitmap_id < BITMAP_COMPRESSED_NUM) begin
            push_flag <= 0;
            active_v_id <= 0;
            active_v_value <= 0;
            active_v_pull_first_flag <= 0;
            active_v_id_valid <= 0;

            local_task_num <= 0;
        end else begin
            if (now_push_flag) begin
                // push mode
                if (next_stage_full || now_active_buffer_empty) begin
                    push_flag <= 0;
                    active_v_id <= 0;
                    active_v_value <= 0;
                    active_v_pull_first_flag <= 0;
                    active_v_id_valid <= 0;
                end else begin
                    push_flag <= now_push_flag;
                    active_v_id <= now_active_buffer_id ? local_active_buffer2_top : local_active_buffer1_top;
                    active_v_value <= local_iteration_id + 1;
                    active_v_pull_first_flag <= 0;
                    active_v_id_valid <= 1;
                    $display("push active_id %d @%t",now_active_buffer_id ? local_active_buffer2_top : local_active_buffer1_top, $time);
                end

                local_task_num <= 0;
            end else begin
                // pull mode
                if (next_stage_full) begin
                    // forward will be a wrong case
                    /*
                    if (backend_active_v_id_valid && backend_active_v_pull_first_flag && !backend_active_v_updated) begin
                        push_flag <= now_push_flag;
                        active_v_id <= backend_active_v_id;
                        active_v_value <= local_iteration_id + 1;
                        active_v_pull_first_flag <= 0;
                        active_v_id_valid <= 1;
                    end
                    */
                    push_flag <= 0;
                    active_v_id <= 0;
                    active_v_value <= 0;
                    active_v_pull_first_flag <= 0;
                    active_v_id_valid <= 0;
                    if (backend_active_v_id_valid && backend_active_v_pull_first_flag) begin
                        local_task_num <= local_task_num - 1;
                    end
                end else begin
                    // forward anyway
                    if (backend_active_v_id_valid && backend_active_v_pull_first_flag && !backend_active_v_updated) begin
                        push_flag <= now_push_flag;
                        active_v_id <= backend_active_v_id;
                        active_v_value <= local_iteration_id + 1;
                        active_v_pull_first_flag <= 0;
                        active_v_id_valid <= 1;

                        local_task_num <= local_task_num - 1;
                    end else begin
                        if (local_vis_bitmap_index < BITMAP_COMPRESSED_NUM && !pull_first_active_vertex_bitmap && local_task_num < MAX_TASK_NUM) begin
                            push_flag <= now_push_flag;
                            active_v_id <= (((local_vis_bitmap_index << BITMAP_COMPRESSED_LENGTH_WIDTH) + pull_first_active_vertex_index) << CORE_NUM_WIDTH) + CORE_ID;
                            active_v_value <= local_iteration_id + 1;
                            active_v_pull_first_flag <= 1;
                            active_v_id_valid <= 1;

                            if (!(backend_active_v_id_valid && backend_active_v_pull_first_flag)) begin
                                local_task_num <= local_task_num + 1;
                            end
                        end else begin
                            push_flag <= 0;
                            active_v_id <= 0;
                            active_v_value <= 0;
                            active_v_pull_first_flag <= 0;
                            active_v_id_valid <= 0;

                            if (backend_active_v_id_valid && backend_active_v_pull_first_flag) begin
                                local_task_num <= local_task_num - 1;
                            end
                        end
                    end
                end
            end
        end
    end

    // output iteration end
    always @ (posedge clk) begin
        if (rst) begin
            local_iteration_id <= 0;
            iteration_end <= 0;
            iteration_end_valid <= 0;
        end else begin
            if (iteration_end) begin
                // check if prefetch buffer is empty
                if (backend_iteration_end && backend_iteration_end_valid && iteration_lock) begin
                    local_iteration_id <= local_iteration_id + 1;
                    iteration_end <= 0;
                    iteration_end_valid <= 0;
                    // TODO debug
                    if (CORE_ID == 0)    $display("local_iteration_id changed from %1d to %1d @%t", local_iteration_id, local_iteration_id + 1, $time);
                end
            end else begin
                if (now_push_flag) begin
                    if (now_active_buffer_empty && local_init_bitmap_id >= BITMAP_COMPRESSED_NUM) begin
                        iteration_end <= 1;
                        iteration_end_valid <= 1;
                    end
                end else begin
                    if (local_vis_bitmap_index >= BITMAP_COMPRESSED_NUM && local_task_num == 0) begin
                        iteration_end <= 1;
                        iteration_end_valid <= 1;
                    end
                end
            end
        end
    end

    // pull mode : bitmap prefetch addr
    // push mode : bitmap addr of backend id
    always @ (posedge clk) begin
        if (rst || local_init_bitmap_id < BITMAP_COMPRESSED_NUM) begin
            prefetch_addr <= {(BITMAP_COMPRESSED_NUM_WIDTH + 1){1'b1}};
            prefetch_addr_valid <= 0;
        end else begin
            if (now_push_flag) begin
                prefetch_addr <= {(BITMAP_COMPRESSED_NUM_WIDTH + 1){1'b1}};
                prefetch_addr_valid[0] <= 0;
            end else begin
                // prefetch
                if (prefetch_addr < BITMAP_COMPRESSED_NUM || prefetch_addr == {(BITMAP_COMPRESSED_NUM_WIDTH + 1){1'b1}}) begin
                    // if (!prefetch_buffer_almost_full && (prefetch_addr_valid == 'b100 || prefetch_addr_valid == 3'b0)) begin
                    if (!prefetch_buffer_almost_full ) begin
                        prefetch_addr <= prefetch_addr + 1;
                        prefetch_addr_valid[0] <= 1;
                    end else begin
                        prefetch_addr_valid[0] <= 0;
                    end
                end else begin
                    prefetch_addr_valid[0] <= 0;
                    if (backend_iteration_end && backend_iteration_end_valid && iteration_lock) begin
                        prefetch_addr <= {(BITMAP_COMPRESSED_NUM_WIDTH + 1){1'b1}};
                    end
                end
            end
            prefetch_addr_valid[1] <= prefetch_addr_valid[0];
            prefetch_addr_valid[2] <= prefetch_addr_valid[1];
        end
    end

    // bitmap read in local reg
    always @ (posedge clk) begin
        if (rst) begin
            local_vis_bitmap_now <= {BITMAP_COMPRESSED_LENGTH{1'b1}};
            local_vis_bitmap_index <= 0;
            local_vis_bitmap_index_lock <= 0;
        end else begin
            if (local_init_bitmap_id > 0) begin
                if (now_push_flag || (local_vis_bitmap_index >= BITMAP_COMPRESSED_NUM && backend_iteration_end && backend_iteration_end_valid && iteration_lock)) begin
                    local_vis_bitmap_now <= {BITMAP_COMPRESSED_LENGTH{1'b1}};
                    local_vis_bitmap_index <= 0;
                    local_vis_bitmap_index_lock <= 0;
                end else begin
                    if (local_init_bitmap_id == BITMAP_COMPRESSED_NUM) begin
                        if (local_vis_bitmap_index < BITMAP_COMPRESSED_NUM) begin
                            if (pull_first_active_vertex_bitmap) begin
                                if(!prefetch_buffer_empty)begin
                                    local_vis_bitmap_now <= prefetch_buffer_top;
                                    if((local_vis_bitmap_index!=0 || local_vis_bitmap_index_lock)) begin
                                        local_vis_bitmap_index <= local_vis_bitmap_index + 1;
                                        local_vis_bitmap_index_lock <= 0;
                                    end
                                    else begin
                                        local_vis_bitmap_index_lock <= 1;
                                    end
                                end
                            end else begin
                                if (!next_stage_full && !(backend_active_v_id_valid && backend_active_v_pull_first_flag && !backend_active_v_updated) && local_task_num < MAX_TASK_NUM) begin
                                    local_vis_bitmap_now[pull_first_active_vertex_index] <= 1'b1;
                                end
                            end
                        end
                    end else begin
                        // do initial
                        local_vis_bitmap_now <= {BITMAP_COMPRESSED_LENGTH{1'b1}};
                        local_vis_bitmap_index <= 0;
                        local_vis_bitmap_index_lock <= 0;
                    end
                end
            end
        end
    end

    // bitmap initial & write
    // note: use bram ip initial
    // CHECK redundant?
    always @ (posedge clk) begin
        if (rst) begin
            local_init_bitmap_id <= 0;
        end else begin
            if (local_init_bitmap_id < BITMAP_COMPRESSED_NUM) begin
                local_init_bitmap_id <= local_init_bitmap_id + 1;
            end
        end
    end

    // // clk1
    // always @(posedge clk) begin
    //     iteration_done_1 <= iteration_done;
    //     push_flag_1 <= push_flag;
    //     active_v_id_1 <= active_v_id;
    //     active_v_value_1 <= active_v_value;
    //     active_v_pull_first_flag_1 <= active_v_pull_first_flag;
    //     active_v_id_valid_1 <= active_v_id_valid;
    //     iteration_end_1 <= iteration_end;
    //     iteration_end_valid_1 <= iteration_end_valid;
    //     global_iteration_id_1 <= global_iteration_id;
    // end
    // // clk2
    // always @(posedge clk) begin
    //     iteration_done_2 <= iteration_done_1;
    //     push_flag_2 <= push_flag_1;
    //     active_v_id_2 <= active_v_id_1;
    //     active_v_value_2 <= active_v_value_1;
    //     active_v_pull_first_flag_2 <= active_v_pull_first_flag_1;
    //     active_v_id_valid_2 <= active_v_id_valid_1;
    //     iteration_end_2 <= iteration_end_1;
    //     iteration_end_valid_2 <= iteration_end_valid_1;
    //     global_iteration_id_2 <= global_iteration_id_1;
    // end
    // // clk3
    // always @(posedge clk) begin
    //     iteration_done_3 <= iteration_done_2;
    //     push_flag_3 <= push_flag_2;
    //     active_v_id_3 <= active_v_id_2;
    //     active_v_value_3 <= active_v_value_2;
    //     active_v_pull_first_flag_3 <= active_v_pull_first_flag_2;
    //     active_v_id_valid_3 <= active_v_id_valid_2;
    //     iteration_end_3 <= iteration_end_2;
    //     iteration_end_valid_3 <= iteration_end_valid_2;
    //     global_iteration_id_3 <= global_iteration_id_2;
    // end
endmodule

module btree_cal_active_vtx_in_bitmap #(parameter
    BITMAP_COMPRESSED_LENGTH = `BITMAP_COMPRESSED_LENGTH,
    BITMAP_COMPRESSED_LENGTH_WIDTH = `BITMAP_COMPRESSED_LENGTH_WIDTH
) (
    input [BITMAP_COMPRESSED_LENGTH - 1 : 0] bitmap,

    output [BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : 0] index,
    output all_visited
);

    wire [BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : 0] index_level0 [0 : 31];
    wire [31 : 0] visited_level0;
    wire [BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : 0] index_level1 [0 : 15];
    wire [15 : 0] visited_level1;
    wire [BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : 0] index_level2 [0 : 7];
    wire [7 : 0] visited_level2;
    wire [BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : 0] index_level3 [0 : 3];
    wire [3 : 0] visited_level3;
    wire [BITMAP_COMPRESSED_LENGTH_WIDTH - 1 : 0] index_level4 [0 : 1];
    wire [1 : 0] visited_level4;

    assign index = visited_level4[0] ? index_level4[1] : index_level4[0];
    assign all_visited = visited_level4[0] && visited_level4[1];
    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin
            assign index_level0[i] = i;
            assign visited_level0[i] = bitmap[i];
        end
        for (i = 0; i < 16; i = i + 1) begin
            assign index_level1[i] = visited_level0[2 * i] ? index_level0[2 * i + 1] : index_level0[2 * i];
            assign visited_level1[i] = visited_level0[2 * i] && visited_level0[2 * i + 1];
        end
        for (i = 0; i < 8; i = i + 1) begin
            assign index_level2[i] = visited_level1[2 * i] ? index_level1[2 * i + 1] : index_level1[2 * i];
            assign visited_level2[i] = visited_level1[2 * i] && visited_level1[2 * i + 1];
        end
        for (i = 0; i < 4; i = i + 1) begin
            assign index_level3[i] = visited_level2[2 * i] ? index_level2[2 * i + 1] : index_level2[2 * i];
            assign visited_level3[i] = visited_level2[2 * i] && visited_level2[2 * i + 1];
        end
        for (i = 0; i < 2; i = i + 1) begin
            assign index_level4[i] = visited_level3[2 * i] ? index_level3[2 * i + 1] : index_level3[2 * i];
            assign visited_level4[i] = visited_level3[2 * i] && visited_level3[2 * i + 1];
        end
    endgenerate

endmodule

module rd_active_vertex_global_signal #(parameter
    CORE_ID = 0,
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    
    // [32 * 32 - 1 : 0] VERTEX_NOT_READ = {
    //     32'd798169, 32'd802022, 32'd859188, 32'd737253, 32'd236717, 32'd800651, 32'd884620, 32'd1038374, 32'd246686, 32'd72581,
    //     32'd514920, 32'd939780, 32'd433575, 32'd644849, 32'd887126, 32'd817258, 32'd812863, 32'd802479, 32'd701232, 32'd798386,
    //     32'd1030895, 32'd609384, 32'd504066, 32'd426492, 32'd16463, 32'd644226, 32'd506990, 32'd1045487, 32'd628265, 32'd735673,
    //     32'd507966, 32'd584249
    // },
    
    // [32 * 32 - 1 : 0] VERTEX_NOT_READ = {
    //     32'd2472, 32'd1355, 32'd9395, 32'd9636, 32'd1431, 32'd1488, 32'd12919, 32'd6682, 32'd9609, 32'd12355,
    //     32'd13358, 32'd317, 32'd12851, 32'd4939, 32'd10307, 32'd9577, 32'd10330, 32'd3782, 32'd14884, 32'd1842,
    //     32'd2086, 32'd9255, 32'd7582, 32'd12890, 32'd2337, 32'd13303, 32'd10501, 32'd14495, 32'd5712, 32'd7027,
    //     32'd10490, 32'd2990
    // },
    CORE_NUM = `CORE_NUM,
    POWERLAW_VTX_NUM = `POWERLAW_VTX_NUM
) (
    input clk,
    input rst,
    input [POWERLAW_VTX_NUM * 32 - 1 : 0]   vertex_not_read,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]   backend_active_v_id,
    input [CORE_NUM - 1 : 0]                backend_active_v_updated,
    input [CORE_NUM - 1 : 0]                backend_active_v_id_valid,

    output reg [POWERLAW_VTX_NUM * 32 - 1 : 0]      next_vertex_not_read,
    output reg [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0] global_powerlaw_v_visit
);

    wire [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0] local_global_powerlaw_v_visit;
    wire [POWERLAW_VTX_NUM - 1 : 0] local_global_powerlaw_v_visit_combine;

    always @(posedge clk) begin
        if (rst) begin
            next_vertex_not_read <= 'h0;
        end
        else begin
            next_vertex_not_read <= vertex_not_read;
        end
    end

    generate
        // if (CORE_NUM == 32) begin
        btree_combine_global_signal_32 BTREE_COMBINE (
            .visited            (local_global_powerlaw_v_visit),

            .visited_combine    (local_global_powerlaw_v_visit_combine)
        );
        // end else if(CORE_NUM == 16) begin
        //     btree_combine_global_signal_16 BTREE_COMBINE (
        //         .visited            (local_global_powerlaw_v_visit),

        //         .visited_combine    (local_global_powerlaw_v_visit_combine)
        //     );
        // end else if(CORE_NUM == 64) begin
        //     btree_combine_global_signal_64 BTREE_COMBINE (
        //         .visited            (local_global_powerlaw_v_visit),

        //         .visited_combine    (local_global_powerlaw_v_visit_combine)
        //     );
        // end
    endgenerate

    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            rd_active_vertex_global_signal_single RD_ACTIVE_VERTEX_GLOBAL_SIGNAL_SINGLE (
                .clk                (clk),
                .rst                (rst),
                .VERTEX_NOT_READ    (vertex_not_read),
                .backend_active_v_id(backend_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .backend_active_v_updated   (backend_active_v_updated[i]),
                .backend_active_v_id_valid  (backend_active_v_id_valid[i]),

                .global_powerlaw_v_visit    (local_global_powerlaw_v_visit[(i + 1) * POWERLAW_VTX_NUM - 1 : i * POWERLAW_VTX_NUM])
            );

            always @ (posedge clk) begin
                if (rst) begin
                    global_powerlaw_v_visit[(i + 1) * POWERLAW_VTX_NUM - 1 : i * POWERLAW_VTX_NUM] <= 0;
                end else begin
                    global_powerlaw_v_visit[(i + 1) * POWERLAW_VTX_NUM - 1 : i * POWERLAW_VTX_NUM] <= local_global_powerlaw_v_visit_combine;
                end
            end
        end
    endgenerate

endmodule

module btree_combine_global_signal #(parameter
    CORE_NUM = `CORE_NUM,
    POWERLAW_VTX_NUM = `POWERLAW_VTX_NUM
) (
    input [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0] visited,

    output [POWERLAW_VTX_NUM - 1 : 0] visited_combine
);

    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level0 [0 : 511];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level1 [0 : 255];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level2 [0 : 127];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level3 [0 : 63];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level4 [0 : 31];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level5 [0 : 15];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level6 [0 : 7];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level7 [0 : 3];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level8 [0 : 1];

    assign visited_combine = visited_level8[0] | visited_level8[1];
    generate
        genvar i;
        for (i = 0; i < 512; i = i + 1) begin
            assign visited_level0[i] = visited[(i + 1) * POWERLAW_VTX_NUM - 1 : i * POWERLAW_VTX_NUM];
        end
        for (i = 0; i < 256; i = i + 1) begin
            assign visited_level1[i] = visited_level0[2 * i] | visited_level0[2 * i + 1];
        end
        for (i = 0; i < 128; i = i + 1) begin
            assign visited_level2[i] = visited_level1[2 * i] | visited_level1[2 * i + 1];
        end
        for (i = 0; i < 64; i = i + 1) begin
            assign visited_level3[i] = visited_level2[2 * i] | visited_level2[2 * i + 1];
        end
        for (i = 0; i < 32; i = i + 1) begin
            assign visited_level4[i] = visited_level3[2 * i] | visited_level3[2 * i + 1];
        end
        for (i = 0; i < 16; i = i + 1) begin
            assign visited_level5[i] = visited_level4[2 * i] | visited_level4[2 * i + 1];
        end
        for (i = 0; i < 8; i = i + 1) begin
            assign visited_level6[i] = visited_level5[2 * i] | visited_level5[2 * i + 1];
        end
        for (i = 0; i < 4; i = i + 1) begin
            assign visited_level7[i] = visited_level6[2 * i] | visited_level6[2 * i + 1];
        end
        for (i = 0; i < 2; i = i + 1) begin
            assign visited_level8[i] = visited_level7[2 * i] | visited_level7[2 * i + 1];
        end
    endgenerate

endmodule

// for testbench
module btree_combine_global_signal_32 #(parameter
    CORE_NUM = `CORE_NUM,
    POWERLAW_VTX_NUM = `POWERLAW_VTX_NUM
) (
    input [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0] visited,

    output [POWERLAW_VTX_NUM - 1 : 0] visited_combine
);

    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level4 [0 : 31];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level5 [0 : 15];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level6 [0 : 7];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level7 [0 : 3];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level8 [0 : 1];

    assign visited_combine = visited_level8[0] | visited_level8[1];
    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin
            assign visited_level4[i] = visited[(i + 1) * POWERLAW_VTX_NUM - 1 : i * POWERLAW_VTX_NUM];
        end
        for (i = 0; i < 16; i = i + 1) begin
            assign visited_level5[i] = visited_level4[2 * i] | visited_level4[2 * i + 1];
        end
        for (i = 0; i < 8; i = i + 1) begin
            assign visited_level6[i] = visited_level5[2 * i] | visited_level5[2 * i + 1];
        end
        for (i = 0; i < 4; i = i + 1) begin
            assign visited_level7[i] = visited_level6[2 * i] | visited_level6[2 * i + 1];
        end
        for (i = 0; i < 2; i = i + 1) begin
            assign visited_level8[i] = visited_level7[2 * i] | visited_level7[2 * i + 1];
        end
    endgenerate

endmodule

module btree_combine_global_signal_16 #(parameter
    CORE_NUM = `CORE_NUM,
    POWERLAW_VTX_NUM = `POWERLAW_VTX_NUM
) (
    input [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0] visited,

    output [POWERLAW_VTX_NUM - 1 : 0] visited_combine
);

    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level5 [0 : 15];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level6 [0 : 7];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level7 [0 : 3];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level8 [0 : 1];

    assign visited_combine = visited_level8[0] | visited_level8[1];
    generate
        genvar i;
        
        for (i = 0; i < 16; i = i + 1) begin
            assign visited_level5[i] = visited[(i + 1) * POWERLAW_VTX_NUM - 1 : i * POWERLAW_VTX_NUM];
        end
        for (i = 0; i < 8; i = i + 1) begin
            assign visited_level6[i] = visited_level5[2 * i] | visited_level5[2 * i + 1];
        end
        for (i = 0; i < 4; i = i + 1) begin
            assign visited_level7[i] = visited_level6[2 * i] | visited_level6[2 * i + 1];
        end
        for (i = 0; i < 2; i = i + 1) begin
            assign visited_level8[i] = visited_level7[2 * i] | visited_level7[2 * i + 1];
        end
    endgenerate

endmodule


module btree_combine_global_signal_64 #(parameter
    CORE_NUM = `CORE_NUM,
    POWERLAW_VTX_NUM = `POWERLAW_VTX_NUM
) (
    input [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0] visited,

    output [POWERLAW_VTX_NUM - 1 : 0] visited_combine
);

    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level3 [0 : 63];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level4 [0 : 31];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level5 [0 : 15];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level6 [0 : 7];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level7 [0 : 3];
    wire [POWERLAW_VTX_NUM - 1 : 0] visited_level8 [0 : 1];

    assign visited_combine = visited_level8[0] | visited_level8[1];
    generate
        genvar i;
        for (i = 0; i < 64; i = i + 1) begin
            assign visited_level3[i] = visited[(i + 1) * POWERLAW_VTX_NUM - 1 : i * POWERLAW_VTX_NUM];
        end
        for (i = 0; i < 32; i = i + 1) begin
            assign visited_level4[i] = visited_level3[2 * i] | visited_level3[2 * i + 1];
        end
        for (i = 0; i < 16; i = i + 1) begin
            assign visited_level5[i] = visited_level4[2 * i] | visited_level4[2 * i + 1];
        end
        for (i = 0; i < 8; i = i + 1) begin
            assign visited_level6[i] = visited_level5[2 * i] | visited_level5[2 * i + 1];
        end
        for (i = 0; i < 4; i = i + 1) begin
            assign visited_level7[i] = visited_level6[2 * i] | visited_level6[2 * i + 1];
        end
        for (i = 0; i < 2; i = i + 1) begin
            assign visited_level8[i] = visited_level7[2 * i] | visited_level7[2 * i + 1];
        end
    endgenerate

endmodule


module rd_active_vertex_global_signal_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    
    // [32 * 32 - 1 : 0] VERTEX_NOT_READ = {
    //     32'd798169, 32'd802022, 32'd859188, 32'd737253, 32'd236717, 32'd800651, 32'd884620, 32'd1038374, 32'd246686, 32'd72581,
    //     32'd514920, 32'd939780, 32'd433575, 32'd644849, 32'd887126, 32'd817258, 32'd812863, 32'd802479, 32'd701232, 32'd798386,
    //     32'd1030895, 32'd609384, 32'd504066, 32'd426492, 32'd16463, 32'd644226, 32'd506990, 32'd1045487, 32'd628265, 32'd735673,
    //     32'd507966, 32'd584249
    // },
    
    // [32 * 32 - 1 : 0] VERTEX_NOT_READ = {
    //     32'd2472, 32'd1355, 32'd9395, 32'd9636, 32'd1431, 32'd1488, 32'd12919, 32'd6682, 32'd9609, 32'd12355,
    //     32'd13358, 32'd317, 32'd12851, 32'd4939, 32'd10307, 32'd9577, 32'd10330, 32'd3782, 32'd14884, 32'd1842,
    //     32'd2086, 32'd9255, 32'd7582, 32'd12890, 32'd2337, 32'd13303, 32'd10501, 32'd14495, 32'd5712, 32'd7027,
    //     32'd10490, 32'd2990
    // },
    POWERLAW_VTX_NUM = `POWERLAW_VTX_NUM
) (
    input clk,
    input rst,
    input [POWERLAW_VTX_NUM * 32 - 1 : 0]   VERTEX_NOT_READ,
    input [V_ID_WIDTH - 1 : 0]              backend_active_v_id,
    input                                   backend_active_v_updated,
    input                                   backend_active_v_id_valid,

    output reg [POWERLAW_VTX_NUM - 1 : 0]   global_powerlaw_v_visit
);

    generate
        genvar i;
        for (i = 0; i < POWERLAW_VTX_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                if (rst) begin
                    global_powerlaw_v_visit[i] <= 0;
                end else begin
                    global_powerlaw_v_visit[i] <= global_powerlaw_v_visit[i] || (backend_active_v_id == VERTEX_NOT_READ[(i + 1) * 32 - 1 : i * 32] && backend_active_v_id_valid && backend_active_v_updated);
                end
            end
        end
    endgenerate

endmodule

// module vis_bitmap_self #(parameter
//     RAM_DWIDTH_RD = `BITMAP_COMPRESSED_LENGTH,                  // Specify column width (byte width, typically 8 or 9)
//     RAM_AWIDTH_RD = `BITMAP_COMPRESSED_NUM_WIDTH,
//     RAM_DWIDTH_WR = 1,       
//     RAM_AWIDTH_WR = `BITMAP_COMPRESSED_NUM_WIDTH + `BITMAP_COMPRESSED_LENGTH_WIDTH,
//     INIT_FILE = 0                       // Specify name/location of RAM initialization file if using one (leave blank if not)
// ) (
//   input [RAM_AWIDTH_WR - 1 : 0] addra,   // Write address bus, width determined from RAM_DEPTH
//   input [RAM_AWIDTH_RD - 1 : 0] addrb,   // Write address bus, width determined from RAM_DEPTH
//   input [RAM_DWIDTH_WR - 1 : 0] dina,   // RAM input data
//   input clka,                            // Write clock
//   input clkb,                            // Read clock
//   input wea,                // Byte-write enable
//   input enb,  			   // Read Enable, for additional power savings, disable when not in use
//   input rstb,                            // Output reset (does not affect memory contents)
//   input regceb,                          // Output register enable

//   output [RAM_DWIDTH_RD - 1 : 0] doutb           // RAM output data
// );

// // XPM_MEMORY instantiation template for Simple Dual Port RAM configurations
// // Refer to the targeted device family architecture libraries guide for XPM_MEMORY documentation
// // =======================================================================================================================

// // Parameter usage table, organized as follows:
// // +---------------------------------------------------------------------------------------------------------------------+
// // | Parameter name       | Data type          | Restrictions, if applicable                                             |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Description                                                                                                         |
// // +---------------------------------------------------------------------------------------------------------------------+
// // +---------------------------------------------------------------------------------------------------------------------+
// // | ADDR_WIDTH_A         | Integer            | Range: 1 - 20. Default value = 6.                                       |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify the width of the port A address port addra, in bits.                                                        |
// // | Must be large enough to access the entire memory from port A, i.e. &gt;= $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A).    |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | ADDR_WIDTH_B         | Integer            | Range: 1 - 20. Default value = 6.                                       |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify the width of the port B address port addrb, in bits.                                                        |
// // | Must be large enough to access the entire memory from port B, i.e. &gt;= $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B).     |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | AUTO_SLEEP_TIME      | Integer            | Range: 0 - 15. Default value = 0.                                       |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Number of clk[a|b] cycles to auto-sleep, if feature is available in architecture.                                   |
// // |                                                                                                                     |
// // |   0 - Disable auto-sleep feature                                                                                    |
// // |   3-15 - Number of auto-sleep latency cycles                                                                        |
// // |                                                                                                                     |
// // | Do not change from the value provided in the template instantiation.                                                |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | BYTE_WRITE_WIDTH_A   | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | To enable byte-wide writes on port A, specify the byte width, in bits.                                              |
// // |                                                                                                                     |
// // |   8- 8-bit byte-wide writes, legal when WRITE_DATA_WIDTH_A is an integer multiple of 8                              |
// // |   9- 9-bit byte-wide writes, legal when WRITE_DATA_WIDTH_A is an integer multiple of 9                              |
// // |                                                                                                                     |
// // | Or to enable word-wide writes on port A, specify the same value as for WRITE_DATA_WIDTH_A.                          |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | CASCADE_HEIGHT       | Integer            | Range: 0 - 64. Default value = 0.                                       |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | 0- No Cascade Height, Allow Vivado Synthesis to choose.                                                             |
// // | 1 or more - Vivado Synthesis sets the specified value as Cascade Height.                                            |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | CLOCKING_MODE        | String             | Allowed values: common_clock, independent_clock. Default value = common_clock.|
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Designate whether port A and port B are clocked with a common clock or with independent clocks.                     |
// // |                                                                                                                     |
// // |   "common_clock"- Common clocking; clock both port A and port B with clka                                           |
// // |   "independent_clock"- Independent clocking; clock port A with clka and port B with clkb                            |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | ECC_MODE             | String             | Allowed values: no_ecc, both_encode_and_decode, decode_only, encode_only. Default value = no_ecc.|
// // |---------------------------------------------------------------------------------------------------------------------|
// // |                                                                                                                     |
// // |   "no_ecc" - Disables ECC                                                                                           |
// // |   "encode_only" - Enables ECC Encoder only                                                                          |
// // |   "decode_only" - Enables ECC Decoder only                                                                          |
// // |   "both_encode_and_decode" - Enables both ECC Encoder and Decoder                                                   |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | MEMORY_INIT_FILE     | String             | Default value = none.                                                   |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify "none" (including quotes) for no memory initialization, or specify the name of a memory initialization file.|
// // | Enter only the name of the file with .mem extension, including quotes but without path (e.g. "my_file.mem").        |
// // | File format must be ASCII and consist of only hexadecimal values organized into the specified depth by              |
// // | narrowest data width generic value of the memory. Initialization of memory happens through the file name specified only|
// // | when parameter MEMORY_INIT_PARAM value is equal to "".                                                              |
// // | When using XPM_MEMORY in a project, add the specified file to the Vivado project as a design source.                |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | MEMORY_INIT_PARAM    | String             | Default value = 0.                                                      |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify "" or "0" (including quotes) for no memory initialization through parameter, or specify the string          |
// // | containing the hex characters. Enter only hex characters with each location separated by delimiter (,).             |
// // | Parameter format must be ASCII and consist of only hexadecimal values organized into the specified depth by         |
// // | narrowest data width generic value of the memory.For example, if the narrowest data width is 8, and the depth of    |
// // | memory is 8 locations, then the parameter value should be passed as shown below.                                    |
// // | parameter MEMORY_INIT_PARAM = "AB,CD,EF,1,2,34,56,78"                                                               |
// // | Where "AB" is the 0th location and "78" is the 7th location.                                                        |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | MEMORY_OPTIMIZATION  | String             | Allowed values: true, false. Default value = true.                      |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify "true" to enable the optimization of unused memory or bits in the memory structure. Specify "false" to      |
// // | disable the optimization of unused memory or bits in the memory structure.                                          |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | MEMORY_PRIMITIVE     | String             | Allowed values: auto, block, distributed, mixed, ultra. Default value = auto.|
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Designate the memory primitive (resource type) to use.                                                              |
// // |                                                                                                                     |
// // |   "auto"- Allow Vivado Synthesis to choose                                                                          |
// // |   "distributed"- Distributed memory                                                                                 |
// // |   "block"- Block memory                                                                                             |
// // |   "ultra"- Ultra RAM memory                                                                                         |
// // |   "mixed"- Mixed memory                                                                                             |
// // |                                                                                                                     |
// // | NOTE: There may be a behavior mismatch if Block RAM or Ultra RAM specific features, like ECC or Asymmetry, are selected with MEMORY_PRIMITIVE set to "auto".|
// // +---------------------------------------------------------------------------------------------------------------------+
// // | MEMORY_SIZE          | Integer            | Range: 2 - 150994944. Default value = 2048.                             |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify the total memory array size, in bits. For example, enter 65536 for a 2kx32 RAM.                             |
// // |                                                                                                                     |
// // |   When ECC is enabled and set to "encode_only", then the memory size has to be multiples of READ_DATA_WIDTH_B       |
// // |   When ECC is enabled and set to "decode_only", then the memory size has to be multiples of WRITE_DATA_WIDTH_A      |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | MESSAGE_CONTROL      | Integer            | Range: 0 - 1. Default value = 0.                                        |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify 1 to enable the dynamic message reporting such as collision warnings, and 0 to disable the message reporting|
// // +---------------------------------------------------------------------------------------------------------------------+
// // | READ_DATA_WIDTH_B    | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify the width of the port B read data output port doutb, in bits.                                               |
// // |                                                                                                                     |
// // |   When ECC is enabled and set to "encode_only", then READ_DATA_WIDTH_B has to be multiples of 72-bits               |
// // |   When ECC is enabled and set to "decode_only" or "both_encode_and_decode", then READ_DATA_WIDTH_B has to be        |
// // | multiples of 64-bits                                                                                                |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | READ_LATENCY_B       | Integer            | Range: 0 - 100. Default value = 2.                                      |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify the number of register stages in the port B read data pipeline. Read data output to port doutb takes this   |
// // | number of clkb cycles (clka when CLOCKING_MODE is "common_clock").                                                  |
// // | To target block memory, a value of 1 or larger is required- 1 causes use of memory latch only; 2 causes use of      |
// // | output register. To target distributed memory, a value of 0 or larger is required- 0 indicates combinatorial output.|
// // | Values larger than 2 synthesize additional flip-flops that are not retimed into memory primitives.                  |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | READ_RESET_VALUE_B   | String             | Default value = 0.                                                      |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify the reset value of the port B final output register stage in response to rstb input port is assertion.      |
// // | As this parameter is a string, please specify the hex values inside double quotes. As an example,                   |
// // | If the read data width is 8, then specify READ_RESET_VALUE_B = "EA";                                                |
// // | When ECC is enabled, reset value is not supported.                                                                  |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | RST_MODE_A           | String             | Allowed values: SYNC, ASYNC. Default value = SYNC.                      |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Describes the behaviour of the reset                                                                                |
// // |                                                                                                                     |
// // |   "SYNC" - when reset is applied, synchronously resets output port douta to the value specified by parameter READ_RESET_VALUE_A|
// // |   "ASYNC" - when reset is applied, asynchronously resets output port douta to zero                                  |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | RST_MODE_B           | String             | Allowed values: SYNC, ASYNC. Default value = SYNC.                      |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Describes the behaviour of the reset                                                                                |
// // |                                                                                                                     |
// // |   "SYNC" - when reset is applied, synchronously resets output port doutb to the value specified by parameter READ_RESET_VALUE_B|
// // |   "ASYNC" - when reset is applied, asynchronously resets output port doutb to zero                                  |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | SIM_ASSERT_CHK       | Integer            | Range: 0 - 1. Default value = 0.                                        |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | 0- Disable simulation message reporting. Messages related to potential misuse will not be reported.                 |
// // | 1- Enable simulation message reporting. Messages related to potential misuse will be reported.                      |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | USE_EMBEDDED_CONSTRAINT| Integer            | Range: 0 - 1. Default value = 0.                                        |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify 1 to enable the set_false_path constraint addition between clka of Distributed RAM and doutb_reg on clkb    |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | USE_MEM_INIT         | Integer            | Range: 0 - 1. Default value = 1.                                        |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify 1 to enable the generation of below message and 0 to disable generation of the following message completely.|
// // | "INFO - MEMORY_INIT_FILE and MEMORY_INIT_PARAM together specifies no memory initialization.                         |
// // | Initial memory contents will be all 0s."                                                                            |
// // | NOTE: This message gets generated only when there is no Memory Initialization specified either through file or      |
// // | Parameter.                                                                                                          |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | USE_MEM_INIT_MMI     | Integer            | Range: 0 - 1. Default value = 0.                                        |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify 1 to expose this memory information to be written out in the MMI file.                                      |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | WAKEUP_TIME          | String             | Allowed values: disable_sleep, use_sleep_pin. Default value = disable_sleep.|
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify "disable_sleep" to disable dynamic power saving option, and specify "use_sleep_pin" to enable the           |
// // | dynamic power saving option                                                                                         |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | WRITE_DATA_WIDTH_A   | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Specify the width of the port A write data input port dina, in bits.                                                |
// // | The values of WRITE_DATA_WIDTH_A and READ_DATA_WIDTH_A must be equal.                                               |
// // | When ECC is enabled and set to "encode_only" or "both_encode_and_decode", then WRITE_DATA_WIDTH_A must be           |
// // | multiples of 64-bits.                                                                                               |
// // | When ECC is enabled and set to "decode_only", then WRITE_DATA_WIDTH_A must be multiples of 72-bits.                 |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | WRITE_MODE_B         | String             | Allowed values: no_change, read_first, write_first. Default value = no_change.|
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Write mode behavior for port B output data port, doutb.                                                             |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | WRITE_PROTECT        | Integer            | Range: 0 - 1. Default value = 1.                                        |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Default value is 1, means write is protected through enable and write enable and hence the LUT is placed before the memory. This is the default behaviour to access memory.|
// // | When 0, disables write protection. Write enable (WE) directly connected to memory.                                  |
// // | NOTE: Disable this option only if the advanced users can guarantee that the write enable (WE) cannot be given without enable (EN).|
// // +---------------------------------------------------------------------------------------------------------------------+

// // Port usage table, organized as follows:
// // +---------------------------------------------------------------------------------------------------------------------+
// // | Port name      | Direction | Size, in bits                         | Domain  | Sense       | Handling if unused     |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Description                                                                                                         |
// // +---------------------------------------------------------------------------------------------------------------------+
// // +---------------------------------------------------------------------------------------------------------------------+
// // | addra          | Input     | ADDR_WIDTH_A                          | clka    | NA          | Required               |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Address for port A write operations.                                                                                |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | addrb          | Input     | ADDR_WIDTH_B                          | clkb    | NA          | Required               |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Address for port B read operations.                                                                                 |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | clka           | Input     | 1                                     | NA      | Rising edge | Required               |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Clock signal for port A. Also clocks port B when parameter CLOCKING_MODE is "common_clock".                         |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | clkb           | Input     | 1                                     | NA      | Rising edge | Required               |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Clock signal for port B when parameter CLOCKING_MODE is "independent_clock".                                        |
// // | Unused when parameter CLOCKING_MODE is "common_clock".                                                              |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | dbiterrb       | Output    | 1                                     | clkb    | Active-high | DoNotCare              |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Status signal to indicate double bit error occurrence on the data output of port B.                                 |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | dina           | Input     | WRITE_DATA_WIDTH_A                    | clka    | NA          | Required               |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Data input for port A write operations.                                                                             |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | doutb          | Output    | READ_DATA_WIDTH_B                     | clkb    | NA          | Required               |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Data output for port B read operations.                                                                             |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | ena            | Input     | 1                                     | clka    | Active-high | Required               |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Memory enable signal for port A.                                                                                    |
// // | Must be high on clock cycles when write operations are initiated. Pipelined internally.                             |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | enb            | Input     | 1                                     | clkb    | Active-high | Required               |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Memory enable signal for port B.                                                                                    |
// // | Must be high on clock cycles when read operations are initiated. Pipelined internally.                              |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | injectdbiterra | Input     | 1                                     | clka    | Active-high | Tie to 1'b0            |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Controls double bit error injection on input data when ECC enabled (Error injection capability is not available in  |
// // | "decode_only" mode).                                                                                                |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | injectsbiterra | Input     | 1                                     | clka    | Active-high | Tie to 1'b0            |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Controls single bit error injection on input data when ECC enabled (Error injection capability is not available in  |
// // | "decode_only" mode).                                                                                                |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | regceb         | Input     | 1                                     | clkb    | Active-high | Tie to 1'b1            |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Clock Enable for the last register stage on the output data path.                                                   |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | rstb           | Input     | 1                                     | clkb    | Active-high | Required               |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Reset signal for the final port B output register stage.                                                            |
// // | Synchronously resets output port doutb to the value specified by parameter READ_RESET_VALUE_B.                      |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | sbiterrb       | Output    | 1                                     | clkb    | Active-high | DoNotCare              |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Status signal to indicate single bit error occurrence on the data output of port B.                                 |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | sleep          | Input     | 1                                     | NA      | Active-high | Tie to 1'b0            |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | sleep signal to enable the dynamic power saving feature.                                                            |
// // +---------------------------------------------------------------------------------------------------------------------+
// // | wea            | Input     | WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A | clka    | Active-high | Required               |
// // |---------------------------------------------------------------------------------------------------------------------|
// // | Write enable vector for port A input data port dina. 1 bit wide when word-wide writes are used.                     |
// // | In byte-wide write configurations, each bit controls the writing one byte of dina to address addra.                 |
// // | For example, to synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be 4'b0010.   |
// // +---------------------------------------------------------------------------------------------------------------------+


// // xpm_memory_sdpram : In order to incorporate this function into the design,
// //      Verilog      : the following instance declaration needs to be placed
// //     instance      : in the body of the design code.  The instance name
// //    declaration    : (xpm_memory_sdpram_inst) and/or the port declarations within the
// //       code        : parenthesis may be changed to properly reference and
// //                   : connect this function to the design.  All inputs
// //                   : and outputs must be connected.

// //  Please reference the appropriate libraries guide for additional information on the XPM modules.

// //  <-----Cut code below this line---->

//    // xpm_memory_sdpram: Simple Dual Port RAM
//    // Xilinx Parameterized Macro, version 2022.2

//    xpm_memory_sdpram #(
//       .ADDR_WIDTH_A(RAM_AWIDTH_WR),               // DECIMAL
//       .ADDR_WIDTH_B(RAM_AWIDTH_RD),               // DECIMAL
//       .AUTO_SLEEP_TIME(0),            // DECIMAL
//       .BYTE_WRITE_WIDTH_A(1),         // DECIMAL
//       .CASCADE_HEIGHT(0),             // DECIMAL
//       .CLOCKING_MODE("common_clock"), // String
//       .ECC_MODE("no_ecc"),            // String
//       .MEMORY_INIT_FILE($sformatf("%svis_bitmap_small_%0d.mem", `FILE_LOC, INIT_FILE)),      // String
//       .MEMORY_INIT_PARAM(""),        // String
//       .MEMORY_OPTIMIZATION("true"),   // String
//       .MEMORY_PRIMITIVE("auto"),      // String
//       .MEMORY_SIZE(`BITMAP_COMPRESSED_LENGTH * `BITMAP_COMPRESSED_NUM),             // DECIMAL
//       .MESSAGE_CONTROL(0),            // DECIMAL
//       .READ_DATA_WIDTH_B(RAM_DWIDTH_RD),         // DECIMAL
//       .READ_LATENCY_B(2),             // DECIMAL
//       .READ_RESET_VALUE_B("0"),       // String
//       .RST_MODE_A("SYNC"),            // String
//       .RST_MODE_B("SYNC"),            // String
//       .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
//       .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
//       .USE_MEM_INIT(1),               // DECIMAL
//       .USE_MEM_INIT_MMI(0),           // DECIMAL
//       .WAKEUP_TIME("disable_sleep"),  // String
//       .WRITE_DATA_WIDTH_A(RAM_DWIDTH_WR),        // DECIMAL
//       .WRITE_MODE_B("read_first"),     // String
//       .WRITE_PROTECT(1)               // DECIMAL
//    )
//    xpm_memory_sdpram_inst (
//       .dbiterrb(),             // 1-bit output: Status signal to indicate double bit error occurrence
//                                        // on the data output of port B.

//       .doutb(doutb),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
//       .sbiterrb(),             // 1-bit output: Status signal to indicate single bit error occurrence
//                                        // on the data output of port B.

//       .addra(addra),                   // ADDR_WIDTH_A-bit input: Address for port A write operations.
//       .addrb(addrb),                   // ADDR_WIDTH_B-bit input: Address for port B read operations.
//       .clka(clka),                     // 1-bit input: Clock signal for port A. Also clocks port B when
//                                        // parameter CLOCKING_MODE is "common_clock".

//       .clkb(clkb),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
//                                        // "independent_clock". Unused when parameter CLOCKING_MODE is
//                                        // "common_clock".

//       .dina(dina),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
//       .ena(wea),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
//                                        // cycles when write operations are initiated. Pipelined internally.

//       .enb(enb),                       // 1-bit input: Memory enable signal for port B. Must be high on clock
//                                        // cycles when read operations are initiated. Pipelined internally.

//       .injectdbiterra(1'b0), // 1-bit input: Controls double bit error injection on input data when
//                                        // ECC enabled (Error injection capability is not available in
//                                        // "decode_only" mode).

//       .injectsbiterra(1'b0), // 1-bit input: Controls single bit error injection on input data when
//                                        // ECC enabled (Error injection capability is not available in
//                                        // "decode_only" mode).

//       .regceb(regceb),                 // 1-bit input: Clock Enable for the last register stage on the output
//                                        // data path.

//       .rstb(rstb),                     // 1-bit input: Reset signal for the final port B output register stage.
//                                        // Synchronously resets output port doutb to the value specified by
//                                        // parameter READ_RESET_VALUE_B.

//       .sleep(1'b0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
//       .wea(wea)                        // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
//                                        // for port A input data port dina. 1 bit wide when word-wide writes are
//                                        // used. In byte-wide write configurations, each bit controls the
//                                        // writing one byte of dina to address addra. For example, to
//                                        // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
//                                        // is 32, wea would be 4'b0010.

//    );

//    // End of xpm_memory_sdpram_inst instantiation

// endmodule