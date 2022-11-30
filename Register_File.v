module Register_File(
	clk,
	rst_n,
	read_addr1,
	read_addr2,
	write_en,
	write_addr,
	write_data,
	read_data1,
	read_data2
    );

input clk;
input rst_n;
// 5 bit address of registers
input [4:0] read_addr1;
input [4:0] read_addr2;
input write_en;
// 5 bit write address of register
input [4:0] write_addr;
// 32 bit write data we want to store to register
input [31:0] write_data;
// 32 bit data from the we read from 
output wire [31:0] read_data1;
output wire [31:0] read_data2;

reg [31:0] reg_mem [31:0];

// Read data from our register memory file
initial begin
$readmemh("reg_memory.mem", reg_mem); //Load initial values
end

assign read_data1 = reg_mem[read_addr1];
assign read_data2 = reg_mem[read_addr2];

always @ (posedge clk or negedge rst_n)
begin
if (!rst_n)
begin
reg_mem[write_addr] <= reg_mem[write_addr];
end
else
begin
reg_mem[write_addr] <= write_en ? write_data : reg_mem[write_addr];
end
end

endmodule