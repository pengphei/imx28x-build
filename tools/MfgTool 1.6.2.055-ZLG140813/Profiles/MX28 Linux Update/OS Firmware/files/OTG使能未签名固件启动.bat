@echo off
echo. 
echo                              iMX28x  熔丝配置程序
echo     该程序用于配置iMX28x系列芯片的OTP熔丝，使芯片允许未经过签名的固件启动，
echo 该启动卡仅适用于签名密钥为全零的芯片。
echo. 
echo. 
sb_loader /f imx28_BootCfg_ivt_OTG.sb
echo.
echo.
echo 程序运行完毕，若提示“HID device was not found”，则表示执行失败，请确认启动跳线
echo 设置正确后，再给目标板上电并重新操作；若无此提示，则表示执行成功。
echo.
echo 按任意键退出
pause>nul

