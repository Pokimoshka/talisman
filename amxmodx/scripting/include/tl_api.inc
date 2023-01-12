#include <amxmodx>
#include <fun>
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
