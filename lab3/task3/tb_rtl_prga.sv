module tb_rtl_prga();
    logic clk, rst_n, en, rdy, s_wren, pt_wren;
    logic [23:0] key;
    logic [7:0] s_addr, s_rddata, s_wrdata, 
    ct_addr, ct_rddata, 
    pt_addr, pt_rddata, pt_wrdata;

    prga dut (.*);

    initial begin 
        clk = 0; #5;
        forever begin
        clk = 1; #5;
        clk = 0; #5;
        end
    end
    initial begin
        s_rddata = 0; 
        ct_rddata = 0; 
        pt_rddata = 0; #10;
        forever begin
            s_rddata = s_rddata + 1;
            ct_rddata = ct_rddata + 2;
            pt_rddata = pt_rddata + 3; #10;
        end
    end
    initial begin
        key = 24'h00033C;
        #10; rst_n = 0;
        #10; rst_n = 1;
        #10; en = 1;
        #20; en = 0;
        #300000;
        $monitor("en=%d",en);
        $stop;
    end

endmodule: tb_rtl_prga
