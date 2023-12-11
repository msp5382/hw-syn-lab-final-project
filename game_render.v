module pong_game_renderer(
    input clk,
    input [9:0] paddle_left_pos,
    input [9:0] paddle_right_pos,
    input [9:0] ball_pos_x,
    input [9:0] ball_pos_y,
    input [9:0] x, y,
    output reg [3:0] game_on,
    output reg [11:0] game_rgb
    );
    
    // Constants for screen dimensions, paddle and ball sizes
    localparam SCREEN_WIDTH = 640;
    localparam SCREEN_HEIGHT = 480;
    localparam PADDLE_WIDTH = 5;
    localparam PADDLE_HEIGHT = 50;
    localparam BALL_SIZE = 10;
    
    // ROM memory array
    reg [9:0] rom_data;
    wire [9:0] row_addr;
    wire [9:0] bit_addr;

    // Game rendering logic
    always @(posedge clk) begin
        game_rgb <= 12'h000; // Default to black
        game_on <= 1'b0;

        if(y >= 0 && y < 2) begin
            game_rgb <= 12'hFFF; // White color for top border
            game_on <= 1'b1;
        end

        if(y >= 478 && y < 480) begin
            game_rgb <= 12'hFFF; // White color for top border
            game_on <= 1'b1;
        end
        
        // Render left paddle
        if (paddle_left_pos <= y && y < paddle_left_pos + PADDLE_HEIGHT && x > 10 && x <= PADDLE_WIDTH + 10) begin
            game_rgb <= 12'hFFF; // White color for paddle
            game_on <= 1'b1;
        end
        
        // Render right paddle
        if (paddle_right_pos <= y && y < paddle_right_pos + PADDLE_HEIGHT && x > SCREEN_WIDTH - PADDLE_WIDTH - 16 && x < SCREEN_WIDTH -16) begin
            game_rgb <= 12'hFFF; // White color for paddle
            game_on <= 1'b1;
        end

        // Render ball
        if (ball_pos_x <= x && x < ball_pos_x + BALL_SIZE && ball_pos_y <= y && y < ball_pos_y + BALL_SIZE) begin
            row_addr = y - ball_pos_y;
            bit_addr = x - ball_pos_x;

            case(row_addr[3:0])
                4'b0000 :    rom_data = 10'b0001111100; //   ****  
                4'b0001 :    rom_data = 10'b0011111110; //  ******
                4'b0010 :    rom_data = 10'b0111111111; // ********
                4'b0011 :    rom_data = 10'b0111111111; // ********
                4'b0100 :    rom_data = 10'b0111111111; // ********
                4'b0101 :    rom_data = 10'b0111111111; // ********
                4'b0110 :    rom_data = 10'b0011111110; //  ******
                4'b0111 :    rom_data = 10'b0001111100; //   ****
                default :     rom_data = 10'b0000000000; // (empty)
            endcase

            if (rom_data[bit_addr[3:0]]) begin
                game_rgb <= 12'hFFF; // White color for ball
                game_on <= 1'b1;
            end
        end
    end
    
endmodule

