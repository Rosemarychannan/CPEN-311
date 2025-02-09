module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here
    logic[7:0] ADDR,WRDATA,Q,ksaADDR,ksaWRDATA,initADDR,initWRDATA,
    prgaADDR,prgaWRDATA;
    logic WREN,ksaWREN,initWREN,initEN,ksaEN,ksaRDY,initRDY,
    prgaEN,prgaRDY,prgaWREN;
    logic high=0,startflag=0,initflag=0,ksaflag=0,prgaflag=0;
    /*assign LEDR[9] = initRDY;
    assign LEDR[7] = ksaRDY;
    assign LEDR[5] = prgaRDY;*/

    enum {WAIT,EXEC,DONE} state;
    always_ff @(posedge clk)begin
        if(rst_n === 0) state <= WAIT;
        unique case(state)
            WAIT:begin
                if(en) high <= 1;
                if(!en&& high)begin 
                    high <= 0;
                    state <= EXEC;
                    startflag<=1;
                end
            end
            EXEC:begin
                if(startflag) begin 
                    initEN <= 1;
                    startflag <=0;
                end                  ///something wrong here
                else initEN <= 0;

                if(!initRDY) initflag <= 1;

                if(initflag && initRDY) begin 
                    initflag <= 0;
                    ksaEN <=1;
                end
                else ksaEN <= 0;

                if(!ksaRDY) ksaflag <= 1;

                if(ksaflag && ksaRDY) begin 
                    ksaflag <= 0;
                    prgaEN <=1;
                end
                else prgaEN <= 0;

                if(!prgaRDY) prgaflag <= 1;

                if(prgaflag && prgaRDY) begin 
                    prgaflag <= 0;
                    state <= WAIT;
                end
                else state <= EXEC;
            end
        endcase 
    end
    always_comb begin
        case(state)
            WAIT: rdy = 1;
            EXEC: rdy = 0;
            default: rdy = 1;
        endcase
    end

    assign WREN = (initRDY & ksaRDY) ? prgaWREN:(initRDY ? ksaWREN : initWREN);
    assign ADDR = (initRDY & ksaRDY) ? prgaADDR:(initRDY ? ksaADDR : initADDR);
    assign WRDATA = (initRDY & ksaRDY) ? prgaWRDATA:(initRDY ? ksaWRDATA : initWRDATA);
    s_mem s(.address(ADDR), .clock(clk), .data(WRDATA), .wren(WREN), .q(Q));
    init i(.clk(clk), .rst_n(rst_n), .en(initEN), .rdy(initRDY),
        .addr(initADDR),.wrdata(initWRDATA),.wren(initWREN));
    ksa k(.clk(clk),.rst_n(rst_n),
        .en(ksaEN), .rdy(ksaRDY),
        .key(key), .addr(ksaADDR), .rddata(Q), .wrdata(ksaWRDATA), .wren(ksaWREN));
        
    prga p(.clk(clk), .rst_n(rst_n), .en(prgaEN), .rdy(prgaRDY),.key(key),.s_addr(prgaADDR),.s_rddata(Q),
    .s_wrdata(prgaWRDATA),.s_wren(prgaWREN),.ct_addr(ct_addr), .ct_rddata(ct_rddata), .pt_addr(pt_addr), .pt_rddata(pt_rddata), 
    .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));



    // your code here

endmodule: arc4
