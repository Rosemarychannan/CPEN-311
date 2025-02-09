module tb_rtl_dot();
    logic clk, rst_n;
    logic slave_waitrequest, slave_read, slave_write, master_waitrequest=1, master_read, master_readdatavalid, master_write;
    logic [3:0] slave_address;
    logic [31:0]  slave_readdata, slave_writedata, master_address, master_readdata, master_writedata;
    logic [15:0] PROD,SUM,A,W;

    dot dut(.clk(clk), .rst_n(rst_n), .slave_waitrequest(slave_waitrequest), .slave_address(slave_address),
            .slave_read(slave_read), .slave_readdata(slave_readdata), .slave_write(slave_write), .slave_writedata(slave_writedata),
            .master_waitrequest(master_waitrequest), .master_address(master_address), .master_read(master_read),
            .master_readdata(master_readdata), .master_readdatavalid(master_readdatavalid), .master_write(master_write),.master_writedata(master_writedata));

    // Assuming dut.sum is already declared and assigned somewhere in your testbench
    assign A = dut.a_data>>>16;
    assign W = dut.w_data>>>16;
    assign SUM = dut.sum >>> 16;
    assign PROD = dut.product >>> 32;


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    always begin
        #30 master_waitrequest = ~master_waitrequest;
        #10 master_waitrequest = ~master_waitrequest;
    end

    initial begin
        master_readdatavalid = 1'b1;
        rst_n = 0;
        #10 rst_n = 1;
        #10 slave_write = 0;
        #10 slave_write = 1; slave_address = 4'd2; slave_writedata = 32'd200;
        #10 slave_write = 0;
        #10 slave_write = 1;
        slave_address = 4'd3;
        slave_writedata = 32'd300;
        #10 slave_write = 0;
        #10 slave_write = 1;
         slave_address = 4'd5;
         slave_writedata = 32'd3;
        #10 slave_write = 0;
        #10 slave_write = 1;
         slave_address = 4'd0;
         slave_writedata = 32'd100;
        #10 slave_write = 0;
        master_readdata = 32'b1010_0000_0000_0000_0000;//10
        #20;master_readdata = 32'b1111111111110110_0000000000000000;//-10
        #20;master_readdata = 32'b1110_0000000000000000;//14
                $display("SUM: %h", SUM); // Display the value of SUM
        #20 wait(dut.state == dut.WAIT);
        #10; slave_read = 1; slave_address = 4'd0;
        #30;
        $stop;
    end
endmodule: tb_rtl_dot
