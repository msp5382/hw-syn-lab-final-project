
module pong_text(
    input clk,
    input [9:0] x, y,
    output [3:0] text_on,
    output reg [11:0] text_rgb
    );
    
    // signal declaration
    wire [10:0] rom_addr;
    reg [6:0] char_addr;
    reg [3:0] row_addr;
    reg [2:0] bit_addr;
    wire [7:0] ascii_word;
    wire ascii_bit, text_on_top;
    
   // instantiate ascii rom
   ascii_rom ascii_unit(.clk(clk), .addr(rom_addr), .data(ascii_word));
   
   assign text_on_top = (y >= 96) && (y < 16+96) && (x >= 280) && (x < 300+8*5);
   assign row_addr = y[3:0];
   assign bit_addr = x[2:0];
   always @*
    case(x[10:3])
        7'b0100101 : char_addr = 7'h30;     // 0
        7'b0100110 : char_addr = 7'h30;     // 0
        7'b0100111 : char_addr = 7'h00;     // spaceC
        7'b0101000 : char_addr = 7'h30;     // 0
        7'b0101001 : char_addr = 7'h30;     // 0
       default : char_addr = 7'h00;   // spaces
    endcase
    
    // mux for ascii ROM addresses and rgb
    always @* begin
        text_rgb = 12'h000;
        if(text_on_top) begin
            char_addr = char_addr;
            bit_addr = bit_addr;
            if(ascii_bit)
                text_rgb = 12'hFFF;
        end
    end
    
    assign text_on = {3'b000, text_on_top};
    
    // ascii ROM interface
    assign rom_addr = {char_addr, row_addr};
    assign ascii_bit = ascii_word[~bit_addr];
      
endmodule
