module doublecrack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata);

    // your code here
    enum {WAIT, EXEC, RDpt, GETpt, WRpt} state;
    logic PT_WREN,crackEN,crackRDY1,crackRDY2,KEY_VALID1,KEY_VALID2,high,startflag,doneflag;
    logic [7:0] PT_ADDR, PT_WRDATA, PT_RDDATA,ct_addr1,ct_addr2,pt_rddata1,pt_rddata2,dcADDR,PT,i =0,len;
    logic [23:0] KEY1,KEY2;


    always_ff @(posedge clk)begin
        if (rst_n == 0) state <= WAIT;
        case(state)
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
                        crackEN <= 1;
                        startflag <=0;
                    end                  
                    else crackEN <= 0;

                    if(!crackRDY1 || !crackRDY2) doneflag <= 1;

                    if(doneflag && (crackRDY1 || crackRDY2)) begin 
                        doneflag <= 0;
                        if(KEY_VALID1 || KEY_VALID2)begin
                            state <= RDpt;
                            i <= 0;
                            if(KEY_VALID1) key<=KEY1;
                            else key <=KEY2;
                        end
                        else begin
                            state <= WAIT;
                            key <= 24'hx;
                        end
                    end
                    else state <= EXEC;
                end
                RDpt:begin// to write pt in correct crack into pt for double cracks
                    state <= GETpt;
                end
                GETpt:begin
                    if(KEY_VALID1)begin
                        if(i==0) len <= pt_rddata1;
                        PT<=pt_rddata1;
                        state <= WRpt;
                    end
                    else if(KEY_VALID2)begin
                        if(i==0) len <= pt_rddata2;
                        PT<=pt_rddata2;
                        state <= WRpt;
                    end
                end
                WRpt:begin//set wren and addr
                    if(i<len)
                        state <=RDpt;
                    else state <= WAIT;
                    i <= i+1;
                end
        endcase
    end
    always_comb begin
        dcADDR = i;
        PT_ADDR = i;
        PT_WRDATA =PT;
        PT_WREN = 0;
        case(state)
            WAIT: rdy = 1;
            EXEC: rdy = 0;
            RDpt:begin
                dcADDR = i;
                rdy = 0;
            end
            GETpt:begin
                dcADDR = i;
                rdy = 0;
            end
            WRpt:begin
                PT_ADDR = i;
                PT_WRDATA =PT;
                PT_WREN = 1;
                rdy = 0;
            end
        endcase
    end
    // this memory must have the length-prefixed plaintext if key_valid
    pt_mem pt(.address(PT_ADDR), .clock(clk), .data(PT_WRDATA), .wren(PT_WREN), .q(PT_RDDATA));

    // for this task only, you may ADD ports to crack
    crack c1(.clk(clk), .rst_n(rst_n), .en(crackEN), .rdy(crackRDY1), .key(KEY1), .key_valid(KEY_VALID1),
        .ct_addr(ct_addr1), .ct_rddata(ct_rddata),.pt_rddata(pt_rddata1),.dcADDR(dcADDR), .c1_or_c2(1'b0));
    crack c2(.clk(clk), .rst_n(rst_n), .en(crackEN), .rdy(crackRDY2), .key(KEY2), .key_valid(KEY_VALID2),
        .ct_addr(ct_addr2), .ct_rddata(ct_rddata),.pt_rddata(pt_rddata2),.dcADDR(dcADDR),.c1_or_c2(1'b1));

    assign ct_addr = (!KEY_VALID1 || !KEY_VALID1 && !KEY_VALID2) ? ct_addr1: ct_addr2;
    // your code here

endmodule: doublecrack
