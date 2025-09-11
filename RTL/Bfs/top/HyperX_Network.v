`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/08 15:16:11
// Design Name: 
// Module Name: HyperX_Network
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "accelerator.vh"
// 网络一特判
module HyperX_Network #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    CORE_NUM = `CORE_NUM
) (
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    hy1_front_rst,
    input [CORE_NUM - 1 : 0]                    hy1_front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       hy1_front_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    hy1_front_update_v_value,
    input [CORE_NUM - 1 : 0]                    hy1_front_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    hy1_front_update_v_valid,
    input [CORE_NUM - 1 : 0]                    hy1_front_iteration_end,
    input [CORE_NUM - 1 : 0]                    hy1_front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    hy2_front_rst,
    input [CORE_NUM - 1 : 0]                    hy2_front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       hy2_front_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    hy2_front_update_v_value,
    input [CORE_NUM - 1 : 0]                    hy2_front_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    hy2_front_update_v_valid,
    input [CORE_NUM - 1 : 0]                    hy2_front_iteration_end,
    input [CORE_NUM - 1 : 0]                    hy2_front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    source_core_full,

    output [CORE_NUM - 1 : 0]                   hy1_rst,
    output [CORE_NUM - 1 : 0]                   hy2_rst,
    output [CORE_NUM - 1 : 0]                   hy1_stage_full,
    output [CORE_NUM - 1 : 0]                   hy2_stage_full,
    output [CORE_NUM - 1 : 0]                   hy1_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      hy1_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   hy1_update_v_value,
    output [CORE_NUM - 1 : 0]                   hy1_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   hy1_update_v_valid,
    output [CORE_NUM - 1 : 0]                   hy1_iteration_end,
    output [CORE_NUM - 1 : 0]                   hy1_iteration_end_valid,
    output [CORE_NUM - 1 : 0]                   hy2_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      hy2_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   hy2_update_v_value,
    output [CORE_NUM - 1 : 0]                   hy2_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   hy2_update_v_valid,
    output [CORE_NUM - 1 : 0]                   hy2_iteration_end,
    output [CORE_NUM - 1 : 0]                   hy2_iteration_end_valid
);
    hyperx_1_network_single HYPERX_MESH_NETWORK_1 (
        .clk                            (clk),
        .rst                            (hy1_front_rst),
        .hy_front_push_flag             (hy1_front_push_flag),
        .hy_front_update_v_id           (hy1_front_update_v_id),
        .hy_front_update_v_value        (hy1_front_update_v_value),
        .hy_front_pull_first_flag       (hy1_front_pull_first_flag),
        .hy_front_update_v_valid        (hy1_front_update_v_valid),
        .hy_front_iteration_end         (hy1_front_iteration_end),
        .hy_front_iteration_end_valid   (hy1_front_iteration_end_valid),
        .source_core_full               (source_core_full),

        .hy_rst                         (hy1_rst),
        .hy_stage_full                  (hy1_stage_full),
        .hy_push_flag                   (hy1_push_flag),
        .hy_update_v_id                 (hy1_update_v_id),
        .hy_update_v_value              (hy1_update_v_value),
        .hy_pull_first_flag             (hy1_pull_first_flag),
        .hy_update_v_valid              (hy1_update_v_valid),
        .hy_iteration_end               (hy1_iteration_end),
        .hy_iteration_end_valid         (hy1_iteration_end_valid)
    );

    hyperx_2_network_single HYPERX_MESH_NETWORK_2 (
        .clk                            (clk),
        .rst                            (hy2_front_rst),
        .hy_front_push_flag             (hy2_front_push_flag),
        .hy_front_update_v_id           (hy2_front_update_v_id),
        .hy_front_update_v_value        (hy2_front_update_v_value),
        .hy_front_pull_first_flag       (hy2_front_pull_first_flag),
        .hy_front_update_v_valid        (hy2_front_update_v_valid),
        .hy_front_iteration_end         (hy2_front_iteration_end),
        .hy_front_iteration_end_valid   (hy2_front_iteration_end_valid),
        .source_core_full               (0),
        
        .hy_rst                         (hy2_rst),
        .hy_stage_full                  (hy2_stage_full),
        .hy_push_flag                   (hy2_push_flag),
        .hy_update_v_id                 (hy2_update_v_id),
        .hy_update_v_value              (hy2_update_v_value),
        .hy_pull_first_flag             (hy2_pull_first_flag),
        .hy_update_v_valid              (hy2_update_v_valid),
        .hy_iteration_end               (hy2_iteration_end),
        .hy_iteration_end_valid         (hy2_iteration_end_valid)
    );

endmodule

