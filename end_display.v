`timescale 1ns/1ps

module end_display(
    input wire vga_clk,
    input wire sys_rst_n,
    input wire [9:0] pix_x,
    input wire [9:0] pix_y,
    output reg [15:0] pix_data
);

    parameter H_DISPLAY = 640;
    parameter V_DISPLAY = 480;
    
  
    parameter RED   = 16'hF800;
    parameter GREEN = 16'h07E0;
    parameter YELLOW = 16'hFFE0;
    
 
    reg [22:0] flash_counter = 0;
    wire [1:0] color_select;
    
  
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            flash_counter <= 0;
        end else begin
            if (flash_counter == 23'd1250000) begin
                flash_counter <= 0;
            end else begin
                flash_counter <= flash_counter + 1;
            end
        end
    end
    
  
    assign color_select = (flash_counter < 23'd416666) ? 2'b00 :  
                         (flash_counter < 23'd833333) ? 2'b01 :   
                         2'b10;                                  
    

    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            pix_data <= RED;
        end else begin
            case (color_select)
                2'b00: pix_data <= RED;   
                2'b01: pix_data <= YELLOW; 
                2'b10: pix_data <= GREEN; 
                default: pix_data <= RED;
            endcase
        end
    end

endmodule
