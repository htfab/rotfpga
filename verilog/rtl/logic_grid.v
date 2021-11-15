// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2021 Tamas Hubai

`default_nettype none

module logic_grid (
   input clk,
   input rst_n,
   input trig_en,
   input [`ADDRSIZE-1:0] trig_x,
   input [`ADDRSIZE-1:0] trig_y,
   input [`IOPAIRS-1:0] in_pins,
   output [`IOPAIRS-1:0] out_pins
);

wire ic_u[`HEIGHT-1:0][`WIDTH-1:0];   // interconnect for data going upwards
wire ic_d[`HEIGHT-1:0][`WIDTH-1:0];   // ~ downwards
wire ic_r[`HEIGHT-1:0][`WIDTH-1:0];   // ~ to the right
wire ic_l[`HEIGHT-1:0][`WIDTH-1:0];   // ~ to the left
wire trig_h[`HEIGHT-1:0];            // horizontal trigger lines
wire trig_v[`WIDTH-1:0];             // vertical trigger lines

generate genvar x, y;
for (y=0; y<`HEIGHT; y=y+1) begin:g_y
   for (x=0; x<`WIDTH; x=x+1) begin:g_x
      wire trig = trig_h[y] & trig_v[x];
      wire in_i;
      wire en_i;
      wire out_o;
      
      if (y >= `Y_FIRST && y <= `Y_FIRST+`Y_STEP*(`IOPAIRS-1) && (y-`Y_FIRST)%`Y_STEP == 0) begin
         if (x == `X_IN) begin
            assign en_i = 1;
            assign in_i = in_pins[(y-`Y_FIRST)/`Y_STEP];
         end else begin
            assign en_i = 0;
            assign in_i = 0;
         end
         if (x == `X_OUT) begin
            assign out_pins[(y-`Y_FIRST)/`Y_STEP] = out_o;
         end
      end else begin
         assign en_i = 0;
         assign in_i = 0;
      end

      logic_cell lc (
         .clk(clk),
         .rst_n(rst_n),
         .trig(trig),
         .in_t(ic_d[y][x]),
         .in_r(ic_l[y][(x+1)%`WIDTH]),
         .in_b(ic_u[(y+1)%`HEIGHT][x]),
         .in_l(ic_r[y][x]),
         .in_i(in_i),
         .en_i(en_i),
         .out_t(ic_u[y][x]),
         .out_r(ic_r[y][(x+1)%`WIDTH]),
         .out_b(ic_d[(y+1)%`HEIGHT][x]),
         .out_l(ic_l[y][x]),
         .out_o(out_o)     
      );
   end
end

for (x=0; x<`WIDTH; x=x+1) begin:g_vt
   assign trig_v[x] = trig_en & (trig_x == x);
end

for (y=0; y<`HEIGHT; y=y+1) begin:g_ht
   assign trig_h[y] = trig_en & (trig_y == y);
end
endgenerate

endmodule

`default_nettype wire

