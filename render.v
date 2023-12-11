
module pong_text(
    input clk,
    input [9:0] x, y,
    input [3:0] p1_score_d1, p1_score_d2, p2_score_d1, p2_score_d2,
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


    assign text_on_top = (y[9:6] == 3) && (5 <= x[9:5]) && (x[9:5] <= 13);
    assign row_addr = y[5:2];
    assign bit_addr = x[4:2];
    always @*
        case(x[8:5])
            4'h5 : char_addr = 7'h00;
            4'h6 : char_addr = 7'h00;
            4'h7 : char_addr = {3'b011,p1_score_d1};
            4'h8 : char_addr = {3'b011,p1_score_d2};
            4'h9 : char_addr = 7'h00;
            4'hA : char_addr = 7'h00;
            4'hB : char_addr = {3'b011,p2_score_d1};
            4'hC : char_addr = {3'b011,p2_score_d2};
            default : char_addr = 7'h00;
        endcase
    
    
    // mux for ascii ROM addresses and rgb
    always @* begin
        text_rgb = 12'h000;
        if(text_on_top) begin
            char_addr = char_addr;
            bit_addr = bit_addr;
            if(ascii_bit)
                text_rgb = 12'h4FB;
        end
    end
    
    assign text_on = {3'b000, text_on_top};
    
    // ascii ROM interface
    assign rom_addr = {char_addr, row_addr};
    assign ascii_bit = ascii_word[~bit_addr];
      
endmodule
