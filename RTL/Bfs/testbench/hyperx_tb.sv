`timescale 1ns / 1ps

`include "accelerator.vh"

module hyperx_tb();

    parameter V_ID_WIDTH = `V_ID_WIDTH;
    parameter V_VALUE_WIDTH = `V_VALUE_WIDTH;
    parameter CORE_NUM = `CORE_NUM;
    
    parameter integer LP_CLK_PERIOD_PS = 5000; // 200 MHz

    logic ap_clk = 0;

    initial begin: AP_CLK
        forever begin
            ap_clk = #5 ~ap_clk;
        end
    end

    logic [CORE_NUM-1:0] ap_rst = 'h0;

    // module input
    reg [CORE_NUM - 1 : 0]                    hy1_front_push_flag;
    reg [CORE_NUM * V_ID_WIDTH - 1 : 0]       hy1_front_update_v_id;
    reg [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    hy1_front_update_v_value;
    reg [CORE_NUM - 1 : 0]                    hy1_front_pull_first_flag;
    reg [CORE_NUM - 1 : 0]                    hy1_front_update_v_valid;
    reg [CORE_NUM - 1 : 0]                    hy1_front_iteration_end;
    reg [CORE_NUM - 1 : 0]                    hy1_front_iteration_end_valid;
    reg [CORE_NUM - 1 : 0]                    hy2_front_push_flag;
    reg [CORE_NUM * V_ID_WIDTH - 1 : 0]       hy2_front_update_v_id;
    reg [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    hy2_front_update_v_value;
    reg [CORE_NUM - 1 : 0]                    hy2_front_pull_first_flag;
    reg [CORE_NUM - 1 : 0]                    hy2_front_update_v_valid;
    reg [CORE_NUM - 1 : 0]                    hy2_front_iteration_end;
    reg [CORE_NUM - 1 : 0]                    hy2_front_iteration_end_valid;
    reg [CORE_NUM - 1 : 0]                    source_core_full;

    // module output
    wire [CORE_NUM - 1 : 0]                   hy1_rst;
    wire [CORE_NUM - 1 : 0]                   hy2_rst;
    wire [CORE_NUM - 1 : 0]                   hy1_stage_full;
    wire [CORE_NUM - 1 : 0]                   hy2_stage_full;
    wire [CORE_NUM - 1 : 0]                   hy1_push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]      hy1_update_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   hy1_update_v_value;
    wire [CORE_NUM - 1 : 0]                   hy1_pull_first_flag;
    wire [CORE_NUM - 1 : 0]                   hy1_update_v_valid;
    wire [CORE_NUM - 1 : 0]                   hy1_iteration_end;
    wire [CORE_NUM - 1 : 0]                   hy1_iteration_end_valid;
    wire [CORE_NUM - 1 : 0]                   hy2_push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]      hy2_update_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   hy2_update_v_value;
    wire [CORE_NUM - 1 : 0]                   hy2_pull_first_flag;
    wire [CORE_NUM - 1 : 0]                   hy2_update_v_valid;
    wire [CORE_NUM - 1 : 0]                   hy2_iteration_end;
    wire [CORE_NUM - 1 : 0]                   hy2_iteration_end_valid;
    
    task automatic init_input_flag();
        hy1_front_push_flag = 'h0;
        hy1_front_update_v_id = 'h0;
        hy1_front_update_v_value = 'h0;
        hy1_front_pull_first_flag = 'h0;
        hy1_front_update_v_valid = 'h0;
        hy1_front_iteration_end = 'h0;
        hy1_front_iteration_end_valid = 'h0;
        hy2_front_push_flag = 'h0;
        hy2_front_update_v_id = 'h0;
        hy2_front_update_v_value = 'h0;
        hy2_front_pull_first_flag = 'h0;
        hy2_front_update_v_valid = 'h0;
        hy2_front_iteration_end = 'h0;
        hy2_front_iteration_end_valid = 'h0;
        source_core_full = 'h0;
    endtask

    task automatic reset_module();
        ap_rst = {16{1'b1}};//ap_rst = 'b1
        init_input_flag();
        repeat (10) @(posedge ap_clk);
        ap_rst = 'h0;
    endtask

    integer i,j;
    logic [CORE_NUM -1:0] hy1_res_ready,hy2_res_ready;
    logic test_pass;
    
    task automatic test_Push_given_Rst_then_LocalBufferInit();
        reset_module();
        init_input_flag();
        test_pass = 1;
        repeat (1) @(posedge ap_clk);
        
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            assert(hy1_stage_full[i] == 1'b0)
            else begin
                $error("hy1_stage_full init error!");
                test_pass = 0;
            end
            assert(hy1_push_flag[i] == 1'b0)
            else begin
                $error("hy1_push_flag init error");
                test_pass = 0;
            end
            assert(hy1_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("hy1_update_v_id init error!");
                test_pass = 0;
            end
            assert(hy1_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 'h0)
            else begin
                $error("hy1_update_v_value init error");
                test_pass = 0;
            end
            assert(hy1_pull_first_flag[i] == 1'b0)
            else begin
                $error("hy1_pull_first_flag init error");
                test_pass = 0;
            end
            assert(hy1_update_v_valid[i] == 1'b0)
            else begin
                $error("hy1_update_v_valid init error");
                test_pass = 0;
            end
            assert(hy1_iteration_end[i] == 1'b0)
            else begin
                $error("hy1_iteration_end[%3d] is 0x%0x, expect 0x%0x!", i, hy1_iteration_end[i], 1'b0);
            end
            assert(hy1_iteration_end_valid[i] == 1'b0)
            else begin
                $error("hy1_iteration_end_valid[%3d] is 0x%0x, expect 0x%0x!", i, hy1_iteration_end_valid[i], 1'b0);
                test_pass = 0;
            end
            assert(hy2_stage_full[i] == 1'b0)
            else begin
                $error("hy2_stage_full init error!");
                test_pass = 0;
            end
            assert(hy2_push_flag[i] == 1'b0)
            else begin
                $error("hy2_push_flag init error");
                test_pass = 0;
            end
            assert(hy2_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("hy2_update_v_id init error!");
                test_pass = 0;
            end
            assert(hy2_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 'h0)
            else begin
                $error("hy2_update_v_value init error");
                test_pass = 0;
            end
            assert(hy2_pull_first_flag[i] == 1'b0)
            else begin
                $error("hy2_pull_first_flag init error");
                test_pass = 0;
            end
            assert(hy2_update_v_valid[i] == 1'b0)
            else begin
                $error("hy2_update_v_valid init error");
                test_pass = 0;
            end
            assert(hy2_iteration_end[i] == 1'b0)
            else begin
                $error("hy2_iteration_end[%3d] is 0x%0x, expect 0x%0x!", i, hy2_iteration_end[i], 1'b0);
            end
            assert(hy2_iteration_end_valid[i] == 1'b0)
            else begin
                $error("hy2_iteration_end_valid[%3d] is 0x%0x, expect 0x%0x!", i, hy2_iteration_end_valid[i], 1'b0);
                test_pass = 0;
            end
        end
        if (test_pass)  $display("\033[32m[PASSED]\033[m test_Pull_given_Rst_then_LocalBufferInit");
    endtask
    
    task automatic test_PushInOut_given_DataValid_then_OutputValid();
        reset_module();
        init_input_flag();
        test_pass = 1;
        hy1_res_ready = 'b0;
        hy2_res_ready = 'b0;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            hy1_front_push_flag[i] = 1;
            hy1_front_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] = i+1;
            hy1_front_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] = 1;
            hy1_front_pull_first_flag[i] = 0;
            hy1_front_update_v_valid[i] = 1;
            hy1_front_iteration_end[i] = 0;
            hy1_front_iteration_end_valid = 0;
            hy2_front_push_flag[i] = 1;
            hy2_front_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] = i+2;
            hy2_front_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] = 2;
            hy2_front_pull_first_flag[i] = 0;
            hy2_front_update_v_valid[i] = 1;
            hy2_front_iteration_end[i] = 0;
            hy2_front_iteration_end_valid = 0;
        end
        repeat (3) @(posedge ap_clk);
        init_input_flag();
        for (j = 0; j < 100; j = j + 1) begin
            repeat (1) @(posedge ap_clk);
            for (i = 0; i < CORE_NUM; i = i + 1) begin
                if(hy1_update_v_valid[i] && hy1_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] % CORE_NUM == i && hy1_push_flag[i] && hy1_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 1)begin
                    hy1_res_ready[i] = 1;
                end
                if(hy2_update_v_valid[i] && hy2_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] % CORE_NUM == i && hy2_push_flag[i] && hy2_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 2)begin
                    hy2_res_ready[i] = 1;
                end
            end
        end
        assert(hy1_res_ready == {16{1'b1}})
        else begin
            $error("hy1_res_ready init error!");
            test_pass = 0;
        end
        assert(hy2_res_ready == {16{1'b1}})
        else begin
            $error("hy2_res_ready init error!");
            test_pass = 0;
        end
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            assert(hy1_stage_full[i] == 1'b0)
            else begin
                $error("hy1_stage_full init error!");
                test_pass = 0;
            end
            assert(hy1_push_flag[i] == 1'b0)
            else begin
                $error("hy1_push_flag init error");
                test_pass = 0;
            end
            assert(hy1_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("hy1_update_v_id init error!");
                test_pass = 0;
            end
            assert(hy1_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 'h0)
            else begin
                $error("hy1_update_v_value init error");
                test_pass = 0;
            end
            assert(hy1_pull_first_flag[i] == 1'b0)
            else begin
                $error("hy1_pull_first_flag init error");
                test_pass = 0;
            end
            assert(hy1_update_v_valid[i] == 1'b0)
            else begin
                $error("hy1_update_v_valid init error");
                test_pass = 0;
            end
            assert(hy1_iteration_end[i] == 1'b0)
            else begin
                $error("hy1_iteration_end[%3d] is 0x%0x, expect 0x%0x!", i, hy1_iteration_end[i], 1'b0);
            end
            assert(hy1_iteration_end_valid[i] == 1'b0)
            else begin
                $error("hy1_iteration_end_valid[%3d] is 0x%0x, expect 0x%0x!", i, hy1_iteration_end_valid[i], 1'b0);
                test_pass = 0;
            end
            assert(hy2_stage_full[i] == 1'b0)
            else begin
                $error("hy2_stage_full init error!");
                test_pass = 0;
            end
            assert(hy2_push_flag[i] == 1'b0)
            else begin
                $error("hy2_push_flag init error");
                test_pass = 0;
            end
            assert(hy2_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("hy2_update_v_id init error!");
                test_pass = 0;
            end
            assert(hy2_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 'h0)
            else begin
                $error("hy2_update_v_value init error");
                test_pass = 0;
            end
            assert(hy2_pull_first_flag[i] == 1'b0)
            else begin
                $error("hy2_pull_first_flag init error");
                test_pass = 0;
            end
            assert(hy2_update_v_valid[i] == 1'b0)
            else begin
                $error("hy2_update_v_valid init error");
                test_pass = 0;
            end
            assert(hy2_iteration_end[i] == 1'b0)
            else begin
                $error("hy2_iteration_end[%3d] is 0x%0x, expect 0x%0x!", i, hy2_iteration_end[i], 1'b0);
            end
            assert(hy2_iteration_end_valid[i] == 1'b0)
            else begin
                $error("hy2_iteration_end_valid[%3d] is 0x%0x, expect 0x%0x!", i, hy2_iteration_end_valid[i], 1'b0);
                test_pass = 0;
            end
        end
        if (test_pass)  $display("\033[32m[PASSED]\033[m test_PushInOut_given_DataValid_then_OutputValid");
    endtask
    
    task automatic test_PullInOut_given_DataValid_then_OutputValid();
        reset_module();
        init_input_flag();
        test_pass = 1;
        hy1_res_ready = 'b0;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            hy1_front_push_flag[i] = 0;
            hy1_front_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] = 2;
            hy1_front_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] = i+2;
            hy1_front_pull_first_flag[i] = 0;
            hy1_front_update_v_valid[i] = 1;
            hy1_front_iteration_end[i] = 0;
            hy1_front_iteration_end_valid = 0;
        end
        repeat (2) @(posedge ap_clk);
        init_input_flag();
        for (j = 0; j < 100; j = j + 1) begin
            repeat (1) @(posedge ap_clk);
            for (i = 0; i < CORE_NUM; i = i + 1) begin
                if(hy1_update_v_valid[i] && hy1_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == 2 && !hy1_push_flag[i] && hy1_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] % CORE_NUM == i)begin
                    hy1_res_ready[i] = 1;
                end
            end
        end
        assert(hy1_res_ready == {16{1'b1}})
        else begin
            $error("hy1_res_ready init error!");
            test_pass = 0;
        end
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            assert(hy1_stage_full[i] == 1'b0)
            else begin
                $error("hy1_stage_full init error!");
                test_pass = 0;
            end
            assert(hy1_push_flag[i] == 1'b0)
            else begin
                $error("hy1_push_flag init error");
                test_pass = 0;
            end
            assert(hy1_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("hy1_update_v_id init error!");
                test_pass = 0;
            end
            assert(hy1_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 'h0)
            else begin
                $error("hy1_update_v_value init error");
                test_pass = 0;
            end
            assert(hy1_pull_first_flag[i] == 1'b0)
            else begin
                $error("hy1_pull_first_flag init error");
                test_pass = 0;
            end
            assert(hy1_update_v_valid[i] == 1'b0)
            else begin
                $error("hy1_update_v_valid init error");
                test_pass = 0;
            end
            assert(hy1_iteration_end[i] == 1'b0)
            else begin
                $error("hy1_iteration_end[%3d] is 0x%0x, expect 0x%0x!", i, hy1_iteration_end[i], 1'b0);
            end
            assert(hy1_iteration_end_valid[i] == 1'b0)
            else begin
                $error("hy1_iteration_end_valid[%3d] is 0x%0x, expect 0x%0x!", i, hy1_iteration_end_valid[i], 1'b0);
                test_pass = 0;
            end
            assert(hy2_stage_full[i] == 1'b0)
            else begin
                $error("hy2_stage_full init error!");
                test_pass = 0;
            end
            assert(hy2_push_flag[i] == 1'b0)
            else begin
                $error("hy2_push_flag init error");
                test_pass = 0;
            end
            assert(hy2_update_v_id[i * V_ID_WIDTH +: V_ID_WIDTH] == 'h0)
            else begin
                $error("hy2_update_v_id init error!");
                test_pass = 0;
            end
            assert(hy2_update_v_value[i * V_VALUE_WIDTH +: V_VALUE_WIDTH] == 'h0)
            else begin
                $error("hy2_update_v_value init error");
                test_pass = 0;
            end
            assert(hy2_pull_first_flag[i] == 1'b0)
            else begin
                $error("hy2_pull_first_flag init error");
                test_pass = 0;
            end
            assert(hy2_update_v_valid[i] == 1'b0)
            else begin
                $error("hy2_update_v_valid init error");
                test_pass = 0;
            end
            assert(hy2_iteration_end[i] == 1'b0)
            else begin
                $error("hy2_iteration_end[%3d] is 0x%0x, expect 0x%0x!", i, hy2_iteration_end[i], 1'b0);
            end
            assert(hy2_iteration_end_valid[i] == 1'b0)
            else begin
                $error("hy2_iteration_end_valid[%3d] is 0x%0x, expect 0x%0x!", i, hy2_iteration_end_valid[i], 1'b0);
                test_pass = 0;
            end
        end
        if (test_pass)  $display("\033[32m[PASSED]\033[m test_PullInOut_given_DataValid_then_OutputValid");
    endtask
    
    HyperX_Network inst_hyperx_dut (
        .clk                                             (ap_clk),
        .hy1_front_rst                                   (ap_rst),
        .hy1_front_push_flag                             (hy1_front_push_flag),
        .hy1_front_update_v_id                           (hy1_front_update_v_id),
        .hy1_front_update_v_value                        (hy1_front_update_v_value),
        .hy1_front_pull_first_flag                       (hy1_front_pull_first_flag),
        .hy1_front_update_v_valid                        (hy1_front_update_v_valid),
        .hy1_front_iteration_end                         (hy1_front_iteration_end),
        .hy1_front_iteration_end_valid                   (hy1_front_iteration_end_valid),
        .hy2_front_rst                                   (ap_rst),
        .hy2_front_push_flag                             (hy2_front_push_flag),
        .hy2_front_update_v_id                           (hy2_front_update_v_id),
        .hy2_front_update_v_value                        (hy2_front_update_v_value),
        .hy2_front_pull_first_flag                       (hy2_front_pull_first_flag),
        .hy2_front_update_v_valid                        (hy2_front_update_v_valid),
        .hy2_front_iteration_end                         (hy2_front_iteration_end),
        .hy2_front_iteration_end_valid                   (hy2_front_iteration_end_valid),
        .source_core_full                                (source_core_full),

        .hy1_rst                                   (hy1_rst),
        .hy2_rst                                   (hy2_rst),
        .hy1_stage_full                            (hy1_stage_full),
        .hy2_stage_full                            (hy2_stage_full),
        .hy1_push_flag                             (hy1_push_flag),
        .hy1_update_v_id                           (hy1_update_v_id),
        .hy1_update_v_value                        (hy1_update_v_value),
        .hy1_pull_first_flag                       (hy1_pull_first_flag),
        .hy1_update_v_valid                        (hy1_update_v_valid),
        .hy1_iteration_end                         (hy1_iteration_end),
        .hy1_iteration_end_valid                   (hy1_iteration_end_valid),
        .hy2_push_flag                             (hy2_push_flag),
        .hy2_update_v_id                           (hy2_update_v_id),
        .hy2_update_v_value                        (hy2_update_v_value),
        .hy2_pull_first_flag                       (hy2_pull_first_flag),
        .hy2_update_v_valid                        (hy2_update_v_valid),
        .hy2_iteration_end                         (hy2_iteration_end),
        .hy2_iteration_end_valid                   (hy2_iteration_end_valid)
    );

    initial begin : hyperx_network_Test
        test_Push_given_Rst_then_LocalBufferInit();
        test_PushInOut_given_DataValid_then_OutputValid();
        test_PullInOut_given_DataValid_then_OutputValid();
        repeat (10) @(posedge ap_clk);
        $finish;
    end
endmodule
