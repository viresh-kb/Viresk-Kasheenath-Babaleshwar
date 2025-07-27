// `include "adder_transaction.sv"
class adder_driver;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
adder_transaction addr_pkt;
mailbox gen2drv, drv2scb;
event gen_done;
virtual adder_interface.drv_mp drv_vif;
string name;
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	//Log
	function void log(string message);
		$display("[%t] INFO [DRV %s]: %s",$time, this.name, message);
	endfunction : log
	
	// Constructor
	function new(string name = "adder_driver");
		this.name = name;
		log("ADDER_DRIVER_BUILD");
	endfunction : new
	
	//Connect
	function void connect(mailbox gen2drv, mailbox drv2scb, event gen_done, virtual adder_interface.drv_mp drv_vif);
		this.gen2drv = gen2drv;
		this.drv2scb = drv2scb;
		this.gen_done = gen_done;
		this.drv_vif = drv_vif;
		log("ADDER_DRIVER_CONNECT");
	endfunction : connect

	//Run
	task run(input integer itreation);
			addr_pkt = new();
		forever begin
			wait(gen_done.triggered);
			while(drv_vif.rst_n == 0) @(drv_vif.cb_driver);
			repeat(itreation) begin
				data_drive();
			end
		end
	endtask : run

	task data_drive();
		@(drv_vif.cb_driver);
		gen2drv.get(addr_pkt);
		drv2scb.put(addr_pkt);
		drv_vif.cb_driver.a_in <= addr_pkt.a_in;
		drv_vif.cb_driver.b_in <= addr_pkt.b_in;
		addr_pkt.display_transaction();
	endtask : data_drive

endclass	
