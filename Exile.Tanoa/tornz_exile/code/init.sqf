/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

if (!isNil "TornZ_Started") exitWith {};
TornZ_Started = compileFinal "true";

TornZ_zombiesTypes_Crawler	 = (getArray (configFile >> "CfgPatches" >> "TornZ" >> "units_legacy_crawlers")) + (getArray (configFile >> "CfgPatches" >> "TornZ" >> "units_ryanz_crawlers"));
TornZ_zombiesTypes_Medium		 = (getArray (configFile >> "CfgPatches" >> "TornZ" >> "units_legacy_medium")) + (getArray (configFile >> "CfgPatches" >> "TornZ" >> "units_ryanz_medium"));
TornZ_zombiesTypes_Slow  		 = (getArray (configFile >> "CfgPatches" >> "TornZ" >> "units_legacy_slow")) + (getArray (configFile >> "CfgPatches" >> "TornZ" >> "units_ryanz_slow"));
TornZ_zombiesTypes_Spider		 = (getArray (configFile >> "CfgPatches" >> "TornZ" >> "units_legacy_spider")) + (getArray (configFile >> "CfgPatches" >> "TornZ" >> "units_ryanz_spider"));
TornZ_zombiesTypes     		   = TornZ_zombiesTypes_Crawler + TornZ_zombiesTypes_Medium + TornZ_zombiesTypes_Slow + TornZ_zombiesTypes_Spider;

// Both
TornZ_fnc_z_init			= compileFinal preprocessFileLineNumbers "\tornz_exile\code\both\fn_z_init.sqf";
TornZ_fnc_z_mpkilled	= compileFinal preprocessFileLineNumbers "\tornz_exile\code\both\fn_z_mpkilled.sqf";

// Client
if (hasInterface) then {
	// Functions
	// Exile Network Functions
	ExileClient_TornZ_network_z_init 	= compileFinal preprocessFileLineNumbers "\tornz_exile\code\network\ExileClient_TornZ_network_z_init.sqf";
	// TornZ Network Functions
	TornZ_fnc_re_z_attack 						= compileFinal preprocessFileLineNumbers "\tornz_exile\code\re\fn_re_z_attack.sqf";
	TornZ_fnc_re_z_initAll 						= compileFinal preprocessFileLineNumbers "\tornz_exile\code\re\fn_re_z_initAll.sqf";

	TornZ_fnc_blurEffect							= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_blurEffect.sqf";
	TornZ_fnc_firedNear								= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_firedNear.sqf";
	TornZ_fnc_getPlayerInRange				= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_getPlayerInRange.sqf";
	TornZ_fnc_inBuilding			 				= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_inBuilding.sqf";
	TornZ_fnc_isVisible								= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_isVisible.sqf";
	TornZ_fnc_isVisibleFOV						= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_isVisibleFOV.sqf";
	TornZ_fnc_main										= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_main.sqf";

	TornZ_fnc_z_attack								= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_z_attack.sqf";
	TornZ_fnc_z_attackVehicle					= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_z_attackVehicle.sqf";
	TornZ_fnc_z_attackVehicleCheck		= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_z_attackVehicleCheck.sqf";
	TornZ_fnc_z_chase									= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_z_chase.sqf";
	TornZ_fnc_z_kill									= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_z_kill.sqf";
	TornZ_fnc_z_sounds_chase					= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_z_sounds_chase.sqf";
	TornZ_fnc_z_sounds_moan						= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_z_sounds_moan.sqf";
	TornZ_fnc_z_transfer							= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_z_transfer.sqf";
	TornZ_fnc_z_wander								= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_z_wander.sqf";
	TornZ_fnc_z_wanderTo							= compileFinal preprocessFileLineNumbers "\tornz_exile\code\client\fn_z_wanderTo.sqf";

	// Player TornZ Loop
	[] spawn TornZ_fnc_main;
};
