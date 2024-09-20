`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 10:37:45
// Design Name: 
// Module Name: systolic_array
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

module systolic_array (
    input clk,
    input mode,
    input reset,
    input [0:`PE_ROW * 32 - 1] data,
    input [0:`PE_COL * 32 - 1] weight,
    output reg [0:`PE_ROW * 32 - 1] result
);

wire [31:0] hor [0:`PE_ROW-1][0:`PE_COL];

genvar i, j;
generate
    for (i = 0; i < `PE_ROW; i = i + 1) begin
        for (j = 0; j < `PE_COL; j = j + 1) begin
            processing_element pe (
                .clk(clk),
                .mode(mode),
                .reset(reset),
                .conn(hor[i][j]),
                .data(data[i*32 +: 32]),
                .weight(weight[j*32 +: 32]),
                .result(hor[i][j+1])
            );
        end
    end
endgenerate

integer k;
always @(*) begin
    for (k = 0; k < `PE_ROW; k = k + 1) begin
        result[k*32 +: 32] = hor[k][`PE_COL];
    end
end

endmodule
