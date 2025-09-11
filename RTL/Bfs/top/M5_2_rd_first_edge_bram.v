`timescale 1ns / 1ps

`include "accelerator.vh"

module rd_first_edge_bram #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    VTX_NUM_WIDTH = `VTX_NUM_WIDTH,
    HBM_AWIDTH = `HBM_AWIDTH,
    HBM_DWIDTH = `HBM_DWIDTH,
    HBM_DWIDTH_PER_CORE = `HBM_DWIDTH_PER_CORE,
    FIRST_EDGE_BRAM_AWIDTH = `FIRST_EDGE_BRAM_AWIDTH,
    FIRST_EDGE_BRAM_DWIDTH = `FIRST_EDGE_BRAM_DWIDTH,
    LOADER_PSEUDO_CHANNEL_NUM = `PSEUDO_CHANNEL_NUM / 2,
    CORE_NUM = `CORE_NUM,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH
) (
    input                                               clk,
    input [CORE_NUM - 1 : 0]                            rst,
    input                                               first_edge_rst,
    input [LOADER_PSEUDO_CHANNEL_NUM * HBM_DWIDTH - 1 : 0]  first_edge,
    input [LOADER_PSEUDO_CHANNEL_NUM - 1 : 0]           loader_counter,
    input [LOADER_PSEUDO_CHANNEL_NUM - 1 : 0]           first_edge_valid,
    input [CORE_NUM * FIRST_EDGE_BRAM_AWIDTH - 1 : 0]   front_rd_edge_addr,
    input [CORE_NUM - 1 : 0]                            front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]               front_active_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]            front_active_v_value,
    input [CORE_NUM - 1 : 0]                            front_rd_edge_valid,
    input [CORE_NUM - 1 : 0]                            front_iteration_end,
    input [CORE_NUM - 1 : 0]                            front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                            next_stage_full,

    output [LOADER_PSEUDO_CHANNEL_NUM - 1 : 0]          transfer_complete,
    output [CORE_NUM - 1 : 0]                           stage_full,
    output [CORE_NUM - 1 : 0]                           push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]              active_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]           active_v_value,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]              active_v_edge,
    output [CORE_NUM - 1 : 0]                           active_v_valid,
    output [CORE_NUM - 1 : 0]                           iteration_end,
    output [CORE_NUM - 1 : 0]                           iteration_end_valid
);

    genvar i;

    wire [FIRST_EDGE_BRAM_DWIDTH - 1 : 0] tmp_bram_data [0 : CORE_NUM - 1];
    wire [FIRST_EDGE_BRAM_DWIDTH - 1 : 0] tmp_bram_data_debug [0 : CORE_NUM - 1];
    reg [CORE_NUM - 1 : 0] tmp_bram_valid [0 : 1];

    reg [HBM_AWIDTH - 1 : 0] local_first_edge_wr_addr [LOADER_PSEUDO_CHANNEL_NUM - 1 : 0];
    wire [HBM_AWIDTH * CORE_NUM - 1 : 0] bram_addr_in;
    wire [HBM_DWIDTH_PER_CORE * CORE_NUM - 1 : 0] bram_data_in;
    wire [CORE_NUM - 1 : 0] wea;

    generate
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            rd_first_edge_bram_single #(.CORE_ID(i)) RD_FIRST_EDGE_BRAM_SINGLE (
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
                // .stage_full_3                 (stage_full[i]),
                // .push_flag_3                  (push_flag[i]),
                // .active_v_id_3                (active_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                // .active_v_value_3             (active_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                // .active_v_edge_3              (active_v_edge[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                // .active_v_valid_3             (active_v_valid[i]),
                // .iteration_end_3              (iteration_end[i]),
                // .iteration_end_valid_3        (iteration_end_valid[i])
            );

            first_edge_rom FIRST_EDGE_ROM_IP_SINGLE (
                .addra      (rst[i] ? bram_addr_in[HBM_AWIDTH * i +: HBM_AWIDTH] : front_rd_edge_addr[FIRST_EDGE_BRAM_AWIDTH * i +: FIRST_EDGE_BRAM_AWIDTH]),
                .clka       (clk),
                .dina       (bram_data_in[HBM_DWIDTH_PER_CORE * i +: HBM_DWIDTH_PER_CORE]),
                .douta      (tmp_bram_data[i]),
                .ena        (!first_edge_rst),
                .wea        (rst[i] ? wea[i] : 1'b0)
            );

            // first_edge_rom_self #(.INIT_FILE(i)) FIRST_EDGE_ROM_SELF_SINGLE (
            //     .rst        (rst[i]),
            //     .clka       (clk),
            //     .ena        (!rst[i]),
            //     .addra      (front_rd_edge_addr[(i + 1) * FIRST_EDGE_BRAM_AWIDTH - 1 : i * FIRST_EDGE_BRAM_AWIDTH]),
            //     .douta      (tmp_bram_data_debug[i])
            // );

            // always @(posedge clk) begin
            //     if (!rst[i] && tmp_bram_data[i] != tmp_bram_data_debug[i]) begin
            //         $display("Err: bram_data is 0x%x rather than 0x%x @%t CORE%2d", tmp_bram_data[i], tmp_bram_data_debug[i], $time, i);
            //     end
            // end
        end
    endgenerate

    // load first_edge from HBM
    generate
        for (i = 0; i < LOADER_PSEUDO_CHANNEL_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                if (first_edge_rst) begin
                    local_first_edge_wr_addr[i] <= 'h0;
                end
                // TODO delete the transfer_complete
                else if (first_edge_valid[i] && loader_counter[i] && !transfer_complete[i]) begin
                    local_first_edge_wr_addr[i] <= local_first_edge_wr_addr[i] + 1'b1;
                end
            end

            // 1 PC -> 32 Cores, write into 16 Cores each time
            assign bram_addr_in[HBM_AWIDTH * i * 32 +: HBM_AWIDTH * 32] = {32{local_first_edge_wr_addr[i]}};
            assign bram_data_in[HBM_DWIDTH_PER_CORE * i * 32 +: HBM_DWIDTH_PER_CORE * 32] = {2{first_edge[HBM_DWIDTH * i +: HBM_DWIDTH]}};
            assign wea[i * 32 +: 32] = {{16{loader_counter[i]}}, {16{!loader_counter[i]}}} & {32{first_edge_valid[i]}};

            assign transfer_complete[i] = (local_first_edge_wr_addr[i] == (((1 << VTX_NUM_WIDTH) >> CORE_NUM_WIDTH)));
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
    CORE_NUM = `CORE_NUM,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH,
    CORE_ID = 0
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
    output reg                                 push_flag,
    output reg [V_ID_WIDTH - 1 : 0]             active_v_id,
    output reg [V_VALUE_WIDTH - 1 : 0]          active_v_value,
    output reg [V_ID_WIDTH - 1 : 0]             active_v_edge,
    output reg                              active_v_valid,
    output reg                              iteration_end,
    output reg                              iteration_end_valid
    // output reg                                 stage_full_3,
    // output reg                                 push_flag_3,
    // output reg [V_ID_WIDTH - 1 : 0]             active_v_id_3,
    // output reg [V_VALUE_WIDTH - 1 : 0]          active_v_value_3,
    // output reg [V_ID_WIDTH - 1 : 0]             active_v_edge_3,
    // output reg                              active_v_valid_3,
    // output reg                              iteration_end_3,
    // output reg                              iteration_end_valid_3
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

    // //clk1
    // always @ (posedge clk) begin
    //     stage_full_1 <= stage_full;
    //     push_flag_1 <= push_flag;
    //     active_v_id_1 <= active_v_id;
    //     active_v_value_1 <= active_v_value;
    //     active_v_edge_1 <= active_v_edge;
    //     active_v_valid_1 <= active_v_valid;
    //     iteration_end_1 <= iteration_end;
    //     iteration_end_valid_1 <= iteration_end_valid;
    // end
    
    // //clk2
    // always @ (posedge clk) begin
    //     stage_full_2 <= stage_full_1;
    //     push_flag_2 <= push_flag_1;
    //     active_v_id_2 <= active_v_id_1;
    //     active_v_value_2 <= active_v_value_1;
    //     active_v_edge_2 <= active_v_edge_1;
    //     active_v_valid_2 <= active_v_valid_1;
    //     iteration_end_2 <= iteration_end_1;
    //     iteration_end_valid_2 <= iteration_end_valid_1;
    // end
    
    // //clk3
    // always @ (posedge clk) begin
    //     stage_full_3 <= stage_full_2;
    //     push_flag_3 <= push_flag_2;
    //     active_v_id_3 <= active_v_id_2;
    //     active_v_value_3 <= active_v_value_2;
    //     active_v_edge_3 <= active_v_edge_2;
    //     active_v_valid_3 <= active_v_valid_2;
    //     iteration_end_3 <= iteration_end_2;
    //     iteration_end_valid_3 <= iteration_end_valid_2;
    // end

