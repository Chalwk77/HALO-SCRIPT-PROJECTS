@echo off
set multiclient_instances=1
set run_default_halo_client=1

cd "C:\Program Files (x86)\Microsoft Games\Halo\HPC - SAPP SERVER"
start haloded.exe

IF %run_default_halo_client%==1 (
    ECHO starting halo.exe
    cd "C:\Program Files (x86)\Microsoft Games\Halo"
    start halo.exe -console -novideo -window -vidmode 800,600 -connect localhost:2302
)

FOR /L %%i IN (1,1,%multiclient_instances%) DO (
    cd "C:\Program Files (x86)\Microsoft Games\Halo\HPC_Multiclient.exe"
    start HPC_Multiclient.exe halo.exe -console -novideo -window -vidmode 800,600 -connect localhost:2302
)

exit
