#define TL_HANDLE 0     // Block
#define TL_IGNORE 1     // Ignore

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
	@param iEnt     Entity index
*/
forward drop_talisman_post(iEnt);
