module tb_rtl_init();

    logic clk, rst_n, en, rdy,wren;
    logic [7:0] addr, wrdata;
    init dut(.*);

    initial begin 
    clk = 0; #5;
        forever begin
        clk = 1; #5;
        clk = 0; #5;
        end
    end
    initial begin
        #10; rst_n = 0;
        #10; rst_n = 1;
        #10; en = 1;
        #20; en = 0;
        #3000;
        $monitor("en=%d,wren=%d,addr=%d,wrdata=%d", en, wren, addr, wrdata);
        $stop;
    end

endmodule: tb_rtl_init
