@echo off
echo. 
echo                      iMX28x  ��˿����ר����������������
echo �����õ���������������iMX28xϵ��оƬ��OTP��˿��ʹоƬ����δ����ǩ���Ĺ̼�������
echo ����������������ǩ����ԿΪȫ���оƬ��
echo. 
echo. 
echo ������TF���̷���
set /p diskpath=
REM set diskpath=E
echo ע��:
echo %diskpath% �̻ᱻ��ʽ��
echo.  
cfimager -a -f imx28_BootCfg_ivt.sb -d %diskpath%
echo ������������ϣ���������˳�
pause>nul