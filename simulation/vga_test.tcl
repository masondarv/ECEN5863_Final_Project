// VGA test TCL script


// Add waves
add wave -position insertpoint  \
sim:/vga/clk \
sim:/vga/reset \
sim:/vga/hcount \
sim:/vga/vcount \
sim:/vga/hsync \
sim:/vga/vsync \
sim:/vga/hcount_raw \
sim:/vga/vcount_raw


// Clocks and Reset
force -freeze sim:/vga/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/vga/reset 1 0, 0 100
run 100

// Test
run 42000100