`timescale 1ns/1ps

module fun_breakout_text(
    input wire vga_clk,
    input wire sys_rst_n,
    input wire [9:0] pix_x,
    input wire [9:0] pix_y,
    output reg [15:0] pix_data
);


    parameter H_VALID = 10'd640;
    parameter V_VALID = 10'd480;
    

    parameter BLUE   = 16'h001F;
    parameter WHITE  = 16'hFFFF;
    parameter RED    = 16'hF800;
    parameter GREEN  = 16'h07E0;
    parameter YELLOW = 16'hFFE0;
    parameter PURPLE = 16'hF81F;
    parameter CYAN   = 16'h07FF;
    parameter ORANGE = 16'hFD20;
    parameter PINK   = 16'hF817;

    parameter CHAR_WIDTH = 32;
    parameter CHAR_HEIGHT = 48;
    parameter CHAR_SPACING = 8;
    

    parameter TOTAL_WIDTH = 8*CHAR_WIDTH + 7*CHAR_SPACING;
    parameter TEXT_START_X = (H_VALID - TOTAL_WIDTH) / 2;
    parameter TEXT_START_Y = 150;
    

    parameter B_START_X = TEXT_START_X;
    parameter R_START_X = B_START_X + CHAR_WIDTH + CHAR_SPACING;
    parameter E_START_X = R_START_X + CHAR_WIDTH + CHAR_SPACING;
    parameter A_START_X = E_START_X + CHAR_WIDTH + CHAR_SPACING;
    parameter K_START_X = A_START_X + CHAR_WIDTH + CHAR_SPACING;
    parameter O_START_X = K_START_X + CHAR_WIDTH + CHAR_SPACING;
    parameter U_START_X = O_START_X + CHAR_WIDTH + CHAR_SPACING;
    parameter T_START_X = U_START_X + CHAR_WIDTH + CHAR_SPACING;
    
 
    parameter BUTTON_WIDTH = 120;
    parameter BUTTON_HEIGHT = 40;
    parameter BUTTON_START_X = (H_VALID - BUTTON_WIDTH) / 2;
    parameter BUTTON_START_Y = TEXT_START_Y + CHAR_HEIGHT + 40;
    
  
    parameter START_CHAR_WIDTH = 16;
    parameter START_CHAR_HEIGHT = 24;
    parameter START_TOTAL_WIDTH = 5*START_CHAR_WIDTH + 4*3;
    parameter START_TEXT_X = BUTTON_START_X + (BUTTON_WIDTH - START_TOTAL_WIDTH) / 2;
    parameter START_TEXT_Y = BUTTON_START_Y + (BUTTON_HEIGHT - START_CHAR_HEIGHT) / 2;
    
    wire in_B = (pix_x >= B_START_X) && (pix_x < B_START_X + CHAR_WIDTH) && 
                (pix_y >= TEXT_START_Y) && (pix_y < TEXT_START_Y + CHAR_HEIGHT);
    wire in_R = (pix_x >= R_START_X) && (pix_x < R_START_X + CHAR_WIDTH) && 
                (pix_y >= TEXT_START_Y) && (pix_y < TEXT_START_Y + CHAR_HEIGHT);
    wire in_E = (pix_x >= E_START_X) && (pix_x < E_START_X + CHAR_WIDTH) && 
                (pix_y >= TEXT_START_Y) && (pix_y < TEXT_START_Y + CHAR_HEIGHT);
    wire in_A = (pix_x >= A_START_X) && (pix_x < A_START_X + CHAR_WIDTH) && 
                (pix_y >= TEXT_START_Y) && (pix_y < TEXT_START_Y + CHAR_HEIGHT);
    wire in_K = (pix_x >= K_START_X) && (pix_x < K_START_X + CHAR_WIDTH) && 
                (pix_y >= TEXT_START_Y) && (pix_y < TEXT_START_Y + CHAR_HEIGHT);
    wire in_O = (pix_x >= O_START_X) && (pix_x < O_START_X + CHAR_WIDTH) && 
                (pix_y >= TEXT_START_Y) && (pix_y < TEXT_START_Y + CHAR_HEIGHT);
    wire in_U = (pix_x >= U_START_X) && (pix_x < U_START_X + CHAR_WIDTH) && 
                (pix_y >= TEXT_START_Y) && (pix_y < TEXT_START_Y + CHAR_HEIGHT);
    wire in_T = (pix_x >= T_START_X) && (pix_x < T_START_X + CHAR_WIDTH) && 
                (pix_y >= TEXT_START_Y) && (pix_y < TEXT_START_Y + CHAR_HEIGHT);
    
 
    wire in_button = (pix_x >= BUTTON_START_X) && (pix_x < BUTTON_START_X + BUTTON_WIDTH) &&
                     (pix_y >= BUTTON_START_Y) && (pix_y < BUTTON_START_Y + BUTTON_HEIGHT);
    
   
    wire in_S = (pix_x >= START_TEXT_X) && (pix_x < START_TEXT_X + START_CHAR_WIDTH) && 
                (pix_y >= START_TEXT_Y) && (pix_y < START_TEXT_Y + START_CHAR_HEIGHT);
    wire in_T1 = (pix_x >= START_TEXT_X + START_CHAR_WIDTH + 3) && 
                 (pix_x < START_TEXT_X + 2*START_CHAR_WIDTH + 3) && 
                 (pix_y >= START_TEXT_Y) && (pix_y < START_TEXT_Y + START_CHAR_HEIGHT);
    wire in_A_start = (pix_x >= START_TEXT_X + 2*START_CHAR_WIDTH + 6) && 
                (pix_x < START_TEXT_X + 3*START_CHAR_WIDTH + 6) && 
                (pix_y >= START_TEXT_Y) && (pix_y < START_TEXT_Y + START_CHAR_HEIGHT);
    wire in_R_start = (pix_x >= START_TEXT_X + 3*START_CHAR_WIDTH + 9) && 
                (pix_x < START_TEXT_X + 4*START_CHAR_WIDTH + 9) && 
                (pix_y >= START_TEXT_Y) && (pix_y < START_TEXT_Y + START_CHAR_HEIGHT);
    wire in_T2 = (pix_x >= START_TEXT_X + 4*START_CHAR_WIDTH + 12) && 
                 (pix_x < START_TEXT_X + 5*START_CHAR_WIDTH + 12) && 
                 (pix_y >= START_TEXT_Y) && (pix_y < START_TEXT_Y + START_CHAR_HEIGHT);

    
    wire [5:0] rel_x_B = pix_x - B_START_X;
    wire [5:0] rel_y_B = pix_y - TEXT_START_Y;
    wire [5:0] rel_x_R = pix_x - R_START_X;
    wire [5:0] rel_y_R = pix_y - TEXT_START_Y;
    wire [5:0] rel_x_E = pix_x - E_START_X;
    wire [5:0] rel_y_E = pix_y - TEXT_START_Y;
    wire [5:0] rel_x_A = pix_x - A_START_X;
    wire [5:0] rel_y_A = pix_y - TEXT_START_Y;
    wire [5:0] rel_x_K = pix_x - K_START_X;
    wire [5:0] rel_y_K = pix_y - TEXT_START_Y;
    wire [5:0] rel_x_O = pix_x - O_START_X;
    wire [5:0] rel_y_O = pix_y - TEXT_START_Y;
    wire [5:0] rel_x_U = pix_x - U_START_X;
    wire [5:0] rel_y_U = pix_y - TEXT_START_Y;
    wire [5:0] rel_x_T = pix_x - T_START_X;
    wire [5:0] rel_y_T = pix_y - TEXT_START_Y;
    
 
    wire [4:0] s_x = pix_x - START_TEXT_X;
    wire [4:0] s_y = pix_y - START_TEXT_Y;
    wire [4:0] t1_x = pix_x - (START_TEXT_X + START_CHAR_WIDTH + 3);
    wire [4:0] t1_y = pix_y - START_TEXT_Y;
    wire [4:0] a_s_x = pix_x - (START_TEXT_X + 2*START_CHAR_WIDTH + 6);
    wire [4:0] a_s_y = pix_y - START_TEXT_Y;
    wire [4:0] r_s_x = pix_x - (START_TEXT_X + 3*START_CHAR_WIDTH + 9);
    wire [4:0] r_s_y = pix_y - START_TEXT_Y;
    wire [4:0] t2_x = pix_x - (START_TEXT_X + 4*START_CHAR_WIDTH + 12);
    wire [4:0] t2_y = pix_y - START_TEXT_Y;


    function is_B_pixel;
        input [5:0] x;
        input [5:0] y;
        reg pixel;
        begin
            pixel = 0;
          
            if (x >= 2 && x <= 6) 
                pixel = 1;
           
            else if (y >= 2 && y <= 6 && x >= 2 && x <= 30)
                pixel = 1;
        
            else if (y >= 22 && y <= 26 && x >= 2 && x <= 30)
                pixel = 1;
          
            else if (y >= 42 && y <= 46 && x >= 2 && x <= 30)
                pixel = 1;
           
            else if (x >= 26 && x <= 30 && y >= 2 && y <= 26)
                pixel = 1;
      
            else if (x >= 26 && x <= 30 && y >= 22 && y <= 46)
                pixel = 1;
            is_B_pixel = pixel;
        end
    endfunction


    function is_R_pixel;
        input [5:0] x;
        input [5:0] y;
        reg pixel;
        begin
            pixel = 0;
           
            if (x >= 2 && x <= 6) 
                pixel = 1;
          
            else if (y >= 2 && y <= 6 && x >= 2 && x <= 30)
                pixel = 1;
      
            else if (y >= 22 && y <= 26 && x >= 2 && x <= 30)
                pixel = 1;
      
            else if (x >= 26 && x <= 30 && y >= 2 && y <= 26)
                pixel = 1;
         
            else if (x >= 8 && x <= 30 && y >= 26 && y <= 46) begin
                if (x - 8 <= (y - 26) * 22 / 20 && 
                    x - 8 >= (y - 26) * 18 / 20) begin
                    pixel = 1;
                end
            end
            is_R_pixel = pixel;
        end
    endfunction

 
    function is_E_pixel;
        input [5:0] x;
        input [5:0] y;
        reg pixel;
        begin
            pixel = 0;
         
            if (x >= 2 && x <= 6)
                pixel = 1;
      
            else if (y >= 2 && y <= 6 && x >= 2 && x <= 30)
                pixel = 1;
        
            else if (y >= 22 && y <= 26 && x >= 2 && x <= 30)
                pixel = 1;
     
            else if (y >= 42 && y <= 46 && x >= 2 && x <= 30)
                pixel = 1;
            is_E_pixel = pixel;
        end
    endfunction

 
    function is_A_pixel;
        input [5:0] x;
        input [5:0] y;
        reg pixel;
        begin
            pixel = 0;
         
            if (y >= 2 && y <= 6 && x >= 8 && x <= 24)
                pixel = 1;
       
            else if (x >= 2 && x <= 6 && y >= 6 && y <= 46)
                pixel = 1;
    
            else if (x >= 26 && x <= 30 && y >= 6 && y <= 46)
                pixel = 1;
   
            else if (y >= 22 && y <= 26 && x >= 8 && x <= 24)
                pixel = 1;
            is_A_pixel = pixel;
        end
    endfunction

    
    function is_K_pixel;
        input [5:0] x;
        input [5:0] y;
        reg pixel;
        begin
            pixel = 0;
   
            if (x >= 2 && x <= 6)
                pixel = 1;
    
            else if (x >= 10 && x <= 30 && y >= 2 && y <= 24) begin
                if (x - 10 >= (24 - y) * 20 / 22 - 3 && 
                    x - 10 <= (24 - y) * 20 / 22 + 3) begin
                    pixel = 1;
                end
            end

            else if (x >= 10 && x <= 30 && y >= 24 && y <= 46) begin
                if (x - 10 >= (y - 24) * 20 / 22 - 3 && 
                    x - 10 <= (y - 24) * 20 / 22 + 3) begin
                    pixel = 1;
                end
            end
            is_K_pixel = pixel;
        end
    endfunction


    function is_O_pixel;
        input [5:0] x;
        input [5:0] y;
        reg pixel;
        begin
            pixel = 0;
     
            if (x >= 2 && x <= 6 && y >= 8 && y <= 40)
                pixel = 1;
   
            else if (x >= 26 && x <= 30 && y >= 8 && y <= 40)
                pixel = 1;
 
            else if (y >= 2 && y <= 6 && x >= 2 && x <= 30)
                pixel = 1;
 
            else if (y >= 42 && y <= 46 && x >= 2 && x <= 30)
                pixel = 1;
            is_O_pixel = pixel;
        end
    endfunction

  
    function is_U_pixel;
        input [5:0] x;
        input [5:0] y;
        reg pixel;
        begin
            pixel = 0;
       
            if (x >= 2 && x <= 6 && y >= 2 && y <= 40)
                pixel = 1;
     
            else if (x >= 26 && x <= 30 && y >= 2 && y <= 40)
                pixel = 1;
   
            else if (y >= 42 && y <= 46 && x >= 2 && x <= 30)
                pixel = 1;
            is_U_pixel = pixel;
        end
    endfunction

    function is_T_pixel;
        input [5:0] x;
        input [5:0] y;
        reg pixel;
        begin
            pixel = 0;
        
            if (y >= 2 && y <= 6 && x >= 2 && x <= 30)
                pixel = 1;
      
            else if (x >= 14 && x <= 18 && y >= 6 && y <= 46)
                pixel = 1;
            is_T_pixel = pixel;
        end
    endfunction

 
    function is_S_pixel;
        input [4:0] x;
        input [4:0] y;
        reg pixel;
        begin
            pixel = 0;
     
            if ((y >= 1 && y <= 3 && x >= 4 && x <= 12) ||
                (y >= 11 && y <= 13 && x >= 4 && x <= 12) ||
                (y >= 21 && y <= 23 && x >= 4 && x <= 12) ||
                (x >= 1 && x <= 3 && y >= 1 && y <= 11) ||
                (x >= 13 && x <= 15 && y >= 11 && y <= 23))
                pixel = 1;
            is_S_pixel = pixel;
        end
    endfunction

    function is_T_small_pixel;
        input [4:0] x;
        input [4:0] y;
        reg pixel;
        begin
            pixel = 0;
       
            if ((y >= 1 && y <= 3 && x >= 1 && x <= 15) ||
                (x >= 7 && x <= 9 && y >= 3 && y <= 23))
                pixel = 1;
            is_T_small_pixel = pixel;
        end
    endfunction

    function is_A_small_pixel;
        input [4:0] x;
        input [4:0] y;
        reg pixel;
        begin
            pixel = 0;
   
            if ((y >= 1 && y <= 3 && x >= 4 && x <= 12) ||
                (x >= 1 && x <= 3 && y >= 3 && y <= 23) ||
                (x >= 13 && x <= 15 && y >= 3 && y <= 23) ||
                (y >= 11 && y <= 13 && x >= 4 && x <= 12))
                pixel = 1;
            is_A_small_pixel = pixel;
        end
    endfunction


    function is_R_small_pixel;
        input [4:0] x;
        input [4:0] y;
        reg pixel;
        begin
            pixel = 0;
       
            if (x >= 1 && x <= 3 && y >= 1 && y <= 23)
                pixel = 1;
  
            else if (y >= 1 && y <= 3 && x >= 1 && x <= 15)
                pixel = 1;

            else if (y >= 11 && y <= 13 && x >= 1 && x <= 15)
                pixel = 1;
      
            else if (x >= 13 && x <= 15 && y >= 1 && y <= 13)
                pixel = 1;
   
            else if (x >= 4 && x <= 15 && y >= 13 && y <= 23) begin
     
                if (x - 4 <= (y - 13) * 11 / 10 + 1 && 
                    x - 4 >= (y - 13) * 11 / 10 - 1) begin
                    pixel = 1;
                end
    
                else if (x >= 4 && x <= 6 && y >= 13 && y <= 23)
                    pixel = 1;
            end
            is_R_small_pixel = pixel;
        end
    endfunction

 
    wire B_pixel = in_B && is_B_pixel(rel_x_B, rel_y_B);
    wire R_pixel = in_R && is_R_pixel(rel_x_R, rel_y_R);
    wire E_pixel = in_E && is_E_pixel(rel_x_E, rel_y_E);
    wire A_pixel = in_A && is_A_pixel(rel_x_A, rel_y_A);
    wire K_pixel = in_K && is_K_pixel(rel_x_K, rel_y_K);
    wire O_pixel = in_O && is_O_pixel(rel_x_O, rel_y_O);
    wire U_pixel = in_U && is_U_pixel(rel_x_U, rel_y_U);
    wire T_pixel = in_T && is_T_pixel(rel_x_T, rel_y_T);


    wire S_pixel = in_S && is_S_pixel(s_x, s_y);
    wire T1_pixel = in_T1 && is_T_small_pixel(t1_x, t1_y);
    wire A_s_pixel = in_A_start && is_A_small_pixel(a_s_x, a_s_y);
    wire R_s_pixel = in_R_start && is_R_small_pixel(r_s_x, r_s_y);
    wire T2_pixel = in_T2 && is_T_small_pixel(t2_x, t2_y);

 
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            pix_data <= BLUE;
        end else begin
    
            pix_data <= BLUE;
            
     
            if (in_B && B_pixel) pix_data <= RED;     
            else if (in_R && R_pixel) pix_data <= ORANGE;  
            else if (in_E && E_pixel) pix_data <= YELLOW;  
            else if (in_A && A_pixel) pix_data <= GREEN;   
            else if (in_K && K_pixel) pix_data <= CYAN;   
            else if (in_O && O_pixel) pix_data <= PURPLE;  
            else if (in_U && U_pixel) pix_data <= PINK;    
            else if (in_T && T_pixel) pix_data <= WHITE;  
            
           
            if (in_button) begin
                pix_data <= GREEN;
                
               
                if ((in_S && S_pixel) || (in_T1 && T1_pixel) || 
                    (in_A_start && A_s_pixel) || (in_R_start && R_s_pixel) || 
                    (in_T2 && T2_pixel)) begin
                    pix_data <= WHITE;
                end
            end
        end
    end

endmodule
