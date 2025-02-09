module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);
    logic high;
    logic [7:0] i;
    enum {WAIT,EXEC,DONE} state;
    always_ff @(posedge clk)begin
        if(rst_n === 0) state <= WAIT;
        unique case(state)
            WAIT:begin
                i <= 0;
                if(en) high <= 1;
                if(!en&& high)begin 
                    high <= 0;
                    state <= EXEC;
                end
            end
            EXEC:begin
                if(i<=255) begin
                    if(addr<255) state<= EXEC;
                    else state <= DONE;
                    i <= i+1;
                end
            end
            DONE:begin
                state <= WAIT;
                i<=0;
            end
        endcase 
    end
    always_comb begin
        case(state)
            WAIT: begin
                wrdata <= 0;
                addr <= 0;
                if(!en&& high) rdy = 0;
                else rdy = 1;
                wren = 0;
            end
            EXEC:begin
                wrdata <= i;
                addr <= i;
                rdy = 0;
                if(en == 0)
                    wren = 1;
                else wren = 0;
            end
            DONE: begin
                wrdata <= 0;
                addr <= 0;
                rdy = 0;
                wren = 0;
            end
        endcase
    end

endmodule: init