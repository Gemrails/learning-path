@echo off
title [IP��ַ���ú�ARP��]
color F9
ver|find /i "5.1." >nul && set ETHERNET=�������� && set SYSTEM=WinXP 
ver|find /i "6.1." >nul && set ETHERNET=�������� && set SYSTEM=Win7
ver|find /i "6.2." >nul && set ETHERNET=��̫�� &&set SYSTEM=Win8
ver|find /i "6.3." >nul && set ETHERNET=��̫�� &&set SYSTEM=Win8.1
@echo ======================================================================
@echo ""
@echo ��ǰϵͳΪ��%SYSTEM%
@echo ""
@echo ע�⣺Win7��WIN8��Win8.1ϵͳ�����Ҽ�ѡ���Թ���Ա������У�
@echo ע�⣺�������360������ѡ������
@echo ע�⣺���� [�������] ��ʾ������ϣ������ĵȴ�����;��Ҫִ������������
@echo ""
@echo ======================================================================
@ping 127.0.0.1 -n 8 >nul
@echo ""
@echo ************************��һ�������� ip ��ַ��************************
@echo ""
@set IP=172.16.1.19
@set MASK=255.255.254.0
@set GATEWAY=172.16.0.1
@set DNS1=114.114.114.114
@set DNS2=8.8.4.4
@echo ==========================[��ʼ���� ip ��ַ]==========================
@echo ��������IP��ַ�����Ե�......
netsh interface ip set address %ETHERNET% static %IP% %MASK% %GATEWAY% 1 >nul
@echo ""
@echo IP��ַΪ��%IP%
@echo �������룺%MASK%
@echo Ĭ�����أ�%GATEWAY%
@echo ==========================[��ʼ���� dns��ַ]==========================
@echo ��������DNS��ַ�����Ե�......
netsh interface ip set dns %ETHERNET% source=static address=%DNS1% primary >nul
netsh interface ip add dns %ETHERNET% address=%DNS2% >nul
@echo ""
@echo ��DNS��ַΪ��%DNS1%
@echo ��DNS��ַΪ��%DNS2%
@echo ==========================[��� ip ��ַ����]==========================
@echo ""
@echo ======================================================================
@echo ""
@echo ************************�ڶ�����arp ���ذ󶨣�************************
@echo ""
if /i "%SYSTEM%"=="WinXP" goto NT5
if /i "%SYSTEM%"=="Win7" goto NT6
if /i "%SYSTEM%"=="Win8" goto NT6
if /i "%SYSTEM%"=="Win8.1" goto NT6
:NT5
@echo ==========================[��ʼ arp���ذ�]==========================
@echo NT5���ذ�
arp -s %GATEWAY% 00-22-19-d4-18-79
@echo ==========================[���� arp���ļ�]==========================
@echo ��ʼ������������arp���ļ������Ե�......
echo cd \ > "C:\Documents and Settings\All Users\����ʼ���˵�\����\����\arp.cmd"
echo arp -a >> "C:\Documents and Settings\All Users\����ʼ���˵�\����\����\arp.cmd"
echo arp -d >> "C:\Documents and Settings\All Users\����ʼ���˵�\����\����\arp.cmd"
echo arp -s %GATEWAY% 00-22-19-d4-18-79 >> "C:\Documents and Settings\All Users\����ʼ���˵�\����\����\arp.cmd"
@echo ==========================[��� arp���ذ�]==========================
goto END
:NT6
@echo ==========================[��ʼ arp���ذ�]==========================
@echo NT6���ذ�
netsh i i show in
@echo ==========================[��ȡ���� idx���]==========================
@echo ���ڻ�ȡ����idx��ţ����Ե�......
for /f "tokens=1 delims= " %%i in ('netsh i i show in^|findstr %ETHERNET%') do set Idx=%%i >nul
@echo ""
@echo �������idx�����:[%Idx%]
@echo ==========================[�� arp���ص�ַ]==========================
@echo ���ڰ�arp���ص�ַ�����Ե�......
arp -d >nul
netsh i i delete neighbors >nul
netsh -c "i i" add neighbors %Idx% %GATEWAY% "00-22-19-d4-18-79" >nul
@echo ""
@echo ��ʾ���ذ�״̬:
arp -a | find /i "%GATEWAY%"
@echo ==========================[��� arp���ذ�]==========================
goto END
:END
@ping 127.0.0.1 -n 3 >nul
@echo ""
@echo ******************************[�������]******************************
@echo ""
@echo �밴������رմ��ڣ� &pause>nul