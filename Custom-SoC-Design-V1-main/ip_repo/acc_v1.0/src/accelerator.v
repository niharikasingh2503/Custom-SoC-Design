`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 21:38:49
// Design Name: 
// Module Name: accelerator
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

module accelerator #
(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line

    parameter MM_HGT = `MM_HGT,
    parameter MM_WDT = `MM_WDT,
    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter integer C_S00_AXI_DATA_WIDTH	= 32,
    parameter integer C_S00_AXI_ADDR_WIDTH	= 4,
      
    // Parameters of Axi Master Bus Interface M00_AXI
    parameter  C_M00_AXI_START_DATA_VALUE	= 32'hAA000000,
    parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
    parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
    parameter integer C_M00_AXI_DATA_WIDTH	= 32,
    parameter integer C_M00_AXI_TRANSACTIONS_NUM	= MM_HGT*MM_WDT
)
(
    // Users to add ports here

    // User ports ends
    // Do not modify the ports beyond this line


    // Ports of Axi Slave Bus Interface S00_AXI
    input wire  s00_axi_aclk,
    input wire  s00_axi_aresetn,
    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
    input wire [2 : 0] s00_axi_awprot,
    input wire  s00_axi_awvalid,
    output wire  s00_axi_awready,
    input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
    input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
    input wire  s00_axi_wvalid,
    output wire  s00_axi_wready,
    output wire [1 : 0] s00_axi_bresp,
    output wire  s00_axi_bvalid,
    input wire  s00_axi_bready,
    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
    input wire [2 : 0] s00_axi_arprot,
    input wire  s00_axi_arvalid,
    output wire  s00_axi_arready,
    output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
    output wire [1 : 0] s00_axi_rresp,
    output wire  s00_axi_rvalid,
    input wire  s00_axi_rready,

    // Ports of Axi Master Bus Interface M00_AXI
    
    output wire  m00_axi_error,
    output wire  m00_axi_txn_done,
    input wire  m00_axi_aclk,
    input wire  m00_axi_aresetn,
    output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
    output wire [2 : 0] m00_axi_awprot,
    output wire  m00_axi_awvalid,
    input wire  m00_axi_awready,
    output wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
    output wire [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
    output wire  m00_axi_wvalid,
    input wire  m00_axi_wready,
    input wire [1 : 0] m00_axi_bresp,
    input wire  m00_axi_bvalid,
    output wire  m00_axi_bready,
    output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
    output wire [2 : 0] m00_axi_arprot,
    output wire  m00_axi_arvalid,
    input wire  m00_axi_arready,
    input wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
    input wire [1 : 0] m00_axi_rresp,
    input wire  m00_axi_rvalid,
    output wire  m00_axi_rready
);
// Instantiation of Axi Bus Interface S00_AXI
wire [31:0] InputImageAddress; //(slv_reg0)
wire [3:0] InputImageDimensions;//  (slv_reg1)
wire [31:0] ConvolutionKernelAddress ;// (slv_reg2)
wire [1:0] ConvolutionKernelDimensions;//  (slv_reg3)
wire [31:0] OutputImageAddress;//  (slv_reg4)
wire [31:0] MatrixAAddress ;// (slv_reg5)
wire [3:0] MatrixADimensions ;// (slv_reg6)
wire [31:0] MatrixBAddress;//  (slv_reg7)
wire [3:0] MatrixBDimensions;//  (slv_reg8)
wire [31:0] OutputMatrixAddress;//  (slv_reg9)
wire  ConvolutionOperationInterrupt;// (slv_reg10)
wire  MatrixOperationInterrupt ;//(slv_reg11)
// Instantiation of Axi Bus Interface S00_AXI
axi4_slave_interface # ( 
    .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
) axi4_slave_interface_inst (
    .S_AXI_ACLK(s00_axi_aclk),
    .S_AXI_ARESETN(s00_axi_aresetn),
    .S_AXI_AWADDR(s00_axi_awaddr),
    .S_AXI_AWPROT(s00_axi_awprot),
    .S_AXI_AWVALID(s00_axi_awvalid),
    .S_AXI_AWREADY(s00_axi_awready),
    .S_AXI_WDATA(s00_axi_wdata),
    .S_AXI_WSTRB(s00_axi_wstrb),
    .S_AXI_WVALID(s00_axi_wvalid),
    .S_AXI_WREADY(s00_axi_wready),
    .S_AXI_BRESP(s00_axi_bresp),
    .S_AXI_BVALID(s00_axi_bvalid),
    .S_AXI_BREADY(s00_axi_bready),
    .S_AXI_ARADDR(s00_axi_araddr),
    .S_AXI_ARPROT(s00_axi_arprot),
    .S_AXI_ARVALID(s00_axi_arvalid),
    .S_AXI_ARREADY(s00_axi_arready),
    .S_AXI_RDATA(s00_axi_rdata),
    .S_AXI_RRESP(s00_axi_rresp),
    .S_AXI_RVALID(s00_axi_rvalid),
    .S_AXI_RREADY(s00_axi_rready),
    .InputImageAddress(InputImageAddress),
    .InputImageDimensions(InputImageDimensions),
    .ConvolutionKernelAddress(ConvolutionKernelAddress) ,
    .ConvolutionKernelDimensions(ConvolutionKernelDimensions),
    .OutputImageAddress(OutputImageAddress),
    .MatrixAAddress(MatrixAAddress) ,
    .MatrixADimensions(MatrixADimensions) ,
    .MatrixBAddress(MatrixBAddress),
    .MatrixBDimensions(MatrixBDimensions),
    .OutputMatrixAddress(OutputMatrixAddress),
    .ConvolutionOperationInterrupt(ConvolutionOperationInterrupt),
    .MatrixOperationInterrupt(MatrixOperationInterrupt) 
);

wire write_index;
wire read_array_a;
wire [7:0]read_index_a;
wire read_done;
wire write_done;
wire read_array_b;
wire [7:0]read_index_b;
wire  m00_axi_init_axi_txn;
wire systolic_done;
wire [31:0] axi_wdata;
wire [31:0] w_MatrixAAddress ;// (slv_reg5)
wire [3:0] w_MatrixADimensions ;// (slv_reg6)
wire [31:0]w_MatrixBAddress;//  (slv_reg7)
wire [3:0]w_MatrixBDimensions;//  (slv_reg8)
wire [31:0]w_OutputMatrixAddress;//  (slv_reg9)
// Instantiation of Axi Bus Interface M00_AXI
axi4_master_interface # ( 
    .C_M_START_DATA_VALUE(C_M00_AXI_START_DATA_VALUE),
    .C_M_TARGET_SLAVE_BASE_ADDR(C_M00_AXI_TARGET_SLAVE_BASE_ADDR),
    .C_M_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
    .C_M_AXI_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
    .C_M_TRANSACTIONS_NUM(C_M00_AXI_TRANSACTIONS_NUM)
) axi4_master_interface_inst (
    .INIT_AXI_TXN(m00_axi_init_axi_txn),
    .ERROR(m00_axi_error),
    .TXN_DONE(m00_axi_txn_done),
    .M_AXI_ACLK(m00_axi_aclk),
    .M_AXI_ARESETN(m00_axi_aresetn),
    .M_AXI_AWADDR(m00_axi_awaddr),
    .M_AXI_AWPROT(m00_axi_awprot),
    .M_AXI_AWVALID(m00_axi_awvalid),
    .M_AXI_AWREADY(m00_axi_awready),
    .M_AXI_WDATA(m00_axi_wdata),
    .M_AXI_WSTRB(m00_axi_wstrb),
    .M_AXI_WVALID(m00_axi_wvalid),
    .M_AXI_WREADY(m00_axi_wready),
    .M_AXI_BRESP(m00_axi_bresp),
    .M_AXI_BVALID(m00_axi_bvalid),
    .M_AXI_BREADY(m00_axi_bready),
    .M_AXI_ARADDR(m00_axi_araddr),
    .M_AXI_ARPROT(m00_axi_arprot),
    .M_AXI_ARVALID(m00_axi_arvalid),
    .M_AXI_ARREADY(m00_axi_arready),
    .M_AXI_RDATA(m00_axi_rdata),
    .M_AXI_RRESP(m00_axi_rresp),
    .M_AXI_RVALID(m00_axi_rvalid),
    .M_AXI_RREADY(m00_axi_rready),
    .m_read_array_a(read_array_a),
    .m_read_index_a(read_index_a),
    .m_reads_done(read_done),
    .m_write_done(write_done),
    .m_read_array_b(read_array_b),
    .m_read_index_b(read_index_b),
    .m_write_index(write_index),
    .SYSTOLIC_DONE(systolic_done),                              
    .c_MatrixAAddress(w_MatrixAAddress) ,
    .c_MatrixADimensions(w_MatrixADimensions) ,
    .c_MatrixBAddress(w_MatrixBAddress),
    . c_MatrixBDimensions(w_MatrixBDimensions),
    . OutputMatrixAddress(w_OutputMatrixAddress),
    .axi_wdata(axi_wdata)   
);

wire w_operation;
wire w_systolic_array_start;
controller acc_controller (
    .InputImageAddress(InputImageAddress),
    .InputImageDimensions(InputImageDimensions),
    .ConvolutionKernelAddress(ConvolutionKernelAddress) ,
    .ConvolutionKernelDimensions(ConvolutionKernelDimensions),
    .OutputImageAddress(OutputImageAddress),
    .MatrixAAddress(MatrixAAddress) ,
    .MatrixADimensions(MatrixADimensions) ,
    .MatrixBAddress(MatrixBAddress),
    .MatrixBDimensions(MatrixBDimensions),
    .OutputMatrixAddress(OutputMatrixAddress),
    .ConvolutionOperationInterrupt(ConvolutionOperationInterrupt),
    .MatrixOperationInterrupt(MatrixOperationInterrupt), 
       
    .c_MatrixAAddress(w_MatrixAAddress) ,
    .c_MatrixADimensions(w_MatrixADimensions) ,
    .c_MatrixBAddress(w_MatrixBAddress),
    .c_MatrixBDimensions(w_MatrixBDimensions),
    .c_OutputMatrixAddress(w_OutputMatrixAddress),
     
    .operation(w_operation),
    
    .c_INIT_AXI_TXN(m00_axi_init_axi_txn),
    .c_systolic_array_start(w_systolic_array_start),
    .read_done(read_done),
    .systolic_array_done(systolic_done),
    .write_done(write_done)
);

wire imem_clk;
wire imem_load;
wire imem_reset;
wire imem_enable;
wire [31:0] imem_data;
wire [0:MM_HGT-1] imem_sel;
wire [0:MM_HGT * 32 - 1] imem_result;
memory_array input_memory (
    .clk(imem_clk), .load(imem_load), .reset(imem_reset),
    .enable(imem_enable), .data(imem_data), .sel(imem_sel),
    .result(imem_result)
);

wire wmem_clk;
wire wmem_load;
wire wmem_reset;
wire wmem_enable;
wire [31:0] wmem_data;
wire [0:MM_HGT-1] wmem_sel;
wire [0:MM_HGT * 32 - 1] wmem_result;
memory_array weight_memory (
    .clk(wmem_clk), .load(wmem_load), .reset(wmem_reset),
    .enable(wmem_enable), .data(wmem_data), .sel(wmem_sel),
    .result(wmem_result)
);

wire clk;
wire mode;
wire reset;
wire [0:MM_HGT * 32 - 1] data;
wire [0:MM_WDT * 32 - 1] weight;
wire [0:MM_HGT * 32 - 1] result;
systolic_array sys_arr (
    .clk(clk), .mode(mode), .reset(reset),
    .data(data), .weight(weight), .result(result)
);

endmodule
