// ternary_mac.v
// Ternary {-1, 0, +1} Multiply-Accumulate unit
// No multiplier needed - just MUX + add/subtract

module ternary_mac (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [1:0]  weight_tern,  // 2-bit ternary: 00=invalid, 01=+1, 10=0, 11=-1
    input  wire [7:0]  in_data,      // 8-bit signed input data
    output reg  [31:0] acc_tern      // 32-bit accumulator
);

    reg signed [31:0] delta;

    always @(*) begin
        case (weight_tern)
            2'b01:   delta = {{24{in_data[7]}}, in_data};         // +1: add input
            2'b10:   delta = 32'sd0;                               //  0: no change
            2'b11:   delta = -{{24{in_data[7]}}, in_data};        // -1: subtract input
            default: delta = 32'sd0;                               // invalid: treat as 0
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            acc_tern <= 32'sd0;
        else
            acc_tern <= acc_tern + delta;
    end

endmodule
