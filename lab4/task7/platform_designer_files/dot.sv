module dot(input logic clk, input logic rst_n,
           // slave (CPU-facing)
           output logic slave_waitrequest,
           input logic [3:0] slave_address,
           input logic slave_read, output logic [31:0] slave_readdata,
           input logic slave_write, input logic [31:0] slave_writedata,
           // master (memory-facing)
           input logic master_waitrequest,
           output logic [31:0] master_address,
           output logic master_read, input logic [31:0] master_readdata, input logic master_readdatavalid,
           output logic master_write, output logic [31:0] master_writedata);

    enum logic [2:0] {WAIT, READw, STOREw, READa, STOREa, CHECK} state;

    logic [31:0] w_addr,a_addr,a_len;
    logic signed [31:0] w_data, a_data,sum,sum_reg;
    logic signed [63:0] product;

    // Synchronous block for state machine
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= WAIT;
            w_addr <= 0;
            a_addr <= 0;    
            w_data <= 0;
            a_data <= 0;
            a_len <=0;
            sum <= 0;  
        end else begin
            case (state)
                WAIT: begin
                    if(slave_write)begin
                        case (slave_address)
                            4'd0: if(a_len > 0)state <= READw;
                            4'd2: w_addr <= slave_writedata;
                            4'd3: a_addr <= slave_writedata;
                            4'd5: a_len <= slave_writedata;
                        endcase
                    end    
                    w_data <= 0;
                    a_data <= 0;
                    sum <= 0;  
                end
                READw: begin
                    if (!master_waitrequest)
                        state <= STOREw;
                end
                STOREw: begin
                    if(master_readdatavalid)begin
                        w_data <= master_readdata;
                        state <= READa;
                    end
                end
                READa: begin
                    if (!master_waitrequest)
                        state <= STOREa;
                end
                STOREa: begin
                    if(master_readdatavalid)begin
                        a_data <= master_readdata;
                        state <= CHECK;
                    end
                end
                CHECK: begin
                    if (a_len > 1) begin
                        a_len <= a_len - 32'b1;
                        w_addr <= w_addr + 32'd4;
                        a_addr <= a_addr + 32'd4;
                        state <= READw;
                    end else begin
                        state <= WAIT;
                        sum_reg <= sum + product[47:16];
                    end
                    sum <= sum + product[47:16];
                end
            endcase
        end
    end

    // Combinational logic block
    always_comb begin
        // Default assignments
        slave_waitrequest = 1'b1;
        master_address = 32'b0;
        master_read = 1'b0;
        master_write = 1'b0;
        master_writedata = 32'b0;
        slave_readdata =32'b0;
        product = 64'b0;
        case (state)
            WAIT: begin
                slave_waitrequest = 0;
                slave_readdata = sum_reg;
            end
            READw: begin
                master_address = w_addr;
                master_read = 1'b1;
            end
            STOREw: begin
                master_address = w_addr;
                master_read = 1'b0;
            end
            READa: begin
                master_address = a_addr;
                master_read = 1'b1;
            end
            STOREa: begin
                master_address = a_addr;
                master_read = 1'b0;
            end
            CHECK: begin
                master_address = a_addr;
                master_read = 1'b0;
                product = w_data * a_data;
            end
        endcase
    end

endmodule: dot
