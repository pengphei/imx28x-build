@echo off
echo. 
echo                   iMX28x  NAND Flash格式化专用启动卡制作程序
echo     制作好的启动卡用于格式化iMX28x系列开发套件或核心板的NAND Flash，该启
echo 动固件未经过数字签名，使用该启动卡启动前，需确保芯片已使能未签名固件启动。
echo 可通过TF卡方式“使能未签名固件启动”或使用“MfgTool 1.6.2.055-ZLG140813软
echo 件下载固件”来使能。
echo.  
echo. 
echo 请输入TF卡盘符：
set /p diskpath=
REM set diskpath=E
echo 注意:
echo %diskpath% 盘会被格式化
echo. 
cfimager -a -f imx28_ivt_uboot_erase.sb -d %diskpath%
echo 启动卡制作完毕，按任意键退出
pause>nul