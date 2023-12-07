
function RegisterCommands()

    -- COMMAND TO DISPLAY / HIDE THE MAIN WINDOW.
    cmdMainWin = Turbine.ShellCommand();

    function cmdMainWin:Execute( command, arguments )
        local mainWin = TakeMeThereWin.GetInstance();

        if mainWin:IsVisible() == false then
            mainWin:SetVisible(true);
            SETTINGS.MAINWIN.VISIBLE = true;
        else
            mainWin:SetVisible(false);
            SETTINGS.MAINWIN.VISIBLE = false;
        end
    end

    function cmdMainWin:GetHelp()
        return GetString(_LANG.COMMANDS.HELP);
    end

    function cmdMainWin:GetShortHelp()
        return GetString(_LANG.COMMANDS.HELP);
    end

    Turbine.Shell.AddCommand( "tmt", cmdMainWin);
    Turbine.Shell.AddCommand( "takemethere", cmdMainWin);

end