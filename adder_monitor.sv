
class adder_monitor;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
adder_transaction addr_pkt;
mailbox mon2scb;
event mon_done;
virtual adder_interface.mon_mp mon_vif;
string name;
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	//Log
	function void log(string message);
		$display("[%t] INFO [MON %s]: %s",$time, this.name, message);
	endfunction : log
	
	// Constructor
	function new(string name = "adder_monitor");
		this.name = name;
		log("ADDER_MONITOR_BUILD");
	endfunction : new
	
	//Connect
	function void connect(mailbox mon2scb, event mon_done, virtual adder_interface.mon_mp mon_vif);
		this.mon2scb = mon2scb;
		this.mon_done = mon_done;
		this.mon_vif = mon_vif;
		log("ADDER_MONITOR_CONNECT");
	endfunction : connect

	task run(input integer itreation);
		 forever begin
			log("MONITOR_RUN_STARTS");
			while (mon_vif.rst_n == 1'b0) @(mon_vif.cb_monitor);
			@(mon_vif.cb_monitor);
			@(mon_vif.cb_monitor);
			repeat(itreation) begin
				sample_data();
			end
			-> mon_done;
			log("MONITOR_EVENT_TRIGGRED");
		end
	endtask : run

	task sample_data();
		@(mon_vif.cb_monitor);
		addr_pkt = new();
		addr_pkt.a_in <= mon_vif.cb_monitor.a_in;
		addr_pkt.b_in <= mon_vif.cb_monitor.b_in;
		addr_pkt.sum_out <= mon_vif.cb_monitor.sum_out;
		addr_pkt.display_transaction();
		mon2scb.put(addr_pkt);
	endtask : sample_data
endclass : adder_monitor