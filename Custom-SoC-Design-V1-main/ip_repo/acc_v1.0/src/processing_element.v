`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 02:41:11
// Design Name: 
// Module Name: processing_element
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


module processing_element(
    input clk,
    input mode,
    input reset,
    input [31:0] conn,
    input [31:0] data,
    input [31:0] weight,
    output [31:0] result
);

reg [31:0] temp;
wire [31:0] add_w1, add_w2, add_w3;
wire [31:0] mul_w1, mul_w2, mul_w3;
floating_point_adder add (.operand1(add_w1), .operand2(add_w2), .result(add_w3));
floating_point_multiplier mul (.operand1(mul_w1), .operand2(mul_w2), .result(mul_w3));

assign result = temp;
assign add_w1 = temp;
assign mul_w1 = data;
assign add_w2 = mul_w3;
assign mul_w2 = weight;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        temp = 0;
    end
    else if (mode) begin
        temp = conn;
    end
    else if (!mode) begin
        temp = add_w3;
    end
end

endmodule
