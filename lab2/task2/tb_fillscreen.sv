module tb_fillscreen();

  logic clk=1, rst_n=0,start;
  logic [2:0]colour;
  logic done,vga_plot;
  logic [7:0]vga_x;
  logic [6:0]vga_y;
  logic [2:0]vga_colour;


  always #5 clk = ~clk;  // Create clock with period=10
  fillscreen dut( .* );

  initial begin
    colour = 3'b010;
    #5 rst_n = 1;

    $monitor( "state %s outputs: vga_x=%d, vga_y=%d", dut.state, vga_x, vga_y, vga_colour ); 
    #10 start = 1; #20 start = 0; #10 start = 1;
    #192100; start = 0;
    #20;
    $stop;
  end

endmodule: tb_fillscreen