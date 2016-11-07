@echo off
rem ------------------------------------------------------
rem Create a new Study tree in _STUDIES directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if project folder exists
rem robocopy %1 X-%1 /MIR
rem ------------------------------------------------------
echo ============================
echo pISA-tree: make STUDY 
echo ----------------------------
rem Ask for study ID, loop if empty
set ID=""
if "%1" EQU "" (
echo @
set /p ID=Enter Study ID: 
echo %ID%
) else (
set ID=%1
)
:Ask
if %ID% EQU "" set /p ID=Enter Study ID: 
if %ID% EQU "" goto Ask
REM Check existence/uniqueness
IF EXIST %ID% (
REM Dir exists
echo ERROR: Study named *%ID%* already exists
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
echo %ID%
)

rem ----------------------------------------------
rem Make new Study directory tree
md %ID%
cd %ID%
md reports
md _ASSAYS
rem put something to the directories
rem to force git to add them
echo # Study %ID% >  .\README.MD
echo # Reports for study %ID% >  .\reports\README.MD
echo # Assays for study %ID% >  .\_ASSAYS\README.MD
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
echo STUDY!LF!Short Name:	%ID%!LF!Study Title:	*!LF!Study Description:	*> .\_STUDY_DESCRIPTION.TXT
copy .\_STUDY_DESCRIPTION.TXT+..\..\..\project.ini .\_STUDY_DESCRIPTION.TXT
echo INVESTIGATION:	!LF!FITOBASE LINK:	!LF!RAW DATA:	!LF!>> .\_STUDY_DESCRIPTION.TXT
echo STUDY:	%ID%!LF!>> ..\..\_INVESTIGATION_DESCRIPTION.TXT
rem
rem  make main readme.md file
copy ..\..\..\makeAssay.bat .\_ASSAYS
copy ..\..\makeTree.bat .\_ASSAYS
copy ..\..\Description.bat .\_ASSAYS
type README.MD
del *.tmp
dir .
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
