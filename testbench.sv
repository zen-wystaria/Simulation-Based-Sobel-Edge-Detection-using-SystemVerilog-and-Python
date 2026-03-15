module sobel_filter_tb;
    reg clk;
    reg rst;
    reg [7:0] image [0:89][0:89];  // 90x90 image
    wire [7:0] edge_map [0:89][0:89];

    integer file, i, j, val;

    sobel_filter uut (
        .clk(clk),
        .rst(rst),
        .image(image),
        .edge_map(edge_map)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;

        // Read the grayscale matrix from file
      file = $fopen("integer_matrix.txt", "r");
        if (file == 0) begin
            $display("Error: Could not open file!");
            $stop;
        end

        for (i = 0; i < 90; i = i + 1) begin
            for (j = 0; j < 90; j = j + 1) begin
                $fscanf(file, "%d", val);
                image[i][j] = val;
            end
        end

        $fclose(file);

        #10 rst = 0;  // Release reset
        #50;  // Wait for processing

        // Print Gx Kernel
        $display("\nGx Kernel:");
        $display("-1  0  1");
        $display("-2  0  2");
        $display("-1  0  1");

        // Print Gy Kernel
        $display("\nGy Kernel:");
        $display("-1 -2 -1");
        $display(" 0  0  0");
        $display(" 1  2  1");

        // Display the edge-detected output
        $display("\nEdge Map:");
        for (i = 0; i < 90; i = i + 1) begin
            for (j = 0; j < 90; j = j + 1) begin
                $write("%d ", edge_map[i][j]);
            end
            $write("\n");
        end
        $stop;
    end
endmodule
