`timescale 1ns / 1ps
//  SPB SUAI
//Group 1641
// Authors:   Filippov K. and Denisov D. 
// Bidirectional shift register 74194
module shift_reg_74194(DI,CLK,CLR,S,SR_SER,SL_SER,Q);
    input wire [3:0] DI; // Parallel data input
    input CLK; // CLock 
    input CLR; // Clear parallel data output signal
    input [1:0]S; // Controll input
    input wire SR_SER; // Shift Right serial input 
    input wire SL_SER; // Shift left serial input

    output reg [3:0] Q; // Parallel data output

    initial begin
        Q<=0;      
    end
    always @(posedge CLK or negedge CLR) begin
        if (CLR) begin 
        case (S)
                2'b00: // Do nothing (S0=0,S1=0)
                   begin
                        Q<={Q[3:0]};
                   end
                2'b01: // Shift Left (S0=0,S1=1)
                   begin
                        Q<={Q[2:0],SL_SER};
                   end
                2'b10: // Shift Right (S0=1,S1=0)
                   begin
                       Q<={SR_SER,Q[3:1]}; 
                   end
                2'b11: // Parallel data output (S0=1,S1=1)
                   begin
                        Q<=DI;
                   end
             endcase
        end
        else begin // Reset output
           Q<=0; 
        end
      end
endmodule

