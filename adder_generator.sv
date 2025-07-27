// `include "adder_transaction.sv"
class adder_generator;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
adder_transaction addr_pkt;
mailbox gen2drv;
event gen_done;
string name;
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	//Log
	function void log(string message);
		$display("[%t] INFO [GEN %s]: %s",$time, this.name, message);
	endfunction : log
	
	// Constructor
	function new(string name = "adder_generator");
		this.name = name;
		log("ADDER_GENRATOR_BUILD");
	endfunction : new
	
	//Connect
	function void connect(mailbox gen2drv, event gen_done);
		this.gen2drv = gen2drv;
		this.gen_done = gen_done;
		log("ADDER_GENRATOR_CONNECT");
	endfunction : connect

	task run(input logic [31:0]itration);
		repeat(itration)begin
			addr_pkt = new();
			if (addr_pkt.randomize()) begin
				gen2drv.put(addr_pkt);
				addr_pkt.display_transaction();
			end
		end
		-> gen_done;
	endtask : run
endclass : adder_generator