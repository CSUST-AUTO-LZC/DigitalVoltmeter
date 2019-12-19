/*通用公共功能服务子程序模块*/
NAME COMMON_DEFINED_FUNCTION      ;本模块名：COMMON_DEFINED_FUNCTION

COMMON_FUN_CODE SEGMENT CODE    ;定义可重定位段
RSEG COMMON_FUN_CODE            ;选择可可重定位段  

/*LCD1602硬件接口引脚定义*/
LCD_RW BIT P2.5
LCD_RS BIT P2.6
LCD_EN BIT P2.7
LCD_PORT EQU P0

PUBLIC DELAY_ms,DELAY_us    ;外部接口定义声明
PUBLIC LCD_init,LCD_DISPLAY     ;LCD1602外部软件接口定义声明

EXTRN CODE (S_TX)     ;外部引用函数代码参考调用声明
EXTRN DATA (INTE_value,DECI_value1,DECI_value2)     ;外部引用变量空间参考调用声明

/*  DELAY_ms    软件延时函数：单位 ms */
DELAY_ms:  ;MOV R5,#5
        ;PUSH ACC
D1:     MOV R6,200
D2:     MOV R7,250
D3:     DJNZ R7,D3
        DJNZ R6,D2
        DJNZ R5,D1
        ;POP ACC
    RET

/*  DELAY_us    软件延时函数：单位 us */
DELAY_us:  ;MOV R5,#5
        ;PUSH ACC
D4:     DJNZ R5,D4
        ;POP ACC
    RET

/* LCD_init   LCD初始化函数  */
LCD_init:   PUSH ACC
            CLR LCD_EN
            MOV R5,#1
            ACALL DELAY_ms
            MOV LCD_PORT,#00111000B     ;
            ACALL LCD_CMD_WR
            MOV R5,#1
            ACALL DELAY_ms
            MOV LCD_PORT,#00001100B      ;
            ACALL LCD_CMD_WR
            MOV R5,#1
            ACALL DELAY_ms
            MOV LCD_PORT,#00000110B     ;
            ACALL LCD_CMD_WR
            MOV R5,#1
            ACALL DELAY_ms
            MOV LCD_PORT,#00000001B     ;
            ACALL LCD_CMD_WR
            MOV R5,#1
            ACALL DELAY_ms
            MOV LCD_PORT,#00000010B     ;
            ACALL LCD_CMD_WR
            
            MOV R5,#10
            ACALL DELAY_us
            
            MOV LCD_PORT,#'O'
            ACALL LCD_DATA_WR
            MOV LCD_PORT,#'K'
            ACALL LCD_DATA_WR
            
            MOV R5,#100
            ACALL DELAY_us
            
            POP ACC
    RET

/* LCD_CMD_WR   写命令函数  */
LCD_CMD_WR: ;PUSH ACC
            ACALL BUSY_CHECK
            CLR LCD_RS
            CLR LCD_RW
            MOV R5,#10
            ACALL DELAY_us
            SETB LCD_EN
            MOV R5,#10
            ACALL DELAY_us
            CLR LCD_EN
            ;POP ACC
    RET

/* LCD_DATA_WR   写数据函数  */
LCD_DATA_WR: PUSH ACC
            ACALL BUSY_CHECK
            SETB LCD_RS
            CLR LCD_RW
            MOV R5,#10
            ACALL DELAY_us
            SETB LCD_EN
            MOV R5,#10
            ACALL DELAY_us
            CLR LCD_EN
            POP ACC
    RET

/* BUSY_CHECK   忙状态检测函数  */
BUSY_CHECK: PUSH ACC
      LOOP: CLR LCD_EN
            MOV A,LCD_PORT
            MOV LCD_PORT,#0FFH
            CLR LCD_RS
            SETB LCD_RW
            MOV R5,#10
            ACALL DELAY_us
            SETB LCD_EN
            MOV R5,#10
            ACALL DELAY_us
            JB LCD_PORT.7,LOOP
            CLR LCD_EN
            MOV LCD_PORT,A
            POP ACC
    RET

/* LCD_STRING_WR   写字符串函数  */
LCD_STRING_WR: PUSH ACC
            MOV R1,#00H
            ;MOV DPTR,#LCD_STR_TAB
  STR_LOOP: MOV A,R1
            MOVC A,@A+DPTR
            JZ  STR_END
            MOV LCD_PORT,A
            ACALL LCD_DATA_WR
            INC R1
            SJMP STR_LOOP
   STR_END: POP ACC
    RET

LCD_STR_TAB1: DB "DigitalVoltmeter",00H
LCD_STR_TAB2: DB "   VOLT:",00H

/* LCD_NUM_WR   写数字函数  */
LCD_NUM_WR: ;PUSH ACC
            MOV DPTR,#LCD_NUM_TAB
            MOVC A,@A+DPTR
            MOV LCD_PORT,A
            ACALL LCD_DATA_WR
            ;POP ACC
    RET
    
LCD_NUM_TAB: DB "0123456789"

/*  LCD_DISPLAY   用户自定义LCD显示驱动函数  */
LCD_DISPLAY:   ;PUSH ACC
            MOV R5,#50
            ACALL DELAY_us
            
            MOV LCD_PORT,#80H
            ACALL LCD_CMD_WR
            
            MOV DPTR,#LCD_STR_TAB1
            ACALL LCD_STRING_WR
            
            MOV R5,#1
            ACALL DELAY_ms
            
            MOV LCD_PORT,#0C0H
            ACALL LCD_CMD_WR
            
            MOV DPTR,#LCD_STR_TAB2
            ACALL LCD_STRING_WR
            
            MOV A,INTE_value
            ACALL LCD_NUM_WR
            
            MOV LCD_PORT,#'.'
            ACALL LCD_DATA_WR
            
            MOV A,DECI_value1
            ACALL LCD_NUM_WR
            
            MOV A,DECI_value2
            ACALL LCD_NUM_WR
            
            MOV LCD_PORT,#'V'
            ACALL LCD_DATA_WR
           
           ;POP ACC
    RET
    
END