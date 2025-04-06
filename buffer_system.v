module buffer_system(
      input wire clk_clk,
    input wire reset_reset_n,
    
    // Pixel buffer interface for VGA controller
    input wire [12:0] onchip_memory_pixel_buffer_connection_address,
    input wire onchip_memory_pixel_buffer_connection_clken,
    input wire onchip_memory_pixel_buffer_connection_chipselect,
    input wire onchip_memory_pixel_buffer_connection_write,
    output wire [7:0] onchip_memory_pixel_buffer_connection_readdata,
    input wire [7:0] onchip_memory_pixel_buffer_connection_writedata,
    
    // M68k CPU interface
    input wire [12:0] onchip_memory_m68k_connection_address,
    input wire onchip_memory_m68k_connection_chipselect,
    input wire onchip_memory_m68k_connection_clken,
    input wire onchip_memory_m68k_connection_write,
    output wire [7:0] onchip_memory_m68k_connection_readdata,
    input wire [7:0] onchip_memory_m68k_connection_writedata,
    
    // Shadow buffer interface (write-only)
    input wire [12:0] shadow_buffer_address,
    input wire shadow_buffer_clken,
    input wire shadow_buffer_chipselect,
    input wire shadow_buffer_write,
    output wire [7:0] shadow_buffer_readdata,
    input wire [7:0] shadow_buffer_writedata
);

    pixel_buffer_memory PixelBuffer (
        .clock(clk_clk),
        .address_a(onchip_memory_m68k_connection_address),
        .data_a(onchip_memory_m68k_connection_writedata),
        .wren_a(onchip_memory_m68k_connection_write && onchip_memory_m68k_connection_chipselect),
        .rden_a(onchip_memory_m68k_connection_chipselect && !onchip_memory_m68k_connection_write),
        .q_a(onchip_memory_m68k_connection_readdata),
        .address_b(onchip_memory_pixel_buffer_connection_address),
        .data_b(onchip_memory_pixel_buffer_connection_writedata),
        .wren_b(onchip_memory_pixel_buffer_connection_write && onchip_memory_pixel_buffer_connection_chipselect),
        .rden_b(onchip_memory_pixel_buffer_connection_chipselect && !onchip_memory_pixel_buffer_connection_write),
        .q_b(onchip_memory_pixel_buffer_connection_readdata)
    );

      shadow_buffer_memory ShadowBuffer (
        .clock(clk_clk),
        .address(onchip_memory_m68k_connection_address),
        .data(onchip_memory_m68k_connection_writedata),
        .wren(onchip_memory_m68k_connection_write && onchip_memory_m68k_connection_chipselect),
        .clken(onchip_memory_m68k_connection_clken),
        .q(shadow_buffer_readdata)
    );

endmodule