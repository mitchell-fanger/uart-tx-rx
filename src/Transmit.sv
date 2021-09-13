`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2021 09:41:48 AM
// Design Name: 
// Module Name: Transmit
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


module Transmit(ref_clk, nreset, parity, transmit, tx_clk, data_in, serial_out, tx_done);
    
    input ref_clk;              //internal clock that transmit module logic runs on
    input nreset;               //active low reset line
    input parity;               //0 for odd parity, 1 for even parity
    input transmit;             //indicate when to transmit, from controller
    input tx_clk;               //serial output clock
    input [7:0] data_in;        //data to transmit, from controller
    output logic serial_out;    //serial output line
    output logic tx_done;	    //flag indicating transmission is complete
    
    logic [11:0] parallel_out;   //parallel data with start bit, parity bit, and stop bit
    logic [3:0] index;           //serial data index to transmit
    
    logic next_tx_done;
    logic [3:0] next_index;
    
    enum logic [1:0] {
        IDLE = 2'b00,
        TRANSMIT = 2'b01,
        DONE = 2'b10
    } state, next_state;
    
    always_comb begin
        case (state)
            IDLE:
                if(transmit) begin
                    next_state = TRANSMIT;
                    parallel_out = {2'b11, (^data_in)^1'b1^parity, data_in, 1'b0};  //generate serial output with parity bit
                    next_tx_done = 1'b0;                                            //set done flag to 0
                    index = 4'b0000;                                                //set transmission index to 0
                end
                else
                    next_state = IDLE;
            TRANSMIT:
                if(tx_done)                                                         //if transmit is done, return to idle
                    next_state = DONE;
                else
                    next_state = TRANSMIT;
            DONE: 
                if(!transmit) begin                                                 //when transmit goes low, return to idle
                    next_state = IDLE;
                    next_tx_done = 1'b0;
                end
                else
                    next_state = DONE;
            default: next_state = IDLE;
        endcase
    end
    
    //perform serial data transmission
    always_ff @(posedge tx_clk or negedge nreset)
        if(!nreset) begin
            next_index <= 4'b0000;                  //reset next index to zero
            next_tx_done <= 1'b0;                   //reset tx_done to low
        end
        else if(state === TRANSMIT) begin
            if(index === 12) begin
                next_tx_done <= 1'b1;               //once index reaches 12, set done flag high, indicate to controller that transmit is complete
                serial_out <= 1'b1;                 //tie serial input back to high
                next_index <= 1'b0;                 //resets index back to zero
            end
            else begin
                serial_out <= parallel_out[index];  //send parallel_out[index] out to serial output
                next_index <= index + 1;            //increment index
                next_tx_done <= 1'b0;               //set tx_done low
            end
        end
        
    //update state
    always_ff @(posedge ref_clk or negedge nreset)
        if(!nreset) begin
            state <= IDLE;
            serial_out <= 1'b1;
        end        
        else begin
            state <= next_state; 
            tx_done <= next_tx_done;
            index <= next_index;
        end

endmodule
