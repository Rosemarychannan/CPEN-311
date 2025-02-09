`define zero 7'b1000000
`define one 7'b1111001
`define two 7'b0100100
`define three 7'b0110000
`define four 7'b0011001
`define five 7'b0010010
`define six 7'b0000010
`define seven 7'b1111000
`define eight 7'b0000000
`define nine 7'b0010000
`define a 7'b0001000
`define b 7'b0000011
`define c 7'b1000110
`define d 7'b0100001
`define e 7'b0000110
`define f 7'b0001110
`define na 7'b0111111
`define blank 7'b1111111

module task5(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
    logic [23:0] key;
    logic[7:0] CT_ADDR, CT_RDDATA, CT_WRDATA;
    logic CT_WREN=0,doublecrackEN=0, doublecrackRDY,doublecrackflag = 0,done = 0,KEY_VALID;
    logic [6:0] HEXx[5:0];
    assign LEDR[0] = doublecrackRDY;
    assign LEDR[2] = KEY_VALID;

    always_ff @(posedge CLOCK_50)begin
        if(!KEY[3]) doublecrackEN <= 1;
        else doublecrackEN <= 0;

        if(!doublecrackRDY) doublecrackflag <= 1;
        if(doublecrackRDY && doublecrackflag) done <=1;
    end
    assign HEX0 = done ? HEXx[0] : `blank;
    assign HEX1 = done ? HEXx[1] : `blank;
    assign HEX2 = done ? HEXx[2] : `blank;
    assign HEX3 = done ? HEXx[3] : `blank;
    assign HEX4 = done ? HEXx[4] : `blank;
    assign HEX5 = done ? HEXx[5] : `blank;

    SEG hex0(key[3:0],HEXx[0]);
    SEG hex1(key[7:4],HEXx[1]);
    SEG hex2(key[11:8],HEXx[2]);
    SEG hex3(key[15:12],HEXx[3]);
    SEG hex4(key[19:16],HEXx[4]);
    SEG hex5(key[23:20],HEXx[5]);

    ct_mem ct(.address(CT_ADDR), .clock(CLOCK_50), .data(CT_WRDATA), .wren(CT_WREN), .q(CT_RDDATA));
    doublecrack dc(.clk(CLOCK_50), .rst_n(KEY[3]), .en(doublecrackEN), .rdy(doublecrackRDY),.key(key), .key_valid(KEY_VALID),
    .ct_addr(CT_ADDR), .ct_rddata(CT_RDDATA));

    // your code here

endmodule: task5
module SEG(input logic [3:0] in,output logic [6:0] out);
    always_comb begin
        case(in)
            4'h0: out = `zero;
            4'h1: out = `one;
            4'h2: out = `two;
            4'h3: out = `three;
            4'h4: out = `four;
            4'h5: out = `five;
            4'h6: out = `six;
            4'h7: out = `seven;
            4'h8: out = `eight;
            4'h9: out = `nine;
            4'ha: out = `a;
            4'hb: out = `b;
            4'hc: out = `c;
            4'hd: out = `d;
            4'he: out = `e;
            4'hf: out = `f;
            default: out = `na;
        endcase
    end
endmodule: SEG