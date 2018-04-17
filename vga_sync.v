`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
// File name: vga_sync.v
// 
// 
// Created by        Rosswell Tiongco on 3/6/18
// Copyright © 2018  Rosswell Tiongco. All rights reserved.
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work
// of no one else. In submitting this code I acknowledge that
// plagiarism in student project work is subject to dismissal
// from the class
//
// Purpose: Produces hsync, vsync, and video_on signals
////////////////////////////////////////////////////////////////////////////////////
module vga_sync(clk, rst, pixel_tick, pixel_x, pixel_y, hsync, vsync, video_on);
   input            clk, rst; 
	output reg [9:0] pixel_x, pixel_y;
   output           pixel_tick, hsync, vsync, video_on;
   

   // Signal & register declaration
   reg        v_sync_reg , h_sync_reg;
	
   wire [9:0] h_count_next, v_count_next;         
	
   wire       h_video_on, v_video_on, video_on,
              v_sync_next, h_sync_next,
              h_end, v_end;

   
   //=============Generating Tick====================
   //Using a 100MHz clk, generate a 25Mhz signal
   reg [1:0] count;
   assign pixel_tick = (count == 3) ? 1'b1: 1'b0;
    
   always @ (posedge clk, posedge rst)
      if      (rst)        count <= 2'b0; else
      if      (pixel_tick) count <= 2'b0;
      else                 count <= count + 2'b1;
   // ================================================
   
   //Register logic
   always @ (posedge clk, posedge rst)
      //Requirement 1: Reset brings registers to known state of 0
      if (rst) begin
            pixel_y     <= 10'b0;
            pixel_x     <= 10'b0;
            v_sync_reg  <=  1'b0;
            h_sync_reg  <=  1'b0;
            end
      else begin
            pixel_y     <= v_count_next;
            pixel_x     <= h_count_next;
            v_sync_reg  <= v_sync_next;
            h_sync_reg  <= h_sync_next;
            end
   

   //Status signal logic
   //Requirement 4: end of horizontal counter (799)
   assign h_end  = (pixel_x == 799);
   //Requirement 8: end of vertical counter (524)
   assign v_end  = (pixel_y == 524);
   
   
   //Next state logic
   //Horizontal next state logic
   //Requirement 3: Horizontal scan count updated at a 25 MHz rate
   assign h_count_next = (pixel_tick) ? (h_end) ? 10'b0: pixel_x + 1'b1 : pixel_x;
   //Vertical next state logic
   //Requirement 7; Vertical scan count updated at completion of horizontal scan
   assign v_count_next = (pixel_tick & h_end) ? (v_end) ? 10'b0 : pixel_y + 1'b1  : pixel_y;
   //horizontal and vertical sync, buffered to avoid glitch
   //Requirement 5: h_sync_next asserted between 656 and 751
   assign h_sync_next = (pixel_x >= 656 && pixel_x <= 751);
   //Requirement 9: v_sync_next asserted between 490 and 491
   assign v_sync_next = (pixel_y >= 490 && pixel_y <= 491);
    
    
   //video on signals
   //Rquirement 6: HIGH Active from 0-639
   assign h_video_on = (pixel_x <= 639);
   //Requirement 10: HIGH active from 0-479   
   assign v_video_on = (pixel_y <= 479);
   //Requirement 11: HIGH active when HVO && VVO
   assign video_on   = (h_video_on && v_video_on); 
   
   
   //outputs
   assign hsync   = ~h_sync_reg ;
   assign vsync   = ~v_sync_reg ; 
   //Requirement 12: RGB signals driven while video on is ACTIVE
   
endmodule 