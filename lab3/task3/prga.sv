module prga(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);
/// Needs to make comb purely comb, and initialize everything bleh
    logic high;
    logic [7:0] pad [255:0];
    logic [7:0] i,j,k,si,sj,msg_len,ctk,temp_si;
    logic [3:0] what;
    enum {WAIT,RDSi,RDSj,WRSi,WRSj,SETj,GETSj,MSG_LEN,GET_LEN,PADk,RDPADk, 
    PT_LEN,RDCTk, GETCTk, WRPTk} state;
    always_ff @(posedge clk)begin
        if(rst_n === 0) state <= WAIT;
        unique case(state)
            WAIT:begin
                i <= 0;
                j <= 0;
                k <= 1;
                si <=0;
                sj <=0;
                for (int z = 0; z < 256; z++) begin
                    pad[i] <= 8'h0; // Set each 8-bit element to a hexadecimal value
                end
                if(en) high <= 1;
                if(!en && high)begin 
                    high <= 0;
                    state <= MSG_LEN;
                end
            end
    //get message length, ct
            MSG_LEN:begin
                state <= GET_LEN;
            end
            GET_LEN:begin
                msg_len <= ct_rddata;
                state <=RDSi;
            end

    //for k = 1 to message_length:, s
            RDSi:begin
                if(msg_len != 0) begin 
                    i <= (i+1) % 256;
                end
                else state <= PT_LEN;
                state <=SETj;
            end
            SETj:begin
                si <= s_rddata;
                j <= (j + temp_si) % 256; 
                state <= RDSj;
            end
            RDSj:begin
                state <= GETSj;
            end
            GETSj:begin
                sj<=s_rddata;
                state <= WRSj;
            end
            WRSj:begin//set wren and addr
                state <= WRSi;
            end
            WRSi:begin
                state <= RDPADk;
            end
            RDPADk:begin
                state <= PADk;
            end
            PADk:begin
                pad[k] <= s_rddata;
                if(k<msg_len) begin
                    state <= RDSi;
                    k <= k + 1;
                end
                else begin
                    state <= PT_LEN;
                    k<=1;
                end
            end
    //plaintext[0] = message_length
            PT_LEN:begin
               state <= RDCTk;
            end
    /*for k = 1 to message_length:
        plaintext[k] = pad[k] xor ciphertext[k]  -- xor each byte*/
            RDCTk:begin
                state <= GETCTk;
            end
            GETCTk:begin
                ctk <= ct_rddata;
                state <= WRPTk;
            end
            WRPTk:begin
                if(k<msg_len) begin
                    state <= RDCTk;
                    k <= k + 1;
                end
                else state <= WAIT;
            end
            
        endcase 
    end
    always_comb begin
        // Default assignments
        s_wrdata = 8'b0;
        s_addr = 8'b0;
        s_wren = 1'b0;
        ct_addr = 8'b0;
        pt_wrdata = 8'b0;
        pt_addr = 8'b0;
        pt_wren = 1'b0;
        rdy = 1'b0;
        temp_si = 0;
        case(state)
            WAIT:begin
                s_wrdata = 0;
                s_addr = 0;
                rdy = 1;
                s_wren = 0;
            end
            MSG_LEN:begin
                ct_addr = i;
                rdy = 0;
            end
            GET_LEN:begin
                ct_addr = i;
                rdy = 0;
            end
            RDSi:begin
                s_wrdata = 1'bx;
                s_addr = (i+1) % 256;
                rdy = 0;
                s_wren = 0;
            end
            SETj:begin
                temp_si = s_rddata;
                s_wrdata = 1'bx;
                s_addr = i;
                rdy = 0;
                s_wren = 0;
            end
            RDSj:begin
                s_wrdata = 1'bx;
                s_addr = j;
                rdy = 0;
                s_wren = 0;
            end
            GETSj:begin
                s_wrdata = 1'bx;
                s_addr = j;
                rdy = 0;
                s_wren = 0;
            end
            WRSj:begin
                s_wrdata = si;
                s_addr = j;
                rdy = 0;
                s_wren = 1;
            end
            WRSi:begin
                s_wrdata = sj;
                s_addr = i;
                rdy = 0;
                s_wren = 1;
            end
            RDPADk:begin
                s_wrdata = 1'bx;
                s_addr = (sj+si) % 256;
                rdy = 0;
                s_wren = 0;
            end
            PADk:begin
                s_wrdata = 1'bx;
                s_addr = (sj+si) % 256;
                rdy = 0;
                s_wren = 0;
            end
            PT_LEN:begin
                pt_wrdata = msg_len;
                pt_addr = 0;
                rdy = 0;
                pt_wren = 1;
            end
            RDCTk:begin
                ct_addr = k;
                rdy = 0;
            end
            GETCTk:begin
                ct_addr = k;
                rdy = 0;
            end
            WRPTk:begin
                pt_wrdata = pad[k] ^ ctk;// ^ is xor in verilog
                pt_addr = k;
                rdy = 0;
                pt_wren = 1;
            end
        endcase
    end

endmodule: prga
