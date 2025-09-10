`timescale 1ns / 1ps

`include "accelerator.vh"

module rd_first_edge_bram #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    FIRST_EDGE_BRAM_AWIDTH = `FIRST_EDGE_BRAM_AWIDTH,
    FIRST_EDGE_BRAM_DWIDTH = `FIRST_EDGE_BRAM_DWIDTH,
    CORE_NUM = `CORE_NUM
) (
    input                                               clk,
    input [CORE_NUM - 1 : 0]                            rst,
    input [CORE_NUM * FIRST_EDGE_BRAM_AWIDTH - 1 : 0]   front_rd_edge_addr,
    input [CORE_NUM - 1 : 0]                            front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]               front_active_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]            front_active_v_value,
    input [CORE_NUM - 1 : 0]                            front_rd_edge_valid,
    input [CORE_NUM - 1 : 0]                            front_iteration_end,
    input [CORE_NUM - 1 : 0]                            front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                            next_stage_full,

    output [CORE_NUM - 1 : 0]                           stage_full,
    output [CORE_NUM - 1 : 0]                           push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]              active_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]           active_v_value,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]              active_v_edge,
    output [CORE_NUM - 1 : 0]                           active_v_valid,
    output [CORE_NUM - 1 : 0]                           iteration_end,
    output [CORE_NUM - 1 : 0]                           iteration_end_valid
);

    wire [FIRST_EDGE_BRAM_DWIDTH - 1 : 0] tmp_bram_data [0 : CORE_NUM - 1];
    reg [CORE_NUM - 1 : 0] tmp_bram_valid [0 : 1];

    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            rd_first_edge_bram_single RD_FIRST_EDGE_BRAM_SINGLE (
                .clk                        (clk),
                .rst                        (rst[i]),
                .front_push_flag            (front_push_flag[i]),
                .front_active_v_id          (front_active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .front_active_v_value       (front_active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .front_rd_edge_valid        (front_rd_edge_valid[i]),
                .bram_data                  (tmp_bram_data[i]),
                .bram_valid                 (tmp_bram_valid[1][i]),
                .front_iteration_end        (front_iteration_end[i]),
                .front_iteration_end_valid  (front_iteration_end_valid[i]),
                .next_stage_full            (next_stage_full[i]),

                .stage_full                 (stage_full[i]),
                .push_flag                  (push_flag[i]),
                .active_v_id                (active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .active_v_value             (active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .active_v_edge              (active_v_edge[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .active_v_valid             (active_v_valid[i]),
                .iteration_end              (iteration_end[i]),
                .iteration_end_valid        (iteration_end_valid[i])
            );

            first_edge_rom_self #(.INIT_FILE($sformatf("/sdb/pancg/acc/data/first_edge_small_64_%0d.txt",i))) FIRST_EDGE_ROM_IP_SINGLE (
                .clka       (clk),
                .ena        (!rst[i]),
                .addra      (front_rd_edge_addr[(i + 1) * FIRST_EDGE_BRAM_AWIDTH - 1 : i * FIRST_EDGE_BRAM_AWIDTH]),
                .douta      (tmp_bram_data[i])
            );
        end
    endgenerate

    always @ (posedge clk) begin
        tmp_bram_valid[0] <= front_rd_edge_valid;
        tmp_bram_valid[1] <= tmp_bram_valid[0];
    end

endmodule

module rd_first_edge_bram_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    FIRST_EDGE_BRAM_AWIDTH = `FIRST_EDGE_BRAM_AWIDTH,
    FIRST_EDGE_BRAM_DWIDTH = `FIRST_EDGE_BRAM_DWIDTH,
    CORE_NUM = `CORE_NUM
) (
    input                                   clk,
    input                                   rst,
    input                                   front_push_flag,
    input [V_ID_WIDTH - 1 : 0]              front_active_v_id,
    input [V_VALUE_WIDTH - 1 : 0]           front_active_v_value,
    input                                   front_rd_edge_valid,
    input [FIRST_EDGE_BRAM_DWIDTH - 1 : 0]  bram_data,
    input                                   bram_valid,
    input                                   front_iteration_end,
    input                                   front_iteration_end_valid,
    input                                   next_stage_full,

    output                                  stage_full,
    output                                  push_flag,
    output [V_ID_WIDTH - 1 : 0]             active_v_id,
    output [V_VALUE_WIDTH - 1 : 0]          active_v_value,
    output [V_ID_WIDTH - 1 : 0]             active_v_edge,
    output                                  active_v_valid,
    output reg                              iteration_end,
    output reg                              iteration_end_valid
);
    wire v_buffer_empty, v_buffer_full;
    wire e_buffer_emtpy, e_buffer_full;

    assign stage_full = v_buffer_full;

    push_flag_fifo PUSH_FLAG_FIFO (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag),
        .wr_en      (front_rd_edge_valid),
        .rd_en      (!next_stage_full && !v_buffer_empty && !e_buffer_emtpy),
        .dout       (push_flag),
        .full       (),
        .empty      (),
        .valid      ()
    );

    active_v_id_fifo ACTIVE_V_ID_FIFO (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_id),
        .wr_en      (front_rd_edge_valid),
        .rd_en      (!next_stage_full && !v_buffer_empty && !e_buffer_emtpy),
        .dout       (active_v_id),
        .prog_full  (v_buffer_full),
        .full       (),
        .empty      (v_buffer_empty),
        .valid      (active_v_valid)
    );

    active_v_value_fifo ACTIVE_V_VALUE_FIFO (
        .clk        (clk),
        .srst       (rst),
        .din        (front_active_v_value),
        .wr_en      (front_rd_edge_valid),
        .rd_en      (!next_stage_full && !v_buffer_empty && !e_buffer_emtpy),
        .dout       (active_v_value),
        .full       (),
        .empty      (),
        .valid      ()
    );

    active_v_id_fifo EDGE_FIFO (
        .clk        (clk),
        .srst       (rst),
        .din        (bram_data),
        .wr_en      (bram_valid),
        .rd_en      (!next_stage_full && !v_buffer_empty && !e_buffer_emtpy),
        .dout       (active_v_edge),
        .full       (),
        .empty      (e_buffer_emtpy),
        .valid      ()
    );

    always @ (posedge clk) begin
        if (!rst && front_iteration_end && front_iteration_end_valid && v_buffer_empty) begin
            iteration_end <= 1;
            iteration_end_valid <= 1;
        end else begin
            iteration_end <= 0;
            iteration_end_valid <= 0;
        end
    end

endmodule

module first_edge_rom_self #(parameter
    ROM_ID = -1,
    RAM_WIDTH = `FIRST_EDGE_BRAM_DWIDTH,                  // Specify column width (byte width, typically 8 or 9)
    RAM_AWIDTH = `VTX_BRAM_AWIDTH,
    RAM_PERFORMANCE = "PERFORMANCE",
    INIT_FILE = "",                      // Specify name/location of RAM initialization file if using one (leave blank if not)
    RAM_DEPTH = (1 << RAM_AWIDTH)
) (
  input [RAM_AWIDTH - 1 : 0] addra,   // Write address bus, width determined from RAM_DEPTH
  input clka,                            // Write clock
  input ena,

  output [RAM_WIDTH - 1 : 0] douta           // RAM output data
);

  (* ram_style="block" *) reg [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] ram_data = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial begin
        $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
      end
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          BRAM[ram_index] = ram_index + ROM_ID;
    end
  endgenerate

  always @(posedge clka)
    if (ena)
        ram_data <= BRAM[addra];

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign douta = ram_data;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};

      always @(posedge clka)
        douta_reg <= ram_data;

      assign douta = douta_reg;

    end
  endgenerate

endmodule