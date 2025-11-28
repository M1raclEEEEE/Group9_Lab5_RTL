`timescale 1ns/1ps

module vga_state_machine(
    input wire sys_clk,
    input wire sys_rst_n,
    input wire button_press,      
    input wire left_btn,         
    input wire right_btn,        
    output wire hsync,
    output wire vsync,
    output wire [15:0] rgb,
    output reg [2:0] state_leds   
);

  
    parameter STATE_FUN_BREAKOUT = 2'b00;  
    parameter STATE_BREAKOUT_GAME = 2'b01; 
    parameter STATE_END          = 2'b10;  
    
    reg [1:0] current_state;
    reg [1:0] next_state;
    
 
    wire vga_clk;
    wire [9:0] pix_x;
    wire [9:0] pix_y;
    wire [15:0] fun_breakout_data;
    wire [15:0] breakout_data;
    wire [15:0] end_data;
    wire [15:0] selected_data;
    wire game_win;  
    
   
    wire button_debounced;
    wire left_btn_debounced;
    wire right_btn_debounced;
    
    
    reg button_prev;
    wire button_rising;
    
   
    reg game_win_prev;
    wire game_win_rising;
    
   
    pll pll_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .vga_clk(vga_clk)
    );
    
   
    vga_ctrl vga_ctrl_inst (
        .vga_clk(vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_data(selected_data),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );
    
    
    reg [19:0] btn_debounce_cnt = 0;
    reg btn_debounced = 0;
    reg btn_prev_state = 0;
    
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            btn_debounce_cnt <= 0;
            btn_debounced <= 0;
            btn_prev_state <= 0;
        end else begin
            btn_prev_state <= button_press;
            
           
            if (button_press != btn_prev_state) begin
                btn_debounce_cnt <= 0;
            end 
          
            else if (btn_debounce_cnt < 20'd25000) begin // 1ms @ 25MHz (25000 cycles)
                btn_debounce_cnt <= btn_debounce_cnt + 1;
            end 
           
            else begin
                btn_debounced <= button_press;
            end
        end
    end
    
    assign button_debounced = btn_debounced;
    
  
    reg [19:0] left_debounce_cnt = 0;
    reg left_debounced = 0;
    reg left_prev_state = 0;
    
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            left_debounce_cnt <= 0;
            left_debounced <= 0;
            left_prev_state <= 0;
        end else begin
            left_prev_state <= left_btn;
            
            if (left_btn != left_prev_state) begin
                left_debounce_cnt <= 0;
            end 
            else if (left_debounce_cnt < 20'd25000) begin // 1ms
                left_debounce_cnt <= left_debounce_cnt + 1;
            end 
            else begin
                left_debounced <= left_btn;
            end
        end
    end
    
    assign left_btn_debounced = left_debounced;
    
 
    reg [19:0] right_debounce_cnt = 0;
    reg right_debounced = 0;
    reg right_prev_state = 0;
    
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            right_debounce_cnt <= 0;
            right_debounced <= 0;
            right_prev_state <= 0;
        end else begin
            right_prev_state <= right_btn;
            
            if (right_btn != right_prev_state) begin
                right_debounce_cnt <= 0;
            end 
            else if (right_debounce_cnt < 20'd25000) begin // 1ms
                right_debounce_cnt <= right_debounce_cnt + 1;
            end 
            else begin
                right_debounced <= right_btn;
            end
        end
    end
    
    assign right_btn_debounced = right_debounced;
    
   
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            button_prev <= 1'b0;
            game_win_prev <= 1'b0;
        end else begin
            button_prev <= button_debounced;  
            game_win_prev <= game_win;
        end
    end
    
    assign button_rising = (button_debounced == 1'b1) && (button_prev == 1'b0);
    assign game_win_rising = (game_win == 1'b1) && (game_win_prev == 1'b0);
    

    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            current_state <= STATE_FUN_BREAKOUT;
        end else begin
            current_state <= next_state;
        end
    end
    
 
    always @(*) begin
        next_state = current_state; 
        
      
        if (button_rising) begin
            case (current_state)
                STATE_FUN_BREAKOUT: next_state = STATE_BREAKOUT_GAME;
                STATE_BREAKOUT_GAME: next_state = STATE_END;
                STATE_END:          next_state = STATE_FUN_BREAKOUT;
                default:            next_state = STATE_FUN_BREAKOUT;
            endcase
        end
        
       
        if (game_win_rising && (current_state == STATE_BREAKOUT_GAME)) begin
            next_state = STATE_END;
        end
    end
    
   
    fun_breakout_text fun_text_inst (
        .vga_clk(vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .pix_data(fun_breakout_data)
    );
    
 
    breakout_game breakout_inst (
        .vga_clk(vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .left_btn(left_btn_debounced),   
        .right_btn(right_btn_debounced),  
        .pix_data(breakout_data),
        .game_win(game_win) 
    );
    
   
    end_display end_inst (
        .vga_clk(vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .pix_data(end_data)
    );
    
   
    assign selected_data = (current_state == STATE_FUN_BREAKOUT) ? fun_breakout_data :
                          (current_state == STATE_BREAKOUT_GAME) ? breakout_data :
                          (current_state == STATE_END) ? end_data :
                          16'h0000;
    

    always @(*) begin
        case (current_state)
            STATE_FUN_BREAKOUT: state_leds = 3'b001;
            STATE_BREAKOUT_GAME: state_leds = 3'b010;
            STATE_END:          state_leds = 3'b100;
            default:            state_leds = 3'b001;
        endcase
    end

endmodule