endmodule

// module first_edge_rom_self #(parameter
//     ROM_ID = -1,
//     RAM_WIDTH = `FIRST_EDGE_BRAM_DWIDTH,                  // Specify column width (byte width, typically 8 or 9)
//     RAM_AWIDTH = `VTX_BRAM_AWIDTH,
//     RAM_PERFORMANCE = "PERFORMANCE",
//     INIT_FILE = "",                      // Specify name/location of RAM initialization file if using one (leave blank if not)
//     RAM_DEPTH = (1 << RAM_AWIDTH)
// ) (
//   input [RAM_AWIDTH - 1 : 0] addra,   // Write address bus, width determined from RAM_DEPTH
//   input clka,                            // Write clock
//   input ena,

//   output [RAM_WIDTH - 1 : 0] douta           // RAM output data
// );

//   (* ram_style="block" *) reg [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
//   reg [RAM_WIDTH-1:0] ram_data = {RAM_WIDTH{1'b0}};

//   // The following code either initializes the memory values to a specified file or to all zeros to match hardware
//   generate
//     if (INIT_FILE != "") begin: use_init_file
//       initial begin
//         $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
//       end
//     end else begin: init_bram_to_zero
//       integer ram_index;
//       initial
//         for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
//           BRAM[ram_index] = ram_index + ROM_ID;
//     end
//   endgenerate

