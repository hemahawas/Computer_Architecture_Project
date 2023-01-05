`include "timer_input.v"
`define CLK @(posedge clk)

module apb_slave_tb();
   	reg clk, reset_n, enable;
  
  	reg[9 : 0] FINAL_VALUE;
    wire done;
  
  
    // CLock Implementation
     always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end

    timer_input dut(.*);
    
    initial begin
        enable = 1; 
        reset_n = 1'b0;
     	repeat (2) `CLK;
      	FINAL_VALUE = 650;
        reset_n = 1'b1;
      repeat (1953) `CLK;
        
    $finish();
end
  

    //dump 
    initial begin
        $dumpfile("abp_master.vcd");
      $dumpvars(2,apb_slave_tb);
    end

endmodule