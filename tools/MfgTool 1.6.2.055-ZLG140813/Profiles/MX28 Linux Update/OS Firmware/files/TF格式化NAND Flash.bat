@echo off
echo. 
echo                   iMX28x  NAND Flash��ʽ��ר����������������
echo     �����õ����������ڸ�ʽ��iMX28xϵ�п����׼�����İ��NAND Flash������
echo ���̼�δ��������ǩ����ʹ�ø�����������ǰ����ȷ��оƬ��ʹ��δǩ���̼�������
echo ��ͨ��TF����ʽ��ʹ��δǩ���̼���������ʹ�á�MfgTool 1.6.2.055-ZLG140813��
echo �����ع̼�����ʹ�ܡ�
echo.  
echo. 
echo ������TF���̷���
set /p diskpath=
REM set diskpath=E
echo ע��:
echo %diskpath% �̻ᱻ��ʽ��
echo. 
cfimager -a -f imx28_ivt_uboot_erase.sb -d %diskpath%
echo ������������ϣ���������˳�
pause>nul