module task3(input logic CLOCK_50, input logic [3:0] KEY,
        input logic [9:0] SW, output logic [9:0] LEDR,
        output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
        output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
        output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
        output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
        output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
        output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

    // instantiate and connect the VGA adapter and your module
    /*logic [7:0] VGA_Xf, VGA_Xc;
    logic [6:0] VGA_Yf, VGA_Yc;
    logic [2:0] VGA_COLOURf, VGA_COLOURc;
    logic VGA_PLOTf, VGA_PLOTc;*/
    
    logic [9:0] VGA_R_10;
    logic [9:0] VGA_G_10;
    logic [9:0] VGA_B_10;
    logic VGA_BLANK, VGA_SYNC;

    assign VGA_R = VGA_R_10[9:2];
    assign VGA_G = VGA_G_10[9:2];
    assign VGA_B = VGA_B_10[9:2];

    /*assign CIRCLE_START = LEDR[7];
    assign VGA_X = CIRCLE_START ? VGA_Xc : VGA_Xf;
    assign VGA_Y = CIRCLE_START ? VGA_Yc : VGA_Yf;
    assign VGA_COLOUR = CIRCLE_START ? VGA_COLOURc : VGA_COLOURf;
    assign VGA_PLOT = CIRCLE_START ? VGA_PLOTc : VGA_PLOTf;*/

    /*fillscreen Fillscreen(.clk(CLOCK_50), .rst_n(KEY[3]), .colour(3'b001),
                          .start(~KEY[1]), .done(LEDR[7]), .vga_x(VGA_Xf), .vga_y(VGA_Yf),
                          .vga_colour(VGA_COLOURf), .vga_plot(VGA_PLOTf));*/
    circle CIR (CLOCK_50, KEY[3], 3'b010, 8'd80, 8'd60, 40, ~KEY[0], LEDR[9], VGA_X, VGA_Y, VGA_COLOUR, VGA_PLOT);
    vga_adapter#(.RESOLUTION("160x120")) vga_u0(.resetn(KEY[3]), .clock(CLOCK_50), .colour(VGA_COLOUR),
            .x(VGA_X), .y(VGA_Y), .plot(VGA_PLOT),
            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10),
            .*);

endmodule: task3
/*
module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);
     enum { WAIT, EXEC, DONE } state;
     logic [7:0]y;
     logic [8:0]x;
     always_ff @(posedge clk) begin
          if(rst_n  == 0)state <= WAIT;
          else begin
               case(state)
               WAIT:begin
                    vga_colour = colour;
                    done <= 0;
                    vga_plot <= 0;
                    x <= 0;
                    y <= 0;
                    vga_x <= 0;
                    vga_y <= 0;
                    if(start == 1)begin
                         state <= EXEC;
                         vga_plot <= 1;
                    end
               end
               EXEC:begin
                    if(start == 0) state <= WAIT;
                    else begin
                         vga_plot <= 1;
                         if (y<7'b1110111 && x<=8'b10011111)begin // move coloum untill the last one
                              y <= y + 1;
                              state <= EXEC;
                         end
                         else if (y==7'b1110111 && x<8'b10011111)begin // when it's the last one move down row
                              y <= 0;
                              x <= x + 1;
                              state <= EXEC;
                         end
                         else if(y==7'b1110111 && x==8'b10011111) begin // when it's ths last square
                              state <= DONE;
                              done <= 1;
                         end
                         vga_x <= x;
                         vga_y <= y;
                    end
               end
               DONE:begin
                    vga_plot <= 0;
                    if(start == 0)begin
                         state <= WAIT;
                         done <= 0;
                    end
               end
               endcase
          end
     end
endmodule
*/