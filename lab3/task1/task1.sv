module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
    logic[7:0] ADDR,WRDATA;
    logic WREN,EN,Q;
    always_ff @(posedge CLOCK_50)begin
        if(!KEY[3]) EN = 1;
        else EN = 0;
    end
    s_mem s(.address(ADDR), .clock(CLOCK_50), .data(WRDATA), .wren(WREN), .q(Q));
    init Init(.clk(CLOCK_50), .rst_n(KEY[3]), .en(EN), .rdy(LEDR[9]),
        .addr(ADDR),.wrdata(WRDATA),.wren(WREN));

    // your code here

endmodule: task1
