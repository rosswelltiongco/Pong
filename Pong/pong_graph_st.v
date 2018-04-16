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
module pong_graph_st(video_on, pix_x, pix_y, graph_rgb);
    input            video_on;
    input      [9:0] pix_x, pix_y;
    output reg [2:0] graph_rgb;


    //Ojbect output signals
    wire wall_on, bar_on, sq_ball_on;
    wire [2:0] wall_rgb, bar_rgb, sq_ball_on_rgb;
    
    
    //Boundary declarations
    //Wall Pixel & Blue RGB
    assign wall_on = (32<=pix_x) && (pix_x<= 35);
    assign wall_rgb = 3'b001;
    
    //Paddle Pixel & Green RGB
    assign bar_on = (600 <=pix_x) && (pix_x<= 603) &&
                    (204 <=pix_x) && (pix_y<=275);
    assign bar_rgb = 3'b010;
    
    //Square ball Pixel & Red RGB
    assign sq_ball_on = (580<=pix_x) && (pix_x<=587) && 
                        (238<=pix_y) && (pix_y<=245);
    assign ball_rgb = 3'b100;
    
    
    //RGB Multiplexing circuit
    always @ (*)
        if (~video_on)
            graph_rgb = 3'b000; //blank
        else
            if (wall_on)
                graph_rgb = wall_rgb;
            else if (bar_on)
                graph_rgb = bar_rgb;
            else if (sq_ball_on)
                graph_rgb = ball_rgb;
            else
                graph_rgb = 3'b110; //Yellow background
    


endmodule
