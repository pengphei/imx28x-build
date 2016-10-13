@echo off
echo. 
echo                      iMX28x  熔丝配置专用启动卡制作程序
echo 制作好的启动卡用于配置iMX28x系列芯片的OTP熔丝，使芯片允许未经过签名的固件启动，
echo 该启动卡仅适用于签名密钥为全零的芯片。
echo. 
echo. 
echo 请输入TF卡盘符：
set /p diskpath=
REM set diskpath=E
echo 注意:
echo %diskpath% 盘会被格式化
echo.  
cfimager -a -f imx28_BootCfg_ivt.sb -d %diskpath%
echo 启动卡制作完毕，按任意键退出
pause>nul