#include <amxmodx>
#include <reapi>

#define TASK_ID 67628

enum CVARS
{
	SCREENFADE,
	SCREENFADE_COLOR_R,
	SCREENFADE_COLOR_G,
	SCREENFADE_COLOR_B,
	GLOW,
	GLOW_CT_COLOR_R,
	GLOW_CT_COLOR_G,
	GLOW_CT_COLOR_B,
	GLOW_TT_COLOR_R,
	GLOW_TT_COLOR_G,
	GLOW_TT_COLOR_B,
	MIN_PLAYERS,
	ROUND_ACCESS,
	Float:GIVE_HEALTH,
	Float:INTERVAL_REGENERATION,
	Float:MAX_REREGENERATION_HEALTH
};

new g_eCvars[CVARS];

new const g_szModel[] = "models/talisman.mdl";

new g_iPlayerId, g_iRoundCounter;
new g_ModelInDexTalisman;

public plugin_init()
{
	register_plugin("[RE] Talisman", "1.2.5", "BiZaJe");

	register_dictionary("talisman.txt");
	
	RegisterHookChain(RG_CSGameRules_RestartRound, "HC_CSGameRules_RestartRound_Pre", .post = false);
	RegisterHookChain(RG_CBasePlayer_Killed, "HC_CBasePlayer_Killed_Post", .post = true);
	RegisterHookChain(RG_CSGameRules_CleanUpMap, "HC_CSGameRules_CleanUpMap_Post", true);

	RegisterCvars();
}

public plugin_precache()
{
	g_ModelInDexTalisman = precache_model(g_szModel);
}

public client_disconnected(id)
{
	if(g_iPlayerId == id){
		TalismanSpawn(id);
	}
}

public HC_CSGameRules_CleanUpMap_Post() {
	new iEnt = NULLENT;
	
	while((iEnt = rg_find_ent_by_class(iEnt, "talisman"))){
		if(!is_nullent(iEnt)){
      		set_entvar(iEnt, var_flags, FL_KILLME);
    	}
	}
}

public HC_CSGameRules_RestartRound_Pre()
{
	if(get_member_game(m_bCompleteReset)){
		g_iRoundCounter = 0;
	}
	g_iRoundCounter++;

	if(g_iRoundCounter < g_eCvars[ROUND_ACCESS] || get_playersnum() < g_eCvars[MIN_PLAYERS] || g_iPlayerId){
		return;
	}

	remove_task(g_iPlayerId+TASK_ID);
		
	new apPlayers[32], iPlayers;
	get_players(apPlayers, iPlayers, "ah");

	g_iPlayerId = apPlayers[random_num(1, iPlayers)];
	
	client_print_color(0, print_team_default, "%L %L", 0, "TALISMAN_PREFIX", 0, "TALISMAN_DROPPED_OUT", g_iPlayerId);

	if(g_eCvars[GLOW]){
		switch(get_member(g_iPlayerId, m_iTeam)){
			case TEAM_CT:{
				rg_set_user_rendering(g_iPlayerId, kRenderFxGlowShell, {g_eCvars[GLOW_CT_COLOR_R], g_eCvars[GLOW_CT_COLOR_G], g_eCvars[GLOW_CT_COLOR_B]}, kRenderNormal, 25.0);
			}
			case TEAM_TERRORIST:{
				rg_set_user_rendering(g_iPlayerId, kRenderFxGlowShell, {g_eCvars[GLOW_TT_COLOR_R], g_eCvars[GLOW_TT_COLOR_G], g_eCvars[GLOW_TT_COLOR_B]}, kRenderNormal, 25.0);
			}
		}
	}

	set_task(g_eCvars[INTERVAL_REGENERATION], "RegenerationHealth", g_iPlayerId+TASK_ID, .flags="b");
}

public HC_CBasePlayer_Killed_Post(const this, pevAttacker, iGib)
{
	if(this == g_iPlayerId)
		TalismanSpawn(g_iPlayerId);
}

public Talisman_Touch(iEnt, id)
{
	if(!is_entity(iEnt) || !is_user_connected(id))
		return;

	SetTouch(iEnt, "");
	set_entvar(iEnt, var_flags, get_entvar(iEnt, var_flags) | FL_KILLME);
	client_print_color(0, print_team_default, "%L %L", 0, "TALISMAN_PREFIX", 0, "TALISMAN_RAISED", g_iPlayerId = id);
	set_task(g_eCvars[INTERVAL_REGENERATION], "RegenerationHealth", g_iPlayerId+TASK_ID, .flags="b");
}