//   always @(posedge clka)
//     if (ena)
//         ram_data <= BRAM[addra];

//   //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
//   generate
//     if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

//       // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
//        assign douta = ram_data;

//     end else begin: output_register

//       // The following is a 2 clock cycle read latency with improve clock-to-out timing

//       reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};

//       always @(posedge clka)
//         douta_reg <= ram_data;

//       assign douta = douta_reg;

//     end
//   endgenerate

// endmodule




// module first_edge_rom_self #(parameter
//     ROM_ID = -1,
//     RAM_WIDTH = `FIRST_EDGE_BRAM_DWIDTH, // Specify column width (byte width, typically 8 or 9)
//     RAM_AWIDTH = `VTX_BRAM_AWIDTH,
//     RAM_PERFORMANCE = "PERFORMANCE",
//     INIT_FILE = "",                      // Specify name/location of RAM initialization file if using one (leave blank if not)
//     RAM_DEPTH = (1 << RAM_AWIDTH)
// ) (
//   input [RAM_AWIDTH - 1 : 0] addra,   // Write address bus, width determined from RAM_DEPTH
//   input clka,                            // Write clock
//   input ena,
//   input rst,

//   output [RAM_WIDTH - 1 : 0] douta           // RAM output data
// );

//   xpm_memory_sdpram #(
//       .ADDR_WIDTH_A(RAM_AWIDTH),               // DECIMAL
//       .ADDR_WIDTH_B(RAM_AWIDTH),               // DECIMAL
//       .AUTO_SLEEP_TIME(0),            // DECIMAL
//       .BYTE_WRITE_WIDTH_A(),         // DECIMAL
//       .CASCADE_HEIGHT(0),             // DECIMAL
//       .CLOCKING_MODE("common_clock"), // String
//       .ECC_MODE("no_ecc"),            // String
//       .MEMORY_INIT_FILE($sformatf("%sfirst_edge_small_%0d.mem", `FILE_LOC, INIT_FILE)),      // String
//       .MEMORY_INIT_PARAM(""),        // String
//       .MEMORY_OPTIMIZATION("true"),   // String
//       .MEMORY_PRIMITIVE("auto"),      // String
//       .MEMORY_SIZE( RAM_DEPTH * RAM_WIDTH ),             // DECIMAL
//       .MESSAGE_CONTROL(0),            // DECIMAL
//       .READ_DATA_WIDTH_B(RAM_WIDTH),         // DECIMAL
//       .READ_LATENCY_B(2),             // DECIMAL
//       .READ_RESET_VALUE_B("0"),       // String
//       .RST_MODE_A("SYNC"),            // String
//       .RST_MODE_B("SYNC"),            // String
//       .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
//       .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
//       .USE_MEM_INIT(1),               // DECIMAL
//       .USE_MEM_INIT_MMI(0),           // DECIMAL
//       .WAKEUP_TIME("disable_sleep"),  // String
//       .WRITE_DATA_WIDTH_A(RAM_WIDTH),        // DECIMAL
//       .WRITE_MODE_B("read_first"),     // String
//       .WRITE_PROTECT(1)               // DECIMAL
//    )
//    xpm_memory_sdpram_inst (
//       .dbiterrb(),             // 1-bit output: Status signal to indicate double bit error occurrence
//                                        // on the data output of port B.

