module mux_address(clock, addressInCache, addressInProcessor, wren, addressOut);
	input wire clock;
	input wire wren;
	input wire [4:0] addressInCache;
	input wire [4:0] addressInProcessor;
	
	output reg [4:0] addressOut;

	always @(posedge clock) begin
		if(wren) begin
			addressOut <= addressInProcessor;
		end else begin 
			addressOut <= addressInCache;
		end
	end

endmodule
