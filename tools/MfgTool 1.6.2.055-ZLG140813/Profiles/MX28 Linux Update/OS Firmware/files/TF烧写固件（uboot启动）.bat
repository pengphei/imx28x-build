@echo off
echo. 
echo                        EasyARM-iMX28x  SD��д����
echo     �����õ�������������д��uboot + kernel + rootfs����iMX28xϵ�п����׼�
echo ����İ��NAND Flash���������̼�δ��������ǩ����ʹ�ø�����������ǰ����ȷ
echo ��оƬ��ʹ��δǩ���̼���������ͨ��TF����USB��ʽ��ʹ��δǩ���̼���������
echo ʹ�á�MfgTool 1.6.2.055-ZLG140813������ع̼�����ʹ�ܡ�
echo 
echo. 
echo ������SD���̷���
set /p diskpath=
REM set diskpath=E
echo ע��:
echo     �ļ��ᱻ��д�� %diskpath% ��
echo. 
cfimager -a -f updater_ivt_burnuboot.sb -d %diskpath%
copy imx28_ivt_uboot.sb %diskpath%: /y
copy uImage     	%diskpath%: /y
copy rootfs.tar.bz2     %diskpath%: /y
echo ��д��ϣ������˳�
pause>nul