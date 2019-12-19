/*通用功能服务子程序模块*/
NAME USER_DEFINED_FUNCTION      ;本模块名：USER_DEFINED_FUNCTION

USER_FUN_CODE SEGMENT CODE    ;定义可重定位段
RSEG USER_FUN_CODE            ;选择可可重定位段  

/*AD硬件接口引脚定义*/
OE BIT P2.0     ;Output Eable 数据输出使能端（数据锁存器打开）
EOC  BIT P2.1   ;ADC转换结束标志位Flag--（End Of Convert）
ADC_ALE BIT P2.2    ;输入通道地址锁存器锁存（Adress Lock Eable）
START BIT P2.3      ;转换开始脉冲输入端（上升沿开始清零，下降沿启动ADC转换）

/*AD转换结果内存空间定义（数据缓存）*/
INTE_value DATA 70H
DECI_value1 DATA 71H
DECI_value2 DATA 72H
ADC_DATA DATA 73H

PUBLIC ADC_init,ADC_read,INTE_value,DECI_value1,DECI_value2    ;ADC0808外部软件接口定义声明


/*  ADC_init   函数说明 */
ADC_init:   PUSH ACC
        CLR A
        MOV INTE_value,A    ;清零操作
        MOV DECI_value1,A     ;清零操作
        MOV DECI_value2,A     ;清零操作
        CLR EOC
        CLR OE
        CLR ADC_ALE
        NOP
        SETB ADC_ALE
        NOP
        CLR ADC_ALE
        NOP
        POP ACC
    RET

/*  ADC_read   函数说明 */
ADC_read:   PUSH ACC
        CLR START
        NOP
        SETB START
        NOP
        CLR START
        NOP
        SETB EOC
  WAIT: JNB EOC,WAIT
        MOV P0,#0FFH
        SETB OE
        MOV P0,#0FFH
        MOV A,P0
        CLR OE
        MOV ADC_DATA,A
        LCALL DATA_Conversion
        POP ACC
    RET

/*  DATA_Conversion   函数说明 */   
DATA_Conversion:   PUSH ACC
        MOV A,ADC_DATA
        MOV B,#51
        DIV AB
        MOV INTE_value,A
        XCH A,B
        MOV B,#5
        DIV AB
        MOV DECI_value1,A
        XCH A,B
        MOV B,#2    ;除以0.5即乘以2
        MUL AB
        MOV DECI_value2,A
        POP ACC
    RET
    
END