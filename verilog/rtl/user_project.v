// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2021 Tamas Hubai

`default_nettype none

module user_project (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);

// clock & reset
wire clk = wb_clk_i;
wire rst_n = ~wb_rst_i;

// single cycle input only wishbone logic
wire valid = wbs_stb_i && wbs_cyc_i;
assign wbs_ack_o = valid;
wire trig_en = valid && wbs_we_i;
wire [15:0] trig_x = trig_en ? wbs_adr_i[15:0] : 0;
wire [15:0] trig_y = trig_en ? wbs_adr_i[31:16] : 0;
assign wbs_dat_o = 32'b0;

// trigger debugging
reg parity;
always @ (posedge clk) begin
    if (!rst_n) begin
        parity <= 0;
    end else begin
        parity <= parity ^ trig_en;
    end
end

// pin assignment
wire [11:0] in_pins = io_in[23:12];
wire [11:0] out_pins;
assign io_out[23:0] = 24'b0;
assign io_out[35:24] = out_pins;
assign io_out[36] = clk;
assign io_out[37] = parity;
assign io_oeb[23:0] = 24'b1; // input
assign io_oeb[37:24] = 14'b0; // output

// logic analyzer is unused
assign la_data_out = 128'b0;

// irq is unused
assign irq = 3'b0;

logic_grid lg (
    .clk(clk),
    .rst_n(rst),
    .trig_en(trig_en),
    .trig_x(trig_x),
    .trig_y(trig_y),
    .in_pins(in_pins),
    .out_pins(out_pins)
);

endmodule

`default_nettype wire

