/*中断服务子程序模块*/
NAME INT_SERVER_FUNCTION    ;本模块名：USER_DEFINED_FUNCTION

FUN_CODE  SEGMENT  CODE     ;定义可重定位段
RSEG  FUN_CODE              ;选择可可重定位段

PUBLIC INT_INIT,INT0S,INT1S,T0S,T1S,S_TX,S_RX    ;外部接口定义声明
EXTRN DATA (INTE_value,DECI_value1,DECI_value2)     ;外部引用变量空间参考调用声明

/*  INT0    中断服务子程序模块*/
INT0S:  NOP
        NOP
    RETI
        
/*  INT1    中断服务子程序模块*/
INT1S:  NOP
        NOP
    RETI
        
/*  T0  中断服务子程序模块*/
T0S:    NOP
        NOP
    RETI
        
/*  T1  中断服务子程序模块*/        
T1S:   NOP
       NOP
    RETI
        
/*  SERIAL-TX  中断服务子程序模块*/
S_TX:   MOV SBUF,R1
        JNB TI,$
        CLR TI
    RETI
        
/*  SERIAL-RX  中断服务子程序模块*/
S_RX:   JNB RI,S_RX_EXIT
        PUSH ACC
        MOV A,SBUF
        JNB RI,$
        CLR RI
        
        CJNE A,#'V',LOOPX
        MOV A,INTE_value
        ADD A,#30H
        MOV SBUF,A
        JNB TI,$
        CLR TI
        
        MOV SBUF,#'.'
        JNB TI,$
        CLR TI
        
        MOV A,DECI_value1
        ADD A,#30H
        MOV SBUF,A
        JNB TI,$
        CLR TI
        
        MOV A,DECI_value2
        ADD A,#30H
        MOV SBUF,A
        JNB TI,$
        CLR TI
        
        MOV SBUF,#00001101B
        JNB TI,$
        CLR TI
        
 LOOPX: POP ACC
S_RX_EXIT:  NOP

    RETI

/*  INT_INIT SETUP   初始化中断配置子程序模块*/
INT_INIT:   /*  -字节操作-   功能寄存器配置*/
            MOV IP,#00000000B   ;
            MOV IE,#10010010B   ;
            MOV TMOD,#00100001B     ;T1 MODE2,  T0 MODE=1    ;定时计数模式计数器TMOD
            MOV TCON,#00010000B     ;
            MOV PCON,#10000000B     ;波特率加倍
            MOV SCON,#01010000B
            MOV PSW,#00000000B
            MOV TH0,#3CH       ;
            MOV TL0,#0B0H        ;
            MOV TH1,#0E6H       ;1200bps*2=2400bps
            MOV TL1,#0E6H        ;
            ;SETB TR0    ;
            SETB TR1
    RET

END        
