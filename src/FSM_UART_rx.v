`timescale 1ns / 1ps

module FSM_UART_rx(
	input rx,
	input clk,
	input rst,
	input end_bit_time_t, //Bit rate flag
	input [3:0] Rx_bit_Count, //Count to 9 for 8bits data and 1 parity bit
	output reg bit_counter_en_rx, //enable for counter
	output reg bit_shift_en_rx, //
	output reg bit_WAIT_RX, //enable to bit rate.
	output reg rst_WAIT_RX, //rst for bit rate (idle TX line)
	output reg rst_bit_counter_rx, //rst for counter bits.
	output reg finish,
	output reg busy
);

//localparam to define every state 	in gray code 
localparam INI_R		= 3'b000;
localparam START_R	= 3'b001;
localparam WAIT_RX	= 3'b010;
localparam RESET_TIM	= 3'b011;
localparam RX_BITS	= 3'b100;
localparam STOP		= 3'b101;


reg [2:0] Rx_state;
reg samp;
wire So;

//procedural blocks to define the road for every state, Rx_state is updated once the state is present.

always @(posedge rst, posedge clk)
	begin
		if (rst) 
		begin
			Rx_state<= INI_R;
		end
		else
		case (Rx_state)
				INI_R: 		
					if (rx==0)
						Rx_state <= START_R;
				START_R:		
					Rx_state <= WAIT_RX;
				RX_BITS:	
					if (Rx_bit_Count == 4'b1001)
						Rx_state <= STOP;
					else
						Rx_state <= WAIT_RX;
				WAIT_RX:	
					if (end_bit_time_t)	
						if (So == 4'b0)
						begin
							Rx_state <= RX_BITS;
						end
						else
						begin
							Rx_state <= RESET_TIM;
						end
					else
						Rx_state <= WAIT_RX;
				RESET_TIM:
						Rx_state <= WAIT_RX;		
				STOP:		
					Rx_state <= INI_R;
				default:		
					Rx_state <= INI_R;
		endcase
	end
// OUTPUT DEFINITION
//procedural blocks to define which variables are changing according with the present state, Rx_state define that chenge.
always @(Rx_state)
	begin
				case(Rx_state)
				INI_R: 	
					begin
						bit_counter_en_rx = 1'b0;
						rst_bit_counter_rx = 1'b0;
						bit_shift_en_rx = 1'b0;
						bit_WAIT_RX = 1'b0;
						rst_WAIT_RX = 1'b0;
		            busy = 1'b0;				
						finish = 1'b0;
						samp = 1'b0;
					end
				START_R: 	
					begin
						bit_counter_en_rx = 1'b0;
						rst_bit_counter_rx = 1'b1;
						bit_shift_en_rx = 1'b0;
						bit_WAIT_RX = 1'b0;
						rst_WAIT_RX = 1'b1;
		            busy = 1'b1;				
						finish = 1'b0;
						samp = 1'b0;
					end
				RX_BITS: 	
					begin
						bit_counter_en_rx = 1'b1;
						rst_bit_counter_rx = 1'b0;
						bit_shift_en_rx = 1'b1;
						bit_WAIT_RX = 1'b0;
						rst_WAIT_RX = 1'b1;
		            busy = 1'b1;				
						finish = 1'b0;
						samp = 1'b1;
					end
				WAIT_RX:
					begin
						bit_counter_en_rx = 1'b0;
						rst_bit_counter_rx = 1'b0;
						bit_shift_en_rx = 1'b0;
						bit_WAIT_RX = 1'b1;
						rst_WAIT_RX = 1'b0;
		            busy = 1'b1;				
						finish = 1'b0;
						samp = 1'b0;
					end
				RESET_TIM:
					begin
						bit_counter_en_rx = 1'b0;
						rst_bit_counter_rx = 1'b0;
						bit_shift_en_rx = 1'b0;
						bit_WAIT_RX = 1'b0;
						rst_WAIT_RX = 1'b1;
		            busy = 1'b1;				
						finish = 1'b0;
						samp = 1'b1;	
					end
				STOP: 	
					begin
						bit_counter_en_rx = 1'b0;
						rst_bit_counter_rx = 1'b1;
						bit_shift_en_rx = 1'b0;
						bit_WAIT_RX = 1'b0;
						rst_WAIT_RX = 1'b1;
		            busy = 1'b0;				
						finish = 1'b1;	
						samp = 1'b1;	
					end						
				default:
					begin
						bit_counter_en_rx = 1'b0;
						rst_bit_counter_rx = 1'b0;
						bit_shift_en_rx = 1'b0;
						bit_WAIT_RX = 1'b0;
						rst_WAIT_RX = 1'b0;
		            busy = 1'b0;				
						finish = 1'b0;	
						samp = 1'b0;	
					end
			endcase
	end
FF_D_enable Sampling(
.clk(clk),
.rst(rst),
.enable(samp),
.d(~So),
.q(So));
endmodule