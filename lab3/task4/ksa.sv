module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata, output logic [7:0] wrdata, output logic wren);

    logic high;
    logic [7:0] i,j,si,sj,key0,key1,key2,temp_si;
    logic [3:0] what;
    enum {WAIT,RDSi,RDSj,WRSi,WRSj} state;
    always_ff @(posedge clk)begin
        if(rst_n === 0) state <= WAIT;
        unique case(state)
            WAIT:begin
                i <= 0;
                j <= 0;
                si <=0;
                sj <=0;
                if(en) high <= 1;
                if(!en && high)begin 
                    high <= 0;
                    state <= RDSi;
                end
            end
            RDSi:begin
                state <= RDSj;
            end
            RDSj:begin
                si <= rddata;
                case (i % 3)
                    0: j <= (j + temp_si + key[23:16]) % 256; // uses the leftmost 4 bits
                    1: j <= (j + temp_si + key[15:8]) % 256;  // uses the middle 4 bits
                    2: j <= (j + temp_si + key[7:0]) % 256;  // uses the rightmost 4 bits
                endcase
                state <= WRSj;
            end
            WRSj:begin//set wren and addr
                sj<=rddata;
                state <= WRSi;
            end
            WRSi:begin
                if(i<255) begin
                    state <= RDSi;
                    i <= i+1;
                end
                else state <= WAIT;
            end
        endcase 
    end
    always_comb begin
        temp_si =rddata;
        wrdata = 0;
        addr = 0;
        rdy = 0;
        wren = 0;
        case(state)
            WAIT:begin
                wrdata <= 0;
                addr <= 0;
                rdy = 1;
                wren = 0;
            end
            RDSi:begin
                wrdata = 1'bx;
                addr = i;
                rdy = 0;
                wren = 0;
            end
            RDSj:begin
                temp_si =rddata;
                wrdata = 1'bx;
                case (i % 3)
                    0: addr <= (j + temp_si + key[23:16]) % 256; // uses the leftmost 4 bits
                    1: addr <= (j + temp_si + key[15:8]) % 256;  // uses the middle 4 bits
                    2: addr <= (j + temp_si + key[7:0]) % 256;  // uses the rightmost 4 bits
                endcase
                rdy = 0;
                wren = 0;
            end
            WRSj:begin
                wrdata = si;
                addr = j;
                rdy = 0;
                wren = 1;
            end
            WRSi:begin
                wrdata = sj;
                addr = i;
                rdy = 0;
                wren = 1;
            end
        endcase
    end
endmodule: ksa

