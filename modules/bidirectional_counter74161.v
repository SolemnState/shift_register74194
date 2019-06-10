`timescale 1ns / 1ps
//  SPB SUAI
//Group 1641
// Authors:   Filippov K. and Denisov D. 
// Bidirectional counter 74161
module bidirectional_counter_74161(DIC,LOAD,CLK,CLRBAR,RCO,ENT,ENP,QC);
    input wire [3:0] DIC; // Parallel data input
    input wire CLK; // CLock 
    input wire CLRBAR; // Clear counter
    input wire ENT; // Enable Trickle Input
    input wire ENP; // Enable Parallel Input
    input wire LOAD; // Load
    output reg [3:0] QC; // Parallel data output
    output RCO; // Ripple Carry Output
    
    assign RCO=&QC; // check if all bits == 1 
    initial begin
        QC<=0;     
    end
    always @(posedge CLK or negedge CLRBAR) begin
        if (~CLRBAR)
            QC<=0;
        else begin     
            if (ENT==1 && ENP == 1 && LOAD==1) // Count mode
                QC<=QC+4'b0001;
            else if (ENP==1) // Parallel output
                QC<=DIC;
            else if (ENT == 1) // Trickle output (Inhibit state)
                QC<=QC;
            
        end

    end
    

endmodule