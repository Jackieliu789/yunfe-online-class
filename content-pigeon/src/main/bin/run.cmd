@echo off & setlocal enabledelayedexpansion

set LIB_JARS=""
cd ..\lib
for %%i in (*) do set LIB_JARS=!LIB_JARS!;..\lib\%%i
cd ..\bin

java -Xms64m -Xmx1024m -XX:MaxPermSize=64m -classpath ..\config;%LIB_JARS% com.applet.push.server.PushRun
pause