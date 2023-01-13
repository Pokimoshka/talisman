#include <tl_api>

enum CVARS
{
	GLOW,
	GLOW_CT_COLOR_R,
	GLOW_CT_COLOR_G,
	GLOW_CT_COLOR_B,
	GLOW_TT_COLOR_R,
	GLOW_TT_COLOR_G,
	GLOW_TT_COLOR_B,
	THICKNESS_GLOW
};

new g_eCvars[CVARS];

public plugin_init()
{
	register_plugin("[RE] Talisman Glow Player", "1.0", "BiZaJe");

	@RegisterCvars();
}

public give_talisman(){
    if(g_eCvars[GLOW]){
		switch(get_member(player_is_talisman(), m_iTeam)){
			case TEAM_CT:{
                rg_set_rendering(player_is_talisman(), kRenderFxGlowShell, g_eCvars[GLOW_CT_COLOR_R], g_eCvars[GLOW_CT_COLOR_G], g_eCvars[GLOW_CT_COLOR_B], kRenderNormal, g_eCvars[THICKNESS_GLOW])
            }
            case TEAM_TERRORIST:{
                rg_set_rendering(player_is_talisman(), kRenderFxGlowShell, g_eCvars[GLOW_TT_COLOR_R], g_eCvars[GLOW_TT_COLOR_G], g_eCvars[GLOW_TT_COLOR_B], kRenderNormal, g_eCvars[THICKNESS_GLOW])
            }
		}
	}
}

public rise_talisman_post(iPlayer){
	if(g_eCvars[GLOW]){
		switch(get_member(iPlayer, m_iTeam)){
			case TEAM_CT:{
                rg_set_rendering(iPlayer, kRenderFxGlowShell, g_eCvars[GLOW_CT_COLOR_R], g_eCvars[GLOW_CT_COLOR_G], g_eCvars[GLOW_CT_COLOR_B], kRenderNormal, g_eCvars[THICKNESS_GLOW])
            }
            case TEAM_TERRORIST:{
                rg_set_rendering(iPlayer, kRenderFxGlowShell, g_eCvars[GLOW_TT_COLOR_R], g_eCvars[GLOW_TT_COLOR_G], g_eCvars[GLOW_TT_COLOR_B], kRenderNormal, g_eCvars[THICKNESS_GLOW])
            }
		}
	}
	return PLUGIN_CONTINUE;
}

public drop_talisman_post(iPlayer){
	if(g_eCvars[GLOW]){
		rg_set_rendering(iPlayer)
	}

	return PLUGIN_CONTINUE;
}

@RegisterCvars(){
	bind_pcvar_num(create_cvar(
		"talisman_player_glow",
		"1",
		FCVAR_NONE,
		"Highlight a player if he has a talisman"),
		g_eCvars[GLOW]
	);
	bind_pcvar_num(create_cvar(
		"talisman_player_ct_glow_color_r",
		"0",
		FCVAR_NONE,
		"Color Glow CT (red shade)"),
		g_eCvars[GLOW_CT_COLOR_R]
	);
	bind_pcvar_num(create_cvar(
		"talisman_player_ct_glow_color_g",
		"255",
		FCVAR_NONE,
		"Color Glow CT (green shade)"),
		g_eCvars[GLOW_CT_COLOR_G]
	);
	bind_pcvar_num(create_cvar(
		"talisman_player_ct_glow_color_b",
		"0",
		FCVAR_NONE,
		"Color Glow CT (blue shade)"),
		g_eCvars[GLOW_CT_COLOR_B]
	);
	bind_pcvar_num(create_cvar(
		"talisman_player_tt_glow_color_r",
		"0",
		FCVAR_NONE,
		"Color Glow TT (red shade)"),
		g_eCvars[GLOW_TT_COLOR_R]
	);
	bind_pcvar_num(create_cvar(
		"talisman_player_tt_glow_color_g",
		"255",
		FCVAR_NONE,
		"Color Glow TT (green shade)"),
		g_eCvars[GLOW_TT_COLOR_G]
	);
	bind_pcvar_num(create_cvar(
		"talisman_player_tt_glow_color_b",
		"0",
		FCVAR_NONE,
		"Color Glow TT (blue shade)"),
		g_eCvars[GLOW_TT_COLOR_B]
	);
	bind_pcvar_num(create_cvar(
		"talisman_thickness_glow",
		"25",
		FCVAR_NONE,
		"The thickness of the glow effect"),
		g_eCvars[THICKNESS_GLOW]
	);
	AutoExecConfig(true, "talisman_glow");
}
