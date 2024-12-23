module Vga (input wire clk,     // 65 MHz
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
      red_reg<= (h_state == H_ACTIVE_STATE)?((v_state == V_ACTIVE_STATE)?{color_in[11:8],4'd0}:8'd0):8'd0 ;
      green_reg<= (h_state == H_ACTIVE_STATE)?((v_state == V_ACTIVE_STATE)?{color_in[7:4],4'd0}:8'd0):8'd0 ;
      blue_reg<= (h_state == H_ACTIVE_STATE)?((v_state == V_ACTIVE_STATE)?{color_in[3:0],4'd0}:8'd0):8'd0 ;
      
    end
  end
  // Assign output values - to VGA connector
  assign hsync = hysnc_reg ;
  assign vsync = vsync_reg ;
  assign red   = red_reg[7:4] ;
  assign green = green_reg[7:4] ;
  assign blue  = blue_reg[7:4] ;
  // The x/y coordinates that should be available on the NEXT cycle
  assign next_x = (h_state == H_ACTIVE_STATE)?h_counter:11'd0 ;
  assign next_y = (v_state == V_ACTIVE_STATE)?v_counter:11'd0 ;
  
endmodule

//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 2024/12/22 15:49:59
//// Design Name: 
//// Module Name: Vga
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module Vga (clk_vga, rst, R, G, B, HS, VS, x, y, color);
//    parameter SCREEN_WIDTH = 10;
////    parameter MAX_WIDTH = 11;
//    localparam HPW = 96;
//    localparam HFP = 8;
//    localparam Width = 640;
//    localparam HMax = 800;
    
//    localparam VPW = 2;
//    localparam Height = 480;
//    localparam VFP = 2;
//    localparam VMax = 525;
//    localparam Boarder = 0;
    
//    input clk_vga;
//    input rst;
//    input [11:0] color;
    
//    output [3:0] R;
//    output [3:0] G;
//    output [3:0] B;
//    output HS;
//    output VS;
    
    
//    output [SCREEN_WIDTH-1:0] x;
//    output [SCREEN_WIDTH-1:0] y;
    
    
//    reg [11:0] RGB;
//    assign {R, G, B} = RGB;
    
//    reg [SCREEN_WIDTH-1:0] tmp_x;
//    reg [SCREEN_WIDTH-1:0] tmp_y;
//    reg tmp_HS;
//    reg tmp_VS;
////    reg [SCREEN_WIDTH-1:0] out_x;
////    reg [SCREEN_WIDTH-1:0] out_y;
    
    
//    // Horizontal counter
//    always @(posedge clk_vga) begin
//        if (rst) tmp_x <= 0;
//        else begin
//            if (tmp_x < HMax - 1) tmp_x <= tmp_x + 1;
//            else tmp_x <= 0;
////            if (tmp_x < Width) out_x <= tmp_x;
////            else out_x = Width; 
//        end
//    end
    
//    always @(posedge clk_vga) begin
//        if (rst) tmp_HS <= 1;
//        else begin
//		    if (tmp_x >= HFP + Width - 1 && tmp_x < HFP + Width + HPW - 1) tmp_HS <= 0;
//		    else tmp_HS <= 1;
//		end
//    end
    
//    // Vertical counter
//    always @(posedge clk_vga) begin
//        if (rst) tmp_y <= 0;
//        else begin
//            if (tmp_x == HMax - 1) begin
//                if (tmp_y < VMax - 1) tmp_y <= tmp_y + 1;
//                else tmp_y <= 0;
//            end
//            else tmp_y <= tmp_y;
            
////            if (tmp_y < Height) out_y = tmp_y;
////            else out_y = Height;
//        end
//    end
    
//    always @(posedge clk_vga) begin
//        if (rst) tmp_VS <= 1;
//        else begin
//            if (tmp_y >= VFP + Height - 1 && tmp_y < VFP + Height + VPW - 1) tmp_VS <= 0;
//            else tmp_VS <= 1;
//        end
//    end
    
//    always @(posedge clk_vga) begin
//        if (rst) RGB <= 0;
//        else begin
//            if (tmp_y < Height - Boarder && tmp_y >= Boarder
//                && tmp_x < Width - Boarder && tmp_x >= Boarder)
//                RGB <= color;
//            else if (tmp_x < Width && tmp_y < Height) RGB <= 'h111;
//            else RGB <= 0;
//        end
//    end
    
        
    
//    assign x = tmp_x;
//    assign y = tmp_y;
//    assign HS = tmp_HS;
//    assign VS = tmp_VS;
    
//endmodule
