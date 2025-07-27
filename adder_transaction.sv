class adder_transaction;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	rand logic [7:0] a_in;
	rand logic [7:0] b_in;
	logic [8:0] sum_out;

	constraint c1 { a_in inside {[0:100]};
				    b_in inside {[101:200]};}
	
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	function void display_transaction();
		$display("A = %d, B = %d, SUM = %d",a_in,b_in,sum_out);
	endfunction	


endclass : adder_transaction