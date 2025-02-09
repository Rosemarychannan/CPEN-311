module tb_scorehand();
    reg [3:0] card1, card2, card3;//input
    reg [3:0] total;//output

        // Instantiate the scorehand module
        scorehand dut (.*);
// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").
    // Test cases
    initial begin
        // 1+2+3=6,normal
        card1 = 4'b0001; // 1
        card2 = 4'b0010; // 2
        card3 = 4'b0011; // 3
        #10;
        $display("Test Case 1: card1=%b, card2=%b, card3=%b -> total=%b, expected: 6",card1, card2, card3, total);

        // one value > 9
        card1 = 4'b0001; // 1
        card2 = 4'b1001; // 9
        card3 = 4'b0001; // 1
        #10;
        $display("Test Case 2: card1=%b, card2=%b, card3=%b -> total=%b,EXPECTED 1", card1, card2, card3, total); 

        //all > 9
        card1 = 4'b1010; // 10
        card2 = 4'b1011; // 11
        card3 = 4'b1100; // 12
        #10;
        $display("Test Case 3: card1=%b, card2=%b, card3=%b -> total=%b, expected 3", card1, card2, card3, total);

        // mixed
        card1 = 4'b0001; // 1
        card2 = 4'b0011; // 3
        card3 = 4'b1001; // 9
        #10;
        $display("Test Case 4: card1=%b, card2=%b, card3=%b -> total=%b,expected 4", card1, card2, card3, total);

        // edge case, 10
        card1 = 4'b0100; // 4
        card2 = 4'b0100; // 4
        card3 = 4'b0010; // 2
        #10;
        $display("Test Case 5: card1=%b, card2=%b, card3=%b -> total=%b, expected 0", card1, card2, card3, total);

        // End of testbench
        #10;
        $stop;
    end
endmodule
