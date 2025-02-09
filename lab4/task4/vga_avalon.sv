module vga_avalon(input logic clk, input logic reset_n,
                  input logic [3:0] address,
                  input logic read, output logic [31:0] readdata,
                  input logic write, input logic [31:0] writedata,
                  output logic [7:0] vga_red, output logic [7:0] vga_grn, output logic [7:0] vga_blu,
                  output logic vga_hsync, output logic vga_vsync, output logic vga_clk);

    logic vga_plot;
    logic[6:0] vga_y;
    logic[7:0] vga_x, brightness;
    logic [9:0] VGA_RED, VGA_GRN, VGA_BLU;
    // your Avalon slave implementation goes here
    always_comb begin
        if (address == 0 && write == 1 && writedata[30:24] < 8'd120 && writedata[23:16] < 8'd160)
            vga_plot <= 1;
        else
            vga_plot <= 0;
    end

    assign vga_x = writedata[23:16];
    assign vga_y = writedata[30:24];
    assign brightness = writedata[7:0];
    assign vga_red = VGA_RED[9:2];
    assign vga_grn = VGA_GRN[9:2];
    assign vga_blu = VGA_BLU[9:2];
    vga_adapter #( .RESOLUTION("160x120"), .MONOCHROME("TRUE"), .BITS_PER_COLOUR_CHANNEL(8) )
	vga(.resetn(reset_n), .clock(clk), .colour(brightness),
			.x(vga_x), .y(vga_y), .plot(vga_plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_RED),
			.VGA_G(VGA_GRN),
			.VGA_B(VGA_BLU),
			.VGA_HS(vga_hsync),
			.VGA_VS(vga_vsync),
			.VGA_BLANK(),
			.VGA_SYNC(),
			.VGA_CLK(vga_clk));

    // NOTE: We will ignore the VGA_SYNC and VGA_BLANK signals.
    //       Either don't connect them or connect them to dangling wires.
    //       In addition, the VGA_{R,G,B} should be the upper 8 bits of the VGA module outputs.

endmodule: vga_avalon
