`timescale 1ns/1ns;
module test(adder_interface.cb_driver drv_if, adder_interface.cb_monitor mon_if);
	import sim_file_pkg::*;
	adder_enviourment env;
	initial begin
		// b_drv = new();
		env = new("ADDER_ENV");
		env.connect(drv_if,mon_if);
		// env.build(drv_if,mon_if);
		// env.reset();
		// env.gen.no_of_packets=100;
		// env.sb.no_of_packets=100;
		// env.drv = b_drv;
		#10 env.run(16);
		// env.cleanup();
		// env.report();
	end
endmodule