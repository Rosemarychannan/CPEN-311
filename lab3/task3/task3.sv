module task3(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
    logic[7:0] CT_ADDR, CT_RDDATA, CT_WRDATA,
    PT_ADDR, PT_RDDATA, PT_WRDATA;

    logic CT_WREN=0,PT_WREN,arc4EN=0, arc4RDY;

    assign LEDR[0] = arc4RDY;

    always_ff @(posedge CLOCK_50)begin
        if(!KEY[3]) arc4EN <= 1;
        else arc4EN <= 0;
    end
           
    ct_mem ct(.address(CT_ADDR), .clock(CLOCK_50), .data(CT_WRDATA), .wren(CT_WREN), .q(CT_RDDATA));
    pt_mem pt(.address(PT_ADDR), .clock(CLOCK_50), .data(PT_WRDATA), .wren(PT_WREN), .q(PT_RDDATA));
    arc4 a4(.clk(CLOCK_50), .rst_n(KEY[3]),.en(arc4EN), .rdy(arc4RDY), .key({14'b0,SW[9:0]}),
    .ct_addr(CT_ADDR), .ct_rddata(CT_RDDATA), 
    .pt_addr(PT_ADDR), .pt_rddata(PT_RDDATA), .pt_wrdata(PT_WRDATA), .pt_wren(PT_WREN));

    // your code here

endmodule: task3
