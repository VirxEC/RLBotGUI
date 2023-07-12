@echo off

echo Installing RLBotGUI if necessary, then launching!

if not exist "%LocalAppData%\RLBotGUIX" mkdir "%LocalAppData%\RLBotGUIX"
pushd "%LocalAppData%\RLBotGUIX"

set rl_py="Python37\python.exe"
set rl_pip="Python37\Scripts\pip.exe"

if not exist %rl_py% (
  echo Looks like we're missing RLBot's Python ^(3.7.9^), installing...

  if not exist "python-3.7.9-custom-amd64.zip" (
    curl https://virxec.github.io/rlbot_gui_rust/python-3.7.9-custom-amd64.zip -o python-3.7.9-custom-amd64.zip
  )

  powershell -command "Expand-Archive '%LocalAppData%\RLBotGUIX\python-3.7.9-custom-amd64.zip' '%LocalAppData%\RLBotGUIX\Python37'"
)

rem We ping google.com to see if we have an internet connection
rem We then store the output of the command to nul which prevents the command from printing to the console
ping -n 1 google.com > nul
if %errorlevel% == 0 (
  if not exist %rl_pip% (
    echo Python pip not found - installing!
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py
  )

  echo Installing / upgrading RLBot components...

  %rl_py% -m pip install -U pip --no-warn-script-location
  %rl_pip% install setuptools wheel --no-warn-script-location
  %rl_pip% install eel --no-warn-script-location
  %rl_pip% install -U rlbot_gui rlbot --no-warn-script-location
) else (
  echo.
  echo It looks like you're offline, skipping package upgrades.
  echo Please note that if this is your first time running RLBotGUI, an internet connection is required to properly install.
  echo.
)

echo Launching RLBotGUI...

%rl_py% -c "from rlbot_gui import gui; gui.start()"

if %ERRORLEVEL% GTR 0 (
  pause
)
