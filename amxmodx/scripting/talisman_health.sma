#include <tl_api>

#define TASK_ID 67628

enum CVARS
{
	SCREENFADE,
	SCREENFADE_COLOR_R,
	SCREENFADE_COLOR_G,
	SCREENFADE_COLOR_B,
	Float:GIVE_HEALTH,
	Float:INTERVAL_REGENERATION,
	Float:MAX_REREGENERATION_HEALTH
};

new g_eCvars[CVARS];

public plugin_init()
{
	register_plugin("[RE] Talisman Health", PLUGIN_VERSION, "BiZaJe");

	@RegisterCvars();
}

public give_talisman(){
    set_task(g_eCvars[INTERVAL_REGENERATION], "@RegenerationHealth", player_is_talisman()+TASK_ID, .flags="b");
}

public rise_talisman_post(iPlayer){
	set_task(g_eCvars[INTERVAL_REGENERATION], "@RegenerationHealth", iPlayer+TASK_ID, .flags="b");
	return PLUGIN_CONTINUE;
}

public drop_talisman_post(iPlayer){
	remove_task(iPlayer+TASK_ID);
	return PLUGIN_CONTINUE;
}

@RegenerationHealth()
{
	if(!player_is_talisman())
		return;
	
	if(!is_user_alive(player_is_talisman()))
		return;

	new Float:fHealth = get_entvar(player_is_talisman(), var_health);

	if(fHealth < g_eCvars[MAX_REREGENERATION_HEALTH])
	{
		new Float:giveHealth = (fHealth + g_eCvars[GIVE_HEALTH]) < g_eCvars[MAX_REREGENERATION_HEALTH] ? g_eCvars[GIVE_HEALTH] : (g_eCvars[MAX_REREGENERATION_HEALTH] - fHealth);
		
		set_entvar(player_is_talisman(), var_health, fHealth + giveHealth);
		
		if(g_eCvars[SCREENFADE]){
			if(!is_player_blinded(player_is_talisman())){
				message_begin(MSG_ONE_UNRELIABLE, 98, _, player_is_talisman());
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
}

@RegisterCvars(){
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
	AutoExecConfig(true, "talisman_health");
}

stock bool:is_player_blinded(iPlayer)
{
    return bool:(Float:get_member(iPlayer, m_blindStartTime) + Float:get_member(iPlayer, m_blindFadeTime) >= get_gametime())
}
