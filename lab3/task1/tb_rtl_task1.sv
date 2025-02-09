`timescale 1ps / 1ps
module tb_rtl_task1();

    logic CLOCK_50,clk,rst_n;
    logic [3:0] KEY;
    logic [9:0] SW, LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    task1 dut(.*);

    initial begin 
    CLOCK_50 = 0; #5;
        forever begin
        CLOCK_50 = 1; #5;
        CLOCK_50 = 0; #5;
        end
    end
    initial begin
        #10; KEY[3] = 0;
        #10; KEY[3] = 1;
        #3000;
        $monitor(dut.s.altsyncram_component.m_default.altsyncram_inst.mem_data);
	#10;
        $stop;
    end


endmodule: tb_rtl_task1
