module Midway8080MemoryAdapter (
    input wire [9:0] input_x_address,  // 10-bit x address from VGA
    input wire [8:0] input_y_address,  // 9-bit y address from VGA
    input wire [7:0] raw_data_from_midway8080_memory, // 8-bit vertical pixel data
    output wire [7:0] output_x_address, // 8-bit x address for pixel buffer
    output wire [4:0] output_y_address, // 5-bit y address for pixel buffer
    output reg [23:0] rgb_data_out      // 24-bit RGB data for VGA
);
    // VGA (0,0) is on top left. 
    // Midway 8080 (0,0) is on bottom left.
    // Midway 8080 (224,0) is on bottom right
    // Midway 8080 (0,256) is on top left.
    // Midway 8080 (224,256) is on top right
    
    // Output X address is gonna be 8 bits truncated from 0 to 224
    // Output Y address is gonna be pixel address scaled from 0 to 31 (divided by 8)
    

    // RGB data will depend on if X and Y are in range. If not it will be 0 (Black)


    // Map VGA x and y addresses to Midway 8080 pixel buffer addresses
    assign output_x_address = input_x_address[7:0]; // Truncate to 8 bits
    assign output_y_address = (255 - input_y_address[7:0]) >> 3; // Scale to 5 bits (0-31 range)

    // Generate RGB data based on the vertical pixel data
    always @(*) begin
        if (input_x_address[9:0] > 223 || input_y_address[8:0] > 255) begin
            rgb_data_out = 24'h000000; // Out of range, set to black
        end else begin
          case (7 - input_y_address[2:0]) // Use the lower 3 bits of y to select the bit
              3'd0: rgb_data_out = raw_data_from_midway8080_memory[0] ? 24'hFFFFFF : 24'h000000; // Bottom pixel
              3'd1: rgb_data_out = raw_data_from_midway8080_memory[1] ? 24'hFFFFFF : 24'h000000;
              3'd2: rgb_data_out = raw_data_from_midway8080_memory[2] ? 24'hFFFFFF : 24'h000000;
              3'd3: rgb_data_out = raw_data_from_midway8080_memory[3] ? 24'hFFFFFF : 24'h000000;
              3'd4: rgb_data_out = raw_data_from_midway8080_memory[4] ? 24'hFFFFFF : 24'h000000;
              3'd5: rgb_data_out = raw_data_from_midway8080_memory[5] ? 24'hFFFFFF : 24'h000000;
              3'd6: rgb_data_out = raw_data_from_midway8080_memory[6] ? 24'hFFFFFF : 24'h000000;
              3'd7: rgb_data_out = raw_data_from_midway8080_memory[7] ? 24'hFFFFFF : 24'h000000; // Top pixel
              default: rgb_data_out = 24'h000000; // Default to black
          endcase
        end
    end

endmodule