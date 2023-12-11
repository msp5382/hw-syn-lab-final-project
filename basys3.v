/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

module top (
    input clk,
    input reset,

    output tx,
    input  rx,

    input  [3:0] btn,

    input  [15:0] sw,
    output [15:0] led,

    output hsync,           // to VGA Connector
    output vsync,           // to VGA Connector
    output [11:0] rgb       // to DAC, to VGA Connector
);

  wire clk_bufg;
  BUFG bufg (
      .I(clk),
      .O(clk_bufg)
  );

  reg [5:0] reset_cnt = 0;
  wire resetn = &reset_cnt;

  always @(posedge clk_bufg) begin
    reset_cnt <= reset_cnt + !resetn;
  end

  wire        iomem_valid;
  reg         iomem_ready;
  wire [ 3:0] iomem_wstrb;
  wire [31:0] iomem_addr;
  wire [31:0] iomem_wdata;
  reg  [31:0] iomem_rdata;

  reg  [31:0] gpio;

  assign led = gpio[15:0];
  
  wire w_vid_on;
  wire w_p_tick;
  wire [9:0] w_x, w_y;
  reg [11:0] reg_rgb;
  wire [3:0] text_on;
  wire [11:0] text_rgb;
  
  // Mock positions for testing
  reg [9:0] paddle_left_pos = 10'd150;
  reg [9:0] paddle_right_pos = 10'd150;
  reg [9:0] ball_pos_x = 10'd120;
  reg [9:0] ball_pos_y = 10'd240;
  reg [3:0] p1_score_d1 = 4'd0;
  reg [3:0] p1_score_d2 = 4'd0;
  reg [3:0] p2_score_d1 = 4'd0;
  reg [3:0] p2_score_d2 = 4'd0;
  wire [3:0] game_on;
  wire [11:0] game_rgb;
  
  // Combine the text RGB output with the background and game rendering
  always @(posedge clk_bufg)
    if (~w_vid_on)
      reg_rgb <= 12'h000; // black background
    else
      if(text_on && game_on)
        if (game_rgb == 12'h000)
          reg_rgb <= text_rgb;
        else
          reg_rgb <= game_rgb;
      else if (text_on)
        reg_rgb <= text_rgb;
      else if (game_on)
        reg_rgb <= game_rgb;
      else
        reg_rgb <= 12'h000; // black background
    
  assign rgb = reg_rgb;

  pong_game_renderer pong_game_renderer_unit(
      .clk(clk_bufg),
      .paddle_left_pos(paddle_left_pos),
      .paddle_right_pos(paddle_right_pos),
      .ball_pos_x(ball_pos_x),
      .ball_pos_y(ball_pos_y),
      .game_on(game_on),
      .game_rgb(game_rgb),
      .x(w_x),
      .y(w_y)
  );

  always @(posedge clk_bufg) begin
    if (reset) begin
      gpio <= 0;
      paddle_left_pos <= 10'd0; // Reset paddle position on reset
      paddle_right_pos <= 10'd0; // Reset paddle position on reset
      ball_pos_x <= 10'd0; // Reset ball position on reset
      ball_pos_y <= 10'd0; // Reset ball position on reset
      p1_score_d1 <= 4'd0; // Reset player 1 score on reset
      p1_score_d2 <= 4'd0; // Reset player 1 score on reset
      p2_score_d1 <= 4'd0; // Reset player 2 score on reset
      p2_score_d2 <= 4'd0; // Reset player 2 score on reset

    end else begin
      iomem_ready <= 0;
      if (iomem_valid && !iomem_ready) begin
        if (iomem_addr[31:24] == 8'h04) begin
          iomem_ready <= 1;
          iomem_rdata <= {22'd0, paddle_left_pos};
          if (iomem_wstrb[0]) paddle_left_pos[7:0] <= iomem_wdata[7:0];
          if (iomem_wstrb[1]) paddle_left_pos[9:8] <= iomem_wdata[9:8];
        end else if (iomem_addr[31:24] == 8'h05) begin
          iomem_ready <= 1;
          iomem_rdata <= {22'd0, paddle_right_pos};
          if (iomem_wstrb[0]) paddle_right_pos[7:0] <= iomem_wdata[7:0];
          if (iomem_wstrb[1]) paddle_right_pos[9:8] <= iomem_wdata[9:8];
        end else if (iomem_addr[31:24] == 8'h06) begin
          iomem_ready <= 1;
          iomem_rdata <= {22'd0, ball_pos_x};
          if (iomem_wstrb[0]) ball_pos_x[7:0] <= iomem_wdata[7:0];
          if (iomem_wstrb[1]) ball_pos_x[9:8] <= iomem_wdata[9:8];
        end else if (iomem_addr[31:24] == 8'h07) begin
          iomem_ready <= 1;
          iomem_rdata <= {22'd0, ball_pos_y};
          if (iomem_wstrb[0]) ball_pos_y[7:0] <= iomem_wdata[7:0];
          if (iomem_wstrb[1]) ball_pos_y[9:8] <= iomem_wdata[9:8];
        end else if (iomem_addr[31:24] == 8'h08) begin
          iomem_ready <= 1;
          iomem_rdata <= {31'd0, btn[0]};
        end else if (iomem_addr[31:24] == 8'h09) begin
          iomem_ready <= 1;
          iomem_rdata <= {31'd0, btn[1]};
        end else if (iomem_addr[31:24] == 8'h0A) begin
          iomem_ready <= 1;
          iomem_rdata <= {31'd0, btn[2]};
        end else if (iomem_addr[31:24] == 8'h0B) begin
          iomem_ready <= 1;
          iomem_rdata <= {31'd0, btn[3]};
        end else if (iomem_addr[31:24] == 8'h0C) begin
          iomem_ready <= 1;
          iomem_rdata <= {28'd0, p1_score_d1};
          if (iomem_wstrb[0]) p1_score_d1[3:0] <= iomem_wdata[3:0];
        end else if (iomem_addr[31:24] == 8'h0D) begin
          iomem_ready <= 1;
          iomem_rdata <= {28'd0, p1_score_d2};
          if (iomem_wstrb[0]) p1_score_d2[3:0] <= iomem_wdata[3:0];
        end else if (iomem_addr[31:24] == 8'h0E) begin
          iomem_ready <= 1;
          iomem_rdata <= {28'd0, p2_score_d1};
          if (iomem_wstrb[0]) p2_score_d1[3:0] <= iomem_wdata[3:0];
        end else if (iomem_addr[31:24] == 8'h0F) begin
          iomem_ready <= 1;
          iomem_rdata <= {28'd0, p2_score_d2};
          if (iomem_wstrb[0]) p2_score_d2[3:0] <= iomem_wdata[3:0];
        end
      end
    end
  end
  
  pong_text pong_text_unit(
      .clk(clk_bufg),
      .x(w_x),
      .y(w_y),
      .p1_score_d1(p1_score_d1), 
      .p1_score_d2(p1_score_d2), 
      .p2_score_d1(p2_score_d1), 
      .p2_score_d2(p2_score_d2),
      .text_on(text_on),
      .text_rgb(text_rgb)
  );

  vga_controller vga_unit(
        .clk_100MHz(clk_bufg),
        .reset(reset),
        .video_on(w_vid_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(w_p_tick),
        .x(w_x),
        .y(w_y));

  picosoc_noflash soc (
      .clk   (clk_bufg),
      .resetn(~reset),

      .ser_tx(tx),
      .ser_rx(rx),

      .irq_5(1'b0),
      .irq_6(1'b0),
      .irq_7(1'b0),

      .iomem_valid(iomem_valid),
      .iomem_ready(iomem_ready),
      .iomem_wstrb(iomem_wstrb),
      .iomem_addr (iomem_addr),
      .iomem_wdata(iomem_wdata),
      .iomem_rdata(iomem_rdata)
  );

endmodule
