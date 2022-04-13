// Cheng Zhao 
// Refer to Zerui An - Bluetooth_top.v
// FPGA for Robotics Education
//------------------------------------------------------------------------------
// Robot Control

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
    assign WF_LED = 0;
    assign ledFL = 0;
    assign ledFR = 0;
    assign ledBL = 0;
    assign ledBR = 0;

    wire Rx, Tx; // Bluetooth Rx and Tx signals
    assign Rx = ir_snsrch0;
    assign ir_snsrch1 = Tx; // Map Bluetooth signals to ir sensor pins

    assign Tx = 1'b1; // We are not using Tx in this example

    wire [7:0] Rx_data; // Connected to the bluetooth Rx module
    reg [7:0] left, left_next;
    reg [7:0] right, right_next;

    localparam REST = 8'b0;

    Rx_wrapper receiver(WF_CLK, ~WF_BUTTON, Rx, Rx_data);

    always @(posedge WF_CLK) begin
        left <= WF_BUTTON ? left_next : REST;
        right <= WF_BUTTON ? right_next : REST;
    end    

    always @(*) begin
        left_next = 8'b0;
        right_next = 8'b0;
        if (Rx_data[6] == 0) begin
            left = {1,Rx_data[6:0]};
            left_next = left;
            right = right_next;
        end 
        else begin
            right = {1,Rx_data[6:0]};
            right_next = right;
            left = left_next;
        end
    end    
    
    speedctl(WF_clk,WF_button,motorL_encdr,left_next[4:0],PWM_L);
    speedctl(WF_clk,WF_button,motorR_encdr,right_next[4:0],PWM_R);
    
    assign motorL_pwm = PWM_L;
    assign motorR_pwm = PWM_R; 
    assign motorL_dir = left_next[5];
    assign motorR_dir = right_next[5];
    assign motorL_en = left_next[6];
    assign motorR_en = right_next[6];
            
endmodule          
