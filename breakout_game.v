`timescale 1ns/1ps

module breakout_game(
    input wire vga_clk,
    input wire sys_rst_n,
    input wire [9:0] pix_x,
    input wire [9:0] pix_y,
    input wire left_btn,     
    input wire right_btn,    
    output reg [15:0] pix_data,
    output reg game_win     
);

    parameter H_VALID = 10'd640;
    parameter V_VALID = 10'd480;
    
   
    parameter WHITE  = 16'hFFFF;
    parameter RED    = 16'hF800;
    parameter GREEN  = 16'h07E0;
    parameter BLUE   = 16'h001F;
    parameter YELLOW = 16'hFFE0;
    parameter BLACK  = 16'h0000;
    parameter GRAY   = 16'h8410;
    
  
    parameter BALL_SIZE = 8;
    parameter PADDLE_WIDTH = 80;
    parameter PADDLE_HEIGHT = 10;
    parameter PADDLE_Y = 450;
    parameter BRICK_ROWS = 4;
    parameter BRICK_COLS = 7;
    parameter BRICK_WIDTH = 70;
    parameter BRICK_HEIGHT = 20;
    parameter BORDER_WIDTH = 4;
    
    
    parameter GAME_LEFT = 10;
    parameter GAME_RIGHT = 630;
    parameter GAME_TOP = 10;
    parameter GAME_BOTTOM = 470;
    
   
    parameter TOTAL_BRICKS_WIDTH = BRICK_COLS * BRICK_WIDTH + (BRICK_COLS - 1) * 10;
    parameter BRICKS_START_X = (H_VALID - TOTAL_BRICKS_WIDTH) / 2;
    parameter BRICKS_START_Y = 50;
    
  
    reg game_over = 0; 
    
    
    reg [9:0] ball_x = 320;
    reg [9:0] ball_y = 300;
    reg ball_dx = 1;
    reg ball_dy = 1;
    
   
    reg [9:0] paddle_x = 280;
    
   
    reg [27:0] bricks = 28'hFFFFFFF;
    

    reg [15:0] game_counter = 0;
    wire game_tick = (game_counter == 16'h3FFF);
    

    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            game_counter <= 0;
        end else begin
            game_counter <= game_counter + 1;
        end
    end
    
 
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            paddle_x <= 280;
        end else if (game_tick && !game_over) begin  
            if (left_btn && paddle_x > GAME_LEFT + 5) begin
                paddle_x <= paddle_x - 10;
            end else if (right_btn && paddle_x < GAME_RIGHT - PADDLE_WIDTH - 5) begin
                paddle_x <= paddle_x + 10;
            end
        end
    end
    
   
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            ball_x <= 320;
            ball_y <= 300;
            ball_dx <= 1;
            ball_dy <= 1;
            bricks <= 28'hFFFFFFF;
            game_over <= 0;
            game_win <= 0; 
        end else if (game_tick && !game_over) begin 
            
            if (ball_dx) ball_x <= ball_x + 3;
            else ball_x <= ball_x - 3;
            
            if (ball_dy) ball_y <= ball_y + 3;
            else ball_y <= ball_y - 3;
            
          
            if (ball_x <= GAME_LEFT + BORDER_WIDTH) begin
                ball_dx <= 1;
                ball_x <= GAME_LEFT + BORDER_WIDTH + 3;
            end else if (ball_x >= GAME_RIGHT - BALL_SIZE - BORDER_WIDTH) begin
                ball_dx <= 0;
                ball_x <= GAME_RIGHT - BALL_SIZE - BORDER_WIDTH - 3;
            end
            
            if (ball_y <= GAME_TOP + BORDER_WIDTH) begin
                ball_dy <= 1;
                ball_y <= GAME_TOP + BORDER_WIDTH + 3;
            end else if (ball_y >= GAME_BOTTOM - BALL_SIZE) begin
                ball_x <= 320;
                ball_y <= 300;
                ball_dx <= 1;
                ball_dy <= 1;
            end
            
          
            if (ball_y + BALL_SIZE >= PADDLE_Y && 
                ball_y <= PADDLE_Y + PADDLE_HEIGHT &&
                ball_x + BALL_SIZE >= paddle_x && 
                ball_x <= paddle_x + PADDLE_WIDTH) begin
                ball_dy <= 0;
                if (ball_x < paddle_x + PADDLE_WIDTH/4) ball_dx <= 0;
                else if (ball_x > paddle_x + 3*PADDLE_WIDTH/4) ball_dx <= 1;
            end
            
           
            begin
                integer i, j;
                reg brick_hit;
                brick_hit = 0;
                
                for (i = 0; i < BRICK_ROWS; i = i + 1) begin
                    for (j = 0; j < BRICK_COLS; j = j + 1) begin
                        if (bricks[i*7 + j] && !brick_hit) begin
                            reg [9:0] brick_left = BRICKS_START_X + j*(BRICK_WIDTH+10);
                            reg [9:0] brick_right = brick_left + BRICK_WIDTH;
                            reg [9:0] brick_top = BRICKS_START_Y + i*(BRICK_HEIGHT+10);
                            reg [9:0] brick_bottom = brick_top + BRICK_HEIGHT;
                            
                            if (ball_x + BALL_SIZE > brick_left && 
                                ball_x < brick_right &&
                                ball_y + BALL_SIZE > brick_top && 
                                ball_y < brick_bottom) begin
                                
                                bricks[i*7 + j] <= 0;
                                brick_hit = 1;
                                
                                if ((ball_dy == 1 && ball_y < brick_top) || 
                                    (ball_dy == 0 && ball_y + BALL_SIZE > brick_bottom)) begin
                                    ball_dy <= ~ball_dy;
                                end 
                                else if ((ball_dx == 1 && ball_x < brick_left) || 
                                         (ball_dx == 0 && ball_x + BALL_SIZE > brick_right)) begin
                                    ball_dx <= ~ball_dx;
                                end
                                else begin
                                    ball_dy <= ~ball_dy;
                                end
                            end
                        end
                    end
                end
            end
            
         
            if (bricks == 28'b0) begin
                game_over <= 1; 
                game_win <= 1;   
            end
        end
    end
    
   
    wire [9:0] brick_x [0:6];
    wire [9:0] brick_y [0:3];
    
    assign brick_x[0] = BRICKS_START_X;
    assign brick_x[1] = BRICKS_START_X + 1 * (BRICK_WIDTH + 10);
    assign brick_x[2] = BRICKS_START_X + 2 * (BRICK_WIDTH + 10);
    assign brick_x[3] = BRICKS_START_X + 3 * (BRICK_WIDTH + 10);
    assign brick_x[4] = BRICKS_START_X + 4 * (BRICK_WIDTH + 10);
    assign brick_x[5] = BRICKS_START_X + 5 * (BRICK_WIDTH + 10);
    assign brick_x[6] = BRICKS_START_X + 6 * (BRICK_WIDTH + 10);
    
    assign brick_y[0] = BRICKS_START_Y;
    assign brick_y[1] = BRICKS_START_Y + 1 * (BRICK_HEIGHT + 10);
    assign brick_y[2] = BRICKS_START_Y + 2 * (BRICK_HEIGHT + 10);
    assign brick_y[3] = BRICKS_START_Y + 3 * (BRICK_HEIGHT + 10);
    
  
    wire border_left   = (pix_x >= GAME_LEFT) && (pix_x < GAME_LEFT + BORDER_WIDTH);
    wire border_right  = (pix_x >= GAME_RIGHT - BORDER_WIDTH) && (pix_x < GAME_RIGHT);
    wire border_top    = (pix_y >= GAME_TOP) && (pix_y < GAME_TOP + BORDER_WIDTH);
    wire border_bottom = (pix_y >= GAME_BOTTOM - BORDER_WIDTH) && (pix_y < GAME_BOTTOM);
    
    wire in_border = border_left || border_right || border_top || border_bottom;
    
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            pix_data <= BLACK;
        end else begin
            if (in_border) begin
                pix_data <= GRAY;
            end else if (pix_x >= ball_x && pix_x < ball_x + BALL_SIZE &&
                     pix_y >= ball_y && pix_y < ball_y + BALL_SIZE) begin
                pix_data <= WHITE;
            end else if (pix_x >= paddle_x && pix_x < paddle_x + PADDLE_WIDTH &&
                     pix_y >= PADDLE_Y && pix_y < PADDLE_Y + PADDLE_HEIGHT) begin
                pix_data <= GREEN;
            end else begin
                integer i, j;
                reg brick_drawn;
                brick_drawn = 0;
                for (i = 0; i < BRICK_ROWS; i = i + 1) begin
                    for (j = 0; j < BRICK_COLS; j = j + 1) begin
                        if (bricks[i*7 + j] &&
                            pix_x >= brick_x[j] && pix_x < brick_x[j] + BRICK_WIDTH &&
                            pix_y >= brick_y[i] && pix_y < brick_y[i] + BRICK_HEIGHT) begin
                            brick_drawn = 1;
                            case (i)
                                0: pix_data <= RED;
                                1: pix_data <= YELLOW;
                                2: pix_data <= GREEN;
                                3: pix_data <= BLUE;
                                default: pix_data <= WHITE;
                            endcase
                        end
                    end
                end
                if (!brick_drawn) begin
                    pix_data <= BLACK;
                end
            end
        end
    end

endmodule
