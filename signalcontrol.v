// Cheng Zhao 
// refer to Zerui An Bluetooth_top.v
// FPGA for Robotics Education
//------------------------------------------------------------------------------
// Robotcontrol

module fpga_top (
    input wire WF_CLK, WF_BUTTON,
    input bump0, bump1, bump2, bump3, bump4, bump5,
    input wire motorL_encdr, motorR_encdr,
    input wire ir_snsrch0,
    output wire ir_snsrch1,
    output wire ir_evenLED, ir_oddLED,
    output wire motorL_pwm, motorR_pwm,
    output wire motorL_en, motorR_en,
    output wire motorL_dir, motorR_dir,
    output reg WF_LED,
    output wire ledFL, ledFR, ledBL, ledBR
    );

// Disable all the unused signals
assign ir_evenLED = 0;
assign ir_oddLED = 0;
assign motorL_pwm = 0;
assign motorR_pwm = 0;
assign motorL_en = 0;
assign motorR_en = 0;
assign motorL_dir = 0;
assign motorR_dir = 0;

wire Rx, Tx; // Bluetooth Rx and Tx signals
assign Rx = ir_snsrch0;
assign ir_snsrch1 = Tx; // Map Bluetooth signals to ir sensor pins

assign Tx = 1'b1; // We are not using Tx in this example

wire [7:0] Rx_data; // Connected to the bluetooth Rx module
reg [7:0] counter, counter_next; // blink counter
reg [31:0] timer, timer_next;

localparam SECOND = 32'd16000000;
localparam SLEEP = 4'b0;
localparam BLINK = 4'b1;

reg [3:0] state, state_next;
reg led_next;

Rx_wrapper receiver(WF_CLK, ~WF_BUTTON, Rx, Rx_data);
