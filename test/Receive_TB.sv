`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2021 09:50:25 AM
// Design Name: 
// Module Name: Receive_TB
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


module Receive_TB();
    logic ref_clk;              //input; 150000 Hz clock
    logic nreset;               //input; reset
    logic parity_mode;
    logic receive;              //output; flag indicating data can be received
    logic clk_in;               //input; 300 baud clock
    logic [7:0] data_out;       //output; parallel data output
    logic serial_in;            //input; serial data input
    logic rx_done;              //input; flag indicating data has been received
        
    Receive dut(.*);
    Clock_Divider cd(.input_clk(ref_clk), .nreset(nreset), .output_clk(clk_in));
    
    initial begin
        ref_clk = 0;
        nreset = 1; 
        serial_in = 1'b1;
        parity_mode = 0;
        
        //reset transmit block
        #5 nreset = 0; 
        #3333 nreset = 1;
        
        //input 0 | 1 0 1 1 0 0 1 1 | 0 | 1 1 serially; output should be 2'hCD
        //valid input, so receive should go HIGH
        #3333333 serial_in = 0; //low start bit
        #3333333 serial_in = 1; //data bit index 0
        #3333333 serial_in = 0; //data bit index 1
        #3333333 serial_in = 1; //data bit index 2
        #3333333 serial_in = 1; //data bit index 3
        #3333333 serial_in = 0; //data bit index 4
        #3333333 serial_in = 0; //data bit index 5
        #3333333 serial_in = 1; //data bit index 6
        #3333333 serial_in = 1; //data bit index 7
        #3333333 serial_in = 0; //parity bit
        #3333333 serial_in = 1; //high first stop bit
        #3333333 serial_in = 1; //high second stop bit

        #6666666
        rx_done = 1;
        #6666666
        rx_done = 0;

        //input 0 | 1 0 1 1 0 0 1 1 | 1 | 1 serially; output should be 2'hCD
        //invalid input, invalid parity bit, so receive should stay LOW
        #3333333 serial_in = 0; //low start bit
        #3333333 serial_in = 1; //data bit index 0
        #3333333 serial_in = 0; //data bit index 1
        #3333333 serial_in = 1; //data bit index 2
        #3333333 serial_in = 1; //data bit index 3
        #3333333 serial_in = 0; //data bit index 4
        #3333333 serial_in = 0; //data bit index 5
        #3333333 serial_in = 1; //data bit index 6
        #3333333 serial_in = 1; //data bit index 7
        #3333333 serial_in = 1; //invalid parity bit
        #3333333 serial_in = 1; //high first stop bit
        #3333333 serial_in = 1; //high second stop bit
        
        #6666666
        #6666666

        //input 0 | 1 0 1 1 0 0 1 1 | 0 | 0 serially; output should be 2'hCD
        //invalid input, low stop bit, so receive should stay LOW
        #3333333 serial_in = 0; //low start bit
        #3333333 serial_in = 1; //data bit index 0
        #3333333 serial_in = 0; //data bit index 1
        #3333333 serial_in = 1; //data bit index 2
        #3333333 serial_in = 1; //data bit index 3
        #3333333 serial_in = 0; //data bit index 4
        #3333333 serial_in = 0; //data bit index 5
        #3333333 serial_in = 1; //data bit index 6
        #3333333 serial_in = 1; //data bit index 7
        #3333333 serial_in = 0; //valid parity bit
        #3333333 serial_in = 0; //low stop bit
        #3333333 serial_in = 1; //late first high stop bit
        #3333333 serial_in = 1; //late second stop bit
        
        #6666666
        #6666666
        
        //input 0 | 1 1 1 0 0 0 1 0 | 1 | 1 serially; output should be 2'h47
        //valid input, so receive should go HIGH
        #3333333 serial_in = 0; //low start bit
        #3333333 serial_in = 1; //data bit index 0
        #3333333 serial_in = 1; //data bit index 1
        #3333333 serial_in = 1; //data bit index 2
        #3333333 serial_in = 0; //data bit index 3
        #3333333 serial_in = 0; //data bit index 4
        #3333333 serial_in = 0; //data bit index 5
        #3333333 serial_in = 1; //data bit index 6
        #3333333 serial_in = 0; //data bit index 7
        #3333333 serial_in = 1; //valid parity bit
        #3333333 serial_in = 1; //high first stop bit
        #3333333 serial_in = 1; //high second stop bit
        
        #6666666
        rx_done = 1;
        #6666666
        rx_done = 0;
        
        //using even parity
        
        parity_mode = 1;
        
        //input 0 | 1 0 1 1 0 0 1 1 | 1 | 1 1 serially; output should be 2'hCD
        //valid input, so receive should go HIGH
        #3333333 serial_in = 0; //low start bit
        #3333333 serial_in = 1; //data bit index 0
        #3333333 serial_in = 0; //data bit index 1
        #3333333 serial_in = 1; //data bit index 2
        #3333333 serial_in = 1; //data bit index 3
        #3333333 serial_in = 0; //data bit index 4
        #3333333 serial_in = 0; //data bit index 5
        #3333333 serial_in = 1; //data bit index 6
        #3333333 serial_in = 1; //data bit index 7
        #3333333 serial_in = 1; //parity bit
        #3333333 serial_in = 1; //high first stop bit
        #3333333 serial_in = 1; //high second stop bit
        
        #6666666
        rx_done = 1;
        #6666666
        rx_done = 0;
    end
    
    //pulse ref_clk every 1 ms
    always
        #3333 ref_clk = ~ref_clk;
        
endmodule
