`timescale 1ns/1ns;
interface adder_interface (input clk, input rst_n);
	logic [7:0] a_in;
	logic [7:0] b_in;
	logic [8:0] sum_out;


	clocking cb_driver @(posedge clk);
		default input #1ns output #1ns;
		output a_in;
		output b_in;
		input sum_out;
	endclocking

	clocking cb_monitor @(posedge clk);
		default input #1ns output #1ns;
		input a_in;
		input b_in;
		input sum_out;
	endclocking
		
	modport drv_mp (clocking cb_driver, input clk, input rst_n);
	modport mon_mp (clocking cb_monitor, input clk, input rst_n);
	modport dut_mp (input a_in,input b_in, output sum_out, input clk, input rst_n);	
endinterface : adder_interface