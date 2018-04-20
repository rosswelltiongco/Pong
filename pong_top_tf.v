`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////////
// File name: pong_top_tf.v
// 
// 
// Created by        Rosswell Tiongco on 4/18/18
// Copyright © 2018  Rosswell Tiongco. All rights reserved.
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work
// of no one else. In submitting this code I acknowledge that
// plagiarism in student project work is subject to dismissal
// from the class
//
// Purpose: Employs a self-checking testbench to check the top level module
////////////////////////////////////////////////////////////////////////////////////

module pong_top_tf;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire hsync;
	wire vsync;
	wire [11:0] rgb;

	// Instantiate the Unit Under Test (UUT)
	pong_top uut (
		.clk(clk), 
		.rst(rst), 
		.hsync(hsync), 
		.vsync(vsync), 
		.rgb(rgb)
	);

    always #5 clk = ~clk;

    //Wall Declaration 
    wire wall_on  = (32 <= uut.pixel_x) && (uut.pixel_x <= 35);
    localparam wall_rgb = 12'h070;
    wire paddle_on  = (600 <= uut.pixel_x) && (uut.pixel_x <= 603) &&
                            (204 <= uut.pixel_y) && (uut.pixel_y <= 276);
    localparam paddle_rgb = 12'h770;
    wire ball_on     = (580 <= uut.pixel_x) && (uut.pixel_x <= 588) && 
                         (238 <= uut.pixel_y) && (uut.pixel_y <= 246);
    localparam ball_on_rgb = 12'hF0F;
    
    // Fixed Object Requirement 3: Wall occupies horizontal scan 32-35
    always @ (posedge clk) begin
        #2 if (wall_on)    $display ("wall in range");
    end
    
    // Fixed Object Requirement 4: Paddle occupies horizontal scan 600-603 & vertical scan 204-276
    always @ (posedge clk) begin
        #2 if (paddle_on)  $display ("paddle in range");
    end
    
    // Fixed Object Requirement 5: Ball occupies horizontal scan 580-588 & vertical scan 238-246
    always @ (posedge clk) begin
        #2 if (ball_on)    $display ("ball in range");
    end
    
    
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        rst = 0;
	end
      
endmodule

