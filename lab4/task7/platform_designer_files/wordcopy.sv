module wordcopy(input logic clk, input logic rst_n,
                output logic slave_waitrequest,
                input logic [3:0] slave_address,
                input logic slave_read, output logic [31:0] slave_readdata,
                input logic slave_write, input logic [31:0] slave_writedata,
                input logic master_waitrequest,
                output logic [31:0] master_address,
                output logic master_read, input logic [31:0] master_readdata,
                input logic master_readdatavalid,
                output logic master_write, output logic [31:0] master_writedata);

    typedef enum logic [2:0] {WAIT, READ, STORE, WRITE, CHECK} state_t;
    state_t state;

    logic [31:0] destination, source, number, temp;

    // Synchronous block for state machine
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= WAIT;
            destination <= 0;
            source <= 0;
            number <= 0;
            temp <= 0;
        end else begin
            case (state)
                WAIT: begin
                    if(slave_write)begin
                        case (slave_address)
                            4'd0: if(number > 0) state <= READ;
                            4'd1: destination <= slave_writedata;
                            4'd2: source <= slave_writedata;
                            4'd3: number <= slave_writedata;
                        endcase
                    end
                end
                READ: begin
                    if (!master_waitrequest)
                        state <= STORE;
                end
                STORE: begin
                    if(master_readdatavalid)begin
                        temp <= master_readdata;
                        state <= WRITE;
                    end
                end
                WRITE: begin
                    if (!master_waitrequest)
                        state <= CHECK;
                end
                CHECK: begin
                    if (number > 1) begin
                        number <= number - 32'b1;
                        source <= source + 32'd4;
                        destination <= destination + 32'd4;
                        state <= READ;
                    end else begin
                        state <= WAIT;
                    end
                end
            endcase
        end
    end

    // Combinational logic block
    always_comb begin
        // Default assignments
        slave_waitrequest = 1'b1;
        slave_readdata = 32'b0;
        master_address = 32'b0;
        master_read = 1'b0;
        master_write = 1'b0;
        master_writedata = 32'b0;

        case (state)
            WAIT: begin
                slave_waitrequest = 0;
            end
            READ: begin
                    master_address = source;
                    master_read = 1'b1;
            end
            STORE: begin
                    master_address = source;
                    master_read = 1'b0;
            end
            WRITE: begin
                    master_address = destination;
                    master_write = 1'b1;
                    master_writedata = temp;
            end
            CHECK: begin
                    master_address = destination;
                    master_write = 1'b0;
                    master_writedata = temp;
            end
        endcase
    end

endmodule: wordcopy
