#include <tl_api>

enum CVARS{
    Float:HOLDTIME_HUD,
    Float:FADEOUTTIME_HUD,
    HUD_COLOR_R,
    HUD_COLOR_G,
    HUD_COLOR_B,
    Float:HUD_POS_X,
    Float:HUD_POS_Y
}

new g_eCvars[CVARS];

new g_SyncHud;

public plugin_init()
{
    register_plugin("[RE] Talisman HUD", PLUGIN_VERSION, "BiZaJe")

    register_dictionary("talisman_hud.txt");

    g_SyncHud = CreateHudSyncObj();

    @RegisterCvars();
}

public give_talisman(){
    set_hudmessage(.red = g_eCvars[HUD_COLOR_R], .green = g_eCvars[HUD_COLOR_G], .blue = g_eCvars[HUD_COLOR_B], .x = g_eCvars[HUD_POS_X], .y = g_eCvars[HUD_POS_Y], .holdtime = g_eCvars[HOLDTIME_HUD], .fadeouttime = g_eCvars[FADEOUTTIME_HUD]);
    ShowSyncHudMsg(player_is_talisman(), g_SyncHud, "%L", player_is_talisman(), "TALISMAN_GIVE_HUD");
}

public rise_talisman_post(iPlayer){
    set_hudmessage(.red = g_eCvars[HUD_COLOR_R], .green = g_eCvars[HUD_COLOR_G], .blue = g_eCvars[HUD_COLOR_B], .x = g_eCvars[HUD_POS_X], .y = g_eCvars[HUD_POS_Y], .holdtime = g_eCvars[HOLDTIME_HUD], .fadeouttime = g_eCvars[FADEOUTTIME_HUD]);
    ShowSyncHudMsg(iPlayer, g_SyncHud, "%L", iPlayer, "TALISMAN_RISE_HUD");
    return PLUGIN_CONTINUE;
}

public drop_talisman_post(iPlayer){
    set_hudmessage(.red = g_eCvars[HUD_COLOR_R], .green = g_eCvars[HUD_COLOR_G], .blue = g_eCvars[HUD_COLOR_B], .x = g_eCvars[HUD_POS_X], .y = g_eCvars[HUD_POS_Y], .holdtime = g_eCvars[HOLDTIME_HUD], .fadeouttime = g_eCvars[FADEOUTTIME_HUD]);
    ShowSyncHudMsg(iPlayer, g_SyncHud, "%L", iPlayer, "TALISMAN_DROP_HUD");
    return PLUGIN_CONTINUE;
}

@RegisterCvars(){
    bind_pcvar_num(create_cvar(
        "hud_color_r",
        "0",
        FCVAR_NONE,
        "Цвет HUD`а (Красный)"),
        g_eCvars[HUD_COLOR_R]
    );
    bind_pcvar_num(create_cvar(
        "hud_color_g",
        "170",
        FCVAR_NONE,
        "Цвет HUD`а (Зеленый)"),
        g_eCvars[HUD_COLOR_G]
    );
    bind_pcvar_num(create_cvar(
        "hud_color_b",
        "255",
        FCVAR_NONE,
        "Цвет HUD`а (Синий)"),
        g_eCvars[HUD_COLOR_B]
    );
    bind_pcvar_float(create_cvar(
        "hud_position_x",
        "-1.0",
        FCVAR_NONE,
        "Позиция HUD (X)"),
        g_eCvars[HUD_POS_X]
    );
    bind_pcvar_float(create_cvar(
        "hud_position_y",
        "0.8",
        FCVAR_NONE,
        "Позиция HUD (Y)"),
        g_eCvars[HUD_POS_Y]
    );
    bind_pcvar_float(create_cvar(
        "holdtime_hud",
        "5.0",
        FCVAR_NONE,
        "How long will the message be on the screen"),
        g_eCvars[HOLDTIME_HUD]
    );
    bind_pcvar_float(create_cvar(
        "fadeouttime_hud",
        "1.0",
        FCVAR_NONE,
        "How long will it take for the message to leave the screen (smooth disappearance)"),
        g_eCvars[FADEOUTTIME_HUD]
    );
    AutoExecConfig(true, "talisman_hud");
}
