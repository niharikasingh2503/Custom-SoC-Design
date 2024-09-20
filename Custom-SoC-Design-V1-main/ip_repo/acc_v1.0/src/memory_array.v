`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2024 00:56:16
// Design Name: 
// Module Name: memory_array
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

module memory_array #(
    parameter MM_HGT = `MM_HGT,
    parameter MM_WDT = `MM_WDT
)(
    input clk,
    input load,
    input reset,
    input enable,
    input [31:0] data,
    input [0:MM_HGT-1] sel,
    output [0:MM_HGT * 32 - 1] result
);

reg [31:0] mem [0:MM_HGT-1][0:MM_WDT-1];

genvar i;
generate
    for (i = 0; i < MM_HGT; i = i + 1) begin
        assign result[i*32 +: 32] = mem[i][MM_WDT-1];
    end
endgenerate

integer k, l;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (k = 0; k < MM_HGT; k = k + 1) begin
            for (l = 0; l < MM_WDT; l = l + 1) begin
                mem[k][l] = 0;
            end
        end
    end
    else if (enable) begin
        for (k = 0; k < MM_HGT; k = k + 1) begin
            for (l = MM_WDT-1; l > 0; l = l - 1) begin
                mem[k][l] = mem[k][l-1];
            end
        end
    end
    else if (load) begin
        for (k = 0; k < MM_HGT; k = k + 1) begin
            if (sel[k]) begin
                for (l = 0; l < MM_WDT; l = l + 1) begin
                    if (l == MM_WDT-1) begin
                        mem[k][l] = data;
                    end
                    else begin
                        mem[k][l] = mem[k][l+1];
                    end
                end
            end
        end
    end
end

endmodule
