module tb_statemachine();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").
    statemachine dut(.*);
    reg slow_clock, resetb;
    reg [3:0] dscore, pscore, pcard3;
    reg load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light;

    initial begin//test bench

        resetb = 1'b0;//reset to ensure starting on correct stage
        #10;
        slow_clock = 1'b0; //manually clock to ensure every stage is check-able
        #10;
        slow_clock = 1'b1;
        #10;
        resetb = 1'b1;
        $display("reset");
       
        //lets state machine go to when desition needs to be made (SD)
        repeat(3) begin
            dscore = 4'b0000;
            pscore = 4'b0000;
            #10 slow_clock = 1'b0;  
            #10 slow_clock = 1'b1; 
            $display("load_pcard:%b%b%b,load_dcard:%b%b%b,player win:%d,dealer win:%d",load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light);
        end

        //checking if transitions works

        //2nd card all dealt, 0<=player<=5, player get third card
        pscore = 4'b0100;
        dscore = 4'b0011;//assuming from before, didn't add earlier as its not needed
        pcard3 = 4'b0011;
        #10;
        slow_clock = 1'b0;
        #10;
        slow_clock = 1'b1;
        $display("load_pcard:%b%b%b,load_dcard:%b%b%b,player win:%d,dealer win:%d",load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light);
        $display("pscore:%b,dscore%b, pcard3",pscore,dscore);
        //all cards dealt, bscore = 3 and pcard3 != 8, dealer gets card 3
 
        pscore = 4'b0111; //third card is 3,just updated
        dscore = 4'b0011; 
        #10;
        slow_clock = 1'b0;
        #10
        slow_clock = 1'b1;
        $display("load_pcard:%b%b%b,load_dcard:%b%b%b,player win:%d,dealer win:%d",load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light);
        $display("pscore:%b,dscore%b, pcard3:%b,dcard3",pscore,dscore,pcard3);
        //all score updated
        dscore = 4'b1001; //third card is 6
        pscore = 4'b0111; // updated last time
        #10;
        slow_clock = 1'b0;
        #10
        slow_clock = 1'b1;
        $display("load_pcard:%b%b%b,load_dcard:%b%b%b,player win:%d,dealer win:%d",load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light);
        $display("pscore:%b,dscore%b,dealer win",pscore,dscore,pcard3);
    end
endmodule
