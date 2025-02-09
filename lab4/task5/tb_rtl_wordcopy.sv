module tb_rtl_wordcopy();
    logic clk = 1; 
    logic rst_n = 1;
    // slave (CPU-facing)
    logic slave_waitrequest; //
    logic [3:0] slave_address;
    logic slave_read; 
    logic [31:0] slave_readdata; //
    logic slave_write; 
    logic [31:0] slave_writedata;
    // master (SDRAM-facing)
    logic master_waitrequest = 0;
    logic [31:0] master_address; //
    logic master_read; //
    logic [31:0] master_readdata; 
    logic master_readdatavalid; 
    logic master_write; //
    logic [31:0] master_writedata; //

    wordcopy dut (.*);

    always begin 
        #5 clk = ~clk;
    end

    always begin
        #30 master_waitrequest = ~master_waitrequest;
        #10 master_waitrequest = ~master_waitrequest;
    end


    initial begin
        #5;
        rst_n = 1'b0;
        #10;
        rst_n = 1'b1;
        slave_read = 1'b1;
        slave_write = 1'b1;
        master_readdatavalid = 1'b1;
        master_readdata = 32'habcdef;
        // des addr
        slave_address = 4'd1;
        slave_writedata = 32'd20;
        #10; // src addr
        slave_address = 4'd2;
        slave_writedata = 32'd10;
        #10; // word count
        slave_address = 4'd3;
        slave_writedata = 32'd5;
        #10;
        slave_write = 1'b1;
        slave_address = 4'b0;
        #10;
        slave_write = 1'b0;

        wait(dut.state == dut.STORE);
        #30;
        wait(dut.state == dut.WAIT);
        #30;
        $stop;

    end



endmodule: tb_rtl_wordcopy