interface ram_if(input bit clk,reset);
//Declaring signals with width
  logic[7:0] data_in,data_out;
  logic write_enb,read_enb;
  logic[4:0] address;

//Clocking block for driver
  clocking drv_cb@(posedge clk);
    default input #0 output #0; 		//Specifying the values for input and output skews 
//Declaring signals without widths, but specifying the direction
    input reset;
    output write_enb,read_enb,data_in,address;
  endclocking

//Clocking block for monitor
  clocking mon_cb@(posedge clk);
    default input #0 output #0;			//Specifying the values for input and output skews
    input data_out,address,reset;		//Declaring signals without widths, but specifying the direction
  endclocking

//clocking block for reference model
  clocking ref_cb@(posedge clk);
  //  default input #0 output #0;			//Specifying the values for input and output skews
  //Declaring signals without widths, but specifying the direction
 // 	input data_in,write_enb,read_enb,address,reset;
//  	output data_out;
  endclocking

//modports for driver, monitor and reference model
  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);
  modport REF_SB(clocking ref_cb);
endinterface