module hyperx_1_network_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VERTICAL_NUM = `VERTICAL_NUM,
    VERTICAL_NUM_WIDTH = `VERTICAL_NUM_WIDTH,
    HORIZONTAL_NUM = `HORIZONTAL_NUM,
    HORIZONTAL_NUM_WIDTH = `HORIZONTAL_NUM_WIDTH,
    CORE_NUM = `CORE_NUM
)(
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    rst,
    input [CORE_NUM - 1 : 0]                    hy_front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       hy_front_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    hy_front_update_v_value,
    input [CORE_NUM - 1 : 0]                    hy_front_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    hy_front_update_v_valid,
    input [CORE_NUM - 1 : 0]                    hy_front_iteration_end,
    input [CORE_NUM - 1 : 0]                    hy_front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    source_core_full,

    output [CORE_NUM - 1 : 0]                   hy_rst,
    output [CORE_NUM - 1 : 0]                   hy_stage_full,
    output [CORE_NUM - 1 : 0]                   hy_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      hy_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   hy_update_v_value,
    output [CORE_NUM - 1 : 0]                   hy_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   hy_update_v_valid,
    output [CORE_NUM - 1 : 0]                   hy_iteration_end,
    output [CORE_NUM - 1 : 0]                   hy_iteration_end_valid
);
    wire [CORE_NUM - 1 : 0]  tmp_hy_horizontal_stage_full;
    wire [CORE_NUM - 1 : 0]  tmp_hy_horizontal_push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]  tmp_hy_horizontal_update_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  tmp_hy_horizontal_update_v_value;
    wire [CORE_NUM - 1 : 0]  tmp_hy_horizontal_pull_first_flag;
    wire [CORE_NUM - 1 : 0]  tmp_hy_horizontal_update_v_valid;
    
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  tmp_hy_horizontal_update_v_select;
    
    wire [CORE_NUM - 1 : 0]  tmp_hy_vertical_stage_full;
    wire [CORE_NUM - 1 : 0]  tmp_hy_vertical_push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]  tmp_hy_vertical_update_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  tmp_hy_vertical_update_v_value;
    wire [CORE_NUM - 1 : 0]  tmp_hy_vertical_pull_first_flag;
    wire [CORE_NUM - 1 : 0]  tmp_hy_vertical_update_v_valid;

    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  tmp_hy_vertical_update_v_select;

    wire [CORE_NUM - 1 : 0]  horizontal_push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]  horizontal_update_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  horizontal_update_v_value;
    wire [CORE_NUM - 1 : 0]  horizontal_pull_first_flag;
    wire [CORE_NUM - 1 : 0]  horizontal_update_v_valid;
    wire [CORE_NUM * HORIZONTAL_NUM - 1 : 0]  horizontal_select;
    wire [HORIZONTAL_NUM_WIDTH - 1 : 0]  select_horizontal_id [0 : CORE_NUM - 1];
    wire select_horizontal_valid [0 : CORE_NUM - 1];
    
    wire [CORE_NUM - 1 : 0]  vertical_push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]  vertical_update_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  vertical_update_v_value;
    wire [CORE_NUM - 1 : 0]  vertical_pull_first_flag;
    wire [CORE_NUM - 1 : 0]  vertical_update_v_valid;
    wire [CORE_NUM * VERTICAL_NUM - 1 : 0]  vertical_select;
    wire [VERTICAL_NUM_WIDTH - 1 : 0]  select_vertical_id [0 : CORE_NUM - 1];
    wire select_vertical_valid [0 : CORE_NUM - 1];

    assign hy_rst = rst;
    
    generate
        genvar i;
        for( i = 0 ; i<CORE_NUM ; i = i+1) begin
            assign tmp_hy_horizontal_update_v_select[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH] = tmp_hy_horizontal_push_flag[i]? tmp_hy_horizontal_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH] : tmp_hy_horizontal_update_v_value[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH];
            assign tmp_hy_vertical_update_v_select[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH] = tmp_hy_vertical_push_flag[i]? tmp_hy_vertical_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH] : tmp_hy_vertical_update_v_value[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH];
        end
    endgenerate


    generate
        genvar j;
        for( i = 0 ; i<VERTICAL_NUM ; i = i+1) begin
            for( j = 0 ; j<HORIZONTAL_NUM ; j = j+1) begin
                select_horizontal#(.V_ID_WIDTH(V_VALUE_WIDTH),.X_ID(j)) SELECT_HORIZONTAL(
                    .h_id               (tmp_hy_horizontal_update_v_select[(i+1)*HORIZONTAL_NUM*V_VALUE_WIDTH - 1 : i*HORIZONTAL_NUM*V_VALUE_WIDTH]),
                    .h_valid            (tmp_hy_horizontal_update_v_valid[(i+1)*HORIZONTAL_NUM - 1 : i*HORIZONTAL_NUM]),
                    .h_full             (tmp_hy_horizontal_stage_full[i*HORIZONTAL_NUM + j]),

                    .s_id               (select_horizontal_id[(i*HORIZONTAL_NUM + j)]),
                    .s_valid            (select_horizontal_valid[i*HORIZONTAL_NUM+j])
                );
                assign horizontal_push_flag[i*HORIZONTAL_NUM + j] = select_horizontal_valid[i*HORIZONTAL_NUM+j] ? tmp_hy_horizontal_push_flag[i*HORIZONTAL_NUM+select_horizontal_id[i*HORIZONTAL_NUM + j] -: 1] : 0;
                assign horizontal_update_v_id[(i*HORIZONTAL_NUM+j+1)*V_ID_WIDTH - 1 : (i*HORIZONTAL_NUM+j)*V_ID_WIDTH] = select_horizontal_valid[i*HORIZONTAL_NUM+j] ? tmp_hy_horizontal_update_v_id[(i*HORIZONTAL_NUM+select_horizontal_id[i*HORIZONTAL_NUM + j]+1)*V_ID_WIDTH-1 -: V_ID_WIDTH] : 0;
                assign horizontal_update_v_value[(i*HORIZONTAL_NUM+j+1)*V_VALUE_WIDTH - 1 : (i*HORIZONTAL_NUM+j)*V_VALUE_WIDTH] = select_horizontal_valid[i*HORIZONTAL_NUM+j] ? tmp_hy_horizontal_update_v_value[(i*HORIZONTAL_NUM+select_horizontal_id[i*HORIZONTAL_NUM + j]+1)*V_VALUE_WIDTH-1 -: V_VALUE_WIDTH] : 0;
                assign horizontal_pull_first_flag[i*HORIZONTAL_NUM + j] = select_horizontal_valid[i*HORIZONTAL_NUM+j] ? tmp_hy_horizontal_pull_first_flag[i*HORIZONTAL_NUM+select_horizontal_id[i*HORIZONTAL_NUM + j] -: 1] : 0;
                assign horizontal_update_v_valid[i*HORIZONTAL_NUM + j] = select_horizontal_valid[i*HORIZONTAL_NUM+j] ? 1 : 0;
            end
        end
        for( i = 0 ; i<CORE_NUM ; i = i+1) begin
            for( j = 0 ; j<HORIZONTAL_NUM ; j = j+1) begin
                assign horizontal_select[ i * HORIZONTAL_NUM + j ] = select_horizontal_valid[i / HORIZONTAL_NUM * HORIZONTAL_NUM + j] ? select_horizontal_id[i / HORIZONTAL_NUM * HORIZONTAL_NUM + j] == (i % HORIZONTAL_NUM) : 0;
            end
        end
    endgenerate
    
    generate
        for( i = 0 ; i<HORIZONTAL_NUM ; i = i+1) begin
            for( j = 0 ; j<VERTICAL_NUM ; j = j+1) begin
                select_vertical#(.V_ID_WIDTH(V_VALUE_WIDTH),.Y_ID(j)) SELECT_VERTICAL(
                    .v_id               (tmp_hy_vertical_update_v_select[(i+1)*VERTICAL_NUM*V_VALUE_WIDTH - 1 : i*VERTICAL_NUM*V_VALUE_WIDTH]),
                    .v_valid            (tmp_hy_vertical_update_v_valid[(i+1)*VERTICAL_NUM - 1 : i*VERTICAL_NUM]),
                    .v_full             (tmp_hy_vertical_stage_full[i*VERTICAL_NUM + j]),

                    .s_id               (select_vertical_id[(i*VERTICAL_NUM + j)]),
                    .s_valid            (select_vertical_valid[i*VERTICAL_NUM+j])
                );
                assign vertical_push_flag[i*VERTICAL_NUM + j] = select_vertical_valid[i*VERTICAL_NUM+j] ? tmp_hy_vertical_push_flag[i*VERTICAL_NUM+select_vertical_id[i*VERTICAL_NUM + j] -: 1] : 0;
                assign vertical_update_v_id[(i*VERTICAL_NUM+j+1)*V_ID_WIDTH - 1 : (i*VERTICAL_NUM+j)*V_ID_WIDTH] = select_vertical_valid[i*VERTICAL_NUM+j] ? tmp_hy_vertical_update_v_id[(i*VERTICAL_NUM+select_vertical_id[i*VERTICAL_NUM + j]+1)*V_ID_WIDTH-1 -: V_ID_WIDTH] : 0;
                assign vertical_update_v_value[(i*VERTICAL_NUM+j+1)*V_VALUE_WIDTH - 1 : (i*VERTICAL_NUM+j)*V_VALUE_WIDTH] = select_vertical_valid[i*VERTICAL_NUM+j] ? tmp_hy_vertical_update_v_value[(i*VERTICAL_NUM+select_vertical_id[i*VERTICAL_NUM + j]+1)*V_VALUE_WIDTH-1 -: V_VALUE_WIDTH] : 0;
                assign vertical_pull_first_flag[i*VERTICAL_NUM + j] = select_vertical_valid[i*VERTICAL_NUM+j] ? tmp_hy_vertical_pull_first_flag[i*VERTICAL_NUM+select_vertical_id[i*VERTICAL_NUM + j] -: 1] : 0;
                assign vertical_update_v_valid[i*VERTICAL_NUM + j] = select_vertical_valid[i*VERTICAL_NUM+j] ? 1 : 0;
            end
        end
        for( i = 0 ; i<CORE_NUM ; i = i+1) begin
            for( j = 0 ; j<VERTICAL_NUM ; j = j+1) begin
                assign vertical_select[i*VERTICAL_NUM+j] = select_vertical_valid[i / VERTICAL_NUM * VERTICAL_NUM + j] ? select_vertical_id[i / VERTICAL_NUM * VERTICAL_NUM + j] == (i % VERTICAL_NUM) : 0;
            end
        end
    endgenerate
    
    generate
        for( i = 0 ; i<CORE_NUM ; i = i+1) begin
            hyperx_1_network_node#(.X_ID(i%HORIZONTAL_NUM), .Y_ID(i/HORIZONTAL_NUM), .CORE_ID(i)) HYPERX_NETWORK_NODE_SINGLE(
                .clk                                    (clk),
                .rst                                    (rst[i]),
                .in_push_flag                           (hy_front_push_flag[i]),
                .in_update_v_id                         (hy_front_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH]),
                .in_update_v_value                      (hy_front_update_v_value[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH]),
                .in_pull_first_flag                     (hy_front_pull_first_flag[i]),
                .in_update_v_valid                      (hy_front_update_v_valid[i]),
                .in_iteration_end                       (hy_front_iteration_end[i]),
                .in_iteration_end_valid                 (hy_front_iteration_end_valid[i]),
                .next_stage_full                        (source_core_full[i]),

                .horizontal_push_flag                           (horizontal_push_flag[i]),
                .horizontal_update_v_id                         (horizontal_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH]),
                .horizontal_update_v_value                      (horizontal_update_v_value[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH]),
                .horizontal_pull_first_flag                     (horizontal_pull_first_flag[i]),
                .horizontal_update_v_valid                      (horizontal_update_v_valid[i]),
                .horizontal_select                              (horizontal_select[(i+1)*HORIZONTAL_NUM - 1 : i*HORIZONTAL_NUM]),
                
                .vertical_push_flag                             (vertical_push_flag[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_update_v_id                           (vertical_update_v_id[(((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)+1)*V_ID_WIDTH - 1 : ((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)*V_ID_WIDTH]),
                .vertical_update_v_value                        (vertical_update_v_value[(((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)+1)*V_VALUE_WIDTH - 1 : ((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)*V_VALUE_WIDTH]),
                .vertical_pull_first_flag                       (vertical_pull_first_flag[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_update_v_valid                        (vertical_update_v_valid[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_select                                (vertical_select[(((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)+1)*VERTICAL_NUM - 1 : ((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)*VERTICAL_NUM]),

                .push_flag                              (hy_push_flag[i]),
                .update_v_id                            (hy_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH]),
                .update_v_value                         (hy_update_v_value[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH]),
                .update_v_valid                         (hy_update_v_valid[i]),
                .pull_first_flag                        (hy_pull_first_flag[i]),
                .iteration_end                          (hy_iteration_end[i]),
                .iteration_end_valid                    (hy_iteration_end_valid[i]),
                .stage_full                             (hy_stage_full[i]),
                
                .horizontal_out_push_flag                           (tmp_hy_horizontal_push_flag[i]),
                .horizontal_out_update_v_id                         (tmp_hy_horizontal_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH]),
                .horizontal_out_update_v_value                      (tmp_hy_horizontal_update_v_value[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH]),
                .horizontal_out_pull_first_flag                     (tmp_hy_horizontal_pull_first_flag[i]),
                .horizontal_out_update_v_valid                      (tmp_hy_horizontal_update_v_valid[i]),
                .horizontal_out_stage_full                          (tmp_hy_horizontal_stage_full[i]),
                
                .vertical_out_push_flag                             (tmp_hy_vertical_push_flag[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_out_update_v_id                           (tmp_hy_vertical_update_v_id[(((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)+1)*V_ID_WIDTH - 1 : ((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)*V_ID_WIDTH]),
                .vertical_out_update_v_value                        (tmp_hy_vertical_update_v_value[(((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)+1)*V_VALUE_WIDTH - 1 : ((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)*V_VALUE_WIDTH]),
                .vertical_out_pull_first_flag                       (tmp_hy_vertical_pull_first_flag[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_out_update_v_valid                        (tmp_hy_vertical_update_v_valid[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_out_stage_full                            (tmp_hy_vertical_stage_full[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)])
            );
        end
    endgenerate
    
endmodule


module hyperx_2_network_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VERTICAL_NUM = `VERTICAL_NUM,
    VERTICAL_NUM_WIDTH = `VERTICAL_NUM_WIDTH,
    HORIZONTAL_NUM = `HORIZONTAL_NUM,
    HORIZONTAL_NUM_WIDTH = `HORIZONTAL_NUM_WIDTH,
    CORE_NUM = `CORE_NUM
)(
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    rst,
    input [CORE_NUM - 1 : 0]                    hy_front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       hy_front_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    hy_front_update_v_value,
    input [CORE_NUM - 1 : 0]                    hy_front_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    hy_front_update_v_valid,
    input [CORE_NUM - 1 : 0]                    hy_front_iteration_end,
    input [CORE_NUM - 1 : 0]                    hy_front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    source_core_full,

    output [CORE_NUM - 1 : 0]                   hy_rst,
    output [CORE_NUM - 1 : 0]                   hy_stage_full,
    output [CORE_NUM - 1 : 0]                   hy_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      hy_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   hy_update_v_value,
    output [CORE_NUM - 1 : 0]                   hy_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   hy_update_v_valid,
    output [CORE_NUM - 1 : 0]                   hy_iteration_end,
    output [CORE_NUM - 1 : 0]                   hy_iteration_end_valid
);
    wire [CORE_NUM - 1 : 0]  tmp_hy_horizontal_stage_full;
    wire [CORE_NUM - 1 : 0]  tmp_hy_horizontal_push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]  tmp_hy_horizontal_update_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  tmp_hy_horizontal_update_v_value;
    wire [CORE_NUM - 1 : 0]  tmp_hy_horizontal_pull_first_flag;
    wire [CORE_NUM - 1 : 0]  tmp_hy_horizontal_update_v_valid;

    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  tmp_hy_horizontal_update_v_select;


    wire [CORE_NUM - 1 : 0]  tmp_hy_vertical_stage_full;
    wire [CORE_NUM - 1 : 0]  tmp_hy_vertical_push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]  tmp_hy_vertical_update_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  tmp_hy_vertical_update_v_value;
    wire [CORE_NUM - 1 : 0]  tmp_hy_vertical_pull_first_flag;
    wire [CORE_NUM - 1 : 0]  tmp_hy_vertical_update_v_valid;

    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  tmp_hy_vertical_update_v_select;

    wire [CORE_NUM - 1 : 0]  horizontal_push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]  horizontal_update_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  horizontal_update_v_value;
    wire [CORE_NUM - 1 : 0]  horizontal_pull_first_flag;
    wire [CORE_NUM - 1 : 0]  horizontal_update_v_valid;
    wire [CORE_NUM * HORIZONTAL_NUM - 1 : 0]  horizontal_select;
    wire [HORIZONTAL_NUM_WIDTH - 1 : 0]  select_horizontal_id [0 : CORE_NUM - 1];
    wire select_horizontal_valid [0 : CORE_NUM - 1];
    
    wire [CORE_NUM - 1 : 0]  vertical_push_flag;
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0]  vertical_update_v_id;
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]  vertical_update_v_value;
    wire [CORE_NUM - 1 : 0]  vertical_pull_first_flag;
    wire [CORE_NUM - 1 : 0]  vertical_update_v_valid;
    wire [CORE_NUM * VERTICAL_NUM - 1 : 0]  vertical_select;
    wire [VERTICAL_NUM_WIDTH - 1 : 0]  select_vertical_id [0 : CORE_NUM - 1];
    wire select_vertical_valid [0 : CORE_NUM - 1];
    assign hy_rst = rst;
    
    generate
        genvar i;
        for( i = 0 ; i<CORE_NUM ; i = i+1) begin
            assign tmp_hy_horizontal_update_v_select[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH] =  tmp_hy_horizontal_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH] ;
            assign tmp_hy_vertical_update_v_select[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH] =  tmp_hy_vertical_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH] ;
        end
    endgenerate

    generate
        genvar j;
        for( i = 0 ; i<VERTICAL_NUM ; i = i+1) begin
            for( j = 0 ; j<HORIZONTAL_NUM ; j = j+1) begin
                select_horizontal#(.X_ID(j),.V_ID_WIDTH(V_VALUE_WIDTH)) SELECT_HORIZONTAL(
                    .h_id               (tmp_hy_horizontal_update_v_select[(i+1)*HORIZONTAL_NUM*V_VALUE_WIDTH - 1 : i*HORIZONTAL_NUM*V_VALUE_WIDTH]),
                    .h_valid            (tmp_hy_horizontal_update_v_valid[(i+1)*HORIZONTAL_NUM - 1 : i*HORIZONTAL_NUM]),
                    .h_full             (tmp_hy_horizontal_stage_full[i*HORIZONTAL_NUM + j]),

                    .s_id               (select_horizontal_id[(i*HORIZONTAL_NUM + j)]),
                    .s_valid            (select_horizontal_valid[i*HORIZONTAL_NUM+j])
                );
                assign horizontal_push_flag[i*HORIZONTAL_NUM + j] = select_horizontal_valid[i*HORIZONTAL_NUM+j] ? tmp_hy_horizontal_push_flag[i*HORIZONTAL_NUM+select_horizontal_id[i*HORIZONTAL_NUM + j] -: 1] : 0;
                assign horizontal_update_v_id[(i*HORIZONTAL_NUM+j+1)*V_ID_WIDTH - 1 : (i*HORIZONTAL_NUM+j)*V_ID_WIDTH] = select_horizontal_valid[i*HORIZONTAL_NUM+j] ? tmp_hy_horizontal_update_v_id[(i*HORIZONTAL_NUM+select_horizontal_id[i*HORIZONTAL_NUM + j]+1)*V_ID_WIDTH-1 -: V_ID_WIDTH] : 0;
                assign horizontal_update_v_value[(i*HORIZONTAL_NUM+j+1)*V_VALUE_WIDTH - 1 : (i*HORIZONTAL_NUM+j)*V_VALUE_WIDTH] = select_horizontal_valid[i*HORIZONTAL_NUM+j] ? tmp_hy_horizontal_update_v_value[(i*HORIZONTAL_NUM+select_horizontal_id[i*HORIZONTAL_NUM + j]+1)*V_VALUE_WIDTH-1 -: V_VALUE_WIDTH] : 0;
                assign horizontal_pull_first_flag[i*HORIZONTAL_NUM + j] = select_horizontal_valid[i*HORIZONTAL_NUM+j] ? tmp_hy_horizontal_pull_first_flag[i*HORIZONTAL_NUM+select_horizontal_id[i*HORIZONTAL_NUM + j] -: 1] : 0;
                assign horizontal_update_v_valid[i*HORIZONTAL_NUM + j] = select_horizontal_valid[i*HORIZONTAL_NUM+j] ? 1 : 0;
            end
        end
        for( i = 0 ; i<CORE_NUM ; i = i+1) begin
            for( j = 0 ; j<HORIZONTAL_NUM ; j = j+1) begin
                assign horizontal_select[i*HORIZONTAL_NUM+j] = select_horizontal_valid[ i / HORIZONTAL_NUM * HORIZONTAL_NUM + j] ? select_horizontal_id[ i / HORIZONTAL_NUM * HORIZONTAL_NUM + j ] == (i % HORIZONTAL_NUM) : 0;
            end
        end
    endgenerate
    
    generate
        for( i = 0 ; i<HORIZONTAL_NUM ; i = i+1) begin
            for( j = 0 ; j<VERTICAL_NUM ; j = j+1) begin
                select_vertical#(.Y_ID(j),.V_ID_WIDTH(V_VALUE_WIDTH)) SELECT_VERTICAL(
                    .v_id               (tmp_hy_vertical_update_v_select[(i+1)*VERTICAL_NUM*V_VALUE_WIDTH - 1 : i*VERTICAL_NUM*V_VALUE_WIDTH]),
                    .v_valid            (tmp_hy_vertical_update_v_valid[(i+1)*VERTICAL_NUM - 1 : i*VERTICAL_NUM]),
                    .v_full             (tmp_hy_vertical_stage_full[i*VERTICAL_NUM + j]),

                    .s_id               (select_vertical_id[(i*VERTICAL_NUM + j)]),
                    .s_valid            (select_vertical_valid[i*VERTICAL_NUM+j])
                );
                assign vertical_push_flag[i*VERTICAL_NUM + j] = select_vertical_valid[i*VERTICAL_NUM+j] ? tmp_hy_vertical_push_flag[i*VERTICAL_NUM+select_vertical_id[i*VERTICAL_NUM + j] -: 1] : 0;
                assign vertical_update_v_id[(i*VERTICAL_NUM+j+1)*V_ID_WIDTH - 1 : (i*VERTICAL_NUM+j)*V_ID_WIDTH] = select_vertical_valid[i*VERTICAL_NUM+j] ? tmp_hy_vertical_update_v_id[(i*VERTICAL_NUM+select_vertical_id[i*VERTICAL_NUM + j]+1)*V_ID_WIDTH-1 -: V_ID_WIDTH] : 0;
                assign vertical_update_v_value[(i*VERTICAL_NUM+j+1)*V_VALUE_WIDTH - 1 : (i*VERTICAL_NUM+j)*V_VALUE_WIDTH] = select_vertical_valid[i*VERTICAL_NUM+j] ? tmp_hy_vertical_update_v_value[(i*VERTICAL_NUM+select_vertical_id[i*VERTICAL_NUM + j]+1)*V_VALUE_WIDTH-1 -: V_VALUE_WIDTH] : 0;
                assign vertical_pull_first_flag[i*VERTICAL_NUM + j] = select_vertical_valid[i*VERTICAL_NUM+j] ? tmp_hy_vertical_pull_first_flag[i*VERTICAL_NUM+select_vertical_id[i*VERTICAL_NUM + j] -: 1] : 0;
                assign vertical_update_v_valid[i*VERTICAL_NUM + j] = select_vertical_valid[i*VERTICAL_NUM+j] ? 1 : 0;
            end
        end
        for( i = 0 ; i<CORE_NUM ; i = i+1) begin
            for( j = 0 ; j<VERTICAL_NUM ; j = j+1) begin
                assign vertical_select[ i * VERTICAL_NUM + j ] = select_vertical_valid[ i / VERTICAL_NUM * VERTICAL_NUM + j ] ? select_vertical_id[i / VERTICAL_NUM * VERTICAL_NUM + j] == (i%VERTICAL_NUM) : 0;
            end
        end
    endgenerate
    
    generate
        for( i = 0 ; i<CORE_NUM ; i = i+1) begin
            hyperx_1_network_node#(.X_ID(i%HORIZONTAL_NUM), .Y_ID(i/HORIZONTAL_NUM), .CORE_ID(i)) HYPERX_NETWORK_NODE_SINGLE(
                .clk                                    (clk),
                .rst                                    (rst[i]),
                .in_push_flag                           (hy_front_push_flag[i]),
                .in_update_v_id                         (hy_front_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH]),
                .in_update_v_value                      (hy_front_update_v_value[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH]),
                .in_pull_first_flag                     (hy_front_pull_first_flag[i]),
                .in_update_v_valid                      (hy_front_update_v_valid[i]),
                .in_iteration_end                       (hy_front_iteration_end[i]),
                .in_iteration_end_valid                 (hy_front_iteration_end_valid[i]),
                .next_stage_full                        (source_core_full[i]),

                .horizontal_push_flag                           (horizontal_push_flag[i]),
                .horizontal_update_v_id                         (horizontal_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH]),
                .horizontal_update_v_value                      (horizontal_update_v_value[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH]),
                .horizontal_pull_first_flag                     (horizontal_pull_first_flag[i]),
                .horizontal_update_v_valid                      (horizontal_update_v_valid[i]),
                .horizontal_select                              (horizontal_select[(i+1)*HORIZONTAL_NUM - 1 : i*HORIZONTAL_NUM]),
                
                .vertical_push_flag                             (vertical_push_flag[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_update_v_id                           (vertical_update_v_id[(((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)+1)*V_ID_WIDTH - 1 : ((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)*V_ID_WIDTH]),
                .vertical_update_v_value                        (vertical_update_v_value[(((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)+1)*V_VALUE_WIDTH - 1 : ((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)*V_VALUE_WIDTH]),
                .vertical_pull_first_flag                       (vertical_pull_first_flag[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_update_v_valid                        (vertical_update_v_valid[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_select                                (vertical_select[(((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)+1)*VERTICAL_NUM - 1 : ((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)*VERTICAL_NUM]),

                .push_flag                              (hy_push_flag[i]),
                .update_v_id                            (hy_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH]),
                .update_v_value                         (hy_update_v_value[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH]),
                .update_v_valid                         (hy_update_v_valid[i]),
                .pull_first_flag                        (hy_pull_first_flag[i]),
                .iteration_end                          (hy_iteration_end[i]),
                .iteration_end_valid                    (hy_iteration_end_valid[i]),
                .stage_full                             (hy_stage_full[i]),
                
                .horizontal_out_push_flag                           (tmp_hy_horizontal_push_flag[i]),
                .horizontal_out_update_v_id                         (tmp_hy_horizontal_update_v_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH]),
                .horizontal_out_update_v_value                      (tmp_hy_horizontal_update_v_value[(i+1)*V_VALUE_WIDTH - 1 : i*V_VALUE_WIDTH]),
                .horizontal_out_pull_first_flag                     (tmp_hy_horizontal_pull_first_flag[i]),
                .horizontal_out_update_v_valid                      (tmp_hy_horizontal_update_v_valid[i]),
                .horizontal_out_stage_full                          (tmp_hy_horizontal_stage_full[i]),
                
                .vertical_out_push_flag                             (tmp_hy_vertical_push_flag[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_out_update_v_id                           (tmp_hy_vertical_update_v_id[(((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)+1)*V_ID_WIDTH - 1 : ((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)*V_ID_WIDTH]),
                .vertical_out_update_v_value                        (tmp_hy_vertical_update_v_value[(((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)+1)*V_VALUE_WIDTH - 1 : ((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)*V_VALUE_WIDTH]),
                .vertical_out_pull_first_flag                       (tmp_hy_vertical_pull_first_flag[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_out_update_v_valid                        (tmp_hy_vertical_update_v_valid[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)]),
                .vertical_out_stage_full                            (tmp_hy_vertical_stage_full[((i%HORIZONTAL_NUM)*VERTICAL_NUM+i/HORIZONTAL_NUM)])
            );
        end
    endgenerate
    
endmodule

module select_vertical #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    VERTICAL_NUM = `VERTICAL_NUM,
    VERTICAL_NUM_WIDTH = `VERTICAL_NUM_WIDTH,
    HORIZONTAL_NUM_WIDTH = `HORIZONTAL_NUM_WIDTH,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH,
    Y_ID = 0
)(
    input [VERTICAL_NUM*V_ID_WIDTH - 1 : 0]                  v_id,
    input [VERTICAL_NUM-1 : 0]                               v_valid,
    input                                                      v_full,
    
    output [VERTICAL_NUM_WIDTH - 1 : 0]                  s_id,
    output                                       s_valid
);
    // wire [VERTICAL_NUM_WIDTH - 1 : 0] s_id_level0 [0 : 4 - 1];
    wire [VERTICAL_NUM_WIDTH - 1 : 0] s_id_level1 [0 : 2 - 1];
    // wire s_valid_level0 [0 : 4 - 1];
    wire s_valid_level1 [0 : 2 - 1];
    
    generate
        genvar i;
        for (i = 0; i < 2; i = i + 1) begin
            assign s_valid_level1[i] = (v_full || !v_valid[i] ||  v_id[i*V_ID_WIDTH + CORE_NUM_WIDTH - 1 : i*V_ID_WIDTH + HORIZONTAL_NUM_WIDTH] != Y_ID)? 0 : 1;
            assign s_id_level1[i] = (v_full || !v_valid[i] ||  v_id[i*V_ID_WIDTH + CORE_NUM_WIDTH - 1 : i*V_ID_WIDTH + HORIZONTAL_NUM_WIDTH] != Y_ID)? 0 : i;
        end
        // for (i = 0; i < 2; i = i + 1) begin
        //     assign s_valid_level1[i] = s_valid_level0[2*i] || s_valid_level0[2*i+1];
        //     assign s_id_level1[i] = s_valid_level0[2*i] ? s_id_level0[2*i] : s_id_level0[2*i+1];
        // end
    endgenerate
    assign s_valid = s_valid_level1[0] || s_valid_level1[1];
    assign s_id = s_valid_level1[0] ? s_id_level1[0] : s_id_level1[1];
    
endmodule

module select_horizontal #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    HORIZONTAL_NUM = `HORIZONTAL_NUM,
    HORIZONTAL_NUM_WIDTH = `HORIZONTAL_NUM_WIDTH,
    X_ID = 0
)(
    input [HORIZONTAL_NUM*V_ID_WIDTH - 1 : 0]                  h_id,
    input [HORIZONTAL_NUM-1 : 0]                               h_valid,
    input                                                      h_full,
    
    output [HORIZONTAL_NUM_WIDTH - 1 : 0]                  s_id,
    output                                       s_valid
);
    // wire [V_ID_WIDTH - 1 : 0] s_id_level0 [0 : 8 - 1];
    wire [V_ID_WIDTH - 1 : 0] s_id_level1 [0 : 16 - 1];
    wire [V_ID_WIDTH - 1 : 0] s_id_level2 [0 : 8 - 1];
    wire [V_ID_WIDTH - 1 : 0] s_id_level3 [0 : 4 - 1];
    wire [V_ID_WIDTH - 1 : 0] s_id_level4 [0 : 2 - 1];
    // wire s_valid_level0 [0 : 8 - 1];
    wire s_valid_level1 [0 : 16 - 1];
    wire s_valid_level2 [0 : 8 - 1];
    wire s_valid_level3 [0 : 4 - 1];
    wire s_valid_level4 [0 : 2 - 1];
    
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin
            assign s_valid_level1[i] = (h_full || !h_valid[i] ||  h_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH]%HORIZONTAL_NUM != X_ID)? 0 : 1;
            assign s_id_level1[i] = (h_full || !h_valid[i] ||  h_id[(i+1)*V_ID_WIDTH - 1 : i*V_ID_WIDTH]%HORIZONTAL_NUM != X_ID)? 0 : i;
        end
        for (i = 0; i < 8; i = i + 1) begin
            assign s_valid_level2[i] = s_valid_level1[2*i] || s_valid_level1[2*i+1];
            assign s_id_level2[i] = s_valid_level1[2*i] ? s_id_level1[2*i] : s_id_level1[2*i+1];
        end
        // for (i = 0; i < 8; i = i + 1) begin
        //     assign s_valid_level2[i] = s_valid_level1[2*i] || s_valid_level1[2*i+1];
        //     assign s_id_level2[i] = s_valid_level1[2*i] ? s_id_level1[2*i] : s_id_level1[2*i+1];
        // end
        for (i = 0; i < 4; i = i + 1) begin
            assign s_valid_level3[i] = s_valid_level2[2*i] || s_valid_level2[2*i+1];
            assign s_id_level3[i] = s_valid_level2[2*i] ? s_id_level2[2*i] : s_id_level2[2*i+1];
        end
        for (i = 0; i < 2; i = i + 1) begin
            assign s_valid_level4[i] = s_valid_level3[2*i] || s_valid_level3[2*i+1];
            assign s_id_level4[i] = s_valid_level3[2*i] ? s_id_level3[2*i] : s_id_level3[2*i+1];
        end
    endgenerate
    assign s_valid = s_valid_level4[0] || s_valid_level4[1];
    assign s_id = s_valid_level4[0] ? s_id_level4[0] : s_id_level4[1];
    
endmodule

module hyperx_1_network_node #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VERTICAL_NUM = `VERTICAL_NUM,
    HORIZONTAL_NUM = `HORIZONTAL_NUM,
    HORIZONTAL_NUM_WIDTH = `HORIZONTAL_NUM_WIDTH,
    X_ID = 0,
    Y_ID = 0,
    CORE_ID = 0,
    CORE_NUM = `CORE_NUM,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH
)(
    input                                       clk,
    input                                       rst,
    input                                       in_push_flag,
    input [V_ID_WIDTH - 1 : 0]                  in_update_v_id,
    input [V_VALUE_WIDTH - 1 : 0]               in_update_v_value,
    input                                       in_pull_first_flag,
    input                                       in_update_v_valid,
    input                                       in_iteration_end,
    input                                       in_iteration_end_valid,
    input                                       next_stage_full,
    
    input                                       horizontal_push_flag,
    input [V_ID_WIDTH - 1 : 0]                  horizontal_update_v_id,
    input [V_VALUE_WIDTH - 1 : 0]               horizontal_update_v_value,
    input                                       horizontal_pull_first_flag,
    input                                       horizontal_update_v_valid,
    input [HORIZONTAL_NUM -  1 : 0]               horizontal_select,
    
    input                                       vertical_push_flag,
    input [V_ID_WIDTH - 1 : 0]                  vertical_update_v_id,
    input [V_VALUE_WIDTH - 1 : 0]               vertical_update_v_value,
    input                                       vertical_pull_first_flag,
    input                                       vertical_update_v_valid,
    input [VERTICAL_NUM -  1 : 0]               vertical_select,
    
    output reg                                  push_flag,
    output reg [V_ID_WIDTH - 1 : 0]             update_v_id,
    output reg [V_VALUE_WIDTH - 1 : 0]          update_v_value,
    output reg                                  update_v_valid,
    output reg                                  pull_first_flag,
    output reg                                  iteration_end,
    output reg                                  iteration_end_valid,
    output                                      stage_full,
    
    output                                      horizontal_out_push_flag,
    output  [V_ID_WIDTH - 1 : 0]                horizontal_out_update_v_id,
    output  [V_VALUE_WIDTH - 1 : 0]             horizontal_out_update_v_value,
    output                                      horizontal_out_update_v_valid,
    output                                      horizontal_out_pull_first_flag,
    output                                      horizontal_out_stage_full,
    
    output                                      vertical_out_push_flag,
    output  [V_ID_WIDTH - 1 : 0]                vertical_out_update_v_id,
    output  [V_VALUE_WIDTH - 1 : 0]             vertical_out_update_v_value,
    output                                      vertical_out_update_v_valid,
    output                                      vertical_out_pull_first_flag,
    output                                      vertical_out_stage_full
);

wire buffer_full_in, buffer_empty_in, buffer_full_horizontal, buffer_empty_horizontal, buffer_full_vertical, buffer_empty_vertical;
wire read_in, read_horizontal, read_vertical;
wire push_flag_in_top, pull_first_flag_in_top, push_flag_horizontal_top, pull_first_flag_horizontal_top, push_flag_vertical_top, pull_first_flag_vertical_top;
wire [V_ID_WIDTH - 1 : 0] update_v_id_in_top, update_v_id_horizontal_top, update_v_id_vertical_top;
wire [V_VALUE_WIDTH - 1 : 0] update_v_value_in_top, update_v_value_horizontal_top, update_v_value_vertical_top;
wire vertical_out;
wire in_horizontal;
wire horizontal_vertical;

assign vertical_out = !buffer_empty_vertical && !next_stage_full; //&& update_v_id_vertical_top[CORE_NUM_WIDTH - 1 : 0] == CORE_ID;
assign in_horizontal = !buffer_empty_in; //&& !(update_v_id_in_top[HORIZONTAL_NUM_WIDTH - 1 : 0] == X_ID);
assign horizontal_vertical = !buffer_empty_horizontal; //&& !(update_v_id_horizontal_top[CORE_NUM_WIDTH - 1 : 0]/HORIZONTAL_NUM == Y_ID);

assign read_in = in_horizontal && horizontal_select != 0;
assign read_horizontal = horizontal_vertical && vertical_select != 0;
assign read_vertical = vertical_out;

assign horizontal_out_push_flag = in_horizontal ? push_flag_in_top : 0;
assign horizontal_out_update_v_id = in_horizontal ? update_v_id_in_top : 0;
assign horizontal_out_update_v_value = in_horizontal ? update_v_value_in_top : 0;
assign horizontal_out_update_v_valid = in_horizontal ? 1 : 0;
assign horizontal_out_pull_first_flag = in_horizontal ? pull_first_flag_in_top : 0;

assign vertical_out_push_flag = horizontal_vertical ? push_flag_horizontal_top : 0;
assign vertical_out_update_v_id = horizontal_vertical ? update_v_id_horizontal_top : 0;
assign vertical_out_update_v_value = horizontal_vertical ? update_v_value_horizontal_top : 0;
assign vertical_out_update_v_valid = horizontal_vertical ? 1 : 0;
assign vertical_out_pull_first_flag = horizontal_vertical ? pull_first_flag_horizontal_top : 0;

assign stage_full = buffer_full_in;
assign horizontal_out_stage_full = buffer_full_horizontal;
assign vertical_out_stage_full = buffer_full_vertical;

always @ (posedge clk) begin
    if (buffer_empty_in && buffer_empty_horizontal && buffer_empty_vertical && in_iteration_end && in_iteration_end_valid) begin
        iteration_end <= 1;
        iteration_end_valid <= 1;
    end
    else begin
        iteration_end <= 0;
        iteration_end_valid <= 0;
    end
end

always @ (posedge clk) begin
    if(rst) begin
        push_flag <= 0;
        update_v_id <= 0;
        update_v_value <= 0;
        pull_first_flag <= 0;
        update_v_valid <= 0;
    end
    else if (vertical_out) begin
        push_flag <= push_flag_vertical_top;
        update_v_id <= update_v_id_vertical_top;
        update_v_value <= update_v_value_vertical_top;
        pull_first_flag <= pull_first_flag_vertical_top;
        update_v_valid <= 1;
    end
    else begin
        push_flag <= 0;
        update_v_id <= 0;
        update_v_value <= 0;
        pull_first_flag <= 0;
        update_v_valid <= 0;
    end
end




//input buffer
custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PUSH_FLAG_FIFO_FT_INPUT (
        .clk        (clk),
        .srst       (rst),
        .din        (in_push_flag),
        .wr_en      (in_update_v_valid),
        .rd_en      (read_in),
        .dout       (push_flag_in_top),
        .data_count (),
        .prog_full  (buffer_full_in),
        .full       (),
        .empty      (buffer_empty_in),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(4)) V_ID_FIFO_FT_INPUT (
        .clk        (clk),
        .srst       (rst),
        .din        (in_update_v_id),
        .wr_en      (in_update_v_valid),
        .rd_en      (read_in),
        .dout       (update_v_id_in_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(4)) V_VALUE_FIFO_FT_INPUT (
        .clk        (clk),
        .srst       (rst),
        .din        (in_update_v_value),
        .wr_en      (in_update_v_valid),
        .rd_en      (read_in),
        .dout       (update_v_value_in_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PULL_FIRST_FLAG_FIFO_FT_INPUT (
        .clk        (clk),
        .srst       (rst),
        .din        (in_pull_first_flag),
        .wr_en      (in_update_v_valid),
        .rd_en      (read_in),
        .dout       (pull_first_flag_in_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

//horizontal buffer
custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PUSH_FLAG_FIFO_FT_HORIZONTAL (
        .clk        (clk),
        .srst       (rst),
        .din        (horizontal_push_flag),
        .wr_en      (horizontal_update_v_valid),
        .rd_en      (read_horizontal),
        .dout       (push_flag_horizontal_top),
        .data_count (),
        .prog_full(buffer_full_horizontal),
        .full       (),
        .empty      (buffer_empty_horizontal),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(4)) V_ID_FIFO_FT_HORIZONTAL (
        .clk        (clk),
        .srst       (rst),
        .din        (horizontal_update_v_id),
        .wr_en      (horizontal_update_v_valid),
        .rd_en      (read_horizontal),
        .dout       (update_v_id_horizontal_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(4)) V_VALUE_FIFO_FT_HORIZONTAL (
        .clk        (clk),
        .srst       (rst),
        .din        (horizontal_update_v_value),
        .wr_en      (horizontal_update_v_valid),
        .rd_en      (read_horizontal),
        .dout       (update_v_value_horizontal_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PULL_FIRST_FLAG_FIFO_FT_HORIZONTAL (
        .clk        (clk),
        .srst       (rst),
        .din        (horizontal_pull_first_flag),
        .wr_en      (horizontal_update_v_valid),
        .rd_en      (read_horizontal),
        .dout       (pull_first_flag_horizontal_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

//vertical buffer
custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PUSH_FLAG_FIFO_FT_VERTICAL (
        .clk        (clk),
        .srst       (rst),
        .din        (vertical_push_flag),
        .wr_en      (vertical_update_v_valid),
        .rd_en      (read_vertical),
        .dout       (push_flag_vertical_top),
        .data_count (),
        .prog_full(buffer_full_vertical),
        .full       (),
        .empty      (buffer_empty_vertical),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(4)) V_ID_FIFO_FT_VERTICAL (
        .clk        (clk),
        .srst       (rst),
        .din        (vertical_update_v_id),
        .wr_en      (vertical_update_v_valid),
        .rd_en      (read_vertical),
        .dout       (update_v_id_vertical_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(4)) V_VALUE_FIFO_FT_VERTICAL (
        .clk        (clk),
        .srst       (rst),
        .din        (vertical_update_v_value),
        .wr_en      (vertical_update_v_valid),
        .rd_en      (read_vertical),
        .dout       (update_v_value_vertical_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PULL_FIRST_FLAG_FIFO_FT_VERTICAL (
        .clk        (clk),
        .srst       (rst),
        .din        (vertical_pull_first_flag),
        .wr_en      (vertical_update_v_valid),
        .rd_en      (read_vertical),
        .dout       (pull_first_flag_vertical_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

endmodule


module hyperx_2_network_node #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VERTICAL_NUM = `VERTICAL_NUM,
    HORIZONTAL_NUM = `HORIZONTAL_NUM,
    HORIZONTAL_NUM_WIDTH = `HORIZONTAL_NUM_WIDTH,
    X_ID = 0,
    Y_ID = 0,
    CORE_ID = 0,
    CORE_NUM = `CORE_NUM,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH
)(
    input                                       clk,
    input                                       rst,
    input                                       in_push_flag,
    input [V_ID_WIDTH - 1 : 0]                  in_update_v_id,
    input [V_VALUE_WIDTH - 1 : 0]               in_update_v_value,
    input                                       in_pull_first_flag,
    input                                       in_update_v_valid,
    input                                       in_iteration_end,
    input                                       in_iteration_end_valid,
    input                                       next_stage_full,
    
    input                                       horizontal_push_flag,
    input [V_ID_WIDTH - 1 : 0]                  horizontal_update_v_id,
    input [V_VALUE_WIDTH - 1 : 0]               horizontal_update_v_value,
    input                                       horizontal_pull_first_flag,
    input                                       horizontal_update_v_valid,
    input [HORIZONTAL_NUM -  1 : 0]               horizontal_select,
    
    input                                       vertical_push_flag,
    input [V_ID_WIDTH - 1 : 0]                  vertical_update_v_id,
    input [V_VALUE_WIDTH - 1 : 0]               vertical_update_v_value,
    input                                       vertical_pull_first_flag,
    input                                       vertical_update_v_valid,
    input [VERTICAL_NUM -  1 : 0]               vertical_select,
    
    output reg                                  push_flag,
    output reg [V_ID_WIDTH - 1 : 0]             update_v_id,
    output reg [V_VALUE_WIDTH - 1 : 0]          update_v_value,
    output reg                                  update_v_valid,
    output reg                                  pull_first_flag,
    output reg                                  iteration_end,
    output reg                                  iteration_end_valid,
    output                                      stage_full,
    
    output                                      horizontal_out_push_flag,
    output  [V_ID_WIDTH - 1 : 0]                horizontal_out_update_v_id,
    output  [V_VALUE_WIDTH - 1 : 0]             horizontal_out_update_v_value,
    output                                      horizontal_out_update_v_valid,
    output                                      horizontal_out_pull_first_flag,
    output                                      horizontal_out_stage_full,
    
    output                                      vertical_out_push_flag,
    output  [V_ID_WIDTH - 1 : 0]                vertical_out_update_v_id,
    output  [V_VALUE_WIDTH - 1 : 0]             vertical_out_update_v_value,
    output                                      vertical_out_update_v_valid,
    output                                      vertical_out_pull_first_flag,
    output                                      vertical_out_stage_full
);

wire buffer_full_in, buffer_empty_in, buffer_full_horizontal, buffer_empty_horizontal, buffer_full_vertical, buffer_empty_vertical;
wire read_in, read_horizontal, read_vertical;
wire push_flag_in_top, pull_first_flag_in_top, push_flag_horizontal_top, pull_first_flag_horizontal_top, push_flag_vertical_top, pull_first_flag_vertical_top;
wire [V_ID_WIDTH - 1 : 0] update_v_id_in_top, update_v_id_horizontal_top, update_v_id_vertical_top;
wire [V_VALUE_WIDTH - 1 : 0] update_v_value_in_top, update_v_value_horizontal_top, update_v_value_vertical_top;
wire vertical_out;
wire in_horizontal;
wire horizontal_vertical;

assign vertical_out = !buffer_empty_vertical && !next_stage_full; //&& update_v_id_vertical_top[CORE_NUM_WIDTH - 1 : 0] == CORE_ID;
assign in_horizontal = !buffer_empty_in; //&& !(update_v_id_in_top[HORIZONTAL_NUM_WIDTH - 1 : 0] == X_ID);
assign horizontal_vertical = !buffer_empty_horizontal; //&& !(update_v_id_horizontal_top[CORE_NUM_WIDTH - 1 : 0]/HORIZONTAL_NUM == Y_ID);

assign read_in = in_horizontal && horizontal_select != 0;
assign read_horizontal = horizontal_vertical && vertical_select != 0;
assign read_vertical = vertical_out;

assign horizontal_out_push_flag = in_horizontal ? push_flag_in_top : 0;
assign horizontal_out_update_v_id = in_horizontal ? update_v_id_in_top : 0;
assign horizontal_out_update_v_value = in_horizontal ? update_v_value_in_top : 0;
assign horizontal_out_update_v_valid = in_horizontal ? 1 : 0;
assign horizontal_out_pull_first_flag = in_horizontal ? pull_first_flag_in_top : 0;

assign vertical_out_push_flag = horizontal_vertical ? push_flag_horizontal_top : 0;
assign vertical_out_update_v_id = horizontal_vertical ? update_v_id_horizontal_top : 0;
assign vertical_out_update_v_value = horizontal_vertical ? update_v_value_horizontal_top : 0;
assign vertical_out_update_v_valid = horizontal_vertical ? 1 : 0;
assign vertical_out_pull_first_flag = horizontal_vertical ? pull_first_flag_horizontal_top : 0;

assign stage_full = buffer_full_in;
assign horizontal_out_stage_full = buffer_full_horizontal;
assign vertical_out_stage_full = buffer_full_vertical;

always @ (posedge clk) begin
    if (buffer_empty_in && buffer_empty_horizontal && buffer_empty_vertical && in_iteration_end && in_iteration_end_valid) begin
        iteration_end <= 1;
        iteration_end_valid <= 1;
    end
    else begin
        iteration_end <= 0;
        iteration_end_valid <= 0;
    end
end

always @ (posedge clk) begin
    if(rst) begin
        push_flag <= 0;
        update_v_id <= 0;
        update_v_value <= 0;
        pull_first_flag <= 0;
        update_v_valid <= 0;
    end
    else if (vertical_out) begin
        push_flag <= push_flag_vertical_top;
        update_v_id <= update_v_id_vertical_top;
        update_v_value <= update_v_value_vertical_top;
        pull_first_flag <= pull_first_flag_vertical_top;
        update_v_valid <= 1;
    end
    else begin
        push_flag <= 0;
        update_v_id <= 0;
        update_v_value <= 0;
        pull_first_flag <= 0;
        update_v_valid <= 0;
    end
end




//input buffer
custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PUSH_FLAG_FIFO_FT_INPUT (
        .clk        (clk),
        .srst       (rst),
        .din        (in_push_flag),
        .wr_en      (in_update_v_valid),
        .rd_en      (read_in),
        .dout       (push_flag_in_top),
        .data_count (),
        .prog_full(buffer_full_in),
        .full       (),
        .empty      (buffer_empty_in),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(4)) V_ID_FIFO_FT_INPUT (
        .clk        (clk),
        .srst       (rst),
        .din        (in_update_v_id),
        .wr_en      (in_update_v_valid),
        .rd_en      (read_in),
        .dout       (update_v_id_in_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(4)) V_VALUE_FIFO_FT_INPUT (
        .clk        (clk),
        .srst       (rst),
        .din        (in_update_v_value),
        .wr_en      (in_update_v_valid),
        .rd_en      (read_in),
        .dout       (update_v_value_in_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PULL_FIRST_FLAG_FIFO_FT_INPUT (
        .clk        (clk),
        .srst       (rst),
        .din        (in_pull_first_flag),
        .wr_en      (in_update_v_valid),
        .rd_en      (read_in),
        .dout       (pull_first_flag_in_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

//horizontal buffer
custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PUSH_FLAG_FIFO_FT_HORIZONTAL (
        .clk        (clk),
        .srst       (rst),
        .din        (horizontal_push_flag),
        .wr_en      (horizontal_update_v_valid),
        .rd_en      (read_horizontal),
        .dout       (push_flag_horizontal_top),
        .data_count (),
        .prog_full(buffer_full_horizontal),
        .full       (),
        .empty      (buffer_empty_horizontal),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(4)) V_ID_FIFO_FT_HORIZONTAL (
        .clk        (clk),
        .srst       (rst),
        .din        (horizontal_update_v_id),
        .wr_en      (horizontal_update_v_valid),
        .rd_en      (read_horizontal),
        .dout       (update_v_id_horizontal_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(4)) V_VALUE_FIFO_FT_HORIZONTAL (
        .clk        (clk),
        .srst       (rst),
        .din        (horizontal_update_v_value),
        .wr_en      (horizontal_update_v_valid),
        .rd_en      (read_horizontal),
        .dout       (update_v_value_horizontal_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PULL_FIRST_FLAG_FIFO_FT_HORIZONTAL (
        .clk        (clk),
        .srst       (rst),
        .din        (horizontal_pull_first_flag),
        .wr_en      (horizontal_update_v_valid),
        .rd_en      (read_horizontal),
        .dout       (pull_first_flag_horizontal_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

//vertical buffer
custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PUSH_FLAG_FIFO_FT_VERTICAL (
        .clk        (clk),
        .srst       (rst),
        .din        (vertical_push_flag),
        .wr_en      (vertical_update_v_valid),
        .rd_en      (read_vertical),
        .dout       (push_flag_vertical_top),
        .data_count (),
        .prog_full(buffer_full_vertical),
        .full       (),
        .empty      (buffer_empty_vertical),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(4)) V_ID_FIFO_FT_VERTICAL (
        .clk        (clk),
        .srst       (rst),
        .din        (vertical_update_v_id),
        .wr_en      (vertical_update_v_valid),
        .rd_en      (read_vertical),
        .dout       (update_v_id_vertical_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(4)) V_VALUE_FIFO_FT_VERTICAL (
        .clk        (clk),
        .srst       (rst),
        .din        (vertical_update_v_value),
        .wr_en      (vertical_update_v_valid),
        .rd_en      (read_vertical),
        .dout       (update_v_value_vertical_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(4)) PULL_FIRST_FLAG_FIFO_FT_VERTICAL (
        .clk        (clk),
        .srst       (rst),
        .din        (vertical_pull_first_flag),
        .wr_en      (vertical_update_v_valid),
        .rd_en      (read_vertical),
        .dout       (pull_first_flag_vertical_top),
        .data_count (),
        .prog_full(),
        .full       (),
        .empty      (),
        .valid      ()
);

endmodule