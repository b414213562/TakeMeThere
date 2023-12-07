-- Remove next line:
import "Turbine";


import "Turbine.UI";

ReloadTakeMeThere = Turbine.UI.Control();
ReloadTakeMeThere:SetWantsUpdates( true );

ReloadTakeMeThere.Update = function( sender, args )
    ReloadTakeMeThere:SetWantsUpdates( false );

    Turbine.PluginManager.UnloadScriptState( 'TakeMeThere' );
    Turbine.PluginManager.LoadPlugin( 'Take Me There' );
end