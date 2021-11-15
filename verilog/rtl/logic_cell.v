// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2021 Tamas Hubai

`default_nettype none

/*
Rotatable primitive logic cell

In upright position it implements:
- a buffer from left input to right & bottom outputs
- a NAND gate from right & bottom inputs to top output
- a D flip-flop from top input to left output

Any logic circuit can be built from this cell and its rotations arranged in a grid.
The cell can be rotated counterclockwise using the programming trigger at a clock edge,
affecting both input and output orientation.

        A     V
  +-----|-----|-----+
  |  /==:=====/     |
  |  |  |           |
>====:==:=====+=======>
  |  |  |     |     |
  |  D  ~&    |     |
<====/  |\====:=======<
  |     |     |     |
  |     |     |     |
  +-----|-----|-----+
        A     V

A few logic cells are designated as IO cells, these have their flip-flop
connected to an input and/or output pin.
*/

module logic_cell(
   input clk,     // clock
   input rst_n,   // reset, active low
   input trig,    // programming trigger
   input in_t,    // top input
   input in_r,    // right input
   input in_b,    // bottom input
   input in_l,    // left input
   input in_i,    // io cell input pin
   input en_i,    // is the input pin enabled
   output out_t,  // top output
   output out_r,  // right output
   output out_b,  // bottom output
   output out_l,  // left output
   output out_o   // io cell output pin
);

reg [1:0] rot;    // current rotation
reg ff;           // flip-flop status

wire inx_t, inx_r, inx_b, inx_l;       // inputs after rotation
wire outx_t, outx_r, outx_b, outx_l;   // outputs before rotation

wire inr_t, inr_r, inr_b, inr_l;       // temporary values used during rotation
wire outr_t, outr_r, outr_b, outr_l;

// rotations

assign inr_t = rot[1] ? in_b : in_t;
assign inr_r = rot[1] ? in_l : in_r;
assign inr_b = rot[1] ? in_t : in_b;
assign inr_l = rot[1] ? in_r : in_l;

assign inx_t = rot[0] ? inr_l : inr_t;
assign inx_r = rot[0] ? inr_t : inr_r;
assign inx_b = rot[0] ? inr_r : inr_b;
assign inx_l = rot[0] ? inr_b : inr_l;

assign outr_t = rot[1] ? outx_b : outx_t;
assign outr_r = rot[1] ? outx_l : outx_r;
assign outr_b = rot[1] ? outx_t : outx_b;
assign outr_l = rot[1] ? outx_r : outx_l;

assign out_t = rot[0] ? outr_r : outr_t;
assign out_r = rot[0] ? outr_b : outr_r;
assign out_b = rot[0] ? outr_l : outr_b;
assign out_l = rot[0] ? outr_t : outr_l;

// outputs of the unrotated tile

assign outx_t = ~(inx_r & inx_b);
assign outx_r = inx_l;
assign outx_b = inx_l;
assign outx_l = ff;
assign out_o = ff;

always @ (posedge clk) begin
   if (!rst_n) begin
      rot <= 0;
      ff <= 0;
   end else begin
      if (trig) rot <= rot + 1;
      ff <= en_i ? in_i : inx_t;
   end
end

endmodule

`default_nettype wire

