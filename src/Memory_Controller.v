module Memory_Controller
#(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32)(
	input WrtEn, RdEn,
	input [(ADDR_WIDTH-1):0] ADDRIn,
	output RAM_En,
	output RAM_rd_En,
	output GPIO_En,
	output UART_En,
	output reg[1:0] Sel,
	output reg [(ADDR_WIDTH-1):0] ADDROut
);

reg RAMen, GPIOen, ROMen, UARTen;
assign RAM_En = RAMen & WrtEn;
assign RAM_rd_En = RAMen & RdEn ;
assign GPIO_En = GPIOen & WrtEn;
assign UART_En = UARTen & WrtEn;
//assign ROM_En = ROMen & WrtEn;

always @ *
begin
	if(ADDRIn >= 32'h7FFF_EEFC) begin
		RAMen = 1'b1;
		GPIOen = 1'b0;
		UARTen = 1'b0;
		ADDROut = ADDRIn - 32'h7FFF_EEFC;
		Sel = 2'd0;
	end
	else if(ADDRIn >= 32'h1001002C) begin
		RAMen = 1'b0;
		GPIOen = 1'b0;
		UARTen = 1'b1;
		ADDROut = ADDRIn - 32'h1001002C;
		Sel = 2'd1;
	end
	else if(ADDRIn >= 32'h10010024) begin
		RAMen = 0;
		GPIOen = 1;
		UARTen = 1'b0;
		ADDROut = ADDRIn - 32'h10010024;
		Sel = 2'd2;
	end
/*	else if(ADDRIn >= 32'h00400000) begin
		RAMen = 0;
		GPIOen = 0;
		UARTen = 1'b0;
		ADDROut = ADDRIn - 32'h00400000;
		Sel = 2'd3;
	end*/
	else begin
		RAMen = 0;
		GPIOen = 0;
		UARTen = 1'b0;
		ADDROut = 32'h0;
		Sel = 2'd0;
	end
end
endmodule