@echo off
cls
set ID=%1
:: set /p ID=Enter username to delete: 
echo %ID%
cls

cd C:\

:: SAFETY CHECK
:: If the char array is empty then DO NOT DELETE ALL THE PROFILES!!!
IF [%ID%] == [] GOTO END
GOTO DeleteUser

:DeleteUser
:: Patrol EVI LAB
delprof2.exe /u /id:%ID% /c:PRPT01
delprof2.exe /u /id:%ID% /c:PRPT02
delprof2.exe /u /id:%ID% /c:PRPT03
delprof2.exe /u /id:%ID% /c:PRPT04
delprof2.exe /u /id:%ID% /c:PRPT05
delprof2.exe /u /id:%ID% /c:SO-DRONE

:: Patrol SGT Office
delprof2.exe /u /id:%ID% /c:PSGT01
delprof2.exe /u /id:%ID% /c:PSGT02
delprof2.exe /u /id:%ID% /c:PSGT03
delprof2.exe /u /id:%ID% /c:PSGT04
delprof2.exe /u /id:%ID% /c:PSGT05
delprof2.exe /u /id:%ID% /c:PSGT06

:: Patrol LT Office
delprof2.exe /u /id:%ID% /c:PATROL-LT1
delprof2.exe /u /id:%ID% /c:PATROL-LT2

:: Patrol Admin
delprof2.exe /u /id:%ID% /c:ADMNCONF
delprof2.exe /u /id:%ID% /c:ADMN01
delprof2.exe /u /id:%ID% /c:ADMN04
delprof2.exe /u /id:%ID% /c:ADMN08
delprof2.exe /u /id:%ID% /c:ADMN09
delprof2.exe /u /id:%ID% /c:ADMN10
delprof2.exe /u /id:%ID% /c:ADMN11
delprof2.exe /u /id:%ID% /c:ADMN12
delprof2.exe /u /id:%ID% /c:ADMNCAPTAIN
delprof2.exe /u /id:%ID% /c:ADMNHR

:: Records
delprof2.exe /u /id:%ID% /c:RECORDS01
delprof2.exe /u /id:%ID% /c:RECORDS02
delprof2.exe /u /id:%ID% /c:RECORDS03
delprof2.exe /u /id:%ID% /c:RECORDS04
delprof2.exe /u /id:%ID% /c:RECORDS05
delprof2.exe /u /id:%ID% /c:RECORDS06
delprof2.exe /u /id:%ID% /c:RECORDS07
delprof2.exe /u /id:%ID% /c:RECORDS08
delprof2.exe /u /id:%ID% /c:RECORDS09
delprof2.exe /u /id:%ID% /c:RECORDS10
delprof2.exe /u /id:%ID% /c:RECORDS11
delprof2.exe /u /id:%ID% /c:RECORDS12
delprof2.exe /u /id:%ID% /c:RECORDSAUX
delprof2.exe /u /id:%ID% /c:RECORDS-REDACT
delprof2.exe /u /id:%ID% /c:RECORDS-MUGSHOT

:: Civil
delprof2.exe /u /id:%ID% /c:CIVIL01
delprof2.exe /u /id:%ID% /c:CIVIL02
delprof2.exe /u /id:%ID% /c:CIVIL03
delprof2.exe /u /id:%ID% /c:CIVIL04
delprof2.exe /u /id:%ID% /c:CIVIL05
delprof2.exe /u /id:%ID% /c:CIVIL06
delprof2.exe /u /id:%ID% /c:CIVIL07

:: Jail Towers
delprof2.exe /u /id:%ID% /c:JL-CCR-SUPER
delprof2.exe /u /id:%ID% /c:JL-CCR-VISIT
delprof2.exe /u /id:%ID% /c:JL-UNIT1
delprof2.exe /u /id:%ID% /c:JL-UNIT3
delprof2.exe /u /id:%ID% /c:JL-UNIT4

:: Jail Booking
delprof2.exe /u /id:%ID% /c:JL-BOOK1
delprof2.exe /u /id:%ID% /c:JL-BOOK2
delprof2.exe /u /id:%ID% /c:JL-BOOK3
delprof2.exe /u /id:%ID% /c:JL-BOOK4
delprof2.exe /u /id:%ID% /c:JL-BOOK5
delprof2.exe /u /id:%ID% /c:JL-BOOK6
delprof2.exe /u /id:%ID% /c:JL-BOOK7
delprof2.exe /u /id:%ID% /c:JL-BOOK8
delprof2.exe /u /id:%ID% /c:JL-BOOK9
delprof2.exe /u /id:%ID% /c:JL-MUGSHOT

:: Jail Warrants
delprof2.exe /u /id:%ID% /c:JL-WARSGT
delprof2.exe /u /id:%ID% /c:JL-WARDEP
delprof2.exe /u /id:%ID% /c:JL-WAR1
delprof2.exe /u /id:%ID% /c:JL-WAR2
delprof2.exe /u /id:%ID% /c:JL-WAR3
delprof2.exe /u /id:%ID% /c:JL-WAR4

:: Jail Classification
delprof2.exe /u /id:%ID% /c:JL-CLASSSGT
delprof2.exe /u /id:%ID% /c:JL-CLASS1
delprof2.exe /u /id:%ID% /c:JL-CLASS2
delprof2.exe /u /id:%ID% /c:JL-CLASS3

:: Jail Admin
delprof2.exe /u /id:%ID% /c:JL-LT01
delprof2.exe /u /id:%ID% /c:JL-LT02
delprof2.exe /u /id:%ID% /c:JL-LT03
delprof2.exe /u /id:%ID% /c:JL-LOBBY

:: Jail Maintenance
delprof2.exe /u /id:%ID% /c:JL-MAINT01
delprof2.exe /u /id:%ID% /c:JL-MAINT02
delprof2.exe /u /id:%ID% /c:JL-MAINT03
delprof2.exe /u /id:%ID% /c:JL-MAINT04
delprof2.exe /u /id:%ID% /c:JL-MAINT05
delprof2.exe /u /id:%ID% /c:JL-MAINT06

:: Jail Medical
delprof2.exe /u /id:%ID% /c:JL-MED01
delprof2.exe /u /id:%ID% /c:JL-MED02
delprof2.exe /u /id:%ID% /c:JL-MED03
delprof2.exe /u /id:%ID% /c:JL-MED04
delprof2.exe /u /id:%ID% /c:JL-MED05
delprof2.exe /u /id:%ID% /c:JL-MED06
delprof2.exe /u /id:%ID% /c:JL-MEDSUP
delprof2.exe /u /id:%ID% /c:JL-MEDDEP

:: DL
delprof2.exe /u /id:%ID% /c:DL-01
delprof2.exe /u /id:%ID% /c:DL-02
delprof2.exe /u /id:%ID% /c:DL-03
delprof2.exe /u /id:%ID% /c:DL-04
delprof2.exe /u /id:%ID% /c:DL-05
delprof2.exe /u /id:%ID% /c:DL-06
delprof2.exe /u /id:%ID% /c:DL-07
delprof2.exe /u /id:%ID% /c:DL-08
delprof2.exe /u /id:%ID% /c:DL-09
delprof2.exe /u /id:%ID% /c:DL-10
delprof2.exe /u /id:%ID% /c:DL-11
delprof2.exe /u /id:%ID% /c:DL-12

GOTO END

:END
echo Finished!