// #############################################################################
// DE1_SoC_top_level.v
//
// BOARD         : DE1-SoC from Terasic
// Author        : Sahand Kashani-Akhavan from Terasic documentation
// Revision      : 1.4
// Creation date : 04/02/2015
//
// Syntax Rule : GROUP_NAME_N[bit]
//
// GROUP  : specify a particular interface (ex: SDR_)
// NAME   : signal name (ex: CONFIG, D, ...)
// bit    : signal index
// _N     : to specify an active-low signal
// #############################################################################

module DE1_SoC_top_level (
   // ADC
   // output  ADC_CS_n,
   // output  ADC_DIN,
   // input  ADC_DOUT,
   // output  ADC_SCLK,

   // Audio
   // input  AUD_ADCDAT,
   // inout  AUD_ADCLRCK,
   // inout  AUD_BCLK,
   // output  AUD_DACDAT,
   // inout  AUD_DACLRCK,
   // output  AUD_XCK,

   // CLOCK
   input  CLOCK_50,
   // input  CLOCK2_50,
   // input  CLOCK3_50,
   // input  CLOCK4_50,

   // SDRAM
   output [12:0] DRAM_ADDR,
   output [1:0] DRAM_BA,
   output DRAM_CAS_N,
   output DRAM_CKE,
   output DRAM_CLK,
   output DRAM_CS_N,
   inout [15:0] DRAM_DQ,
   output DRAM_LDQM,
   output DRAM_RAS_N,
   output DRAM_UDQM,
   output DRAM_WE_N,

   // I2C for Audio and Video-In
   // output  FPGA_I2C_SCLK,
   // inout  FPGA_I2C_SDAT,

   // SEG7
   // output [6:0] HEX0_N,
   // output [6:0] HEX1_N,
   // output [6:0] HEX2_N,
   // output [6:0] HEX3_N,
   // output [6:0] HEX4_N,
   // output [6:0] HEX5_N,

   // IR
   // input  IRDA_RXD,
   // output  IRDA_TXD,

   // KEY_N
   input [3:0] KEY,

   // LED
   output [9:0] LEDR,

   // PS2
   // inout  PS2_CLK,
   // inout  PS2_CLK2,
   // inout  PS2_DAT,
   // inout  PS2_DAT2,

   // SW
   // input [9:0] SW,

   // Video-In
   // inout  TD_CLK27,
   // output [7:0] TD_DATA,
   // output TD_HS,
   // output TD_RESET_N,
   // output TD_VS,

   // VGA
   output [7:0] VGA_B,
   output VGA_BLANK_N,
   output VGA_CLK,
   output [7:0] VGA_G,
   output VGA_HS,
   output [7:0] VGA_R,
   output VGA_SYNC_N,
   output VGA_VS,

   // GPIO_0
   // inout [35:0] GPIO_0,

   // GPIO_1
   // inout [35:0] GPIO_1,

   // HPS
   inout HPS_CONV_USB_N,
   output [14:0] HPS_DDR3_ADDR,
   output [2:0] HPS_DDR3_BA,
   output HPS_DDR3_CAS_N,
   output HPS_DDR3_CK_N,
   output HPS_DDR3_CK_P,
   output HPS_DDR3_CKE,
   output HPS_DDR3_CS_N,
   inout [31:0] HPS_DDR3_DQ,
   inout [3:0] HPS_DDR3_DQS_N,
   inout [3:0] HPS_DDR3_DQS_P,
   output HPS_DDR3_ODT,
   output HPS_DDR3_RAS_N,
   output HPS_DDR3_RESET_N,
   input HPS_DDR3_RZQ,
   output HPS_DDR3_WE_N,
   output HPS_ENET_GTX_CLK,
   inout HPS_ENET_INT_N,
   output HPS_ENET_MDC,
   inout HPS_ENET_MDIO,
   input HPS_ENET_RX_CLK,
   input [3:0] HPS_ENET_RX_DATA,
   input HPS_ENET_RX_DV,
   output [3:0] HPS_ENET_TX_DATA,
   output HPS_ENET_TX_EN,
   inout [3:0] HPS_FLASH_DATA,
   output HPS_FLASH_DCLK,
   output HPS_FLASH_NCSO,
   inout HPS_GSENSOR_INT,
   inout HPS_I2C_CONTROL,
   inout HPS_I2C1_SCLK,
   inout HPS_I2C1_SDAT,
   inout HPS_I2C2_SCLK,
   inout HPS_I2C2_SDAT,
   inout HPS_KEY_N,
   inout HPS_LED,
   inout HPS_LTC_GPIO,
   output HPS_SD_CLK,
   inout HPS_SD_CMD,
   inout [3:0] HPS_SD_DATA,
   output HPS_SPIM_CLK,
   input HPS_SPIM_MISO,
   output HPS_SPIM_MOSI,
   inout HPS_SPIM_SS,
   input HPS_UART_RX,
   output HPS_UART_TX,
   input HPS_USB_CLKOUT,
   inout [7:0] HPS_USB_DATA,
   input HPS_USB_DIR,
   input HPS_USB_NXT,
   output HPS_USB_STP
);
endmodule