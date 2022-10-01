`timescale 100ps / 1ps

module p3_cache(input[4:0] addr, 
	input clock,
	input wren,	
	input [7:0] dataIn, // dado que esta indo do circuito para a cache
	input [7:0] dataMemOut, // dado que esta indo da memoria para a cache
	
	output reg[7:0] dataOut, // o bloco da cache que está sendo enviado para o circuito
	output reg cacheWriteBackMem, // sinal de acesso à memoria
	output reg[7:0] dataCacheParaMem, // o bloco da cache que está sendo enviado para a memoria WRITE BACK
	output reg hit, // 1 se a instrução der hit e se a instrução der miss
	output reg [8:0] blocoVia0, // bloco da via 0 que sai para o circuito
	output reg [8:0] blocoVia1, // bloco da via 1 que sai para o circuito
	output reg [8:0] blocoVia0Antes, // bloco da via 0 antes da mudança
	output reg [8:0] blocoVia1Antes, // bloco da via 1 antes da mudança
	output reg [2:0] dataMem,
	output reg [2:0] dataInOut,
	output reg [4:0] addrCacheOut, // endereço que sai da cache
	output reg via);
	
	integer index;			// indice
	integer atualiza;		// sinaliza que precisa atualizar o dado da cache
	integer writeBack;   // sinaliza write back
	integer readMemDone; // auxiliar para esperar o dado da memória
	
	//8: Valid - 7: Dirty - 6: LRU - [5:3]: TAG - [2:0]: Dados
	reg [8:0] cacheVia0 [0:3];
	reg [8:0] cacheVia1 [0:3];
	
	reg [8:0] cacheAntiga;
	
		initial begin
			cacheVia0[0]<=9'b000100011;
			cacheVia0[1]<=9'b100000011;
			cacheVia0[2]<=9'b000000000;
			cacheVia0[3]<=9'b101000011;

			cacheVia1[0]<=9'b101101100;
			cacheVia1[1]<=9'b101001111;
			cacheVia1[2]<=9'b000000000;
			cacheVia1[3]<=9'b000000000;
		end
	
	always @(posedge clock) begin
		index = addr[1:0];
		dataMem = dataMemOut[2:0];
		dataInOut = dataIn[2:0];
		addrCacheOut = addr[3:0];
		
		//Atualiza cache via 0
	  if(atualiza == 1 && via == 0) begin 
					
					//Atualiza Dado
					cacheVia0[index][2:0] = dataMem[2:0];
					dataOut = cacheVia0[index][2:0];
					
					// Atualizar TAG na cache
					cacheVia0[index][5:3] = addr[4:2];
					
					// Atualizar Valid
					cacheVia0[index][8] = 1;
					
					// Atualizar LRU
					cacheVia0[index][6] = 1;
					cacheVia1[index][6] = 0;

					atualiza = 0;
					
					if(cacheWriteBackMem == 1) begin
						atualiza = 1;
						cacheWriteBackMem = 0;
					end
					
					if(readMemDone != 7) begin
						atualiza = 1;
						readMemDone = readMemDone + 1;
					end
					
		end
		else if(atualiza == 1 && via == 1) begin
		
					//Atualiza Dado
					cacheVia1[index][2:0] = dataMem[2:0];
					dataOut = cacheVia1[index][2:0];

					
					// Atualizar Valid
					cacheVia1[index][8] = 1;
				
					// Atualizar LRU
					cacheVia0[index][6] = 0;
					cacheVia1[index][6] = 1;				
					
					// Atualizar TAG na cache
					cacheVia1[index][5:3] = addr[4:2];
					
					atualiza = 0;
				
					if(cacheWriteBackMem == 1) begin
						atualiza = 1;
						cacheWriteBackMem = 0;
					end
					
					if(readMemDone != 7) begin
						atualiza = 1;
						readMemDone = readMemDone + 1;
					end
		end
		//Atualiza cache via 1
		// Se leitura da cache	
		else if(clock == 1 && wren == 0) begin 
	
			// Via 0
			if (cacheVia0[index][8] == 1 && // Valid 
				cacheVia0[index][5] == addr[4] && // TAG
				cacheVia0[index][4] == addr[3] && // TAG
				cacheVia0[index][3] == addr[2]) begin
			
				blocoVia0Antes = cacheVia0[index];

				// Atualizar LRU
				cacheVia0[index][6] = 1;
				cacheVia1[index][6] = 0;
				
				
				//Dado de saída
				dataOut = cacheVia0[index][2:0];
				
				addrCacheOut = addr[3:0];

				blocoVia0 = cacheVia0[index];
				
				//Write back zerado
				cacheWriteBackMem = 0;
				
				// Atualizar variável HIT para 1
				hit = 1;
				via = 0;
				readMemDone = 7;
				
				
			end
			// Via 1
			else if (cacheVia1[index][8] == 1 && // Valid
				cacheVia1[index][5] == addr[4] && // TAG
				cacheVia1[index][4] == addr[3] && // TAG
				cacheVia1[index][3] == addr[2]) begin		
			
				blocoVia1Antes = cacheVia1[index];
			
				// Atualizar LRU
				cacheVia0[index][6] = 0;
				cacheVia1[index][6] = 1;
				
				//Dado de saída
				dataOut = cacheVia1[index][2:0];
				
				addrCacheOut = addr[3:0];
				
				blocoVia1 = cacheVia1[index];
				
				//Write back zerado
				cacheWriteBackMem = 0;
				
				// Atualizar variável HIT para 1
				hit = 1;
				via = 1;
				readMemDone = 7;
			end
			else begin 												
				// MISS em ambas vias
				hit = 0;
				cacheWriteBackMem = 1'b0;
				atualiza = 1;
				readMemDone = 0;
				
				
				if(cacheVia0[index][6] == 0) begin // LRU
					
					via = 0;
					
					blocoVia0Antes = cacheVia0[index];
					
					addrCacheOut = addr[3:0];
					
					dataOut = cacheVia0[index][2:0];
				
					// Sinalizar write-back
					if (cacheVia0[index][8] == 1 && // Valid 
						cacheVia0[index][7] == 1) begin
						
						cacheWriteBackMem = 1;
						
						//Dado para a memória
						dataCacheParaMem = cacheVia0[index][2:0];
						
						//Endereço da memória
						addrCacheOut = {cacheVia0[index][4:3], index[1:0]};
						dataOut = cacheVia0[index][2:0];
						
						//Atualizar dirty
						cacheVia0[index][7] = 0;
					end
					
					// Atualizar LRU
					cacheVia0[index][6] = 1;
					cacheVia1[index][6] = 0;
					
					blocoVia0 = cacheVia0[index];
					
					cacheAntiga = cacheVia0[index];
					
					
				end
				else if(cacheVia1[index][6] == 0) begin // LRU
				
					via = 1;
				
					blocoVia1Antes = cacheVia1[index];
					
					addrCacheOut = addr[3:0];
				
					// Sinalizar write-back	
					if (cacheVia1[index][8] == 1 && // Valid
						cacheVia1[index][7] == 1) // Dirty
					begin
						cacheWriteBackMem = 1;
						
						//Dado para a memória
						dataCacheParaMem = cacheVia1[index][2:0];
						
						//Endereço da memória
						addrCacheOut = {cacheVia1[index][4:3], index[1:0]};
						
						// Atualizar dirty
						cacheVia1[index][7] = 0;
					end

					// Atualizar LRU
					cacheVia0[index][6] = 0;
					cacheVia1[index][6] = 1;
					
					blocoVia1 = cacheVia1[index];
					
					cacheAntiga = cacheVia1[index];
					
					dataOut = cacheVia1[index][2:0];
					via = 1;
					
				end
			end
		end
		
		// Se escrita da cache
		else if(clock == 1 && wren == 1) begin 
			// Via 0
			if (cacheVia0[index][8] == 1 && // Valid
				cacheVia0[index][5] == addr[4] && // TAG 
				cacheVia0[index][4] == addr[3] && // TAG
				cacheVia0[index][3] == addr[2]) begin
				
				blocoVia0Antes = cacheVia0[index];
				
				// Atualizar Dirty
				cacheVia0[index][7] = 1;
				
				// Escrever o dado
				cacheVia0[index][2:0] = dataInOut[2:0];
				
				// Atualizar LRU
				cacheVia0[index][6] = 1;
				cacheVia1[index][6] = 0;

				// Atualizar Valid
				cacheVia0[index][8] = 1;
				
				dataOut = dataInOut[2:0];
				
				blocoVia0 = cacheVia0[index];

				// Atualizar, via e readMemDone
				hit = 1;
				via = 0;
				readMemDone = 7;
			end
			// Via 1
			else if (cacheVia1[index][8] == 1 && // Valid
				cacheVia1[index][5] == addr[4] && // TAG
				cacheVia1[index][4] == addr[3] && // TAG
				cacheVia1[index][3] == addr[2]) // TAG
			begin
			
			   blocoVia1Antes = cacheVia1[index];
			
				// Escrever o dado
				cacheVia1[index][2:0] = dataInOut[2:0];

				// Atualizar LRU
				cacheVia0[index][6] = 0;
				cacheVia1[index][6] = 1;

				// Atualizar Dirty
				cacheVia1[index][7] = 1;
				
				// Atualizar Valid
				cacheVia1[index][8] = 1;
				
				dataOut = dataInOut[2:0];
				
				blocoVia1 = cacheVia1[index];
				
				// Atualizar, via e readMemDone
				hit = 1;
				via = 1;
				readMemDone = 7;			
			end
			else begin		
				// MISS			
				atualiza = 1;
				cacheWriteBackMem = 1'b0;
				hit = 0;
				readMemDone = 0;
		
				if(cacheVia0[index][6] == 0) begin 	
					
					via = 0;
					
					blocoVia0Antes = cacheVia0[index];
					
					addrCacheOut = addr[3:0];
					
					dataOut = dataInOut[2:0];
					
					// Sinalizar write-back
					if (cacheVia0[index][8] == 1 && // Valid 
						cacheVia0[index][7] == 1) begin
						
						cacheWriteBackMem = 1;
						
						//Dado para a memória
						dataCacheParaMem = cacheVia0[index][2:0];
						
						//Endereço da memória
						addrCacheOut = {cacheVia0[index][4:3], index[1:0]};
						dataOut = cacheVia0[index][2:0];
						
						// Atualizar dirty
						cacheVia0[index][7] = 1;
					end
				
					// Atualizar LRU
					cacheVia0[index][6] = 1;
					cacheVia1[index][6] = 0;
					
					blocoVia0 = cacheVia0[index];
					
					cacheAntiga = cacheVia0[index];
					
					
				end else begin	

					via = 1;
				
					blocoVia1Antes = cacheVia1[index];
					
					addrCacheOut = addr[3:0];
					
					dataOut = dataInOut[2:0];
					
					// Sinalizar write-back
					if (cacheVia1[index][8] == 1 && // Valid
						cacheVia1[index][7] == 1) begin
						
						cacheWriteBackMem = 1;
						
						//Dado para a memória
						dataCacheParaMem = cacheVia1[index][2:0];
						
						//Endereço da memória
						addrCacheOut = {cacheVia1[index][4:3], index[1:0]};
						dataOut = cacheVia1[index][2:0];
						
						// Atualizar dirty
						cacheVia1[index][7] = 1;
					end
				
					// Atualizar LRU
					cacheVia0[index][6] = 0;
					cacheVia1[index][6] = 1;
					
					blocoVia1 = cacheVia1[index];
					
					cacheAntiga = cacheVia1[index];
					
					
				end
			end
	 end 
end

endmodule
