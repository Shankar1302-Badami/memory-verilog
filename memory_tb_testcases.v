`include "memory.v"

module tb;

	parameter WIDTH=8;
	parameter DEPTH=16;
	parameter ADDR_WIDTH=$clog2(DEPTH);

	reg clk,rst,wr_rd,valid;
	reg [ADDR_WIDTH-1:0]addr;
	reg[WIDTH-1:0]wdata;
	wire [WIDTH-1:0]rdata;
	wire ready;
	integer i;
	reg[20*8-1:0]test_name;

memory dut(.clk(clk),.rst(rst),.wr_rd(wr_rd),.addr(addr),.wdata(wdata),.rdata(rdata),.valid(valid),.ready(ready));

always #5 clk=~clk;
initial begin
$value$plusargs("test_name=%0s",test_name);
end 
initial begin
clk=0;
rst=1;
reset();
	repeat(2)@(posedge clk);
rst=0;

case(test_name)
	"1WR_1RD":begin
	writes(15,1);
	reads(15,1);
end 
	"5WR_5RD": begin
	writes(15,5);
	reads(15,5);
	end 
	"fd_wr_fd_rd": begin
	writes(0,DEPTH);
	reads(0,DEPTH);
	end
	"bd_wr_bd_rd":begin
	bd_writes();
	bd_reads();
	end
	"fd_wr_bd_rd":begin
	writes(5,10);
	bd_reads();
	end
	"bd_wr_fd_rd":begin
	bd_writes();
	reads(0,DEPTH);
	end
endcase
#100;
$finish;
end 

task reset(); begin
wr_rd=0;
valid=0;
addr=0;
wdata=0;
end 
endtask

task writes(input reg[ADDR_WIDTH-1:0]start_loc,input reg[ADDR_WIDTH:0]num_loc); begin
	for(i=start_loc;i<start_loc+num_loc;i=i+1) begin
	@(posedge clk);
	wr_rd=1;
	addr=i;
	wdata=$urandom_range(100,200);
	valid =1;
	wait(ready==1);
end 
@(posedge clk);
reset();
end 
endtask

task reads(input reg[ADDR_WIDTH-1:0]start_loc,input reg[ADDR_WIDTH:0]num_loc ); begin
for(i=start_loc;i<start_loc+num_loc;i=i+1) begin
@(posedge clk)
wr_rd=0;
addr=i;
valid =1;
wait(ready==1);
end 
@(posedge clk);
reset();
end 
endtask

task bd_writes();
	$readmemh("input.hex",dut.mem);
endtask

task bd_reads();
	$writememh("output.hex",dut.mem);
endtask
endmodule
