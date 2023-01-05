//`include "timer_input.v"
`include "uart_rx.v"
`include "uart_tx.v"
`include "fifo.v"

module uart
  #(
    parameter DBIT = 8,		// # number of data bits
    		  SB_TICK =16	// # number of ticks
  )
  (
    input clk, reset_n,
    	
    
    
   	//transmitter ports
    input [DBIT -1 : 0] w_data,	//data input parallel to uart
    input wr_uart,				//enable write to uart port
    output tx,					//serial output data
    output tx_full,				//indicate that FIFO is full
    
    //receiver ports
    input rd_uart,				//flag to start reading from uart
    input rx,					//serial data input
    output rx_empty,			//flag to indicate that the FIFO is empty and there is no data to read
    output [DBIT - 1: 0] r_data,	//parallel output data
    output rx_done_tick,
    output [DBIT - 1 : 0] rx_dout,
    output fifo_full,
    output [DBIT -1 : 0] tx_din
  );
  
  //receiver
  //wire rx_done_tick;
  //wire [DBIT - 1 : 0] rx_dout;
  
  uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) receiver(
    .clk(clk),
    .reset_n(reset_n),
    .rx(rx),
    .s_tick(clk),
    .rx_done_tick(rx_done_tick),
    .rx_dout(rx_dout)
  );


  //fifo for receiver
  fifo rx_FIFO(
    .clk(clk),				//input wire clock
    .rst(reset_n),		//input wire srst
    .data_in(rx_dout),			//input wire [7:0] din
    .wr(rx_done_tick),	//input wire wr_en
    .rd(rd_uart),		//input wire rd_en
    .data_out(r_data),			//output wire [7:0] dout
    .full(fifo_full),				//output wire full
    .empty(rx_empty)		//output wire empty
  );
  

  //transmitter 
  wire tx_fifo_empty, tx_done_tick;
  uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) transmitter(
    .clk(clk),
    .reset_n(reset_n),
    .tx_start(wr_uart),
    .s_tick(clk),
    .tx_din(w_data),
    .tx_done_tick(tx_done_tick),
    .tx(tx)
  );

  fifo tx_FIFO(
    .clk(clk),				//input wire clock
    .rst(reset_n),		//input wire srst
    .data_in(w_data),			//input wire [7:0] din
    .wr(wr_uart),	//input wire wr_en
    .rd(tx_done_tick),		//input wire rd_en
    .data_out(tx_din),			//output wire [7:0] dout
    .full(tx_full),				//output wire full
    .empty(tx_fifo_empty)		//output wire empty
  );
  
endmodule  