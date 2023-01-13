#include <tl_api>

enum _:FwdTalisman {
	GIVE_TALISMAN,
	RISE_TALISMAN_PRE,
	RISE_TALISMAN_POST,
	DROPPED_TALISMAN_PRE,
	DROPPED_TALISMAN_POST
};

enum CVARS
{
	MIN_PLAYERS,
	ROUND_ACCESS
};

new g_eFwdTalisman[FwdTalisman], g_eCvars[CVARS];
new FwdReturn;

new const g_szModel[] = "models/talisman.mdl";

new g_iPlayerId, g_MaxPlayers, g_iRoundCounter;
new g_ModelInDexTalisman;

public plugin_init()
{
	register_plugin("[RE] Talisman", "1.3.1", "BiZaJe");

	register_dictionary("talisman.txt");
	
	RegisterHookChain(RG_CSGameRules_RestartRound, "@HC_CSGameRules_RestartRound_Pre", .post = false);
	RegisterHookChain(RG_CBasePlayer_Killed, "@HC_CBasePlayer_Killed_Post", .post = true);

	g_MaxPlayers = get_maxplayers()

	@RegisterFwdTalisman();
	@RegisterCvars();
}

@RegisterFwdTalisman(){
	g_eFwdTalisman[GIVE_TALISMAN] = CreateMultiForward("give_talisman", ET_IGNORE);
    g_eFwdTalisman[RISE_TALISMAN_PRE] = CreateMultiForward("rise_talisman_pre", ET_STOP, FP_CELL);
    g_eFwdTalisman[RISE_TALISMAN_POST] = CreateMultiForward("rise_talisman_post", ET_IGNORE, FP_CELL);
    g_eFwdTalisman[DROPPED_TALISMAN_PRE] = CreateMultiForward("drop_talisman_pre", ET_STOP);
    g_eFwdTalisman[DROPPED_TALISMAN_POST] = CreateMultiForward("drop_talisman_post", ET_IGNORE, FP_CELL);
}

public plugin_natives()
{
	register_native("player_is_talisman", "native_core_player_is_talisman");
}

public plugin_precache()
{
	g_ModelInDexTalisman = precache_model(g_szModel);
}

public client_disconnected(iPlayer)
{
	if(g_iPlayerId == iPlayer){
		@TalismanSpawn(iPlayer);
	}
}

@HC_CSGameRules_RestartRound_Pre()
{
	if(get_member_game(m_bCompleteReset)){
		g_iRoundCounter = 0;
	}
	g_iRoundCounter++;

	if(g_iRoundCounter < g_eCvars[ROUND_ACCESS] || get_playersnum() < g_eCvars[MIN_PLAYERS] || g_iPlayerId){
		return;
	}

	new iEnt = NULLENT;
	
	while((iEnt = rg_find_ent_by_class(iEnt, "talisman"))){
		if(!is_nullent(iEnt)){
      		set_entvar(iEnt, var_flags, FL_KILLME);
    	}
	}

	g_iPlayerId = RandomAlive(random_num(1, AliveCount()));

	if(g_iPlayerId <= 0){
		return;
	}

	client_print_color(0, print_team_default, "%L %L", 0, "TALISMAN_PREFIX", 0, "TALISMAN_DROPPED_OUT", g_iPlayerId);

	ExecuteForward(g_eFwdTalisman[GIVE_TALISMAN], FwdReturn);
}

@HC_CBasePlayer_Killed_Post(const this, pevAttacker, iGib)
{
	if(this == g_iPlayerId)
		@TalismanSpawn(g_iPlayerId);
}

@Talisman_Touch(iEnt, iPlayer)
{
	if(!is_entity(iEnt) || !is_user_connected(iPlayer))
		return;

	ExecuteForward(g_eFwdTalisman[RISE_TALISMAN_PRE], FwdReturn, iPlayer);

	if(FwdReturn >= PLUGIN_HANDLED)
		return;

	SetTouch(iEnt, "");
	set_entvar(iEnt, var_flags, get_entvar(iEnt, var_flags) | FL_KILLME);
	client_print_color(0, print_team_default, "%L %L", 0, "TALISMAN_PREFIX", 0, "TALISMAN_RAISED", g_iPlayerId = iPlayer);
	ExecuteForward(g_eFwdTalisman[RISE_TALISMAN_POST], FwdReturn, iPlayer);
}

@RegisterCvars(){
	bind_pcvar_num(create_cvar(
		"talisman_round",
		"3",
		FCVAR_NONE,
		"From which round to issue the talisman"),
		g_eCvars[ROUND_ACCESS]
	);
	bind_pcvar_num(create_cvar(
		"talisman_min_player",
		"2",
		FCVAR_NONE,
		"Minimum number of players to include"),
		g_eCvars[MIN_PLAYERS]
	);
	
	AutoExecConfig(true, "talisman_core");
}

public native_core_player_is_talisman()
{
	return g_iPlayerId;
}

@TalismanSpawn(iPlayer)
{
	ExecuteForward(g_eFwdTalisman[DROPPED_TALISMAN_PRE], FwdReturn);

	if(FwdReturn >= PLUGIN_HANDLED)
		return;

	new Float:fOrigin[3], Float: fAngles[3];
	get_entvar(iPlayer, var_origin, fOrigin);
		
	new iEnt = rg_create_entity("info_target", false);
		
	if(!is_entity(iEnt))
		return;

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
	ExecuteForward(g_eFwdTalisman[DROPPED_TALISMAN_POST], FwdReturn, iPlayer);
	g_iPlayerId = 0
	SetTouch(iEnt, "@Talisman_Touch");
}

/* The code is taken from ZP 5.0 */
stock AliveCount()
{
	new iAlive, iPlayer;
	
	for (iPlayer = 1; iPlayer <= g_MaxPlayers; iPlayer++)
	{
		if (is_user_alive(iPlayer))
			iAlive++;
	}
	
	return iAlive;
}

stock RandomAlive(target_index)
{
	new iAlive, iPlayer;
	
	for (iPlayer = 1; iPlayer <= g_MaxPlayers; iPlayer++)
	{
		if (is_user_alive(iPlayer))
			iAlive++;
		
		if (iAlive == target_index)
			return iPlayer;
	}
	
	return -1;
}
