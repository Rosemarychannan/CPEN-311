module tb_rtl_circle();

    logic clk = 0, rst_n = 0, start, done,vga_plot;
    logic [2:0] colour, vga_colour;
    logic [7:0] centre_x, radius, vga_x;
    logic [6:0] centre_y, vga_y;


  always #5 clk = ~clk;  // Create clock with period=10
  circle dut( .* );

  initial begin
    colour = 3'b010;
    #5 rst_n = 1;
    centre_x = 80;
    centre_y = 60;
    radius = 40;

    $monitor( "state %s outputs: vga_x=%d, vga_y=%d", dut.state, vga_x, vga_y, vga_colour ); 
    #10 start = 1;
    #500000; start = 0;
    #20;
    $stop;
  end

endmodule: tb_rtl_circle
