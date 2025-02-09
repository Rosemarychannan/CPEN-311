module tb_rtl_ksa();

    logic clk, rst_n, en, rdy,wren;
    logic [23:0] key;
    logic [7:0] addr, rddata, wrdata;
    
    ksa dut(.*);

    initial begin 
        clk = 0; #5;
        forever begin
        clk = 1; #5;
        clk = 0; #5;
        end
    end
    initial begin
        rddata = 0; #5;
        forever begin
            rddata = rddata + 1; #5;
        end
    end
    initial begin
        key = 24'h00033C;
        #10; rst_n = 0;
        #10; rst_n = 1;
        #10; en = 1;
        #20; en = 0;
        $monitor("en=%d,wren=%d,addr=%d,wrdata=%d,rddata=%d", en, wren, addr, wrdata, rddata);
        $stop;
    end
endmodule: tb_rtl_ksa
