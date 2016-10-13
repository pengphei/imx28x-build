@echo off
echo. 
echo                        EasyARM-iMX28x  SD烧写程序
echo     制作好的启动卡用于烧写“kernel + rootfs”到iMX28x系列开发套件
echo 或核心板的NAND Flash，该启动固件未经过数字签名，使用该启动卡启动前，需确
echo 保芯片已使能未签名固件启动。可通过TF卡或USB方式“使能未签名固件启动”或
echo 使用“MfgTool 1.6.2.055-ZLG140813软件下载固件”来使能。
echo. 
echo 请输入SD卡盘符：
set /p diskpath=
REM set diskpath=E
echo 注意:
echo     文件会被烧写在 %diskpath% 盘
echo. 
cfimager -a -f updater_ivt_burnlinux.sb -d %diskpath%
copy imx28_ivt_linux.sb %diskpath%: /y
copy rootfs.tar.bz2     %diskpath%: /y
echo 烧写完毕，按键退出
pause>nul