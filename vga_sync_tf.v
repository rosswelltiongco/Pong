`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////////
// File name: vga_sync_tf.v
// 
// 
// Created by        Rosswell Tiongco on 4/5/18
// Copyright © 2018  Rosswell Tiongco. All rights reserved.
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work
// of no one else. In submitting this code I acknowledge that
// plagiarism in student project work is subject to dismissal
// from the class
//
// Purpose: Tests to fulfill requirements
////////////////////////////////////////////////////////////////////////////////////

module vga_sync_tf;

	// Inputs
	reg clk;
	reg rst;
	reg [11:0] sw;

	// Outputs
	wire hsync;
	wire vsync;
	wire [11:0] vga_rgb;

	// Instantiate the Unit Under Test (UUT)
	vga_sync uut (
		.clk(clk), 
		.rst(rst), 
		.sw(sw), 
		.hsync(hsync), 
		.vsync(vsync), 
		.vga_rgb(vga_rgb)
	);

   always #5 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
      sw = 12'b1;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;
        
		// Add stimulus here

	end
      
endmodule

