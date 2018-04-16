`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
// File name: pong_graph_st.v
// 
// 
// Created by        Rosswell Tiongco on 4/15/18
// Copyright © 2018  Rosswell Tiongco. All rights reserved.
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work
// of no one else. In submitting this code I acknowledge that
// plagiarism in student project work is subject to dismissal
// from the class
//
// Purpose: Declares paddle,wall,ball object boundadies and RGB
////////////////////////////////////////////////////////////////////////////////////
module pong_top_st(clk, rst, hsync, vsync, rgb);
    input clk, rst;
    output hsync, vsync;
    output [2:0] rgb;
    
    //Signal generation
    wire [9:0] pixel_x, pixel_y;
    wire video_on, pixel_tick;
    reg [2:0] rgb_reg;
    wire [2:0] rgb_next;
    
    //Instantiations
    //Vga sync circuit
    vga_sync vsync_unit
        (.clk(clk), .rst(rst), .hsync(hsync), .vsync(vsync),
         .video_on(video_on), .p_tick(pixel_tick),
         .pixel_x(pixel_x), .pixel_y(pixel_y)             );
    //Graphics generation
    pong_graph_st pong_grf_unit 
        (.video_on(video_on), .pix_x(pixel_x), .pix_y(pixel_y),
         .graph_rgb(rgb_next)                                );
    
    //rgb buffer
    always @ (posedge clk)
        if (pixel_tick)
            rgb_reg <= rgb_next;
    //output 
    assign rgb = rgb_reg;

endmodule
