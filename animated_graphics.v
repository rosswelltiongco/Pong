`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
// File name: vga_sync.v
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
module animated_graphics(clk, rst, video_on, btn, pix_x, pix_y, graph_rgb);
	input clk, rst, video_on;
	input [1:0] btn;
	input [9:0] pix_x, pix_y;
	output reg [11:0] graph_rgb;

	wire refr_tick;
	wire [9:0] bar_y_t, bar_y_b;
	reg [9:0] bar_y_reg, bar_y_next;
	wire [9:0] ball_x_l, ball_x_r;
	wire [9:0] ball_y_t, ball_y_b;
	reg [9:0] ball_x_reg, ball_y_reg;
	wire [9:0] ball_x_next, ball_y_next;
	reg [9:0] x_delta_reg, x_delta_next;
	reg [9:0] y_delta_reg, y_delta_next;
	wire [2:0] rom_addr, rom_col;
	reg [7:0] rom_data;
	wire rom_bit;
	
	wire wall_on, bar_on, sq_ball_on, rd_ball_on;
	wire [11:0] wall_rgb, bar_rgb, ball_rgb;
	
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
			bar_y_reg <=0; 
			ball_x_reg <= 0;
			ball_y_reg <= 0;
			x_delta_reg <= 10'h004;
			y_delta_reg <= 10'h004;
		end
		else begin
			bar_y_reg <= bar_y_next;
			ball_x_reg <= ball_x_next;
			ball_y_reg <= ball_y_next;
			x_delta_reg <= x_delta_next;
			y_delta_reg <= y_delta_next;
		end
	
	assign refr_tick = (pix_y==481) && (pix_x==0);
	assign wall_on = (32<=pix_x) && (pix_x<=35);
	assign wall_rgb = 12'h060;
	assign bar_y_t = bar_y_reg;
	assign bar_y_b = bar_y_t + 72 - 1;
	assign bar_on = (600<=pix_x) && (pix_x<=603) &&
	                (bar_y_t <= pix_y) && (pix_y<= bar_y_b);
	assign bar_rgb = 12'hFF0;
	
	always @ (*)
	begin
		bar_y_next = bar_y_reg; // no move
		if (refr_tick)
			if (btn[1] & (bar_y_b < (480-1-4)))
				bar_y_next = bar_y_reg + 4; //move down
			else if (btn[0] & (bar_y_t > 4))
				bar_y_next = bar_y_reg - 4; // move up
	end
	
	assign ball_x_l = ball_x_reg;
	assign ball_y_t = ball_y_reg;
	assign ball_x_r = ball_x_l + 8 - 1;
	assign ball_y_b = ball_y_t + 8 - 1;
	
	assign sq_ball_on = (ball_x_l<=pix_x) && (pix_x<=ball_x_r) &&
	                    (ball_y_t<=pix_y) && (pix_y<=ball_y_b);
   assign rom_addr = pix_y[2:0] - ball_y_t[2:0];
	assign rom_col = pix_x[2:0] - ball_x_l[2:0];
	assign rom_bit = rom_data[rom_col];
	assign rd_ball_on = sq_ball_on & rom_bit;
	assign ball_rgb = 12'hF0F;
	assign ball_x_next = (refr_tick) ? ball_x_reg + x_delta_reg : 
	                      ball_x_reg;
	assign ball_y_next = (refr_tick) ? ball_y_reg + y_delta_reg :
								 ball_y_reg;
	
	always @ (*)
	begin
		x_delta_next = x_delta_reg;
		y_delta_next = y_delta_reg;
		if (ball_y_t < 1 )// reach top
			y_delta_next = 2;
		else if (ball_y_b > (480-1)) //reach bottom
			y_delta_next = -2;
		else if (ball_x_l <= 35) //reach wall
			x_delta_next = 2; //bounce back
		else if ((600<= ball_x_r) && (ball_x_r<=603) &&
		         (bar_y_t<=ball_y_b) && (ball_y_t <= bar_y_b))
				//reach x of right bar and hit, ball bounce back
				x_delta_next = -2; 
	end
				
	always @ (*)
		if (~video_on)
			graph_rgb = 12'h000; //blank
		else
			if (wall_on)
				graph_rgb = wall_rgb;
			else if (bar_on)
				graph_rgb = bar_rgb;
			else if (rd_ball_on)
				graph_rgb = ball_rgb;
			else
				graph_rgb = 12'h808; //Purple background
			
					  
		
endmodule
