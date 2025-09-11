// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Sat Dec  2 13:08:17 2023
// Host        : ubuntu86 running 64-bit Ubuntu 18.04.6 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/junshuang/project/accelerator/bfs_acc/ip/next_push_active_v_id_fifo_ft/next_push_active_v_id_fifo_ft_stub.v
// Design      : next_push_active_v_id_fifo_ft
// Purpose     : Stub declaration of top-level module interface
// Device      : xcu280-fsvh2892-2L-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_7,Vivado 2022.2" *)
module next_push_active_v_id_fifo_ft(clk, srst, din, wr_en, rd_en, dout, full, empty, 
  wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[19:0],wr_en,rd_en,dout[19:0],full,empty,wr_rst_busy,rd_rst_busy" */;
  input clk;
  input srst;
  input [19:0]din;
  input wr_en;
  input rd_en;
  output [19:0]dout;
  output full;
  output empty;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
