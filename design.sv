module sobel_filter (
    input clk,
    input rst,
    input [7:0] image [0:89][0:89],  // 90x90 image (8-bit grayscale pixels)
    output reg [7:0] edge_map [0:89][0:89]  // Edge strength output
);

    integer i, j;
    integer gx, gy, g;

    // Sobel Kernels
    integer Gx [0:2][0:2] = '{'{-1, 0, 1}, 
                               {-2, 0, 2}, 
                               {-1, 0, 1}};
    
    integer Gy [0:2][0:2] = '{'{-1, -2, -1}, 
                               { 0,  0,  0}, 
                               { 1,  2,  1}};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset output edge map
            for (i = 0; i < 90; i = i + 1) begin
                for (j = 0; j < 90; j = j + 1) begin
                    edge_map[i][j] <= 8'b0;
                end
            end
        end else begin
            // Apply Sobel filter to the valid (inner) pixels
            for (i = 1; i < 89; i = i + 1) begin
                for (j = 1; j < 89; j = j + 1) begin
                    gx = 0;
                    gy = 0;

                    // Convolution with Sobel Kernels
                    for (integer k = -1; k <= 1; k = k + 1) begin
                        for (integer l = -1; l <= 1; l = l + 1) begin
                            gx = gx + (image[i+k][j+l] * Gx[k+1][l+1]);
                            gy = gy + (image[i+k][j+l] * Gy[k+1][l+1]);
                        end
                    end

                    // Compute gradient magnitude: G = sqrt(Gx^2 + Gy^2)
                    g = (gx * gx) + (gy * gy);
                    g = g ** 0.5;  // Approximate square root

                    // Clamp to 8-bit range (0-255)
                    if (g > 255) g = 255;
                    
                    edge_map[i][j] <= g;
                end
            end
        end
    end
endmodule
