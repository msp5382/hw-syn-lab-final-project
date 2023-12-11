
module progmem (
    // Closk & reset
    input wire clk,
    input wire rstn,

    // PicoRV32 bus interface
    input  wire        valid,
    output wire        ready,
    input  wire [31:0] addr,
    output wire [31:0] rdata
);

  // ============================================================================

  localparam MEM_SIZE_BITS = 10;  // In 32-bit words
  localparam MEM_SIZE = 1 << MEM_SIZE_BITS;
  localparam MEM_ADDR_MASK = 32'h0010_0000;

  // ============================================================================

  wire [MEM_SIZE_BITS-1:0] mem_addr;
  reg  [             31:0] mem_data;
  reg  [             31:0] mem      [0:MEM_SIZE];

  initial begin
    mem['h0000] <= 32'h00000093;
    mem['h0001] <= 32'h00000193;
    mem['h0002] <= 32'h00000213;
    mem['h0003] <= 32'h00000293;
    mem['h0004] <= 32'h00000313;
    mem['h0005] <= 32'h00000393;
    mem['h0006] <= 32'h00000413;
    mem['h0007] <= 32'h00000493;
    mem['h0008] <= 32'h00000513;
    mem['h0009] <= 32'h00000593;
    mem['h000A] <= 32'h00000613;
    mem['h000B] <= 32'h00000693;
    mem['h000C] <= 32'h00000713;
    mem['h000D] <= 32'h00000793;
    mem['h000E] <= 32'h00000813;
    mem['h000F] <= 32'h00000893;
    mem['h0010] <= 32'h00000913;
    mem['h0011] <= 32'h00000993;
    mem['h0012] <= 32'h00000A13;
    mem['h0013] <= 32'h00000A93;
    mem['h0014] <= 32'h00000B13;
    mem['h0015] <= 32'h00000B93;
    mem['h0016] <= 32'h00000C13;
    mem['h0017] <= 32'h00000C93;
    mem['h0018] <= 32'h00000D13;
    mem['h0019] <= 32'h00000D93;
    mem['h001A] <= 32'h00000E13;
    mem['h001B] <= 32'h00000E93;
    mem['h001C] <= 32'h00000F13;
    mem['h001D] <= 32'h00000F93;
    mem['h001E] <= 32'h00000513;
    mem['h001F] <= 32'h00000593;
    mem['h0020] <= 32'h00B52023;
    mem['h0021] <= 32'h00450513;
    mem['h0022] <= 32'hFE254CE3;
    mem['h0023] <= 32'h00000517;
    mem['h0024] <= 32'h17C50513;
    mem['h0025] <= 32'h00000593;
    mem['h0026] <= 32'h00400613;
    mem['h0027] <= 32'h00C5DC63;
    mem['h0028] <= 32'h00052683;
    mem['h0029] <= 32'h00D5A023;
    mem['h002A] <= 32'h00450513;
    mem['h002B] <= 32'h00458593;
    mem['h002C] <= 32'hFEC5C8E3;
    mem['h002D] <= 32'h00400513;
    mem['h002E] <= 32'h00400593;
    mem['h002F] <= 32'h00B55863;
    mem['h0030] <= 32'h00052023;
    mem['h0031] <= 32'h00450513;
    mem['h0032] <= 32'hFEB54CE3;
    mem['h0033] <= 32'h008000EF;
    mem['h0034] <= 32'h0000006F;
    mem['h0035] <= 32'hFF010113;
    mem['h0036] <= 32'h00112623;
    mem['h0037] <= 32'h00812423;
    mem['h0038] <= 32'h01010413;
    mem['h0039] <= 32'h040007B7;
    mem['h003A] <= 32'h0007A023;
    mem['h003B] <= 32'h050007B7;
    mem['h003C] <= 32'h0007A023;
    mem['h003D] <= 32'h060007B7;
    mem['h003E] <= 32'h0007A023;
    mem['h003F] <= 32'h070007B7;
    mem['h0040] <= 32'h0007A023;
    mem['h0041] <= 32'h008000EF;
    mem['h0042] <= 32'hFFDFF06F;
    mem['h0043] <= 32'hFF010113;
    mem['h0044] <= 32'h00812623;
    mem['h0045] <= 32'h01010413;
    mem['h0046] <= 32'h00002783;
    mem['h0047] <= 32'hFFF78713;
    mem['h0048] <= 32'h00E02023;
    mem['h0049] <= 32'h00002783;
    mem['h004A] <= 32'h0C079863;
    mem['h004B] <= 32'h00001737;
    mem['h004C] <= 32'h38870713;
    mem['h004D] <= 32'h00E02023;
    mem['h004E] <= 32'h080007B7;
    mem['h004F] <= 32'h0007A703;
    mem['h0050] <= 32'h00100793;
    mem['h0051] <= 32'h02F71263;
    mem['h0052] <= 32'h040007B7;
    mem['h0053] <= 32'h0007A703;
    mem['h0054] <= 32'h03200793;
    mem['h0055] <= 32'h00E7FA63;
    mem['h0056] <= 32'h040007B7;
    mem['h0057] <= 32'h0007A703;
    mem['h0058] <= 32'hFFF70713;
    mem['h0059] <= 32'h00E7A023;
    mem['h005A] <= 32'h090007B7;
    mem['h005B] <= 32'h0007A703;
    mem['h005C] <= 32'h00100793;
    mem['h005D] <= 32'h02F71263;
    mem['h005E] <= 32'h040007B7;
    mem['h005F] <= 32'h0007A703;
    mem['h0060] <= 32'h1AD00793;
    mem['h0061] <= 32'h00E7EA63;
    mem['h0062] <= 32'h040007B7;
    mem['h0063] <= 32'h0007A703;
    mem['h0064] <= 32'h00170713;
    mem['h0065] <= 32'h00E7A023;
    mem['h0066] <= 32'h0A0007B7;
    mem['h0067] <= 32'h0007A703;
    mem['h0068] <= 32'h00100793;
    mem['h0069] <= 32'h02F71263;
    mem['h006A] <= 32'h050007B7;
    mem['h006B] <= 32'h0007A703;
    mem['h006C] <= 32'h03200793;
    mem['h006D] <= 32'h00E7FA63;
    mem['h006E] <= 32'h050007B7;
    mem['h006F] <= 32'h0007A703;
    mem['h0070] <= 32'hFFF70713;
    mem['h0071] <= 32'h00E7A023;
    mem['h0072] <= 32'h0B0007B7;
    mem['h0073] <= 32'h0007A703;
    mem['h0074] <= 32'h00100793;
    mem['h0075] <= 32'h02F71263;
    mem['h0076] <= 32'h050007B7;
    mem['h0077] <= 32'h0007A703;
    mem['h0078] <= 32'h1AD00793;
    mem['h0079] <= 32'h00E7EA63;
    mem['h007A] <= 32'h050007B7;
    mem['h007B] <= 32'h0007A703;
    mem['h007C] <= 32'h00170713;
    mem['h007D] <= 32'h00E7A023;
    mem['h007E] <= 32'h00000013;
    mem['h007F] <= 32'h00C12403;
    mem['h0080] <= 32'h01010113;
    mem['h0081] <= 32'h00008067;
    mem['h0082] <= 32'h00001388;

  end

  always @(posedge clk) mem_data <= mem[mem_addr];

  // ============================================================================

  reg o_ready;

  always @(posedge clk or negedge rstn)
    if (!rstn) o_ready <= 1'd0;
    else o_ready <= valid && ((addr & MEM_ADDR_MASK) != 0);

  // Output connectins
  assign ready    = o_ready;
  assign rdata    = mem_data;
  assign mem_addr = addr[MEM_SIZE_BITS+1:2];

endmodule
