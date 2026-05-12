// tb_macs.v
// Functional equivalence testbench for standard vs ternary MAC

`timescale 1ns/1ps

module tb_macs;
    reg        clk;
    reg        rst_n;
    reg  [7:0] weight_std;
    reg  [1:0] weight_tern;
    reg  [7:0] in_data;
    wire [31:0] acc_std;
    wire [31:0] acc_tern;

    standard_mac uut_std (
        .clk(clk),
        .rst_n(rst_n),
        .weight_std(weight_std),
        .in_data(in_data),
        .acc_std(acc_std)
    );

    ternary_mac uut_tern (
        .clk(clk),
        .rst_n(rst_n),
        .weight_tern(weight_tern),
        .in_data(in_data),
        .acc_tern(acc_tern)
    );

    always #5 clk = ~clk;

    integer i, fails;
    initial begin
        clk = 0; rst_n = 0; fails = 0;
        weight_std = 0; weight_tern = 0; in_data = 0;
        #10 rst_n = 1; #10;

        $display("=== Functional Equivalence Test ===");

        // Test +1 weight
        for (i = 0; i < 10; i = i + 1) begin
            weight_std = 8'sd1;
            weight_tern = 2'b01;
            in_data = $random;
            @(posedge clk); #1;
            if (acc_std !== acc_tern) begin
                $display("FAIL t=%0t: std=%0d tern=%0d", $time, acc_std, acc_tern);
                fails = fails + 1;
            end
        end

        // Test 0 weight
        for (i = 0; i < 10; i = i + 1) begin
            weight_std = 8'sd0;
            weight_tern = 2'b10;
            in_data = $random;
            @(posedge clk); #1;
            if (acc_std !== acc_tern) begin
                $display("FAIL t=%0t: std=%0d tern=%0d", $time, acc_std, acc_tern);
                fails = fails + 1;
            end
        end

        // Test -1 weight
        for (i = 0; i < 10; i = i + 1) begin
            weight_std = -8'sd1;
            weight_tern = 2'b11;
            in_data = $random;
            @(posedge clk); #1;
            if (acc_std !== acc_tern) begin
                $display("FAIL t=%0t: std=%0d tern=%0d", $time, acc_std, acc_tern);
                fails = fails + 1;
            end
        end

        // Mixed test with random weights
        for (i = 0; i < 10; i = i + 1) begin
            weight_std = ($random % 2) ? 8'sd1 : -8'sd1;
            weight_tern = (weight_std == 8'sd1) ? 2'b01 : 2'b11;
            in_data = $random;
            @(posedge clk); #1;
            if (acc_std !== acc_tern) begin
                $display("FAIL t=%0t: std=%0d tern=%0d", $time, acc_std, acc_tern);
                fails = fails + 1;
            end
        end

        if (fails == 0)
            $display("ALL TESTS PASSED. Final acc_std=%0d acc_tern=%0d", acc_std, acc_tern);
        else
            $display("FAILED %0d tests", fails);

        $finish;
    end
endmodule
