module tb_task5();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 100,000 ticks (equivalent to "initial #100000 $finish();").
    reg CLOCK_50;
    reg [3:0] KEY; 
    reg [9:0] LEDR;
    reg [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
    task5 dut(.*); // instantiate task 4 with wildcard since all names match

    initial forever begin
    CLOCK_50 = 0; #5;
    CLOCK_50 = 1; #5;
    end

//reset to initial state
    initial begin
        KEY[3] = 1'b0;
        #10;
        KEY[0] = 1'b0;
        #10;
        KEY[0] = 1'b1;
        #10;
        KEY[3] = 1'b1;

        #50;
        #50;
        KEY[0] = 1'b0;
        #20;
        KEY[0] = 1'b1;

        #50;
        #50;
        KEY[0] = 1'b0;
        #20;
        KEY[0] = 1'b1;

        //player 1 card
        #53;
        KEY[0] = 1'b0;
        #20;
        KEY[0] = 1'b1;
        $display("pcard1score: %d",LEDR[3:0]);

        //dealer 1 card
        #56;
        KEY[0] = 1'b0;
        #20;
        KEY[0] = 1'b1;
        $display("dcard1score: %d",LEDR[7:4]);

        //player 2 card
        #50;
        KEY[0] = 1'b0;
        #20;
        KEY[0] = 1'b1;
        $display("pcard2score: %d",LEDR[3:0]);

        //dealer 2 card
        #50;
        KEY[0] = 1'b0;
        #20;
        KEY[0] = 1'b1;
        $display("dcard2score: %d",LEDR[7:4]);
//starting from here it does not nessasarily execute, but should keep original value if met early.
        //player 3 card
        #50;
        KEY[0] = 1'b0;
        #20;
        KEY[0] = 1'b1;
        $display("pcard3score: %d",LEDR[3:0]);

        //dealer 3 card
        #50;
        KEY[0] = 1'b0;
        #20;
        KEY[0] = 1'b1;
        $display("dcard3score: %d",LEDR[7:4]);

        //winning logic
        #50;
        KEY[0] = 1'b0;
        #20;

        #50;
        KEY[0] = 1'b0;
        #20;
        KEY[0] = 1'b1;

                KEY[0] = 1'b1;
        $display("pscore: %d",LEDR[3:0]);
        $display("dscore: %d",LEDR[7:4]);
        $display("Player win %d, Dealer win %d",LEDR[8],LEDR[9]);
        $stop;
    end
endmodule
