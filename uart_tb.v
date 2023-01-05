// Code your testbench here
// or browse Examples
`include "uart.v"
`define CLK @(posedge clk)

module apb_slave_tb();
   	
  	reg clk, reset_n;
  
  reg [7 : 0] w_data;	//data input parallel to uart
    reg wr_uart;				//enable write to uart port
    wire tx;					//serial output data
    wire tx_full;				//indicate that FIFO is full
    
    //receiver ports
    reg rd_uart;				//flag to start reading from uart
    reg rx;						//serial data input
    wire rx_empty;			//flag to indicate that the FIFO is empty and there is no data to read
  wire [7: 0] r_data;	//parallel output data
  wire rx_done_tick;
  wire [7 : 0] rx_dout;
  wire fifo_full;
  wire [7 : 0] tx_din;
  wire [7:0] fifo_ram[0:7];


    // CLock Implementation
     always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end

  uart dut(.*);
  	
initial begin
  //rx test bensh
  rd_uart = 0;
		reset_n = 1'b0;
     	repeat (2) `CLK;
      reset_n = 1'b1;
      //
      rx = 1'b1;
      repeat (2) `CLK;
      rx= 1'b1;
      repeat (2) `CLK; 
      
      //start bit
      rx = 0;
      repeat (16) `CLK;
      
      // data bits 			//110011111
      rx = 1;
      repeat (16) `CLK;
      rx = 1;
      repeat (16) `CLK;
      rx = 1;
      repeat (16) `CLK;
      rx = 1;
      repeat (16) `CLK;
      rx = 1;
      repeat (16) `CLK;
      rx = 0;
      repeat (16) `CLK;
      rx = 0;
      repeat (16) `CLK;
      rx = 1;
      repeat (16) `CLK;
      //stop bit
      rx = 1;
      repeat (16) `CLK;
      //done
  //`CLK
  	  rd_uart = 1'b1;
     `CLK
      rd_uart = 0;
      repeat (16) `CLK;
  
  //transmitter
  w_data = r_data;
  `CLK;
  wr_uart = 1'b1;
  `CLK
  wr_uart = 1'b0;
  repeat (161) `CLK;

  
  
  $finish();
end
    	
    initial begin
        $dumpfile("abp_master.vcd");
      $dumpvars(2,apb_slave_tb);
    end

endmodule