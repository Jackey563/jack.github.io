@echo off
cd /d "%~dp0"
echo === 开始同步 ===

:: 1. 把本地所有改动/新增加入缓存
git add -A

:: 2. 如果没有可提交内容就跳过 commit
git diff --cached --quiet
if %errorlevel%==0 (
  echo 没有新文件，直接拉取远程更新...
  goto :pull
)

:: 3. 有变动则提交并推送
set /p msg=请输入提交信息（直接回车=默认“update”）:
if "%msg%"=="" set msg=update
git commit -m "%msg%"
git push
if %errorlevel% neq 0 (
  echo 推送失败，请检查网络或权限！
  pause & exit /b 1
)

echo 推送完成，正在拉回云端可能的新文件...

:pull
git pull --no-edit
if %errorlevel% neq 0 (
  echo 拉取失败，请检查冲突或网络！
  pause & exit /b 1
)

echo === 同步完成！===
pause