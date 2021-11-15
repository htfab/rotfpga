// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2021 Tamas Hubai

`default_nettype none

// width of cell grid
`define WIDTH 12

// height of cell grid
`define HEIGHT 12

// size of width/height field, i.e. clog2(max(WIDTH, HEIGHT))
`define ADDRSIZE 4

// number of input pins = number of output pins
`define IOPAIRS 12

// x coordinate of input pins
`define X_IN 0

// x coordinate of output pins
`define X_OUT (`WIDTH-1)

// y coordinate of first input/output pin pair
`define Y_FIRST 0

// y coordinate difference of successive input/output pin pairs
`define Y_STEP 1

`default_nettype wire

