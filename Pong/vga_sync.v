`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
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
// Purpose: vga_sync generates timing and synchronization signals
//////////////////////////////////////////////////////////////////////////////////
module vga_sync(clk, rst, sw, hsync, vsync, vga_rgb);
   input clk, rst; 
   input [11:0] sw;
   output hsync, vsync;
   output  [11:0] vga_rgb;
   reg [11:0] rgb_reg;
      
   wire [9:0] pixel_x, pixel_y;

   wire h_video_on, v_video_on, video_on;

   
   //=============Generating Tick====================
    //count
    reg [1:0] count;
    // if hit 999999, reset 0
    assign pixel_tick = (count == 3) ? 1'b1: 1'b0;
    
      always @ (posedge clk, posedge rst)
         if (rst)
            count <= 2'b0;
            else if (pixel_tick)
               count <= 2'b0;
               else 
                  count <= count + 2'b1;
   // ================================================
   
   reg [9:0] h_count_reg, h_count_next;
   reg [9:0] v_count_reg, v_count_next;
   reg v_sync_reg, h_sync_reg;
   wire v_sync_next, h_sync_next;
   wire h_end, v_end;

   //body
   //registers
   always @ (posedge clk, posedge rst) //Requirement 1: Reset
      if (rst) begin
            v_count_reg <= 0;
            h_count_reg <= 0;
            v_sync_reg <= 1'b0;
            h_sync_reg <= 1'b0;
            end
      else begin
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            v_sync_reg  <= v_sync_next;
            h_sync_reg  <= h_sync_next;
            end
   

   
   //status signal
   //Requirement 4: end of horizontal counter (799)
   assign h_end  = (h_count_reg == 799);
   //Requirement 8: end of vertical counter (524)
   assign v_end = (v_count_reg == 524);
   
   //next state logic of mod-800 horizontal sync counter
   always @ (*)
      if (pixel_tick) //Requirement 3: Horizontal scan count updated at a 25 MHz rate
         if (h_end) h_count_next = 0;
         else h_count_next = h_count_reg + 1'b1; //FIX? from hcountnexgt to hcountreg
      else
         h_count_next = h_count_reg;
         
   //next state logic of mod-525 vertical sync counter
   always @ (*)
      if (pixel_tick & h_end) //Requirement 7; Vertical scan count updated at completion of horizontal scan
         if (v_end) v_count_next = 0;
         else
            v_count_next = v_count_reg + 1;
      else
         v_count_next = v_count_reg;
         
   //horizontal and vertical sync, buffered to avoid glitch
   //Requirement 5: h_sync_next asserted between 656 and 751
   assign h_sync_next = (h_count_reg >= 656 && h_count_reg <= 751);
   //Requirement 9: vh_sync_next asserted between 490 and 491
   assign v_sync_next = (v_count_reg >= 490 && v_count_reg <= 491);
    
   //video on/off signals
   assign h_video_on = (h_count_reg <= 639); //Rquiremenet 6: HIGH Active from 0-639
   assign v_video_on = (v_count_reg <= 479); //Requirement 10: HIGH active from 0-479
   assign video_on = (h_video_on && v_video_on); //Requirement 11: HIGH active when HVO && VVO
   
   
   //output
   assign hsync = ~h_sync_reg;
   assign vsync = ~v_sync_reg;
   assign pixel_x = h_count_reg;
   assign pixel_y = v_count_reg;    
   
   always @ (posedge clk, posedge rst)
		if (rst) rgb_reg <= 12'b0;
		else rgb_reg <= sw;
	
	assign vga_rgb = (video_on) ? rgb_reg: 12'b0;
   //assign vga_rgb = (video_on) ? sw: 12'b0; //Requirement 12: RGB signals driven while video on is ACTIVE
   
endmodule
