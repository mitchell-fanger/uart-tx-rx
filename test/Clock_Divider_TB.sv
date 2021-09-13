`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2021 09:27:29 AM
// Design Name: 
// Module Name: Clock_Divider_TB
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


module Clock_Divider_TB();
    logic input_clk;            //takes in a 150000 Hz clk
    logic nreset;
    logic output_clk;           //outputs 0.3 Hz clk
    
    
    Clock_Divider dut(.*);
    
    initial begin
        input_clk = 0;        
        nreset = 1;
        #10 nreset = 0;
        #3333 nreset = 1;
    end
    always
        #3333 input_clk = ~input_clk;
endmodule
