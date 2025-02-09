module task2(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);
    logic[7:0] ADDR,WRDATA,Q,ksaADDR,ksaWRDATA,initADDR,initWRDATA;
    logic ksaWREN,initWREN,initEN,ksaEN,ksaRDY,initRDY,flag,WREN;
    assign LEDR[9] = initRDY;
    assign LEDR[7] = ksaRDY;
    always_ff @(posedge CLOCK_50)begin
        if(!KEY[3]) initEN <= 1;
        else initEN <= 0;
        if(!initRDY) flag <= 1;
        if(flag && initRDY) begin 
            flag <= 0;
            ksaEN <=1;
        end
        else ksaEN <= 0;
    end
    assign WREN = initRDY ? ksaWREN : initWREN;
    assign ADDR = initRDY ? ksaADDR : initADDR;
    assign WRDATA = initRDY ? ksaWRDATA : initWRDATA;
    s_mem s(.address(ADDR), .clock(CLOCK_50), .data(WRDATA), .wren(WREN), .q(Q));
    init Init(.clk(CLOCK_50), .rst_n(KEY[3]), .en(initEN), .rdy(initRDY),
        .addr(initADDR),.wrdata(initWRDATA),.wren(initWREN));
    ksa Ksa(.clk(CLOCK_50),.rst_n(KEY[3]),
           .en(ksaEN), .rdy(ksaRDY),
           .key({14'b0,SW[9:0]}), .addr(ksaADDR), .rddata(Q), .wrdata(ksaWRDATA), .wren(ksaWREN));
endmodule: task2
