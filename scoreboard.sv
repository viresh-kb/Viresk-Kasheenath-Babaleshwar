class socreboard;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
adder_transaction drv_addr_pkt;
adder_transaction mon_addr_pkt;
mailbox mon2scb, drv2scb;
string name;
event mon_done;
int packets_proc = 0;
int correct_match = 0;
int incorrect_match = 0;
int no_of_packets = 10;
int actual_output;
int desired_output;


/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "adder_scoreboard");
		this.name = name;
		log("ADDER_SCOREBOARD_BUILD");
	endfunction : new

	function void log(string message);
		$display("[%t] INFO [SCO %s]: %s",$time, this.name, message);
	endfunction : log

	function void connect(mailbox mon2scb, mailbox drv2scb, event mon_done/*semaphore end_of_sb*/);
		this.mon2scb = mon2scb;
		this.drv2scb = drv2scb;
		this.mon_done = mon_done;
		log("ADDER_SCOREBOARD_CONNECT"); 
	endfunction : connect

	function bit compare(int actual_output, int desired_output0);/*adder_transaction drv_addr_pkt ,adder_transaction mon_addr_pkt*/;
		// if (drv_addr_pkt.a_in + drv_addr_pkt.b_in == mon_addr_pkt.sum_out) begin
			if (actual_output == desired_output) begin	
			return 1;	
		end else 
		return 0;
	endfunction : compare

	task run();
		forever begin
			drv_addr_pkt = new();
			mon_addr_pkt = new();
			log("ADDER_SCOREBOARD_RUN_STARTS"); 
			wait(mon_done.triggered);
			log("ADDER_MONITOR_EVENT_DETECTED"); 
			mon2scb.get(mon_addr_pkt);
			drv2scb.get(drv_addr_pkt);
			actual_output  = mon_addr_pkt.sum_out;
			desired_output  = drv_addr_pkt.a_in + drv_addr_pkt.b_in; 
			$display("actual_op = %d",actual_output);
			$display("desired_op = %d",desired_output);
			// if (this.compare(drv_addr_pkt, mon_addr_pkt)) begin
			if (this.compare(actual_output, desired_output)) begin	
				correct_match++;
				$display("[%t]Packets Correctly Matched", $time);
				mon_addr_pkt.display_transaction();
				drv_addr_pkt.display_transaction();
			end else begin
				incorrect_match++;
				$display("[%t]Packets Incorrectly Matched", $time);
				mon_addr_pkt.display_transaction();
				drv_addr_pkt.display_transaction();
			end
			packets_proc++;
			$display("packets_proc = %d",packets_proc);
		end
	endtask : run

endclass : socreboard