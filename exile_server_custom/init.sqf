/*
	Auteur: Djoe45
*/


diag_log "Initialisation du côté serveur custom";

/* Variables Serveur */
server_totalCrashes = 0;

// execVM "\exile_server_custom\Airport.sqf";

/* Serveur Fonction */
server_spawnCrashSite  =    compile preprocessFileLineNumbers "\exile_server_custom\Helico\server_spawnCrashSite.sqf";
spawn_loot  =    compile preprocessFileLineNumbers "\exile_server_custom\Helico\spawn_loot.sqf";
fnc_buildWeightedArray = 	compile preprocessFileLineNumbers "\exile_server_custom\Helico\fn_buildWeightedArray.sqf";
[4, 4, (30 * 60), (5 * 60), 1.00, 'center', 3000, true] spawn server_spawnCrashSite;	
diag_log "SpawnCrashSite Initialise";

server_objectSpawner  =					compile preprocessFileLineNumbers "\exile_server_custom\server_objectSpawner.sqf";
server_objectSpawnerMonitor  =			compile preprocessFileLineNumbers "\exile_server_custom\server_objectSpawnerMonitor.sqf";
server_WreckSpawner  =					compile preprocessFileLineNumbers "\exile_server_custom\server_WreckSpawner.sqf";
server_ObjectInBuildingSpawner  =		compile preprocessFileLineNumbers "\exile_server_custom\server_ObjectInBuildingSpawner.sqf";

TornZ_zombieGroup = createGroup independent;
// Mission Config Settings
TornZ_zombiesSpawnChance = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_spawnChance");
TornZ_zombiesMaxLocal = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_maxLocal");
TornZ_zombiesMaxTotal = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_maxTotal");
TornZ_zombiesDistance = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_distance");
TornZ_zombiesMaxDistance = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_distanceMax");
TornZ_zombiesLootChance =  1 - (getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_lootChance"));
TornZ_zombiesKilledScore = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_killedScore");
TornZ_zombiesSpawnOutsideChance = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_spawnOutsideChance");
TornZ_Legacy_Faces = getArray (configFile >> "CfgTornZ" >> "units_legacy_faces");
TornZ_RyanZombies_Faces = getArray (configFile >> "CfgTornZ" >> "units_ryanz_faces");


if (!(isClass(configFile >> "CfgLootTables" >> "zombies"))) exitWith
{
	diag_log "Error: TornZ_Exile: Missing Loot Table zombies";
	diag_log "Error: TornZ_Exile: Missing Loot Table zombies";
	diag_log "Error: TornZ_Exile: Missing Loot Table zombies";
	endMission "LOSER";
};

TornZ_zombiesDoctor = getArray ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombie_doctors");
TornZ_zombiesPriest = getArray ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombie_priests");
TornZ_zombiesPolice = getArray ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombie_police");
TornZ_zombiesSoldier = getArray ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombie_soldiers");

// Functions
// Exile Network Functions
ExileServer_TornZ_network_z_kill = compileFinal preprocessFileLineNumbers "\tornz_exile\code\network\ExileServer_TornZ_network_z_kill.sqf";
ExileServer_TornZ_network_z_transfer  = compileFinal preprocessFileLineNumbers "\tornz_exile\code\network\ExileServer_TornZ_network_z_transfer.sqf";

// Server Functions
TornZ_fnc_isPlayerInRange = compileFinal preprocessFileLineNumbers "\exile_server_custom\TornZ\server\fn_isPlayerInRange.sqf";
TornZ_fnc_z_locality = compileFinal preprocessFileLineNumbers "\exile_server_custom\TornZ\server\fn_z_locality.sqf";
TornZ_fnc_z_spawn = compileFinal preprocessFileLineNumbers "\exile_server_custom\TornZ\server\fn_z_spawn.sqf";
TornZ_fnc_z_spawnCheck = compileFinal preprocessFileLineNumbers "\exile_server_custom\TornZ\server\fn_z_spawnCheck.sqf";

// Server Zombie Transfer Queue System
TornZ_transferQueue = [];
TornZ_fnc_z_transferQueue = compileFinal preprocessFileLineNumbers "\exile_server_custom\TornZ\server\fn_z_transferQueue.sqf";
[] spawn {
	waitUntil {sleep 1;(!isNil "PublicServerIsLoaded")};
	[1, TornZ_fnc_z_transferQueue, [], true] call ExileServer_system_thread_addTask;
};

// nul_1 = [] spawn server_objectSpawner; //Start spawn object in map

diag_log "Fin d'initialisation du côté serveur custom";