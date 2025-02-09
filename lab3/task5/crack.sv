module crack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata,output logic [7:0] pt_rddata,
             input logic [7:0] dcADDR, input logic c1_or_c2);

    // For Task 5, you may modify the crack port list above,
    // but ONLY by adding new ports. All predefined ports must be identical.

    // your code here

    // this memory must have the length-prefixed plaintext if key_valid
    logic [23:0] KEY;
    logic [7:0] PT_ADDR,ADDR,PT_RDDATA,PT_WRDATA,WRDATA;
    logic PT_WREN,WREN,arc4RDY,arc4EN,high,startflag,arc4flag,asiiflag;
    assign pt_rddata = PT_RDDATA;
    // your code here
    enum {WAIT,EXEC,CHECK,DONE} state;
    always_ff @(posedge clk)begin
        if(rst_n === 0) state <= WAIT;
        unique case(state)
            WAIT:begin
                if(en) high <= 1;
                if(!en&& high)begin 
                    high <= 0;
                    state <= EXEC;
                    arc4flag <=0;
                    startflag<=1;
                    asiiflag<=1;
                    key_valid <= 0;
                    key <= 24'hx;
                    KEY = {23'h000000,c1_or_c2};
                end
            end
            EXEC:begin
                if(startflag) begin 
                    arc4EN <= 1;
                    startflag <=0;
                end                  
                else arc4EN <= 0;

                if(PT_WREN && (PT_WRDATA < 8'h20 || PT_WRDATA > 8'h7E) && ((PT_ADDR > 0)))
                    asiiflag <= 0;
                
                if(!arc4RDY) arc4flag <= 1;

                if(arc4flag && arc4RDY) begin 
                    arc4flag <= 0;
                    state <=CHECK;
                end
                else state <= EXEC;
            end
            CHECK:begin
                if(asiiflag)begin
                    key_valid <=1;
                    state <= DONE;
                    key <= KEY;
                end
                if(!asiiflag)begin
                    if(KEY < 24'hffffff)begin
                        state <= EXEC;
                        startflag <= 1;
                        KEY <= KEY + 2;
                        asiiflag <= 1;
                    end
                    else begin
                        state <= DONE;
                    end
                end
            end
            DONE:begin //useless state
                state <= WAIT;
            end
        endcase 
    end
    always_comb begin
        case(state)
            WAIT:rdy = 1;
            EXEC: rdy = 0;
            CHECK: rdy = 0;
            DONE: rdy = 0;
        endcase
    end
    // your code here
    assign ADDR = key_valid ? dcADDR : PT_ADDR;
    assign WREN = key_valid ? 0 : PT_WREN;
    // this memory must have the length-prefixed plaintext if key_valid
    pt_mem pt(.address(ADDR), .clock(clk), .data(PT_WRDATA), .wren(WREN), .q(PT_RDDATA));
    arc4 a4(.clk(clk), .rst_n(rst_n), .en(arc4EN), .rdy(arc4RDY), .key(KEY),
        .ct_addr(ct_addr), .ct_rddata(ct_rddata), .pt_addr(PT_ADDR), .pt_rddata(PT_RDDATA), .pt_wrdata(PT_WRDATA), 
        .pt_wren(PT_WREN));


    // your code here

endmodule: crack
