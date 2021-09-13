`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2021 09:44:01 AM
// Design Name: 
// Module Name: Receive
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


module Receive(nreset, parity_mode, receive, clk_in, data_out, serial_in, rx_done);
    
    input nreset;                 //reset
    input parity_mode;            //parity selector; 0 for odd parity, 1 for even parity
    input clk_in;                 //300 baud clock
    input serial_in;              //input from peripheral
    input rx_done;                //input from controller; when data has been received

    output logic [7:0] data_out;  //parallel data to be sent to cpu
    output logic receive;         //output flag that data is ready to be received
    
    logic [3:0] index;            //current data index
    logic parity_bit;             //store parity bit
    logic stop_bit;               //store first stop bit

    logic [3:0] next_index;       //intermediary value for index
    logic next_parity_bit;        //intermediary value for parity
    logic next_receive;           //intermediary value for receive flag
    logic next_stop_bit;          //intermediary for first stop bit
    
    enum logic [2:0] {
        IDLE = 2'b00,
        RECEIVE = 2'b01,
        INVALID = 2'b10,
        DONE = 2'b11
    } state, next_state;  
      
    always_comb begin
        case (state)
            IDLE:
                //if start bit is received
                if(!serial_in) begin
                    next_state = RECEIVE;               //begin receiving serial data on next neg edge
                    next_index = 4'b0000;               //load 0 into next_index reg
                    data_out = 8'b00000000;
                    next_receive = 1'b0;
                end
                else
                    next_state = IDLE;                  //if no start bit, stay in IDLE state
            RECEIVE:
                //if second stop bit is received
                if(index === 4'b1010)             
                    //check for valid stop bit and parity bit matches data parity
                    if(stop_bit & serial_in & (^data_out ^ parity_mode ^ parity_bit)) begin
                        next_state = DONE;                                          //go to DONE and wait for data to be received
                        next_receive = 1'b1;                                        //set receive high because data is valid
                    end
                    //invalid parity bit, return to idle but do not set receive high 
                    else if(stop_bit & serial_in) begin                    
                        next_state = IDLE;                                          //return to IDLE
                        next_receive = 1'b0;                                        //set receive low because data is invalid
                    end
                    //invalid stop bits, go to INVALID state and wait for late stop bit
                    else begin
                        next_state = INVALID;
                        next_receive = 1'b0;
                    end
                //if first stop bit, store to check later
                else if(index === 4'b1001) begin
                    next_stop_bit = serial_in;                                      //save first stop bit
                    next_index = index + 1;                                         //increment index
                end    
                //if parity bit, update parity
                else if(index === 4'b1000) begin
                    next_parity_bit = serial_in;                                    //set parity to serial input
                    next_index = index + 1;                                         //increment index
                end
                //if data bit, update data
                else begin  
                    next_state = RECEIVE;
                    next_index = index + 1'b1;                                      //increment index
                    data_out[index] = serial_in;                                    //update data with new serial input
                end
            INVALID: 
                //if late stop bit is received, return to IDLE
                if(serial_in)
                    next_state = IDLE;
                else
                    next_state = INVALID;
            DONE:
                if(rx_done) begin
                    next_state = IDLE;
                    next_receive = 1'b0;
                end
                else
                    next_state = DONE;
            default: next_state = IDLE;
        endcase
    end
    
    always_ff @(posedge clk_in)
        if(!nreset) begin
            state <= IDLE;
            receive <= 1'b0;
            index <= 4'b0000;
        end
        else begin
            state <= next_state;
            index <= next_index;
            parity_bit <= next_parity_bit;
            receive <= next_receive;
            stop_bit <= next_stop_bit;
        end 

endmodule