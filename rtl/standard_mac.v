// standard_mac.v
// Standard 8-bit signed Multiply-Accumulate unit
// acc = acc + (weight * in_data)

module standard_mac (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  weight_std,   // 8-bit signed weight
    input  wire [7:0]  in_data,      // 8-bit signed input data
    output reg  [31:0] acc_std       // 32-bit accumulator
);

    wire signed [15:0] product;
    
    assign product = $signed(weight_std) * $signed(in_data);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            acc_std <= 32'sd0;
        else
            acc_std <= acc_std + {{16{product[15]}}, product};
    end

endmodule
