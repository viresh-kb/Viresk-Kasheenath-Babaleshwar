// `include "adder_genrator.sv"
// `include "adder_driver.sv"
class adder_enviourment;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	adder_generator gen;
	adder_driver drv;
	mailbox gen2drv/* drv2sb, drv2cvg*/;
	mailbox mon2scb, drv2scb;
	event gen_done, mon_done;
	virtual adder_interface.drv_mp drv_vif;
	virtual adder_interface.mon_mp mon_vif;
	string name;
	adder_monitor mon;
	socreboard sco;
	// adder_coverage cvg;
	// semaphore end_of_sb;
	// virtual adder_intf.mon_mp adder_mon_vif;
	//virtual mem_intf.mp_mon mem_vif
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	// function new();
		
	// endfunction : new

	function void log(string message);
		$display("[%t] INFO [ENV %s]: %s",$time, this.name, message);
	endfunction : log

	function new (string name = "adder_enviourment");
		this.name = name;
		this.gen = new("adder_GENRATOR");
		this.drv = new("adder_DRIVER");
		this.gen2drv = new();
		
		this.mon = new("adder_MONITOR");
		this.sco = new("adder_SCOREBOARD");
		// this.cvg = new("adder_FUCTIONAL_COVERAGE");
		this.mon2scb = new();
		this.drv2scb = new();
		// this.drv2cvg = new();
		// this.gen_done = new();
		// this.adder_mon_vif = adder_mon_vif;
		log("ADDER_ENVIOURMENT_BUILD");
	endfunction : new

	function void connect(virtual adder_interface.drv_mp drv_vif, virtual adder_interface.mon_mp mon_vif);
		this.drv_vif = drv_vif;
		this.mon_vif = mon_vif;
		this.gen.connect(gen2drv,gen_done);
		this.drv.connect(gen2drv, drv2scb, /*drv2cvg,*/gen_done,drv_vif);
		this.mon.connect(mon2scb, mon_done, mon_vif);
		this.sco.connect(mon2scb,drv2scb,mon_done);
		// this.cvg.connect(drv2cvg);
		log("adder_ENVIOURMENT_CONNECT");
	endfunction : connect

	task run(input integer iteration);
		
		log("ADDER_ENVIOURMENT_RUN_STARTS");
		fork
			
				this.gen.run(iteration);
			
				this.drv.run(iteration);
			
				// this.cvg.run();
			
				this.mon.run(iteration);

				this.sco.run();
		join_any
		log("ADDER_ENVIOURMENT_RUN_ENDS");
	endtask : run

endclass : adder_enviourment