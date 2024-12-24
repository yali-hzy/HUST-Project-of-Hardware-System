`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/24 09:54:22
// Design Name: 
// Module Name: Vga
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


module Vga(input wire clk,     // 65 MHz
                   input wire rst,     // Active high
                   input [11:0] color_in, // Pixel color data (RRRRGGGGBBB)
                   output [10:0] next_x,  // x-coordinate of NEXT pixel that will be drawn
                   output [10:0] next_y,  // y-coordinate of NEXT pixel that will be drawn
                   output wire hsync,    // HSYNC (to VGA connector)
                   output wire vsync,    // VSYNC (to VGA connctor)
                   output [3:0] red,     // RED (to resistor DAC VGA connector)
                   output [3:0] green,   // GREEN (to resistor DAC to VGA connector)
                   output [3:0] blue    // BLUE (to resistor DAC to VGA connector
                   );        // BLANK to VGA connector
  //639
  // Horizontal localparams (measured in clk cycles)
  localparam [10:0] H_ACTIVE = 11'd639 ; //639
  localparam [10:0] H_FRONT  = 11'd15 ;//15
  localparam [10:0] H_PULSE  = 11'd95 ;//95
  localparam [10:0] H_BACK   = 11'd47 ;//47
  
  // Vertical localparams (measured in lines)
  localparam [10:0] V_ACTIVE = 11'd479 ;//479
  localparam [10:0] V_FRONT  = 11'd9 ;//9
  localparam [10:0] V_PULSE  = 11'd1 ;//1
  localparam [10:0] V_BACK   = 11'd32 ;//32
  
  // localparams for readability
  localparam   LOW  = 1'b0 ;
  localparam   HIGH = 1'b1 ;
  
  // States (more readable)
  localparam   [7:0]    H_ACTIVE_STATE = 8'd0 ;
  localparam   [7:0]   H_FRONT_STATE   = 8'd1 ;
  localparam   [7:0]   H_PULSE_STATE   = 8'd2 ;
  localparam   [7:0]   H_BACK_STATE    = 8'd3 ;
  
  localparam   [7:0]    V_ACTIVE_STATE = 8'd0 ;
  localparam   [7:0]   V_FRONT_STATE   = 8'd1 ;
  localparam   [7:0]   V_PULSE_STATE   = 8'd2 ;
  localparam   [7:0]   V_BACK_STATE    = 8'd3 ;
  
  localparam [10:0] hst = 76;
  localparam [10:0] vst = 100;
  localparam [10:0] width = 488;
  localparam [10:0] height = 280;
  localparam [10:0] hed = 563;
  localparam [10:0] ved = 379;
  
  // clked registers
  reg              hysnc_reg ;
  reg              vsync_reg ;
  reg     [7:0]   red_reg ;
  reg     [7:0]   green_reg ;
  reg     [7:0]   blue_reg ;
  reg              line_done ;
  
  // Control registers
  reg     [10:0]   h_counter ;
  reg     [10:0]   v_counter ;
  
  reg     [7:0]    h_state ;
  reg     [7:0]    v_state ;
  
  // State machine
  always@(posedge clk) begin
    // At rst . . .
    if (rst) begin
      // Zero the counters
      h_counter <= 11'd0 ;
      v_counter <= 11'd0 ;
      // States to ACTIVE
      h_state <= H_ACTIVE_STATE  ;
      v_state <= V_ACTIVE_STATE  ;
      // Deassert line done
      line_done <= LOW ;
      vsync_reg <= 1;
      hysnc_reg <= 1;
      
    end
    else begin
      //////////////////////////////////////////////////////////////////////////
      ///////////////////////// HORIZONTAL /////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////
      if (h_state == H_ACTIVE_STATE) begin
        // Iterate horizontal counter, zero at end of ACTIVE mode
        h_counter <= (h_counter == H_ACTIVE)?11'd0:(h_counter + 11'd1) ;
        // Set hsync
        hysnc_reg <= HIGH ;
        // Deassert line done
        line_done <= LOW ;
        // State transition
        h_state <= (h_counter == H_ACTIVE)?H_FRONT_STATE:H_ACTIVE_STATE ;
      end
        if (h_state == H_FRONT_STATE) begin
          // Iterate horizontal counter, zero at end of H_FRONT mode
          h_counter <= (h_counter == H_FRONT)?11'd0:(h_counter + 11'd1) ;
          // Set hsync
          hysnc_reg <= HIGH ;
          // State transition
          h_state <= (h_counter == H_FRONT)?H_PULSE_STATE:H_FRONT_STATE ;
        end
          if (h_state == H_PULSE_STATE) begin
            // Iterate horizontal counter, zero at end of H_PULSE mode
            h_counter <= (h_counter == H_PULSE)?11'd0:(h_counter + 11'd1) ;
            // Clear hsync
            hysnc_reg <= LOW ;
            // State transition
            h_state <= (h_counter == H_PULSE)?H_BACK_STATE:H_PULSE_STATE ;
          end
            if (h_state == H_BACK_STATE) begin
              // Iterate horizontal counter, zero at end of H_BACK mode
              h_counter <= (h_counter == H_BACK)?11'd0:(h_counter + 11'd1) ;
              // Set hsync
              hysnc_reg <= HIGH ;
              // State transition
              h_state <= (h_counter == H_BACK)?H_ACTIVE_STATE:H_BACK_STATE ;
              // Signal line complete at state transition (offset by 1 for synchronous state transition)
              line_done <= (h_counter == (H_BACK-1))?HIGH:LOW ;
            end
      //////////////////////////////////////////////////////////////////////////
      ///////////////////////// VERTICAL ///////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////
      if (v_state == V_ACTIVE_STATE) begin
        // increment vertical counter at end of line, zero on state transition
        v_counter<= (line_done == HIGH)?((v_counter == V_ACTIVE)?11'd0:(v_counter+11'd1)):v_counter ;
        // set vsync in active mode
        vsync_reg <= HIGH ;
        // state transition - only on end of lines
        v_state<= (line_done == HIGH)?((v_counter == V_ACTIVE)?V_FRONT_STATE:V_ACTIVE_STATE):V_ACTIVE_STATE ;
      end
        if (v_state == V_FRONT_STATE) begin
          // increment vertical counter at end of line, zero on state transition
          v_counter<= (line_done == HIGH)?((v_counter == V_FRONT)?11'd0:(v_counter + 11'd1)):v_counter ;
          // set vsync in front porch
          vsync_reg <= HIGH ;
          // state transition
          v_state<= (line_done == HIGH)?((v_counter == V_FRONT)?V_PULSE_STATE:V_FRONT_STATE):V_FRONT_STATE;
        end
          if (v_state == V_PULSE_STATE) begin
            // increment vertical counter at end of line, zero on state transition
            v_counter<= (line_done == HIGH)?((v_counter == V_PULSE)?11'd0:(v_counter + 11'd1)):v_counter ;
            // clear vsync in pulse
            vsync_reg <= LOW ;
            // state transition
            v_state<= (line_done == HIGH)?((v_counter == V_PULSE)?V_BACK_STATE:V_PULSE_STATE):V_PULSE_STATE;
          end
            if (v_state == V_BACK_STATE) begin
              // increment vertical counter at end of line, zero on state transition
              v_counter<= (line_done == HIGH)?((v_counter == V_BACK)?11'd0:(v_counter + 11'd1)):v_counter ;
              // set vsync in back porch
              vsync_reg <= HIGH ;
              // state transition
              v_state<= (line_done == HIGH)?((v_counter == V_BACK)?V_ACTIVE_STATE:V_BACK_STATE):V_BACK_STATE ;
            end
      
      //////////////////////////////////////////////////////////////////////////
      //////////////////////////////// COLOR OUT ///////////////////////////////
      //////////////////////////////////////////////////////////////////////////
      // Assign colors if in active mode
      red_reg<= (h_state == H_ACTIVE_STATE)?((v_state == V_ACTIVE_STATE)?((h_counter >= hst && h_counter <= hed && v_counter >= vst && v_counter <=ved)? {color_in[11:8],4'd0}:8'd0):8'd0):8'd0 ;
      green_reg<=(h_state == H_ACTIVE_STATE)?((v_state == V_ACTIVE_STATE)?((h_counter >= hst && h_counter <= hed && v_counter >= vst && v_counter <=ved)? {color_in[11:8],4'd0}:8'd0):8'd0):8'd0 ;
      blue_reg<= (h_state == H_ACTIVE_STATE)?((v_state == V_ACTIVE_STATE)?((h_counter >= hst && h_counter <= hed && v_counter >= vst && v_counter <=ved)? {color_in[11:8],4'd0}:8'd0):8'd0):8'd0 ;
      
    end
  end
  // Assign output values - to VGA connector
  assign hsync = hysnc_reg ;
  assign vsync = vsync_reg ;
  assign red   = red_reg[7:4] ;
  assign green = green_reg[7:4] ;
  assign blue  = blue_reg[7:4] ;
  // The x/y coordinates that should be available on the NEXT cycle
  assign next_x = (h_state == H_ACTIVE_STATE)?((h_counter >= hst && h_counter <= hed && v_counter >= vst && v_counter <=ved)?h_counter:11'd0):11'd0 ;
  assign next_y = (v_state == V_ACTIVE_STATE)?((h_counter >= hst && h_counter <= hed && v_counter >= vst && v_counter <=ved)?v_counter:11'd0):11'd0 ;
  
endmodule


