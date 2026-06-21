@echo off
REM ============================================================
REM  launch_byte.bat  --  Byte launcher for Claude Code
REM  Reads CLAUDE.md as project memory + --append-system-prompt
REM ============================================================

setlocal EnableDelayedExpansion

pushd "%~dp0"

set "PROMPT_FILE=%~dp0CLAUDE.md"

if not exist "%PROMPT_FILE%" (
    echo [byte] CLAUDE.md not found beside launcher.
    pause
    popd
    exit /b 1
)

where claude >nul 2>&1
if errorlevel 1 (
    echo [byte] claude CLI not on PATH.
    echo [byte] install Claude Code first:  npm i -g @anthropic-ai/claude-code
    pause
    popd
    exit /b 1
)

REM --- model override:  launch_byte.bat opus    (default: sonnet 4.8) ---
set "MODEL=%~1"
if "%MODEL%"=="" set "MODEL=sonnet"

REM --- env knobs ---
set "DISABLE_TELEMETRY=1"
set "DISABLE_ERROR_REPORTING=1"
set "DISABLE_NON_ESSENTIAL_MODEL_CALLS=1"
set "DISABLE_AUTOUPDATER=1"
set "CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1"

echo.
echo [byte] launching as %MODEL%
echo [byte] project root: %~dp0
echo [byte] CLAUDE.md auto-loads as project memory
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$prompt = [IO.File]::ReadAllText('%PROMPT_FILE%');" ^
  "& claude --model '%MODEL%' --dangerously-skip-permissions --append-system-prompt $prompt"

popd
endlocal
