`include "transmitter.v"


module tx_test;
reg clk, reset,tx_start;
reg [7:0]data_in;
wire txd,tx_done;

uart_tx uut(clk,reset,tx_start,data_in,txd,tx_done);


initial begin
    clk=0;
    reset=1;
    #20 reset=0;
    #40 tx_start=1;
    #20 $display($time, "---start process---");
    data_in = 8'haa;
    #5000 tx_start= 0;
    #200210 $stop;

end
always #10 clk= ~clk;



initial begin
    $dumpfile("dump.vcd");
    $dumpvars(2, tx_test);
end


endmodule
