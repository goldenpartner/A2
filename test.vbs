on error resume next
dim WSHshellA
set WSHshellA = wscript.createobject("wscript.shell")
WSHshellA.run "cmd.exe /c shutdown -r -t 30 -c ""You must surrender"" ",0 ,true 
dim a
do while(a <> "Surrender")
a = inputbox ("You must surrender, enter""Surrender","You want to surrender?","nope",8000,7000)
msgbox chr(13) + chr(13) + chr(13) + a,0,"MsgBox"
loop
msgbox chr(13) + chr(13) + chr(13) + "You lost,I always win,lol"
dim WSHshell
set WSHshell = wscript.createobject("wscript.shell")
WSHshell.run "cmd.exe /c shutdown -a",0 ,true 
msgbox chr(13) + chr(13) + chr(13) + "You cannot beat me" 