# ROTFPGA

![Logic tile](img/rotfpga.svg)

A reconfigurable logic circuit made of identical rotatable copies of the tile shown above
containing a NAND gate, a D flip-flop and a buffer. 
Theoretically any circuit can be built from copies of this single tile.
In practice it's quite a challenge.

Tiles are arranged in a `WIDTH` × `HEIGHT` array wrapping around at the edges.
A few tiles are configured as IO where the flip-flop is connected to an input or output pin.
Tiles are initially in the orientation shown above but they can be rotated
counterclockwise by writing anything to their address using the wishbone bus.

This design is an entry for the MPW3 shuttle and was created from concept to tapeout within 24 hours.

