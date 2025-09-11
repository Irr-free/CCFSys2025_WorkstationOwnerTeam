`timescale 1ns / 1ps

`include "accelerator.vh"

module M5_2_tb ();

    parameter integer V_ID_WIDTH = `V_ID_WIDTH;
    parameter integer V_VALUE_WIDTH = `V_VALUE_WIDTH;
    parameter integer FIRST_EDGE_BRAM_AWIDTH = `FIRST_EDGE_BRAM_AWIDTH;
    parameter integer FIRST_EDGE_BRAM_DWIDTH = `FIRST_EDGE_BRAM_DWIDTH;
    parameter integer CORE_NUM = `CORE_NUM;
    parameter integer CORE_NUM_WIDTH = `CORE_NUM_WIDTH;

    parameter integer LP_CLK_PERIOD_PS = 5000; // 200 MHz

    logic ap_clk = 1;

    initial begin: AP_CLK
        forever begin
            ap_clk = #5 ~ap_clk;
        end
    end

    logic ap_rst = 0;

    // module input
    reg [CORE_NUM * FIRST_EDGE_BRAM_AWIDTH - 1 : 0]   front_rd_edge_addr;
    reg [CORE_NUM - 1 : 0]                            front_push_flag;
    reg [CORE_NUM * V_ID_WIDTH - 1 : 0]               front_active_v_id;
    reg [CORE_NUM * V_VALUE_WIDTH - 1 : 0]            front_active_v_value;
    reg [CORE_NUM - 1 : 0]                            front_rd_edge_valid;
    reg [CORE_NUM - 1 : 0]                            front_iteration_end;
    reg [CORE_NUM - 1 : 0]                            front_iteration_end_valid;
    reg [CORE_NUM - 1 : 0]                            next_stage_full;
    // module output
    wire [CORE_NUM - 1 : 0]                           stage_full;
    wire [CORE_NUM - 1 : 0]                           push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]              active_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]           active_v_value;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]              active_v_edge;
    wire [CORE_NUM - 1 : 0]                           active_v_valid;
    wire [CORE_NUM - 1 : 0]                           iteration_end;
    wire [CORE_NUM - 1 : 0]                           iteration_end_valid;

    integer i, j;
    logic test_pass = 1;

    // task automatic SetUpTestCase();
    //     for (i = 0; i < CORE_NUM; i = i + 1)
    //         for (j = 0; j < 2048; j = j + 1)
    //             inst_M5_2_dut.genblk1[i].FIRST_EDGE_ROM_IP_SINGLE.inst.native_mem_module.blk_mem_gen_v8_4_5_inst.memory[j] = i + j;
    // endtask

    task automatic init_input_flag();
        front_rd_edge_addr = 'h0;
        front_push_flag = 'h0;
        front_active_v_id = 'h0;
        front_active_v_value = 'h0;
        front_rd_edge_valid = 'h0;
        front_iteration_end = 'h0;
        front_iteration_end_valid = 'h0;
        next_stage_full = 'h0;
    endtask

    task automatic reset_module();
        ap_rst = 1;
        // SetUpTestCase();
        init_input_flag();
        repeat (10) @(posedge ap_clk);
        ap_rst = 0;
    endtask

    task automatic test_Pull_given_Rst_then_LocalBufferInit();
        reset_module();
        init_input_flag();
        test_pass = 1;
        repeat (1) @(posedge ap_clk);
        @(negedge ap_clk);
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            assert(stage_full[i] == 1'b0)
            else begin
                $error("stage_full[%3d] is 0x%0x, expect 0x%0x!", i, stage_full[i], 1'b0);
                test_pass = 0;
            end
            assert(push_flag[i] == 1'b0)
            else begin
                $error("push_flag[%3d] is 0x%0x, expect 0x%0x!", i, push_flag[i], 1'b0);
                test_pass = 0;
            end
            assert(active_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("active_v_id[%3d] is 0x%0x, expect 0x%0x!", i, active_v_id[i * V_ID_WIDTH +: V_ID_WIDTH], 'h0);
                test_pass = 0;
            end
            assert(active_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 'h0)
            else begin
                $error("active_v_value[%3d] is 0x%0x, expect 0x%0x!", i, active_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH], 'h0);
                test_pass = 0;
            end
            assert(active_v_edge[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("active_v_edge[%3d] is 0x%0x, expect 0x%0x!", i, active_v_edge[i * V_ID_WIDTH +: V_ID_WIDTH], 'h0);
                test_pass = 0;
            end
            assert(active_v_valid[i] == 1'b0)
            else begin
                $error("active_v_valid[%3d] is 0x%0x, expect 0x%0x!", i, active_v_valid[i], 1'b0);
                test_pass = 0;
            end
            assert(iteration_end[i] == 1'b0)
            else begin
                $error("iteration_end[%3d] is 0x%0x, expect 0x%0x!", i, iteration_end[i], 1'b0);
                test_pass = 0;
            end
            assert(iteration_end_valid[i] == 1'b0)
            else begin
                $error("iteration_end_valid[%3d] is 0x%0x, expect 0x%0x!", i, iteration_end_valid[i], 1'b0);
                test_pass = 0;
            end
        end
        if (test_pass)  $display("[PASSED] test_Pull_given_Rst_then_LocalBufferInit");
    endtask

    task automatic test_AddrInOut_given_AddrValid_then_OutputAddr();
        reset_module();
        init_input_flag();
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            front_rd_edge_addr[i * FIRST_EDGE_BRAM_AWIDTH +: FIRST_EDGE_BRAM_AWIDTH] = i;
            front_active_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] = i;
            front_active_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] = 1;
            front_rd_edge_valid[i] = 1'b1;
        end
        test_pass = 1;
        repeat (1) @(posedge ap_clk);
        @(negedge ap_clk);
        init_input_flag();
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            assert(stage_full[i] == 1'b0)
            else begin
                $error("stage_full[%3d] is 0x%0x, expect 0x%0x!", i, stage_full[i], 1'b0);
                test_pass = 0;
            end
            assert(push_flag[i] == 1'b0)
            else begin
                $error("push_flag[%3d] is 0x%0x, expect 0x%0x!", i, push_flag[i], 1'b0);
                test_pass = 0;
            end
            assert(active_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("active_v_id[%3d] is 0x%0x, expect 0x%0x!", i, active_v_id[i * V_ID_WIDTH +: V_ID_WIDTH], 'h0);
                test_pass = 0;
            end
            assert(active_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 'h0)
            else begin
                $error("active_v_value[%3d] is 0x%0x, expect 0x%0x!", i, active_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH], 'h0);
                test_pass = 0;
            end
            assert(active_v_edge[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("active_v_edge[%3d] is 0x%0x, expect 0x%0x!", i, active_v_edge[i * V_ID_WIDTH +: V_ID_WIDTH], 'h0);
                test_pass = 0;
            end
            assert(active_v_valid[i] == 1'b0)
            else begin
                $error("active_v_valid[%3d] is 0x%0x, expect 0x%0x!", i, active_v_valid[i], 1'b0);
                test_pass = 0;
            end
            assert(iteration_end[i] == 1'b0)
            else begin
                $error("iteration_end[%3d] is 0x%0x, expect 0x%0x!", i, iteration_end[i], 1'b0);
                test_pass = 0;
            end
            assert(iteration_end_valid[i] == 1'b0)
            else begin
                $error("iteration_end_valid[%3d] is 0x%0x, expect 0x%0x!", i, iteration_end_valid[i], 1'b0);
                test_pass = 0;
            end
        end
        @(negedge ap_clk);
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            assert(stage_full[i] == 1'b0)
            else begin
                $error("stage_full[%3d] is 0x%0x, expect 0x%0x!", i, stage_full[i], 1'b0);
                test_pass = 0;
            end
            assert(push_flag[i] == 1'b0)
            else begin
                $error("push_flag[%3d] is 0x%0x, expect 0x%0x!", i, push_flag[i], 1'b0);
                test_pass = 0;
            end
            assert(active_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("active_v_id[%3d] is 0x%0x, expect 0x%0x!", i, active_v_id[i * V_ID_WIDTH +: V_ID_WIDTH], 'h0);
                test_pass = 0;
            end
            assert(active_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 'h0)
            else begin
                $error("active_v_value[%3d] is 0x%0x, expect 0x%0x!", i, active_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH], 'h0);
                test_pass = 0;
            end
            assert(active_v_edge[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("active_v_edge[%3d] is 0x%0x, expect 0x%0x!", i, active_v_edge[i * V_ID_WIDTH +: V_ID_WIDTH], 'h0);
                test_pass = 0;
            end
            assert(active_v_valid[i] == 1'b0)
            else begin
                $error("active_v_valid[%3d] is 0x%0x, expect 0x%0x!", i, active_v_valid[i], 1'b0);
                test_pass = 0;
            end
            assert(iteration_end[i] == 1'b0)
            else begin
                $error("iteration_end[%3d] is 0x%0x, expect 0x%0x!", i, iteration_end[i], 1'b0);
                test_pass = 0;
            end
            assert(iteration_end_valid[i] == 1'b0)
            else begin
                $error("iteration_end_valid[%3d] is 0x%0x, expect 0x%0x!", i, iteration_end_valid[i], 1'b0);
                test_pass = 0;
            end
        end
        @(negedge ap_clk);
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            assert(stage_full[i] == 1'b0)
            else begin
                $error("stage_full[%3d] is 0x%0x, expect 0x%0x!", i, stage_full[i], 1'b0);
                test_pass = 0;
            end
            assert(push_flag[i] == 1'b0)
            else begin
                $error("push_flag[%3d] is 0x%0x, expect 0x%0x!", i, push_flag[i], 1'b0);
                test_pass = 0;
            end
            assert(active_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == i)
            else begin
                $error("active_v_id[%3d] is 0x%0x, expect 0x%0x!", i, active_v_id[i * V_ID_WIDTH +: V_ID_WIDTH], i);
                test_pass = 0;
            end
            assert(active_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 'h1)
            else begin
                $error("active_v_value[%3d] is 0x%0x, expect 0x%0x!", i, active_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH], 'h1);
                test_pass = 0;
            end
            assert(active_v_edge[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h1)
            else begin
                $error("active_v_edge[%3d] is 0x%0x, expect 0x%0x!", i, active_v_edge[i * V_ID_WIDTH +: V_ID_WIDTH], 'h1);
                test_pass = 0;
            end
            assert(active_v_valid[i] == 1'b1)
            else begin
                $error("active_v_valid[%3d] is 0x%0x, expect 0x%0x!", i, active_v_valid[i], 1'b1);
                test_pass = 0;
            end
            assert(iteration_end[i] == 1'b0)
            else begin
                $error("iteration_end[%3d] is 0x%0x, expect 0x%0x!", i, iteration_end[i], 1'b0);
                test_pass = 0;
            end
            assert(iteration_end_valid[i] == 1'b0)
            else begin
                $error("iteration_end_valid[%3d] is 0x%0x, expect 0x%0x!", i, iteration_end_valid[i], 1'b0);
                test_pass = 0;
            end
        end
        if (test_pass)  $display("[PASSED] test_AddrInOut_given_AddrValid_then_OutputAddr");
    endtask

    // DUT instantiation
    rd_first_edge_bram #(
        .V_ID_WIDTH             (V_ID_WIDTH),
        .V_VALUE_WIDTH          (V_VALUE_WIDTH),
        .FIRST_EDGE_BRAM_AWIDTH (FIRST_EDGE_BRAM_AWIDTH),
        .FIRST_EDGE_BRAM_DWIDTH (FIRST_EDGE_BRAM_DWIDTH),
        .CORE_NUM               (CORE_NUM)
    )
    inst_M5_2_dut(
        .clk            (ap_clk),
        .rst            ({CORE_NUM{ap_rst}}),
        .front_rd_edge_addr     (front_rd_edge_addr),
        .front_push_flag        (front_push_flag),
        .front_active_v_id      (front_active_v_id),
        .front_active_v_value   (front_active_v_value),
        .front_rd_edge_valid    (front_rd_edge_valid),
        .front_iteration_end    (front_iteration_end),
        .front_iteration_end_valid  (front_iteration_end_valid),
        .next_stage_full            (next_stage_full),

        .stage_full                 (stage_full),
        .push_flag                  (push_flag),
        .active_v_id                (active_v_id),
        .active_v_value             (active_v_value),
        .active_v_edge              (active_v_edge),
        .active_v_valid             (active_v_valid),
        .iteration_end              (iteration_end),
        .iteration_end_valid        (iteration_end_valid)
    );

    initial begin : Rd_First_Edge_Bram_Test
        test_Pull_given_Rst_then_LocalBufferInit();
        test_AddrInOut_given_AddrValid_then_OutputAddr();
        repeat (10) @(posedge ap_clk);
        $finish;
    end

endmodule