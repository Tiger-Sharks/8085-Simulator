REM PRODUCE AN ASSEMBLY LISTING FOR %1%2
REM TYPE YOUR COMMAND AS ,SAY,B: THEN SPACE
REM  THEN FILE NAME.
IF NOT "Z%2"=="Z" GOTO FURTHER
REM PLEASE LEAVE SPACE  IN BETWEEN AS STATED ABOVE.
GOTO END
:FURTHER
BREAK ON
VERIFY ON
%1
REM THIS BAT FILE WILL EXECUTE WITH ANY 
REM COMBINATION OF DRIVES,PATH COMMAND ENABLES
REM EXECUTION OF COM,EXE,BAT FILES FROM APPROPRIATE
REM DRIVES FROM CURRENT DIRECTORIES.                       	
PATH B:.;A:.;C:.;D:.;E:.
MASM %1%2,NUL,%1%2.LST;
IF "A%3"=="A" GOTO END
COPY %1%2.LST PRN
:END
VERIFY OFF
BREAK OFF
PATH;
  
