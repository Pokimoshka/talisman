#include <amxmodx>
#include <reapi>

/**
    The function is called when the player has received a talisman
*/
forward give_talisman();


/**
    The function is called before the talisman is raised
	@param iPlayer  Player index
*/
forward rise_talisman_pre(iPlayer);

/**
	The function is called after lifting the talisman
	@param iPlayer  Player index
*/
forward rise_talisman_post(iPlayer);

/**
	The function is called before the talisman is lost
*/
forward drop_talisman_pre();

/**
	The function is called after the loss of the talisman
*/
forward drop_talisman_post(iPlayer);

// The function is called when the player has received a talisman
native player_is_talisman();

stock rg_set_rendering(eEnt, fx = kRenderFxNone, r = 255, g = 255, b = 255, render = kRenderNormal, amount = 16)
{
    new Float: fRenderColor[3];
    fRenderColor[0] = float(r);
    fRenderColor[1] = float(g);
    fRenderColor[2] = float(b);

    set_entvar(eEnt, var_renderfx, fx);
    set_entvar(eEnt, var_rendercolor, fRenderColor);
    set_entvar(eEnt, var_rendermode, render);
    set_entvar(eEnt, var_renderamt, float(amount));
}
