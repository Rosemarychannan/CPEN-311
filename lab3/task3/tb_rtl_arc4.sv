`timescale 1ps / 1ps
module tb_rtl_arc4();

    // Declare testbench variables
    logic clk;
    logic rst_n;
    logic en;
    logic [23:0] key;
    logic [7:0] ct_rddata;
    logic [7:0] pt_rddata;
    logic rdy;
    logic [7:0] ct_addr;
    logic [7:0] pt_addr;
    logic [7:0] pt_wrdata;
    logic pt_wren;

    // Instantiate the DUT (Device Under Test)
    arc4 dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .rdy(rdy),
        .key(key),
        .ct_addr(ct_addr),
        .ct_rddata(ct_rddata),
        .pt_addr(pt_addr),
        .pt_rddata(pt_rddata),
        .pt_wrdata(pt_wrdata),
        .pt_wren(pt_wren)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    // Initialize and apply stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        en = 0;
        key = 24'h123456;       // Example key
        ct_rddata = 8'h00;      // Initialize ciphertext data
        pt_rddata = 8'h00;      // Initialize plaintext data

        // Apply reset
        #10;
        rst_n = 1;
        #10;

        // Start encryption/decryption process
        en = 1;
        #10;
        en = 0;

        // Wait for the `rdy` signal to go low (indicating processing)
        wait(rdy == 0);
        $display("Processing started...");

        // Wait for the `rdy` signal to go high (indicating completion)
        wait(rdy == 1);
        $display("Processing completed!");

        // Add any additional checks for expected results here if necessary

        // End simulation
        #20;
        $stop;
    end

endmodule: tb_rtl_arc4
