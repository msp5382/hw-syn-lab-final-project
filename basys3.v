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
  
  // screen buffer 640x480
  reg [11:0] screen [0:640]; // 640x480 1D vector
  
  assign rgb = reg_rgb;

  integer i;
  initial begin
    for (i = 0; i < 320; i = i + 1) begin
      screen[i] = 12'hF00;
    end
    
    for (i = 320; i < 640; i = i + 1) begin
      screen[i] = 12'h0FF;
    end
  end

  always @(posedge clk) begin
    if (w_p_tick)
      reg_rgb <= screen[w_x];
  end


  always @(posedge clk_bufg) begin
    if (!resetn) begin
      gpio <= 0;
      gpio2 <= 0;
    end else begin
      iomem_ready <= 0;
      if (iomem_valid && !iomem_ready) begin
        if (iomem_addr[31:24] == 8'h03) begin
          iomem_ready <= 1;
          iomem_rdata <= {sw, gpio[15:0]};
          if (iomem_wstrb[0]) gpio[7:0] <= iomem_wdata[7:0];
          if (iomem_wstrb[1]) gpio[15:8] <= iomem_wdata[15:8];
          if (iomem_wstrb[2]) gpio[23:16] <= iomem_wdata[23:16];
          if (iomem_wstrb[3]) gpio[31:24] <= iomem_wdata[31:24];
        end
        if (iomem_addr[31:24] == 8'h05) begin
          iomem_ready <= 1;
          if (iomem_wstrb[0] && iomem_wstrb[1]) screen[iomem_wdata[9:0]] <= iomem_wdata[31:20];
        end
      end
    end
  end
  
  vga_controller vga_unit(
        .clk_100MHz(clk),
        .reset(reset),
        .video_on(w_vid_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(w_p_tick),
        .x(w_x),
        .y(w_y));

  picosoc_noflash soc (
      .clk   (clk_bufg),
      .resetn(resetn),

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
