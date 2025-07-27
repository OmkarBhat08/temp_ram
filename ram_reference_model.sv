
`include "defines.sv"
class ram_reference_model;
//PROPERTIES
  //Ram transaction class handle
   ram_transaction ref_trans;
  //Mailbox for reference model to scoreboard connection
   mailbox #(ram_transaction) mbx_rs;
  //Mailbox for driver to reference model connection
   mailbox #(ram_transaction) mbx_dr;
  //Virtual interface with driver modport and it's instance
   virtual ram_if.REF_SB vif;
  //Associative array used for mimicing the functionality of the RAM
   bit [7:0] MEM [31:0];

//METHODS
  //Explicitly overriding the constructor to make mailbox connection from driver
  //to reference model, to make mailbox connection from reference model to scoreboard
  //and to connect the virtual interface from reference model to enviornment 
  function new(mailbox #(ram_transaction) mbx_dr,
               mailbox #(ram_transaction) mbx_rs,
               virtual ram_if.REF_SB vif);
    this.mbx_dr=mbx_dr;
    this.mbx_rs=mbx_rs;
    this.vif=vif;
  endfunction

  //Task which mimics the functionality of the RAM
  task start();
    for(int i=0;i<`no_of_trans;i++)
     begin
      ref_trans=new();
     //getting the driver transaction from mailbox 
      mbx_dr.get(ref_trans);
      repeat(1) @(vif.ref_cb)
       begin 
					$display("----------------Reference model----------------");
        if(ref_trans.write_enb == 1)
				begin
         MEM[ref_trans.address]=ref_trans.data_in;
				 	$display("writing data %0d in address %0d,time=%0t",MEM[ref_trans.address],ref_trans.address,$time);
				end
        if(ref_trans.read_enb == 1)
				begin
         ref_trans.data_out=MEM[ref_trans.address];
        $display("Reference model reading data_out =%0d from address=%0d,time=%0t",ref_trans.data_out,ref_trans.address,$time);
				end
       end
     //Putting the reference model transaction to mailbox 
      mbx_rs.put(ref_trans);
     end 
  endtask
endclass
