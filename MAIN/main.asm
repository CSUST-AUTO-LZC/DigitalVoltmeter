/*软件系统主程序模块*/
CSEG AT 0000H       ;起始绝对地址0000H

        ORG 0000H
        SJMP START      ;复位进入主函数
        
EXTRN CODE (INT_INIT,INT0S,T0S,S_RX,DELAY_ms,ADC_init,ADC_read,LCD_init,LCD_DISPLAY)    ;外部引用函数代码参考调用声明
EXTRN DATA (INTE_value,DECI_value1,DECI_value2)     ;外部引用变量空间参考调用声明

/* 中断函数入口配置 */
        ORG 0003H       ;INT0中断入口
        NOP
        ORG 000BH       ;T0中断入口
        AJMP T0S
        ORG 0013H       ;T1中断入口
        NOP
        ORG 001BH       ;INT1中断入口
        NOP
        ORG 0023H       ;SERIAL中断入口
        AJMP S_RX
        
/* MAIN函数入口配置及函数主体 */
        ORG 0030H       ;MAIN入口地址
START:  LCALL INT_INIT
        LCALL ADC_init
        LCALL LCD_init
LOOP:   LCALL ADC_read
        LCALL LCD_DISPLAY
        SJMP LOOP
        
        END