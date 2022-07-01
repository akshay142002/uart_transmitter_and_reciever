`define idle 3'b000
`define start 3'b001 
`define trans 3'b010 
`define stop 3'b011

module uart_tx(clk,reset,tx_start,data_in,txd,tx_done);
input clk, reset,tx_start;
input [7:0]data_in;
output txd,tx_done;

wire clk,reset,tx_start;
wire [7:0]data_in;
reg tx_done;
wire txd;

reg[2:0] ps,ns;
reg[7:0]sbuf_reg,sbuf_next;
reg [0:2] count_reg ,count_next;
reg tx_reg , tx_next;

wire tick;
reg[9:0]q;
wire[9:0]q_next;

//memory for fsm
always @(posedge clk) begin
    if(reset)
    begin
      ps = `idle;
      sbuf_reg = 0;
      count_reg = 0;
      tx_reg = 0;
    end
    else 
    begin
      ps = ns;
      sbuf_reg= sbuf_next;
      count_reg = count_next;
      tx_reg =tx_next;
    end
end

//next state block
always @(*) 
    begin
        ns = ps;
        sbuf_next = sbuf_reg;
        count_next = count_reg;
        tx_next = tx_reg;

        case(ps)

`idle:
begin
  $display($time, "---idle state---");
  tx_next = 1;
  tx_done=0;
  if(tx_start == 1)
  begin
    ns = `start;
 $display($time, "---idle state to start---");
 end
end

`start:
begin
  $display($time, "---start state---");
  tx_next = 0;

  if(tick)
  begin
    sbuf_next= data_in;
    count_next=0;
    ns = `trans;
 $display($time, "---start to trans---");
 end
end

`trans:
begin
  $display($time, "---trans state---");
  tx_next = sbuf_reg[0];

  if(tick)
  begin
    sbuf_next= sbuf_reg>>1;
    if (count_reg==7) begin
        ns = `stop;
        
 $display($time, "-- trans to stop---");
    end
 else
 count_next = count_reg + 1;
end
end


`stop:
begin
  $display($time, "---start state---");
  tx_next = 1;               //stop bit

  if (tick)
  begin
     tx_done=1;
    ns = `idle;
 end
end

default : ns= `idle;
        endcase
    end

assign txd = tx_reg;

//------------
//--baud rate gen----
always @(posedge clk) begin
 
    if (reset) 
    q = 0; 
    else 
    q = q_next; 
end

assign q_next = (q == 500) ? 0 : q + 1;
assign tick = (q == 500) ? 1 : 0;

//-------

endmodule

 








