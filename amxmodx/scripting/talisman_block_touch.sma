#include <tl_api>
#include <aes_v>

enum CVARS{
    RISE_MIN_LEVEL
}

new g_eCvars[CVARS];

public plugin_init()
{
	register_plugin("[RE] Talisman Block Touch", PLUGIN_VERSION, "BiZaJe");

	register_dictionary("talisman_touch.txt");

	@RegisterCvars();
}

public rise_talisman_pre(iPlayer){
    if(aes_get_player_level(iPlayer) < g_eCvars[RISE_MIN_LEVEL]){
        client_print_color(iPlayer, print_team_default, "%L %L", iPlayer, "TALISMAN_PREFIX", iPlayer, "TALISMAN_RISE_TOUCH_BLOCK");
        return PLUGIN_HANDLED;
    }
    return PLUGIN_HANDLED;
}

@RegisterCvars(){
    bind_pcvar_num(create_cvar(
        "min_level_touch_talisman",
        "5",
        FCVAR_NONE,
        "Minimum level for raising the mascot"),
        g_eCvars[RISE_MIN_LEVEL]
    );
    AutoExecConfig(true, "talisman_touch");
}
