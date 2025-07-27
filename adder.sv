module adder (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input [7:0] a_in,
	input [7:0] b_in,
	output logic [8:0] sum_out
);

always_ff @(posedge clk) begin
	if(~rst_n) begin
		sum_out <= 0;
	end else begin
		sum_out <= a_in + b_in;
	end
end
endmodule : adder