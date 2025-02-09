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

