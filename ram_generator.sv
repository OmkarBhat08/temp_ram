`include "defines.sv"
class ram_generator;

//PROPERTIES
  ram_transaction blueprint;								//Ram transaction class handle 
  mailbox #(ram_transaction)mbx_gd;					//Mailbox for generator to driver connection

//METHODS
  //Explicitly overriding the constructor to make mailbox connection from generator to driver
  function new(mailbox #(ram_transaction)mbx_gd);
    this.mbx_gd=mbx_gd;			//Makes a simple copy
    blueprint=new();
  endfunction

  //Task to generate the random stimuli
  task start();
    for(int i=0;i<`no_of_trans;i++)
      begin
      //Randomizing the inputs
        void'(blueprint.randomize());
      //Putting the randomized inputs to mailbox    
        mbx_gd.put(blueprint.copy());  
        $display("generator randomized transaction: data_in=%0d,write_enb=%0d,read_enb=%0d,address=%0d,time=%0t", blueprint.data_in,blueprint.write_enb,blueprint.read_enb,blueprint.address,$time);
				#130;
      end
  endtask
endclass

