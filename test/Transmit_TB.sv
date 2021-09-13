`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2021 10:07:11 AM
// Design Name: 
// Module Name: Transmit_TB
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


module Transmit_TB();
    logic ref_clk;          //input clock of 150000Hz
    logic nreset;           //input reset
    logic parity;
    logic transmit;         //input set high to transmit
    logic tx_clk;           //input serial clock, 300 baud
    logic [7:0] data_in;    //input data to transmit
    logic serial_out;       //output data
    logic tx_done;          //output transmission is complete
    
    Transmit dut(.*);
    Clock_Divider cd(.input_clk(ref_clk), .nreset(nreset), .output_clk(tx_clk));
    
    initial begin
        ref_clk = 0;
        nreset = 1; 
        transmit = 0;
        tx_clk = 0;
        data_in = 8'b00000000;
        parity = 0;  //odd parity
        
        //reset transmit block
        #5 nreset = 0; 
        #3333 nreset = 1;
        
        //using odd parity
        
        //transmit 8'b10110011, serial output should be 0 | 1 1 0 0 1 1 0 1 | 0 | 1 1
        #5 data_in = 8'b10110011;
        #6666 transmit = 1;
        #6666 transmit = 0;
        
        #66666666
        
        //transmit 8'b10110011, serial output should be 0 | 1 1 0 0 1 1 0 1 | 0 | 1 1
        #5 data_in = 8'b10110011;
        #6666 transmit = 1;
        #6666 transmit = 0;
        
        #66666666
        
        //start using even parity
        
        parity = 1; //even parity
        
        //transmit 8'b10110011, serial output should be 0 | 1 1 0 0 1 1 0 1 | 1 | 1 1
        #5 data_in = 8'b10110011;
        #6666 transmit = 1;
        #6666 transmit = 0;
        
        #66666666
        
        //transmit 8'b10110011, serial output should be 0 | 1 1 0 0 1 1 0 1 | 1 | 1 1
        #5 data_in = 8'b10110011;
        #6666 transmit = 1;
        #6666 transmit = 0;
        
    end
    
    //pulse ref_clk every 1 ms
    always
        #3333 ref_clk = ~ref_clk;
     
        
endmodule
