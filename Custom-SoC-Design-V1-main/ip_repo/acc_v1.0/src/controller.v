`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2024 22:31:52
// Design Name: 
// Module Name: controller
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


module controller(
    input M_AXI_ACLK,
    input M_AXI_ARESETN,
    input wire [31:0] InputImageAddress,
    input wire [3:0] InputImageDimensions,
    input wire [31:0] ConvolutionKernelAddress,
    input wire [1:0] ConvolutionKernelDimensions,
    input wire [31:0] OutputImageAddress,
    input wire [31:0] MatrixAAddress,
    input wire [3:0] MatrixADimensions,
    input wire [31:0] MatrixBAddress,
    input wire [3:0] MatrixBDimensions,
    input wire [31:0] OutputMatrixAddress,
    input wire ConvolutionOperationInterrupt,
    input wire MatrixOperationInterrupt,

    output reg [31:0] c_MatrixAAddress,
    output reg [3:0] c_MatrixADimensions,
    output reg [31:0] c_MatrixBAddress,
    output reg [3:0] c_MatrixBDimensions,
    output reg [31:0] c_OutputMatrixAddress,
    output reg operation,

    input read_done,
    input systolic_array_done,
    input write_done,

    output c_INIT_AXI_TXN,
    output c_systolic_array_start
);

reg [2:0] state, next_state;
reg INIT_AXI_TXN;
reg systolic_array_start;
assign c_INIT_AXI_TXN = INIT_AXI_TXN;

always @(posedge M_AXI_ACLK) begin
    if (INIT_AXI_TXN == 1) begin
        INIT_AXI_TXN <= 1'b0;
    end
end

reg operation_type; // 0: Matrix, 1: Convolution

// State machine states
parameter IDLE = 3'b000;
parameter READ_DATA = 3'b001;
parameter COMPUTE = 3'b010;
parameter WRITE_DATA = 3'b011;
parameter DONE = 3'b100;

// State machine
always @(posedge M_AXI_ACLK) begin
    if (!M_AXI_ARESETN) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (ConvolutionOperationInterrupt) begin
                next_state = READ_DATA;
                operation_type = 1'b1; // Convolution
            end else if (MatrixOperationInterrupt) begin
                next_state = READ_DATA;
                operation_type = 1'b0; // Matrix
            end else begin
                next_state = IDLE;
            end
        end
        READ_DATA: begin
            if (read_done) begin
                next_state = COMPUTE;
            end else begin
                next_state = READ_DATA;
            end
        end
        COMPUTE: begin
            if (systolic_array_done) begin
                next_state = WRITE_DATA;
            end else begin
                next_state = COMPUTE;
            end
        end
        WRITE_DATA: begin
            if (write_done) begin
                next_state = DONE;
            end else begin
                next_state = WRITE_DATA;
            end
        end
        DONE: begin
            next_state = IDLE;
        end
    endcase
end

// AXI Master control signals
always @(*) begin
    case (state)
        IDLE: begin
            INIT_AXI_TXN = 1'b0;
            systolic_array_start = 1'b0;
        end
        READ_DATA: begin
            INIT_AXI_TXN = 1'b1;
            operation = operation_type;
            if (operation_type == 1'b0) begin // Matrix operation
                c_MatrixAAddress = MatrixAAddress;
                c_MatrixADimensions = MatrixADimensions;
                c_MatrixBAddress = MatrixBAddress;
                c_MatrixBDimensions = MatrixBDimensions;
                c_OutputMatrixAddress = OutputMatrixAddress;
            end else begin // Convolution operation
                c_MatrixAAddress = ConvolutionKernelAddress;
                c_MatrixADimensions = ConvolutionKernelDimensions;
                c_MatrixBAddress = InputImageAddress;
                c_MatrixBDimensions = InputImageDimensions;
                c_OutputMatrixAddress = OutputImageAddress;
            end
        end
        COMPUTE: begin
            systolic_array_start <= 1'b1;
            // Load input and weight data into systolic array
            // ...
        end
        WRITE_DATA: begin
           
           
        end
        DONE: begin
            INIT_AXI_TXN = 1'b0;
            systolic_array_start = 1'b0;
        end
    endcase
end

endmodule
