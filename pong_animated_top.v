`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
// File name: pong_top.v
// 
// 
// Created by        Rosswell Tiongco on 5/5/18
// Copyright © 2018  Rosswell Tiongco. All rights reserved.
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work
// of no one else. In submitting this code I acknowledge that
// plagiarism in student project work is subject to dismissal
// from the class
//
// Purpose: Top level and instantiates other modules
////////////////////////////////////////////////////////////////////////////////////
module pong_animated_top(clk, rst, btn, hsync, vsync, rgb);
    input  clk, rst;
	 input [1:0] btn;
    output hsync, vsync;
    output [11:0] rgb;
    
    //Signal generation
    wire [9:0]  pixel_x, pixel_y;
    wire        video_on, pixel_tick;
    reg  [11:0] rgb_reg;
    wire [11:0] rgb_next;
    
    //Instantiations
    //Vga sync circuit
    vga_sync vsync_unit
		  (.clk(clk), .rst(rst), .pixel_tick(pixel_tick),
		   .pixel_x(pixel_x), .pixel_y(pixel_y), 
			.hsync(hsync), .vsync(vsync), .video_on(video_on));
    //Graphics generation
    animated_graphics gfx
		  (.clk(clk), .rst(rst), .btn(btn),
		   .video_on(video_on), .pixel_x(pixel_x),
		   .pixel_y(pixel_y), .graph_rgb(rgb_next));
    
    //rgb buffer
    always @ (posedge clk)
        if (pixel_tick)
            rgb_reg <= rgb_next;
    //output 
    assign rgb = rgb_reg;

endmodule
