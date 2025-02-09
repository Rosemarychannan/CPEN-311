`define SA 4'b0001
`define SB 4'b0010
`define SC 4'b0011
`define SD 4'b0100
`define SE 4'b0101
`define SF 4'b0110
`define SG 4'b0111
`define SH 4'b1000
`define SI 4'b1001
`define SJ 4'b1010
`define Sdone 5'b1111

module statemachine(input logic slow_clock, input logic resetb,
                    input logic [3:0] dscore, input logic [3:0] pscore, input logic [3:0] pcard3,
                    output logic load_pcard1, output logic load_pcard2, output logic load_pcard3,
                    output logic load_dcard1, output logic load_dcard2, output logic load_dcard3,
                    output logic player_win_light, output logic dealer_win_light);
    reg[3:0] state;
// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.
    always_ff @(posedge slow_clock) begin//state transition logic
        if(resetb==0)
            state = `SA;
        else begin
            case(state)
                `SA: state = `SB;//just transition based on slow clock
                `SB: state = `SC;
                `SC: state = `SD;
                `SD: if((pscore >= dscore) && (pscore >= 8))//conditions for transitioning after the dealer 2 card
                        if(pscore == dscore)
                            state = `SG;
                        else
                            state = `SE;

                    else if((dscore > pscore) && (dscore >= 8))//winning condition for dealer or dealer and player
                        state = `SF;
                    else if(pscore<=5)//if player score is smaller than5, transition and give one more cacrd to layer
                        state = `SH;
                    else if(pscore == 6 || pscore == 7)begin
                        if(dscore<=5)
                            state = `SI;
                        else begin              //just a compare block, will be copy pasted, sends to winning signal.
                                if(dscore>pscore)
                                    state = `SF;
                                else if(pscore>dscore)
                                    state = `SE;
                                else
                                    state = `SG;
                            end
                    end
                `SH:if((dscore == 6 && (pcard3 == 6 || pcard3 == 7))||//transitioning depending on player card 3,
                    (dscore == 5 &&(pcard3>=4 && pcard3 <=7))||
                    (dscore == 4 &&(pcard3>=2 && pcard3 <=7))||
                    (dscore == 4 &&(pcard3!=8))||dscore == 0||
                    dscore == 1||dscore == 2)
                        state = `SI;
                    else begin
                            if(dscore>pscore)
                                state = `SF;
                            else if(pscore>dscore)
                                state = `SE;
                            else
                                state = `SG;
                        end  
/*
                    else if(dscore == 7)begin
                            if(dscore>pscore)
                                state = `SF;
                            else if(pscore>dscore)
                                state = `SE;
                            else
                                state = `SG;
                        end  
                    else if(dscore == 6)begin
                            if(pcard3 == 6 || pcard3 == 7)
                                state = `SI;
                            else begin
                                if(dscore>pscore)
                                    state = `SF;
                                else if(pscore>dscore)
                                    state = `SE;
                                else
                                    state = `SG;
                            end
                        end
                    else if(dscore == 5)begin
                            if(pcard3 == 4 || pcard3 == 5 || pcard3 == 6 || pcard3 == 7)
                                state = `SI;
                            else begin
                                if(dscore>pscore)
                                    state = `SF;
                                else if(pscore>dscore)
                                    state = `SE;
                                else
                                    state = `SG;
                            end
                        end
                    else if(dscore == 4)begin
                            if(pcard3 == 2 || pcard3 == 3 ||pcard3 == 4 || pcard3 == 5 || pcard3 == 6 || pcard3 == 7)
                                state = `SI;
                            else begin
                                if(dscore>pscore)
                                    state = `SF;
                                else if(pscore>dscore)
                                    state = `SE;
                                else
                                    state = `SG;
                            end
                        end
                    else if(dscore == 3)begin
                            if(pcard3 != 8)
                                state = `SI;
                            else begin
                                if(dscore>pscore)
                                    state = `SF;
                                else if(pscore>dscore)
                                    state = `SE;
                                else
                                    state = `SG;
                            end
                        end
                    else //when dscore = 1,0,2
                        state = `SI;
*/
                `SI:begin
                        if(dscore>pscore)
                            state = `SF;
                        else if(pscore>dscore)
                            state = `SE;
                        else
                            state = `SG;
                    end
            endcase
        end
    end
    always_comb begin//output logic
        //initialize all output
        load_pcard1 = 1'b0;
        load_pcard2 = 1'b0;
        load_pcard3 = 1'b0;
        load_dcard1 = 1'b0;
        load_dcard2 = 1'b0;
        load_dcard3 = 1'b0;
        player_win_light = 1'b0;
        dealer_win_light = 1'b0;

        case(state)
            `SA: begin
                load_pcard1 = 1'b1;
                load_pcard2 = 1'b0;
                load_pcard3 = 1'b0;
                load_dcard1 = 1'b0;
                load_dcard2 = 1'b0;
                load_dcard3 = 1'b0;
                player_win_light = 1'b0;
                dealer_win_light = 1'b0;
            end
            `SB: begin
                load_pcard1 = 1'b0;
                load_dcard1 = 1'b1;
            end
            `SC: begin
                load_dcard1 = 1'b0;
                load_pcard2 = 1'b1;
            end
            `SD: begin
                load_pcard2 = 1'b0;
                load_dcard2 = 1'b1;
            end
            `SE: begin
                load_dcard2 = 1'b0;
                load_pcard3 = 1'b0;
                load_dcard3 = 1'b0;
                player_win_light = 1'b1;
            end
            `SF: begin
                load_dcard2 = 1'b0;
                load_pcard3 = 1'b0;
                load_dcard3 = 1'b0;
                dealer_win_light = 1'b1;
            end
            `SG: begin
                load_dcard2 = 1'b0;
                load_pcard3 = 1'b0;
                load_dcard3 = 1'b0;
                player_win_light = 1'b1;
                dealer_win_light = 1'b1;
            end
            `SH: begin
                load_dcard2 = 1'b0;
                load_pcard3 = 1'b1;
            end
            `SI: begin
                load_dcard2 = 1'b0;
                load_dcard3 = 1'b1;
                load_pcard3 = 1'b0;
            end
        endcase
    end

endmodule


