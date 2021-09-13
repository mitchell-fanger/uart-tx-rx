`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2021 09:04:48 AM
// Design Name: 
// Module Name: Clock_Divider
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


module Clock_Divider(nreset, input_clk, output_clk);
    input nreset;
    input input_clk;            //takes in a 150000 Hz clk
    output logic output_clk;    //outputs 300 Hz clk
    
    logic [15:0] prescalar;     //count down from 250 to 0
    logic [15:0] count;         //store 250
    
    always_ff @(posedge input_clk)
        if(!nreset) begin
            output_clk <= 0;
            count <= 250;
            prescalar <= 250;
        end
        else if (prescalar === 1) begin
            output_clk <= ~output_clk;
            prescalar <= count;
        end
        else
            prescalar <= prescalar-1; 

       
endmodule