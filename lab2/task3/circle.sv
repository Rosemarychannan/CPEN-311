module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);
     enum { WAIT, OCT1, OCT2, OCT3, OCT4, OCT5, OCT6, OCT7, OCT8, DONE } state;
     logic signed [8:0] offset_y, offset_x, crit, x, next_offset_x, next_offset_y;
     logic signed [7:0] y;
     always_ff @(posedge clk) begin
          if(rst_n  == 0)state <= WAIT;
          else begin
               case(state)
                WAIT:begin
                    offset_y = 0;
                    offset_x = radius;
                    crit = 1- radius;
                    if(start == 1) state <= OCT1;
                end
                OCT1:begin
                    if(offset_y <= offset_x) state <= OCT2;
                    else state <= DONE;
                end
                OCT2:state <= OCT4;
                OCT4:state <= OCT3;
                OCT3:state <= OCT5;
                OCT5:state <= OCT6;
                OCT6:state <= OCT8;
                OCT8:state <= OCT7;
                OCT7:begin
                    if(offset_y <= offset_x) state <= OCT1;
                    else state <= DONE;

                    offset_y <= offset_y + 1;
                    if(crit <= 0) crit <= crit + 2 * (offset_y+1) + 1;
                    else begin
                         offset_x <= offset_x - 1;
                         crit <= crit + 2 * ((offset_y+1) - (offset_x-1))+1;
                    end
                end
                DONE:if(start == 0) state <= WAIT;
               endcase
          end       
     end
     always_comb begin
          vga_colour = colour;
          done = 0;
          vga_plot = 0;
          x = 0;
          y = 0;
          case(state)
               WAIT:begin
                    done = 0;
                    vga_plot = 0;
               end
               OCT1:begin
                    if(offset_y <= offset_x) begin
                         x = centre_x + offset_x;
                         y = centre_y + offset_y;
                    end
                    else begin
                         done = 1;
                         vga_plot = 0;
                    end
               end
               OCT2:begin
                    x = centre_x + offset_y;
                    y = centre_y + offset_x;
               end
               OCT4:begin
                    x = centre_x - offset_x;
                    y = centre_y + offset_y;
               end
               OCT3:begin
                    x = centre_x - offset_y;
                    y = centre_y + offset_x;
               end
               OCT5:begin
                    x = centre_x - offset_x;
                    y = centre_y - offset_y;
               end
               OCT6:begin
                    x = centre_x - offset_y;
                    y = centre_y - offset_x;
               end
               OCT8:begin
                    x = centre_x + offset_x;
                    y = centre_y - offset_y;
               end
               OCT7:begin
                    x = centre_x + offset_y;
                    y = centre_y - offset_x;
                    if(offset_y > offset_x) begin
                         done = 1;
                         vga_plot = 0;
                    end
               end
               DONE: if(start == 0) done = 0;
          endcase
			 
          if(x>=0 && y>=0 && x<=8'd159 && y<=7'd119) begin
               vga_x = x[7:0];
               vga_y = y[6:0];
               vga_plot = 1;
          end
          else begin
			vga_x = x[7:0];
               vga_y = y[6:0];
			vga_plot = 0;
		end
     end
endmodule
