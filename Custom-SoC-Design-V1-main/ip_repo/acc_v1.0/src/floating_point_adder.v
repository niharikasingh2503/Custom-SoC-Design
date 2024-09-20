`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2024 13:53:56
// Design Name: 
// Module Name: floating_point_adder
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


module floating_point_adder(
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

reg [24:0] mantissa;
reg [7:0] exponent;
reg sign;

always @(*) begin
    mantissa1 = {1'b0, 1'b1, operand1[22:0]};
    mantissa2 = {1'b0, 1'b1, operand2[22:0]};
    exponent1 = operand1[30:23];
    exponent2 = operand2[30:23];
    sign1 = operand1[31];
    sign2 = operand2[31];
    
    if (exponent1>exponent2) begin
        exponent = exponent1;
        mantissa2 = mantissa2 >> (exponent1-exponent2);
    end 
    else begin
        exponent = exponent2;
        mantissa1 = mantissa1 >> (exponent2-exponent1);
    end

    if(mantissa1>mantissa2) begin
        sign = sign1;
        mantissa = (sign1==sign2)?(mantissa1+mantissa2):(mantissa1-mantissa2);
    end
    else begin
        sign = sign2;
        mantissa = (sign1==sign2)?(mantissa1+mantissa2):(mantissa2-mantissa1);
    end
    
    if(mantissa[24]==1) begin
        mantissa = mantissa >> 1;
        exponent = exponent + 1;
    end
    else if(mantissa[23]==0) begin
        mantissa = mantissa << 1;
        exponent = exponent - 1;
    end
    
    result = {sign, exponent, mantissa[22:0]};
end
endmodule
