`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer: Edgar Barba & Jorge Velazquez
// Finite State Machine to control a RS232 transmiter
////////////////////////////////////////////////////////////////////////////////////
module FSM_UART_tx(
    input tx,
    input clk,
    input rst,
    input end_bit_time_t, //Bit rate flag
    input [3:0] Tx_bit_Count, //Count to 9 for 8bits data and 1 parity bit
	 output reg bit_counter_en_tx, //enable for counter
	 output reg bit_enable_start, //enable to load data to register
	 output reg bit_shift_en_tx, //
	 output reg bit_wait_tx, //enable to bit rate.
    output reg rst_wait_tx, //rst for bit rate (idle TX line)
    output reg rst_bit_counter_tx, //rst for counter bits.
	 output reg wb,
	 output reg finish,
	 output reg busy
    );

//localparam to define every state 	in gray code 
localparam INI_T		= 3'b000;
localparam START_T		= 3'b001;
localparam WAIT_TX	= 3'b011;
localparam TX_BITS_T	= 3'b010;
localparam STOP_T			= 3'b110;


reg [2:0] Tx_state;

//procedural blocks to define the road for every state, TX_state is updated once the state is present.

always @(posedge rst, posedge clk)
	begin
		if (rst) 
			Tx_state<= INI_T;
		else 
		case (Tx_state)
				INI_T: 		if (tx)
								Tx_state <= START_T;
				START_T:		Tx_state <= WAIT_TX;
				TX_BITS_T:	if (Tx_bit_Count == 4'b1010)
								Tx_state <= STOP_T;
							else
								Tx_state <= WAIT_TX;
				WAIT_TX:	if (end_bit_time_t)	
								Tx_state <= TX_BITS_T;
							else
								Tx_state <= WAIT_TX;
				STOP_T:		Tx_state <= INI_T;
				default:		Tx_state <= INI_T;
		endcase
	end
// OUTPUT DEFINITION
//procedural blocks to define which variables are changing according with the present state, TX_state define that chenge.
always @(Tx_state)
	begin
				case(Tx_state)
				INI_T: 	
					begin
						bit_counter_en_tx = 1'b0;
						bit_enable_start = 1'b0;
						bit_shift_en_tx = 1'b0;
						bit_wait_tx = 1'b0;
						rst_wait_tx = 1'b0;
						rst_bit_counter_tx = 1'b0;
						wb = 1'b0;
		            busy = 1'b0;				
						finish = 1'b0;
					end
				START_T: 	
					begin
						bit_counter_en_tx = 1'b0;
						bit_enable_start = 1'b1;
						bit_shift_en_tx = 1'b0;
						bit_wait_tx = 1'b0;
						rst_wait_tx = 1'b1;
						rst_bit_counter_tx = 1'b1;	
						wb = 1'b1;	
		            busy = 1'b1;					
						finish = 1'b0;
					end
				TX_BITS_T: 	
					begin
						bit_counter_en_tx = 1'b1;
						bit_enable_start = 1'b0;
						bit_shift_en_tx = 1'b1;
						bit_wait_tx = 1'b0;
						rst_wait_tx = 1'b1;
						rst_bit_counter_tx = 1'b0;
						wb = 1'b0;		
		            busy = 1'b1;			
						finish = 1'b0;				
					end
				WAIT_TX:
					begin
						bit_counter_en_tx = 1'b0;
						bit_enable_start = 1'b0;
						bit_shift_en_tx = 1'b0;
						bit_wait_tx = 1'b1;
						rst_wait_tx = 1'b0;
						rst_bit_counter_tx = 1'b0;
						wb = 1'b0;		
		            busy = 1'b1;				
						finish = 1'b0;			
					end
				STOP_T: 	
					begin
						bit_counter_en_tx = 1'b0;
						bit_enable_start = 1'b0;
						bit_shift_en_tx = 1'b0;
						bit_wait_tx = 1'b0;
						rst_wait_tx = 1'b1;
						rst_bit_counter_tx = 1'b1;
						wb = 1'b1;		
		            busy = 1'b0;				
						finish = 1'b1;			
					end						
				default:
					begin
						bit_counter_en_tx = 1'b0;
						bit_enable_start = 1'b0;
						bit_shift_en_tx = 1'b0;
						bit_wait_tx = 1'b0;
						rst_wait_tx = 1'b0;
						rst_bit_counter_tx = 1'b0;
						wb = 1'b0;		
		            busy = 1'b0;				
						finish = 1'b0;			
					end
			endcase
	end
endmodule