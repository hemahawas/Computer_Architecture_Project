`include "uart_rx.v"
`define CLK @(posedge clk)

module apb_slave_tb();
   	
  	reg clk, reset_n, rx;

    wire rx_done_tick;
  	wire [7 : 0] rx_dout;
  	wire [7:0]	b_reg;
  
  
    // CLock Implementation
     always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end

  uart_rx dut(.clk(clk),
                  .reset_n(reset_n),
                  .rx(rx),
                  .rx_done_tick (rx_done_tick),
                  .rx_dout (rx_dout),
              .s_tick(clk)
                 );
    
    initial begin
        reset_n = 1'b0;
     	repeat (2) `CLK;
      
      //
      rx = 1'b1;
      repeat (2) `CLK;
      rx= 1'b1;
      repeat (2) `CLK; 
      
      //start bit
      rx = 0;
      repeat (15) `CLK;
      
      // data bits 
      rx = 1;
      repeat (15) `CLK;
      rx = 1;
      repeat (15) `CLK;
      rx = 1;
      repeat (15) `CLK;
      rx = 1;
      repeat (15) `CLK;
      rx = 1;
      repeat (15) `CLK;
      rx = 1;
      repeat (15) `CLK;
      rx = 1;
      repeat (15) `CLK;
      rx = 1;
      repeat (15) `CLK;
      //stop bit
      rx = 1;
      repeat (15) `CLK;
      //done
      
      
     
      rx = 1;
      repeat (15) `CLK;
      
      //10417
      repeat(15) `CLK;
        
    $finish();
end
  /*
 
    //apb slave
    always@(posedge pclk or negedge preset_n) begin
        if(~preset_n)
        pready_i <= 1'b0;
        else begin
        if(psel_o && penable_o)begin
            pready_i <= 1'b1;
            prdata_i <= $urandom%8'h20;
        end else begin
            pready_i <= 1'b0;
            //prdata_i <= 32'b0;
        end
        end

    end
*/
    //dump 
    initial begin
        $dumpfile("abp_master.vcd");
      $dumpvars(2,apb_slave_tb);
    end

endmodule