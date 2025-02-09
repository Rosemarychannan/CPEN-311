module tb_datapath();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").
    // Testbench signals
    reg slow_clock;
    reg fast_clock;
    reg resetb;
    reg load_pcard1, load_pcard2, load_pcard3;
    reg load_dcard1, load_dcard2, load_dcard3;
    reg [3:0] pcard3_out, pscore_out, dscore_out;
    reg [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

    // Instantiate the datapath
    datapath dut (.*);

    // Clock generation
    initial begin
        slow_clock = 0;
        forever begin
            #5 slow_clock = ~slow_clock; // 100 MHz clock
        end
    end

    initial begin
        fast_clock = 0;
        forever #2 begin
            fast_clock = ~fast_clock; // 250 MHz clock
        end
    end

    initial begin
        // Initialize signals
        resetb = 0;
        load_pcard1 = 0;
        load_pcard2 = 0;
        load_pcard3 = 0;
        load_dcard1 = 0;
        load_dcard2 = 0;
        load_dcard3 = 0;

        // Reset the datapath
        #10;
        resetb = 1; // Release reset
        #10;

        // Load player card 1
        load_pcard1 = 1; 
        #10; 
        load_pcard1 = 0;

        // Load player card 2
        load_pcard2 = 1; 
        #10; 
        load_pcard2 = 0;

        // Load player card 3
        load_pcard3 = 1; 
        #10; 
        load_pcard3 = 0;

        // Load dealer card 1
        load_dcard1 = 1; 
        #10; 
        load_dcard1 = 0;

        // Load dealer card 2
        load_dcard2 = 1; 
        #10; 
        load_dcard2 = 0;

        // Load dealer card 3
        load_dcard3 = 1; 
        #10; 
        load_dcard3 = 0;

        // Check outputs
        #10;
        $display("Player Card 3: %b, Player Score: %b, Dealer Score: %b", pcard3_out, pscore_out, dscore_out);

        //can't really understand just from binary numbers but could be used as reference
        $display("HEX0: %b, HEX1: %b, HEX2: %b, HEX3: %b, HEX4: %b, HEX5: %b", HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

        // Finish simulation
        #20;
        $stop;
    end
endmodule
