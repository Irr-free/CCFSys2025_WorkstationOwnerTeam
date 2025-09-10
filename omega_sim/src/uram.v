`timescale 1ns / 1ps

`include "data_width.vh"

module uram #(parameter
    AWIDTH = 11,
    DWIDTH = 72,
    NBPIPE = 3
) (
    input clk,
    input rst,
    input we,
    input regce,
    input mem_en,
    input [DWIDTH - 1 : 0] din,
    input [AWIDTH - 1 : 0] addr,

    output reg [DWIDTH - 1 : 0] dout
);


    //  Xilinx UltraRAM Single Port Read First Mode.  This code implements 
    //  a parameterizable UltraRAM block in read first mode. The behavior of this RAM is 
    //  when data is written, the old memory contents at the write address are 
    //  presented on the output port.
    //
    (* ram_style = "ultra" *)
    reg [DWIDTH - 1:0] mem [(1 << AWIDTH) - 1 : 0];        // Memory Declaration
    reg [DWIDTH - 1:0] memreg;              
    reg [DWIDTH - 1:0] mem_pipe_reg [NBPIPE - 1 : 0];    // Pipelines for memory
    reg mem_en_pipe_reg[NBPIPE : 0];                // Pipelines for memory enable  

    integer          i;

    // RAM : Both READ and WRITE have a latency of one
    always @ (posedge clk) begin
        if(mem_en) begin
            if(we) begin
                mem[addr] <= din;
            end
            memreg <= mem[addr];
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
        if (rst) begin
            dout <= 0;
        end else if (mem_en_pipe_reg[NBPIPE] && regce) begin
            dout <= mem_pipe_reg[NBPIPE - 1];
        end
    end
						
endmodule