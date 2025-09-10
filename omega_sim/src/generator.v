`timescale 1ns / 1ps

`include "data_width.vh"

module vtx_generator #(parameter
    VERTEX_ID_WIDTH = `VERTEX_ID_WIDTH,
    VERTEX_PIPELINE_NUM = `VERTEX_PIPELINE_NUM
) (
    input clk,
    input rst,
    
    output [VERTEX_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] vtx_id,
    output [VERTEX_PIPELINE_NUM - 1 : 0] vtx_id_valid
);

    reg [VERTEX_ID_WIDTH * VERTEX_PIPELINE_NUM - 1 : 0] local_addr;

    generate
        genvar i;
        for (i = 0; i < VERTEX_PIPELINE_NUM; i = i + 1) begin
            active_map_bram ACTIVE_MAP_BRAM (
                .clka       (clk),
                .ena        (!rst),
                .wea        (1'b0),
                .addra      (1'b0),
                .dina       (1'b0),
                .clkb       (clk),
                .enb        (!rst),
                .addrb      (local_addr[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH]),
                .doutb      (vtx_id_valid[i])
            );
            always @ (posedge clk) begin
                if (rst) begin
                    local_addr[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH] <= 0;
                end else begin
                    local_addr[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH] <= local_addr[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH] + 1;
                end
            end
        end
        assign vtx_id = local_addr;
    endgenerate

endmodule

module off_generator #(parameter
    VERTEX_ID_WIDTH = `VERTEX_ID_WIDTH,
    VERTEX_PIPELINE_NUM = `VERTEX_PIPELINE_NUM,
    NBPIPE = 3
) (
    input clk,
    input rst,
    input [VERTEX_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] prev_vtx_id,
    input [VERTEX_PIPELINE_NUM - 1 : 0] prev_vtx_id_valid,
    
    output [VERTEX_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] vtx_id,
    output [VERTEX_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] offset,
    output [VERTEX_PIPELINE_NUM - 1 : 0] vtx_id_valid
);

    reg [VERTEX_PIPELINE_NUM - 1 : 0] valid_pipe_reg [NBPIPE : 0];
    reg [VERTEX_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] id_pipe_reg [NBPIPE : 0];

    generate
        genvar i;
        for (i = 0; i < VERTEX_PIPELINE_NUM; i = i + 1) begin
            uram URAM (
                .clk        (clk),
                .rst        (rst),
                .we         (1'b0),
                .regce      (1'b1),
                .mem_en     (prev_vtx_id_valid[i]),
                .din        (1'b0),
                .addr       (prev_vtx_id[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH]),

                .dout       (offset[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH])
            );
        end
    endgenerate

    integer j;
    always @ (posedge clk) begin
        valid_pipe_reg[0] <= vtx_id_valid;
        id_pipe_reg[0] <= vtx_id;
        for (j = 0; j < NBPIPE; j = j + 1) begin
            valid_pipe_reg[j + 1] <= valid_pipe_reg[j];
            id_pipe_reg[j + 1] <= id_pipe_reg[j];
        end
    end
    assign vtx_id = id_pipe_reg[NBPIPE];
    assign vtx_id_valid = valid_pipe_reg[NBPIPE];


endmodule

module edge_generator #(parameter
    VERTEX_ID_WIDTH = `VERTEX_ID_WIDTH,
    VERTEX_PIPELINE_NUM = `VERTEX_PIPELINE_NUM,
    HBM_DWIDTH_PER_CHANNEL = `HBM_DWIDTH_PER_CHANNEL,
    HBM_CHANNEL_NUM = `HBM_CHANNEL_NUM,
    EDGE_PIPELINE_NUM = `EDGE_PIPELINE_NUM
) (
    input clk,
    input rst,
    input [VERTEX_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] prev_vtx_id,
    input [VERTEX_PIPELINE_NUM - 1 : 0] prev_vtx_id_valid,
    input [HBM_DWIDTH_PER_CHANNEL * HBM_CHANNEL_NUM - 1 : 0] hbm_read_data,
    input [HBM_CHANNEL_NUM - 1 : 0] hbm_read_data_valid,

    output reg [EDGE_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] src_id,
    output reg [EDGE_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] dst_id,
    output reg [EDGE_PIPELINE_NUM - 1 : 0] valid 
);

    generate
        genvar i;
        for (i = 0; i < EDGE_PIPELINE_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                if (rst) begin
                    src_id <= 0;
                    dst_id <= 0;
                    valid <= 0;
                end else begin
                    src_id <= prev_vtx_id[((i % VERTEX_PIPELINE_NUM) + 1) * VERTEX_ID_WIDTH - 1 : (i % VERTEX_PIPELINE_NUM) * VERTEX_ID_WIDTH];
                    dst_id <= hbm_read_data[((i % HBM_DWIDTH_PER_CHANNEL) + 1) * VERTEX_ID_WIDTH - 1 : (i % HBM_DWIDTH_PER_CHANNEL) * VERTEX_ID_WIDTH];
                    valid <= prev_vtx_id_valid[i % VERTEX_PIPELINE_NUM] || hbm_read_data_valid[i % HBM_CHANNEL_NUM];
                end
            end
        end
    endgenerate

endmodule