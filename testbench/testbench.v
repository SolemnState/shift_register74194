`timescale 1ns / 1ps
// Bidirectional shift register testbench with finite state machine  
//  SPB SUAI                           
//Group 1641    
// Authors:   Filippov K. and Denisov D.                     
module testbench;
    //input for shift registers
    reg CLK;    // CLock                             
    reg CLR;    // Clear parallel data output signal 
    reg [1:0] S; // Controll input                 
    reg  SR_SER; // Shift Right serial input  
    reg  SL_SER; // Shift left serial input
    reg  SL_SER_ERROR; // Shift left serial input with error
    //inputs for counters
    reg ENT;
    reg ENP;
    reg CLRBAR;
    reg LOAD;
    reg [3:0]DIC;  
    //output
    wire [3:0] Q1; // Parallel data output for register 1
    wire [3:0] Q2; // Parallel data output for register 2
    wire [3:0] QC1; // Parallel data output for Counter 1
    wire [3:0] QC2; // Parallel data output for Counter 2
    wire RCO; // Ripple carry output
    integer state; // Current state variable (0-5)
    integer counter; // Counter variable, each state takes 5 clock cycles
    // declaring wires for error checking
    wire xor1;
    wire xor2;
    wire xor3;
    wire xor4;
    wire result;
    // Declaring used modules
    bidirectional_counter_74161 COUNTER1(.DIC(DIC),.LOAD(LOAD), .CLK(CLK),.CLRBAR(CLRBAR),.RCO(RCO),.ENT(ENT),.ENP(ENP),.QC(QC1));   
    bidirectional_counter_74161 COUNTER2(.DIC(DIC),.LOAD(LOAD), .CLK(CLK),.CLRBAR(CLRBAR),.RCO(RCO),.ENT(ENT),.ENP(ENP),.QC(QC2));   
    shift_reg_74194 REG1(.DI(QC1),.CLK(CLK),.CLR(CLR),.S(S),.SR_SER(SR_SER),.SL_SER(SL_SER),.Q(Q1));
    shift_reg_74194 REG2(.DI(QC2),.CLK(CLK),.CLR(CLR),.S(S),.SR_SER(SR_SER),.SL_SER(SL_SER),.Q(Q2));
    //shift_reg_74194 REG2(.DI(QC2),.CLK(CLK),.CLR(CLR),.S(S),.SR_SER(SR_SER),.SL_SER(SL_SER_ERROR),.Q(Q2)); // declaration of shift register with error
     
     // declaration of modules for error checking
    XOR x1(.a(Q1[0]),.b(Q2[0]),.c(xor1)); 
    XOR x2(.a(Q1[1]),.b(Q2[1]),.c(xor2));
    XOR x3(.a(Q1[2]),.b(Q2[2]),.c(xor3));
    XOR x4(.a(Q1[3]),.b(Q2[3]),.c(xor4));
    OR o(.a(xor1),.b(xor2),.c(xor3),.d(xor4),.e(result));
     
     initial begin // Initializing initial values
        CLK=1; 
        SL_SER_ERROR=0; 
        CLR=0; S=2'b11; SR_SER=1'b0; SL_SER=1'b0;
        counter=0;
        CLRBAR=0;
        DIC=4'b0000; CLRBAR=1'b0; LOAD=1'b1; ENT=1'b1; ENP=1'b1; //RCO=0;
        #20;
        CLR=1;
        CLRBAR=1'b1;
     end
     always begin // Clock signal simulation (T=100 ns)
        #50;
        CLK = 'b0;
        #50;
        CLK = 'b1;
     end
     
     always @(negedge CLR) begin // Clear block
        if (~CLR) begin
            CLR<= #50 1; // set CLR = 1 after 50 ns 
            counter<=0;
        end    
     end
     always @(posedge CLK) begin
     if (result==1) begin  // stop program if error occured.
        $display("Error!");
        $stop;
     end
            case(state)
                'd0: begin //Do nothing
               S<=2'b00; SR_SER<=1'b1; SL_SER<=1'b1;
                        counter<=counter+1;
                     if (counter>=2) begin
                        state<=state+1;
                        CLR<=0;
                     end
                end
                'd1: begin //Parallel output
                    S<=2'b11; SR_SER<=1'b0; SL_SER<=1'b0; 
                    counter<=counter+1;
                    if (counter>=5) begin
                        state<=state+1;
                        CLR<=0;
                     end
                end
                'd2: begin //Shift right (SR_SER = 1 each clock cycle)
                    S<=2'b10; SR_SER<=1'b1; SL_SER<=1'b0;
                    counter<=counter+1;
                    if (counter>=5) begin
                        state<=state+1;
                        CLR<=0;
                     end
                end
                'd3: begin //Shift right (SR_SER = 1 on first clock cycle)
                    S<=2'b10; SR_SER<=#50 1'b0; SL_SER<=1'b0;
                    counter<=counter+1;
                    if (counter>=4) begin
                        state<=state+1;
                        CLR<=0;
                     end
                end
                'd4: begin // Shift Left (SL_SER = 1 each clock cycle)
                   S<=2'b01; SR_SER<=1'b0; SL_SER<=1'b1;
                    counter<=counter+1;
                    if (counter>=5) begin
                        state<=state+1;
                        CLR<=0;
                     end
                end
                'd5: begin // Shift Left (SL_SER = 1 on first clock cycle)
                   S<=2'b01; SR_SER<= #50 1'b0; SL_SER<=1'b0;
                    counter<=counter+1;
                    if (counter>=4) begin
                        state<=0;
                        CLR<=0;
                     end
                end
                default: begin
                    state<=0;
                end
            endcase
        end     
endmodule
