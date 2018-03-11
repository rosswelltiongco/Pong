`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File name: vga_sync.v
// 
// 
// Created by        Rosswell Tiongco on 3/6/18
// Copyright � 2018  Rosswell Tiongco. All rights reserved.
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work
// of no one else. In submitting this code I acknowledge that
// plagiarism in student project work is subject to dismissal
// from the class
//
// Purpose: vga_sync generates timing and synchronization signals
//////////////////////////////////////////////////////////////////////////////////
module vga_sync(clk, rst, hsync, vsync, video_on, p_tick);
   input clk, rst;
   input hsync, vsync, video_on, p_tick;
   output [9:0] pixel_x, pixel_y;

   //constant declaration (VGA 640x480sync)
   localparam HD = 640; //horizontal display area
   localparam HF = 48 ; //h. front (left) border
   localparam HB = 26 ; //h. back (right) border
   localparam HR = 96 ; //h. retrace
   localparam VD = 480; //vertical display area
   localparam VF = 10 ; //v. front (top) border
   localparam VB = 33 ; //v. back (bottom) border
   localparam VR = 2  ; //v. retrace
   
   //mod-2 counter
   reg mod2_reg;
   wire mod2_next;
   //sync counters
   reg [9:0] h_count_reg, h_count_next;
   reg [9:0] v_count_reg, v_count_next;
   //output buffer
   reg v_sync_reg, h_sync_reg;
   wire v_sync_next, h_sync_next;
   //status signal
   wire h_end, v_end, pixel_tick;
   
   //=============Generating Tick====================
    //count
    wire m_tick;
    reg [19:0] count;
    // if hit 999999, reset 0
    assign m_tick = (count == 999999) ? 1'b1: 1'b0;
    
      always @ (posedge clk, posedge rst)
         if (rst)
            count <= 20'b0;
            else if (m_tick)
               count <= 20'b0;
               else 
                  count <= count + 20'b1;
   // ================================================
   
   
   //body
   //registers
   always @ (posedge clk, posedge rst)
      if (rst)
         begin
            mod2_reg <= 1'b0;
            v_count_reg <= 0;
            h_count_reg <= 0;
            v_sync_reg <= 1'b0;
            h_sync_reg <= 1'b0;
         end
      else
         begin
            mod2_reg <= mod2_next;
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            v_sync_reg <= v_sync_next;
            h_sync_reg <= h_sync_next;
         end
   
   //mod-2 cirucit to generate 25 MHz enable tick
   assign mod2_next = ~mod2_reg;
   //assign pixel_tick = mod2_reg; //modified
   
   //status signal
   //end of horizontal counter (799)
   assign h_end  = (h_count_reg == (HD+HF+HB+HR-1));
   //end of vertical counter (524)
   assign v_end = (v_count_reg == (VD+VF+VB+VR-1));
   
   //next state logic of mod-800 horizontal sync counter
   always @ (*)
      if (m_tick) //25 MHz pulse
         if (h_end)
            h_count_next = 0;
         else
            h_count_next = h_count_next + 1;
      else
         h_count_next = h_count_reg;
         
   //next state logic of mod-525 vertical sync counter
   always @ (*)
      if (m_tick& h_end)
         if (v_end)
            v_count_next = 0;
         else
            v_count_next = v_count_reg + 1;
      else
         v_count_next = v_count_reg;
         
   //horizontal and vertical sync, buffered to avoid glitch
   //h_sync_next asserted between 656 and 751
   assign h_sync_next = (h_count_reg >= (HD + HB) &&
                         h_count_reg <= (HD + HB + HR - 1));
   //vh_sync_next asserted between 490 and 491
   assign v_sync_next = (v_count_reg >= (VD + VB) &&
                         v_count_reg <= (VD + VB + VR - 1));
    
   //video on/off
   assign video_on = (h_count_reg<HD) && (v_count_reg<VD);
   
   //output
   assign hsync = h_sync_reg;
   assign vsync = v_sync_reg;
   assign pixel_x = h_count_reg;
   assign pixel_y = v_count_reg;
   //assign p_tick = pixel_tick;      
      
endmodule