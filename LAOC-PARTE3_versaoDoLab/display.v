module display (entrada, clockDisplay, saida);
	input [3:0] entrada;
	input clockDisplay;
	output reg [0:6] saida;

	always @(posedge clockDisplay) begin
		case(entrada)
			0: saida=7'b0000001;
			1: saida=7'b1001111;
			2: saida=7'b0010010;
			3: saida=7'b0000110;
			4: saida=7'b1001100;
			5: saida=7'b0100100;
			6: saida=7'b0100000;
			7: saida=7'b0001111;
			8: saida=7'b0000000;
			9: saida=7'b0001100;
			10:saida=7'b0001000;
			11:saida=7'b1100000;
			12:saida=7'b0110001;
			13:saida=7'b1000010;
			14:saida=7'b0110000;
			15:saida=7'b0111000;
		endcase
	end
endmodule
