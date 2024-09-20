`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2024 01:00:02
// Design Name: 
// Module Name: systolic_array_tb
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
`include "parameters.vh"

module systolic_array_tb ();

reg clk;
reg mode;
reg reset;
reg [0:`PE_ROW * 32 - 1] data;
reg [0:`PE_COL * 32 - 1] weight;
wire [0:`PE_ROW * 32 - 1] result;

systolic_array sa (
    .clk(clk), 
    .mode(mode), 
    .reset(reset), 
    .data(data), 
    .weight(weight), 
    .result(result)
);

integer i, j;
initial begin
    clk = 0;
    mode = 0;
    reset = 0;
    for (i = 0; i < `PE_ROW; i = i + 1) begin
        data[i*32 +: 32] = 32'b01000001001000000000000000000000;
    end
    for (j = 0; j < `PE_COL; j = j + 1) begin
        weight[j*32 +: 32] = 32'b01000000101000000000000000000000;
    end
    reset = 0;
    #5 reset = 1;
    #5 reset = 0;
    #100 $finish;
end

always begin
    #5 clk = ~clk;
end

initial begin
    $monitor("result[0] is %b", result[0 +: 32]);
end

endmodule
