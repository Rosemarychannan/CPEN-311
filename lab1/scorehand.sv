module scorehand(input logic [3:0] card1, input logic [3:0] card2, input logic [3:0] card3, output logic [3:0] total);

// The code describing scorehand will go here.  Remember this is a combinational
// block. The function is described in the handout. Be sure to review Verilog
// notes on bitwidth mismatches and signed/unsigned numbers.
    logic [3:0]card1val,card2val,card3val; //to hold the values of the cards
    logic [4:0]sum; //to do intermediate calculations
    always_comb begin
        //assigning value to each card
        card1val = (card1 >= 10) ? 4'b0000 : card1;
        card2val = (card2 >= 10) ? 4'b0000 : card2;
        card3val = (card3 >= 10) ? 4'b0000 : card3;

        //adding card 1 and 2, if it >=10 then only take one digit
        sum = (card1val + card2val >= 10) ? (card1val + card2val - 4'b1010) : (card1val + card2val);
        //adding the sum from card 1+1 and now +3, if it >=10 then only take one digit
        sum = (sum + card3val >= 10) ? (sum + card3val - 4'b1010) : (sum + card3val);
        
        //orrrr
        //sum = (card1val+card2val+card3val >= 20)?(card1val+card2val+card3val - 20):((card1val+card2val+card3val >= 10)?(card1val+card2val+card3val - 10):(card1val+card2val+card3val))
        //too long lol
        
        //assinging output
        total = sum[3:0];
    end
endmodule


