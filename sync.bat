@echo off
cd /d "%~dp0"
echo === Start sync ===

:: add all changes (include delete)
git add -A

:: skip commit if nothing changed
git diff --cached --quiet
if %errorlevel%==0 (
  echo No changes, pull only...
  goto :pull
)

:: commit & push
set /p msg=Enter commit message (default=update):
if "%msg%"=="" set msg=update
git commit -m "%msg%"
git push
if %errorlevel% neq 0 (
  echo Push failed! Check network or permission.
  pause & exit /b 1
)

echo Push done, pulling cloud updates...

:pull
git pull --no-edit --rebase
if %errorlevel% neq 0 (
  echo Pull failed! Check conflicts or network.
  pause & exit /b 1
)

echo === Sync complete! ===
pause