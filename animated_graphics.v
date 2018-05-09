`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
// File name: animated_graphics.v
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
// Purpose: Produces animation for graphics
////////////////////////////////////////////////////////////////////////////////////
module animated_graphics(clk, rst, video_on, btn, pixel_x, pixel_y, graph_rgb);
	input clk, rst, video_on;
	input [1:0] btn;
	input [9:0] pixel_x, pixel_y;
	output reg [11:0] graph_rgb;

	wire refr_tick;
	wire [9:0] paddle_top, paddle_bottom;
	reg  [9:0] paddle_reg, paddle_next;
	wire [9:0] ball_left, ball_x_r;
	wire [9:0] ball_top, ball_bottom;
	reg  [9:0] ball_x_reg, ball_y_reg;
	wire [9:0] ball_x_next, ball_y_next;
	reg  [9:0] x_delta_reg, x_delta_next;
	reg  [9:0] y_delta_reg, y_delta_next;
	wire [2:0] rom_addr, rom_col;
	reg  [7:0] rom_data;
	wire       rom_bit;
	
	wire wall_on, paddle_on, round_ball_on;
	
	always @ (*)
		case (rom_addr)
		3'h0: rom_data = 8'b00111100;
		3'h1: rom_data = 8'b01111110;
		3'h2: rom_data = 8'b11111111;
		3'h3: rom_data = 8'b11111111;
		3'h4: rom_data = 8'b11111111;
		3'h5: rom_data = 8'b11111111;
		3'h6: rom_data = 8'b01111110;
		3'h7: rom_data = 8'b00111100;
		endcase 
	
	always @ (posedge clk, posedge rst)
		if (rst) begin
			paddle_reg  <= 0; 
			ball_x_reg  <= 0;
			ball_y_reg  <= 0;
			x_delta_reg <= 10'h002;
			y_delta_reg <= 10'h002;
		end
		else begin
			paddle_reg  <= paddle_next;
			ball_x_reg  <= ball_x_next;
			ball_y_reg  <= ball_y_next;
			x_delta_reg <= x_delta_next;
			y_delta_reg <= y_delta_next;
		end
	
	assign refr_tick     = (pixel_y==481) && (pixel_x==0);
	assign wall_on       = (32<=pixel_x) && (pixel_x<=35);
	assign paddle_top    = paddle_reg;
	assign paddle_bottom = paddle_top + 72 - 1;
	assign paddle_on     = (600<=pixel_x) && (pixel_x<=603) &&
	                       (paddle_top <= pixel_y) && (pixel_y<= paddle_bottom);
	
	always @ (*)
	begin
		paddle_next = paddle_reg;           // no move
		if (refr_tick)
			if (btn[1] & (paddle_bottom < (480-1-3)))
				paddle_next = paddle_reg + 3; //move down
			else if (btn[0] & (paddle_top > 3))
				paddle_next = paddle_reg - 3; // move up
	end
	
	assign ball_left      = ball_x_reg;
	assign ball_top       = ball_y_reg;
	assign ball_x_r       = ball_left + 8 - 1;
	assign ball_bottom    = ball_top + 8 - 1;
   assign rom_addr       = pixel_y[2:0] - ball_top[2:0];
	assign rom_col        = pixel_x[2:0] - ball_left[2:0];
	assign rom_bit        = rom_data[rom_col];
	assign round_ball_on  = ((ball_left <= pixel_x) && (pixel_x<=ball_x_r) &&
	                        (ball_top <= pixel_y)  && (pixel_y<=ball_bottom)) &
									 rom_bit;
	assign ball_x_next    = (refr_tick) ? ball_x_reg + x_delta_reg : 
	                                      ball_x_reg;
	assign ball_y_next    = (refr_tick) ? ball_y_reg + y_delta_reg :
								                 ball_y_reg;
	
	always @ (*)
	begin
		x_delta_next = x_delta_reg;
		y_delta_next = y_delta_reg;
		if (ball_top < 1 ) y_delta_next = 2;               //Reflect top
		else if (ball_bottom > (480-1)) y_delta_next = -2; //Reflect bottom
		else if (ball_left <= 35) x_delta_next = 2;        //Reflect wall
		else if ((600 <= ball_x_r) && (ball_x_r <= 603) &&
		         (paddle_top <= ball_bottom) && (ball_top <= paddle_bottom))
							x_delta_next = -2;                  //Reflect paddle
	end
				
	always @ (*)
		if (~video_on)
			graph_rgb = 12'h000; //blank
		else
			if (wall_on)
				graph_rgb = 12'h0CF; //Blue wall RGB
			else if (paddle_on)
				graph_rgb = 12'h0CF; //Blue paddle RGB
			else if (round_ball_on)
				graph_rgb = 12'hF39; //Pink ball RGB
			else
				graph_rgb = 12'h003; //Purple background RGB
endmodule
