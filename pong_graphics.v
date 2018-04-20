`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
// File name: pong_graphics.v
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
module pong_graphics(video_on, pixel_x, pixel_y, graphics_rgb);
    input            video_on;
    input      [9:0] pixel_x, pixel_y;
    output reg [11:0] graphics_rgb;


    //Ojbect output signals
    wire        wall_on , paddle_on , ball_on;
    wire [11:0] wall_rgb, paddle_rgb, ball_rgb;
    
    
    //Boundary declarations
    //Wall Pixel & Green RGB
    assign wall_on  = (32 <= pixel_x) && (pixel_x <= 35);
    assign wall_rgb = 12'h060;
    
    //Paddle Pixel & Green RGB
    assign paddle_on  = (600 <= pixel_x) && (pixel_x <= 603) &&
                        (204 <= pixel_y) && (pixel_y <= 275);
    assign paddle_rgb = 12'hFF0;
    
    //Square ball Pixel & Red RGB
    assign ball_on     = (580 <= pixel_x) && (pixel_x <= 587) && 
                         (238 <= pixel_y) && (pixel_y <= 245);
    assign ball_rgb = 12'hF0F;
    
    
    //RGB Multiplexing circuit
    always @ (*)
        if (~video_on)  graphics_rgb = 12'h000;     else
        if (wall_on)    graphics_rgb = wall_rgb;    else
        if (paddle_on)  graphics_rgb = paddle_rgb;  else
        if (ball_on)    graphics_rgb = ball_rgb;
        else            graphics_rgb = 12'h808; //Purple background
    

endmodule
