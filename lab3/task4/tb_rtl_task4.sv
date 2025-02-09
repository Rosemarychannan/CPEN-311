`timescale 1ps/1ps
module tb_rtl_task4();


    // Declarations
    logic CLOCK_50;
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0] LEDR;
    logic [7:0] ct_mem [0:255];

    // Instantiate task3 and arc4 modules
    task4 dut (.*);
    
    initial begin 
    CLOCK_50 = 0; #1;
        forever begin
        CLOCK_50 = 1; #1;
        CLOCK_50 = 0; #1;
        end
    end

    initial begin
        // Load ciphertext from file
        $readmemh("C:/2024_25/CPEN_311/Lab3/lab-3-lab3-l1a-14/task3/test2.memh", dut.ct.altsyncram_component.m_default.altsyncram_inst.mem_data);
        KEY[3] = 1;

        // Apply reset
        #10 KEY[3] = 0;
        #10 KEY[3] = 1;

        // Wait for decryption to complete
        wait (dut.done == 1);
        #40;
        $stop;
    end

endmodule: tb_rtl_task4
