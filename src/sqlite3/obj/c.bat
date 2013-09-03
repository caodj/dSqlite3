@echo off
del sqlite3fts3.obj
del sqlite3.obj
bcc32.exe -6 -O2 -c -d -DSQLITE_ENABLE_FTS3 -u- sqlite3.c
copy sqlite3.obj sqlite3fts3.obj
bcc32.exe -6 -O2 -c -d -u- sqlite3.c
bcc32.exe _ll.asm
 pause
