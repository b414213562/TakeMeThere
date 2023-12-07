-- Turbine Imports..
import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";

-- Plugin Imports..
import "CubePlugins.TakeMeThere.GeneralFunctions";
import "CubePlugins.TakeMeThere.VindarPatch";
import "CubePlugins.TakeMeThere.Strings";
import "CubePlugins.TakeMeThere.Images";
import "CubePlugins.TakeMeThere.Timer";
import "CubePlugins.TakeMeThere.Globals";
import "CubePlugins.TakeMeThere.Commands";
import "CubePlugins.TakeMeThere.MainWin";

function UnloadReloader()
    Turbine.PluginManager.RefreshAvailablePlugins();
    local loadedPlugins = Turbine.PluginManager.GetLoadedPlugins();

    reloadedUnloader = Turbine.UI.Control();
    reloadedUnloader:SetWantsUpdates( true );
    
    reloadedUnloader.Update = function( sender, args )
        Turbine.PluginManager.RefreshAvailablePlugins();
        local loadedPlugins = Turbine.PluginManager.GetLoadedPlugins();

        for k,v in pairs(loadedPlugins) do
            if v.Name == "Take Me There Reloader" then
                Turbine.PluginManager.UnloadScriptState( 'TakeMeThereReloader' );
            end
        end
        reloadedUnloader:SetWantsUpdates( false );
    end
end

function DetermineIfWaypointIsAvailable()
    local loadedPlugins = Turbine.PluginManager:GetAvailablePlugins();
    for i=1, table.maxn(loadedPlugins) do
        if (loadedPlugins[i].Name == "Waypoint") then
            return true;
        end
    end
    return false;
end

function LoadData()
    local SavedSettings = {};
    SavedSettings = PatchDataLoad(Turbine.DataScope.Character, "TakeMeThere_Settings");

    -- Check the saved settings to make sure it is still compatible with newer updates, add in any missing default settings
    if type(SavedSettings) == 'table' then
        local tempSETTINGS = {};
        tempSETTINGS = deepcopy(DEFAULT_SETTINGS);
        SETTINGS = mergeTables(tempSETTINGS,SavedSettings);
    else
        SETTINGS = deepcopy(DEFAULT_SETTINGS);
    end
end

function SaveData()
    PatchDataSave(Turbine.DataScope.Character, "TakeMeThere_Settings", SETTINGS);
end

function RegisterForUnload()
    Turbine.Plugin.Unload = function (sender, args)
        -- Save the data when the plugin unloads.
        SaveData();
        Debug(GetString(_LANG.STATUS.UNLOADED));
    end

end

function DrawWindow()
    TakeMeThereWin.GetInstance():DrawMainWin();
end

function Main()
    UnloadReloader();
    local isWaypointAvailable = DetermineIfWaypointIsAvailable();
    if (isWaypointAvailable) then
        LoadData();
        RegisterForUnload();
        RegisterCommands();
        DrawWindow();
    end

    Debug(GetString(_LANG.STATUS.LOADED));
end

Main();
