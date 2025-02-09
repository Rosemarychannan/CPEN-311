module datapath(input logic slow_clock, input logic fast_clock, input logic resetb,
                input logic load_pcard1, input logic load_pcard2, input logic load_pcard3,
                input logic load_dcard1, input logic load_dcard2, input logic load_dcard3,
                output logic [3:0] pcard3_out,
                output logic [3:0] pscore_out, output logic [3:0] dscore_out,
                output logic [6:0] HEX5, output logic [6:0] HEX4, output logic [6:0] HEX3,
                output logic [6:0] HEX2, output logic [6:0] HEX1, output logic [6:0] HEX0);

// The code describing your datapath will go here.  Your datapath 
// will hierarchically instantiate six card7seg blocks, two scorehand
// blocks, and a dealcard block.  The registers may either be instatiated
// or included as sequential always blocks directly in this file.
//
// Follow the block diagram in the Lab 1 handout closely as you write this code.

    //the connective wires
    wire [3:0]new_card,pcard1,pcard2,pcard3,pcard4,dcard1,dcard2,dcard3; 
    
    //generate cards
    dealcard Dealcard(fast_clock,resetb,new_card);

    //registers for storing cards
    reg4 PCard1(new_card,load_pcard1,resetb,slow_clock,pcard1);
    reg4 PCard2(new_card,load_pcard2,resetb,slow_clock,pcard2);
    reg4 PCard3(new_card,load_pcard3,resetb,slow_clock,pcard3_out);
    reg4 DCard1(new_card,load_dcard1,resetb,slow_clock,dcard1);
    reg4 DCard2(new_card,load_dcard2,resetb,slow_clock,dcard2);
    reg4 DCard3(new_card,load_dcard3,resetb,slow_clock,dcard3);

    //seven segment displays
    card7seg p1(pcard1,HEX0);
    card7seg p2(pcard2,HEX1);
    card7seg p3(pcard3_out,HEX2);
    card7seg d1(dcard1,HEX3);
    card7seg d2(dcard2,HEX4);
    card7seg d3(dcard3,HEX5);

    //score calculation
    scorehand player(pcard1,pcard2,pcard3_out,pscore_out);
    scorehand dealer(dcard1,dcard2,dcard3,dscore_out);

endmodule

module reg4 (input logic [3:0]in,input logic load,input logic reset,input logic clk,output logic [3:0]out);
    always_ff @(posedge clk) begin //sequential and always at rising edge of clock
        if(reset==0)//active-low reset
            out <= 4'b0000;
        else if(load)//if load is high then pass on value & strore
            out <= in;
        //do i need a else?
        //or this?
        //out = (~reset)?4'b0000:(load?in:out)
    end
endmodule

