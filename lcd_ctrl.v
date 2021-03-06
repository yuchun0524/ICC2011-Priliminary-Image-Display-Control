module LCD_CTRL(clk, reset, IROM_Q, cmd, cmd_valid, IROM_EN, IROM_A, IRB_RW, IRB_D, IRB_A, busy, done);
input clk;
input reset;
input [7:0] IROM_Q;
input [2:0] cmd;
input cmd_valid;
output reg IROM_EN;
output reg [5:0] IROM_A;
output reg IRB_RW;
output reg [7:0] IRB_D;
output reg [5:0] IRB_A;
output reg busy;
output reg done;
reg [5:0] point;
reg [7:0] buffer[63:0];
reg state;
reg zero;
reg start;
reg start_write;
wire [9:0] avg = ((buffer[point] + buffer[point + 1]) + (buffer[point + 8] + buffer[point + 9])) >> 2;
integer i;
parameter write = 3'd0,
          up = 3'd1,
          down = 3'd2,
          left = 3'd3,
          right = 3'd4,
          average = 3'd5,
          mx = 3'd6,
          my = 3'd7; 
          
always@(posedge clk or posedge reset)
begin
  if(reset)
    begin
      IROM_EN <= 0;
      IROM_A <= 6'd0;
      IRB_RW <= 1;
      IRB_A <= 6'd0;
      busy <= 1;
      done <= 0;
      point <= 6'd27;
      zero <= 1;
      state <= 0;
      start <= 1;
      start_write <= 0;
      for(i = 0; i < 64; i = i + 1)
        buffer[i] <= 8'd0;
    end
  else
    begin
      case(state)
        1'd0:begin
              if(IROM_A == 6'd63)
                begin
                  IROM_EN <= 0;
                  busy <= 1;
                  state <= 0;
                  start <= 0;
                  buffer[IROM_A - 1] <= IROM_Q;
                  IROM_A <= IROM_A + 1;
                end
              else
                begin
                  if(start)
                    begin
                      IROM_A <= IROM_A + 1;
                      IROM_EN <= 0;
                      busy <= 1;
                      state <= 0;
                      buffer[IROM_A - 1] <= IROM_Q;  // if use IROM_A - 6'd1, system will use 6 bits to store. system will use 32 bits to store in this way, but area is smaller in this way.
		      //$display(IROM_A - 6'd1);
                    end
                  else
                    begin
                      IROM_EN <= 1;
                      busy <= 0;
                      state <= 1;
                      buffer[63] <= IROM_Q;
                    end
                end
          end
        1'd1:begin
          if(!start_write)
            begin
              case(cmd)
                write:begin
                  start_write <= 1;
                  busy <= 1;
                  IRB_RW <= 0;
                  end
                up:begin
                  start_write <= 0;
                  if(point < 7)
                    point <= point;
                  else
                    point <= point - 8;
                  end
                down:begin
                  start_write <= 0;
                  if(point < 55 && point > 47)
                    point <= point;
                  else
                    point <= point + 8;
                  end
                left:begin
                  start_write <= 0;
                  if(point[2:0] == 3'b000)
                    point <= point;
                  else
                    point <= point - 1;
                  end
                right:begin
                  start_write <= 0;
                  if(point[2:0] == 3'b110)
                    point <= point;
                  else
                    point <= point + 1;
                  end
                average:begin
                  start_write <= 0;
                  buffer[point] <= avg;
                  buffer[point + 1] <= avg;
                  buffer[point + 8] <= avg;
                  buffer[point + 9] <= avg;
                  end
                mx:begin
                  start_write <= 0;
                  buffer[point] <= buffer[point + 8];
                  buffer[point + 1] <= buffer[point + 9];
                  buffer[point + 8] <= buffer[point];
                  buffer[point + 9] <= buffer[point + 1];
                  end
                my:begin
                  start_write <= 0;
                  buffer[point] <= buffer[point + 1];
                  buffer[point + 1] <= buffer[point];
                  buffer[point + 8] <= buffer[point + 9];
                  buffer[point + 9] <= buffer[point + 8];
                  end
                default:begin
                  start_write <= 0;
                  end  
                endcase
            end
          else
            begin
              if(zero)
                begin
                  IRB_D <= buffer[0];
                  zero <= 0;
                end
              else
                begin
                  IRB_D <= buffer[IRB_A + 1];
                  if(IRB_A == 6'd63)
                    begin
                      busy <= 0;
                      done <= 1;
                      start_write <= 0;
                    end
                  else
                    begin
                      IRB_A <= IRB_A + 1;
                    end
                end
            end
          end
        default:state <= 1'd0;
        endcase
    end
end
endmodule