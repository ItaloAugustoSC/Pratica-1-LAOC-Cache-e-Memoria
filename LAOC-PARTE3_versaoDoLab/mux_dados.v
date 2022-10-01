module mux_dados(clock, dataInRAM, dataInProcessor, wren, dataOut);
	input wire clock;
	input wire wren;
	input wire [7:0] dataInRAM;
	input wire [7:0] dataInProcessor;
	
	output reg [7:0] dataOut;

	always @(posedge clock) begin
		if(wren) begin
			dataOut <= dataInProcessor;
		end else begin 
			dataOut <= dataInRAM;
		end
	end

endmodule
