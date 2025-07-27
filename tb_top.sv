`timescale 1ns/1ns;
module tb_top ();

	bit clk, rst_n;

	adder_interface adder_if (clk, rst_n);

	test tb (adder_if,adder_if);

	adder dut(.clk(clk),
			  .rst_n  (rst_n),
			  .a_in   (adder_if.a_in),
			  .b_in   (adder_if.b_in),
			  .sum_out(adder_if.sum_out)
			  );

	always #1 clk = ~clk;
	initial
	begin
		clk = 1'b0;
		rst_n = 1'b0;

		#50 rst_n = 1'b1; 
	end
endmodule : tb_top	