//       .doutb(douta),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
//       .sbiterrb(),             // 1-bit output: Status signal to indicate single bit error occurrence
//                                        // on the data output of port B.

//       .addra(),                   // ADDR_WIDTH_A-bit input: Address for port A write operations.
//       .addrb(addra),                   // ADDR_WIDTH_B-bit input: Address for port B read operations.
//       .clka(clka),                     // 1-bit input: Clock signal for port A. Also clocks port B when
//                                        // parameter CLOCKING_MODE is "common_clock".

//       .clkb(clka),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
//                                        // "independent_clock". Unused when parameter CLOCKING_MODE is
//                                        // "common_clock".

//       .dina(),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
//       .ena(1'b0),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
//                                        // cycles when write operations are initiated. Pipelined internally.

//       .enb(ena),                       // 1-bit input: Memory enable signal for port B. Must be high on clock
//                                        // cycles when read operations are initiated. Pipelined internally.

//       .injectdbiterra(1'b0), // 1-bit input: Controls double bit error injection on input data when
//                                        // ECC enabled (Error injection capability is not available in
//                                        // "decode_only" mode).

//       .injectsbiterra(1'b0), // 1-bit input: Controls single bit error injection on input data when
//                                        // ECC enabled (Error injection capability is not available in
//                                        // "decode_only" mode).

//       .regceb(1'b1),                 // 1-bit input: Clock Enable for the last register stage on the output
//                                        // data path.

//       .rstb(rst),                     // 1-bit input: Reset signal for the final port B output register stage.
//                                        // Synchronously resets output port doutb to the value specified by
//                                        // parameter READ_RESET_VALUE_B.

//       .sleep(1'b0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
//       .wea(1'b0)                        // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
//                                        // for port A input data port dina. 1 bit wide when word-wide writes are
//                                        // used. In byte-wide write configurations, each bit controls the
//                                        // writing one byte of dina to address addra. For example, to
//                                        // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
//                                        // is 32, wea would be 4'b0010.

//    );

// endmodule