public RegenerationHealth()
{
	if(!g_iPlayerId || get_playersnum() < g_eCvars[MIN_PLAYERS])
		return;
	
	if(!is_user_alive(g_iPlayerId))
		return;

	new Float:fHealth = get_entvar(g_iPlayerId, var_health);

	if(fHealth < g_eCvars[MAX_REREGENERATION_HEALTH])
	{
		new Float:giveHealth = (fHealth + g_eCvars[GIVE_HEALTH]) < g_eCvars[MAX_REREGENERATION_HEALTH] ? g_eCvars[GIVE_HEALTH] : (g_eCvars[MAX_REREGENERATION_HEALTH] - fHealth);
		
		set_entvar(g_iPlayerId, var_health, fHealth + giveHealth);
		
		if(g_eCvars[SCREENFADE]){
			message_begin(MSG_ONE_UNRELIABLE, 98, _, g_iPlayerId);
			write_short(1<<10);
			write_short(1<<10);
			write_short(0x0000);
			write_byte(g_eCvars[SCREENFADE_COLOR_R]);
			write_byte(g_eCvars[SCREENFADE_COLOR_G]);
			write_byte(g_eCvars[SCREENFADE_COLOR_B]);
			write_byte(40);
			message_end();
		}
	}
}

public RegisterCvars(){
	bind_pcvar_num(create_cvar(
		"talisman_screenfede",
		"1",
		FCVAR_NONE,
		"Darken the screen when regenerating health"),
		g_eCvars[SCREENFADE]
	);
	bind_pcvar_num(create_cvar(
		"talisman_screenfede_color_r",
		"0",
		FCVAR_NONE,
		"screen darkening color (red shade)"),
		g_eCvars[SCREENFADE_COLOR_R]
	);
	bind_pcvar_num(create_cvar(
		"talisman_screenfede_color_g",
		"255",
		FCVAR_NONE,
		"screen darkening color (green shade)"),
		g_eCvars[SCREENFADE_COLOR_G]
	);
	bind_pcvar_num(create_cvar(
		"talisman_screenfede_color_b",
		"0",
		FCVAR_NONE,
		"screen darkening color (blue shade)"),
		g_eCvars[SCREENFADE_COLOR_B]
	);
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
		"talisman_min_player",
		"2",
		FCVAR_NONE,
		"Minimum number of players to include"),
		g_eCvars[MIN_PLAYERS]
	);
	bind_pcvar_float(create_cvar(
		"talisman_give_health",
		"5.0",
		FCVAR_NONE,
		"How much will restore health"),
		g_eCvars[GIVE_HEALTH]
	);
	bind_pcvar_float(create_cvar(
		"talisman_reg_interval",
		"3.0",
		FCVAR_NONE,
		"After how many seconds will health be added"),
		g_eCvars[INTERVAL_REGENERATION]
	);
	bind_pcvar_float(create_cvar(
		"talisman_max_reg_hp",
		"100.0",
		FCVAR_NONE,
		"Maximum amount of health during regeneration"),
		g_eCvars[MAX_REREGENERATION_HEALTH]
	);
	AutoExecConfig(true, "talisman");
}

stock TalismanSpawn(id)
{
	new Float:fOrigin[3], Float: fAngles[3];
	get_entvar(id, var_origin, fOrigin);
	
	new iEnt = rg_create_entity("info_target", false);
	
	if(!is_entity(iEnt))
		return;

	if(g_eCvars[GLOW]){
		set_user_rendering(id)
	}

	fAngles[1] = random_float(-180.0, 180.0);

	set_entvar(iEnt, var_origin, fOrigin);
	set_entvar(iEnt, var_classname, "talisman");
	set_entvar(iEnt, var_model, g_szModel);
	set_entvar(iEnt, var_modelindex, g_ModelInDexTalisman);
	set_entvar(iEnt, var_skin, random_num(0, 5));
	set_entvar(iEnt, var_solid, SOLID_TRIGGER);
	set_entvar(iEnt, var_movetype, MOVETYPE_TOSS);
	set_entvar(iEnt, var_sequence, 0);
	set_entvar(iEnt, var_framerate, 0.5);
	set_entvar(iEnt, var_effects, 8);
	set_entvar(iEnt, var_mins, Float:{-16.0,-16.0,-16.0})
	set_entvar(iEnt, var_maxs, Float:{16.0,16.0,16.0})
	set_entvar(iEnt, var_angles, fAngles);
	client_print_color(0, print_team_default, "%L %L", 0, "TALISMAN_PREFIX", 0, "TALISMAN_LOST", g_iPlayerId);
	g_iPlayerId = 0
	remove_task(id+TASK_ID);
	SetTouch(iEnt, "Talisman_Touch");
}

stock rg_set_user_rendering(index, fx = kRenderFxNone, {Float,_}:color[3] = {0.0,0.0,0.0}, render = kRenderNormal, Float:amount = 0.0)
{
    set_entvar(index, var_renderfx, fx);
    set_entvar(index, var_rendercolor, color);
    set_entvar(index, var_rendermode, render);
    set_entvar(index, var_renderamt, amount);
} 
