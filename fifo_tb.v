// Code your testbench here
// or browse Examples
//timescale 1ns/10ps
`include "fifo.v"

`define CLK @(posedge clk)

module apb_slave_tb();
  
  reg rd; 
  reg wr;
  reg empty; 
  reg full;
  
  wire [7:0] data_out;
  wire [7:0] fifo_ram[0:7];
  
  reg [7:0] data_in;
  
    reg clk;
    reg rst; //Active low reset
      

    // CLock Implementation
     always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end

    
    fifo dut(.*);
    
    initial begin
       rd = 0;
      wr=0;    
        rst = 1'b0;
        repeat (2) CLK;
        rst = 1'b1;
          data_in = 8'hf0;

      wr = 1;
      rd =1;
      repeat(1) CLK;
      wr = 0;
      rd =1;
      repeat(1) CLK;
      rd = 0;
      #500
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