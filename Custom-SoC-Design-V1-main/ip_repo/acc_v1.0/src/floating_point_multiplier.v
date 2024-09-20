`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2024 23:16:16
// Design Name: 
// Module Name: floating_point_multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module floating_point_multiplier(
    input wire [31:0] operand1,
    input wire [31:0] operand2,
    output reg [31:0] result
);
reg [24:0] mantissa1;
reg [24:0] mantissa2;
reg [7:0] exponent1;
reg [7:0] exponent2;
reg sign1;
reg sign2;

reg [47:0] mantissa;
reg [7:0] exponent;
reg sign;

always @(*) begin
    mantissa1 = {1'b0, 1'b1, operand1[22:0]};
    mantissa2 = {1'b0, 1'b1, operand2[22:0]};
    exponent1 = operand1[30:23];
    exponent2 = operand2[30:23];
    sign1 = operand1[31];
    sign2 = operand2[31];
    
    mantissa = mantissa1 * mantissa2;
    exponent = exponent1 + exponent2 - 8'd127;
    sign = sign1 ^ sign2;
    
    if(mantissa[47]==1) begin
        mantissa = mantissa >> 1;
        exponent = exponent + 1;
    end
    
    result = {sign, exponent, mantissa[45:23]};
end
endmodule
