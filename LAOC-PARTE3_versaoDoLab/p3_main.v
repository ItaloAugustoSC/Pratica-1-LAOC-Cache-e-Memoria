	module p3_main (SW, KEY, LEDG, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	// 17: wren - [15:11]: addr - [7:0]: in
	input [17:0] SW;
	input [3:0] KEY;

	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	output reg[7:0] LEDG;
	
	wire [7:0] in;
	wire [4:0] addr;
	wire [4:0] addrRAM;
	wire wren, clock, writeBack, clockRAM, clockMux;
	wire [7:0] dataMemOut;
	wire [7:0] dataMem;
	wire [7:0] dataCacheOut;
	wire [7:0] dataOut;
	wire [4:0] addrCacheOut;
	wire [4:0] addrInRAM;
	
	wire [8:0] exibirBlocoVia0;
	wire [8:0] exibirBlocoVia1;
	wire [8:0] exibirBlocoVia0Antes;
	wire [8:0] exibirBlocoVia1Antes;
	
	wire [8:0] cacheVia0;
	wire [8:0] cacheVia1;
	wire [8:0] cacheVia0Antes;
	wire [8:0] cacheVia1Antes;
	wire [2:0] dataMEMDANDOCERTO;
	wire [2:0] dataInOut;


	//[15:13]: Tag - [12:11]: Indice
	// Usado para modificar a pinagem da placa
	assign addr = SW[15:11];
	assign wren = SW[17];
	assign in = SW[7:0];
	assign clock = KEY[0];
	assign clockRAM = KEY[1];
	assign addrRAM = SW[14:11];

	assign dataMem = dataMemOut;
	
	p3_cache c1(addr, clock, wren, in, dataMem, dataOut, writeBack, dataCacheOut, hit, cacheVia0, cacheVia1, cacheVia0Antes, cacheVia1Antes, dataMEMDANDOCERTO, dataInOut, addrCacheOut, via);

	
	p3 R0(addrCacheOut, clock, dataCacheOut, writeBack, dataMemOut);
	
	assign exibirBlocoVia0 = cacheVia0;
	assign exibirBlocoVia1 = cacheVia1;
	assign exibirBlocoVia0Antes = cacheVia0Antes;
	assign exibirBlocoVia1Antes = cacheVia1Antes;

	//8: Valid - 7: Dirty - 6: LRU - [5:3]: TAG - [2:0]: Dados
	
	reg [8:0] cacheDataOutToDisplay;
	reg [2:0] addressOutRoDisplay;
	reg lruToDisplay;
	reg dirtyToDisplay;
	reg validToDisplay;
	
	always @(posedge clock) begin
		if(via == 0) begin
			cacheDataOutToDisplay = cacheVia0[2:0];
			addressOutRoDisplay = cacheVia0[5:3];
			lruToDisplay = cacheVia0[6]; 
			dirtyToDisplay = cacheVia0[7];
			validToDisplay = cacheVia0[8];
		end
		else if(via == 1) begin
			cacheDataOutToDisplay = cacheVia1[2:0];
			addressOutRoDisplay = cacheVia1[5:3];
			lruToDisplay = cacheVia1[6]; 
			dirtyToDisplay = cacheVia1[7];
			validToDisplay = cacheVia1[8];
		end
	end

	display H1 ({3'b000, hit}, clock, HEX1); // H1 - Hit
	display H3 ({1'b0, cacheDataOutToDisplay}, clock, HEX3); // H3 - DataOut
	display H4 ({1'b0, addressOutRoDisplay}, clock, HEX4); // H4 - Address
	display H5 ({3'b000, lruToDisplay}, clock, HEX5); // H5 - LRU
	display H6 ({3'b000, dirtyToDisplay}, clock, HEX6); // H6 - Dirty
	display H7 ({3'b000, validToDisplay}, clock, HEX7);// H7 - Valid - 1 bit

endmodule
