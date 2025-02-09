module tb_rtl_task3();
    // Inputs to task3
    logic CLOCK_50;
    logic [3:0] KEY;
    logic [9:0] SW;

    // Outputs from task3
    logic [9:0] LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [7:0] VGA_R, VGA_G, VGA_B;
    logic VGA_HS, VGA_VS, VGA_CLK;
    logic [7:0] VGA_X;
    logic [6:0] VGA_Y;
    logic [2:0] VGA_COLOUR;
    logic VGA_PLOT;

    // Instantiate the module under test (MUT)
    task3 uut (
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
        .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
        .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_CLK(VGA_CLK),
        .VGA_X(VGA_X), .VGA_Y(VGA_Y), .VGA_COLOUR(VGA_COLOUR), .VGA_PLOT(VGA_PLOT)
    );

    // Clock generation
    initial begin
        CLOCK_50 = 0;
        forever #10 CLOCK_50 = ~CLOCK_50;  // 50 MHz clock
    end

    // Stimulus generation
    initial begin
        // Initialize all inputs
        KEY = 4'b1111;  // All keys unpressed (active-low logic)
        SW = 10'b0000000000;  // No switches activated

        // Wait for global reset
        #100;

        // Simulate pressing KEY[3] to start the fillscreen process
        KEY[3] = 1'b0;  // Press KEY[3]
        #20;
        KEY[3] = 1'b1;  // Release KEY[3]

        // Run simulation for a while to observe waveforms
        #50000;

        // End simulation
        $finish;
    end
endmodule: tb_rtl_task3
