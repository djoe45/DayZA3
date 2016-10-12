private ["_centerMap","_nearestRadius","_listLocations"];

_listLocations = getArray (configFile >> "CfgObjectSpawner" >> "listLocations");
_centerMap	= getArray (configFile >> "cfgWorlds" >> worldName >> "safePositionAnchor");
_nearestRadius	= (getNumber (configFile >> "cfgWorlds" >> worldName >> "safePositionRadius")) * 2.5;

{
	_x spawn server_objectSpawnerMonitor;
} forEach (nearestLocations [_centerMap, _listLocations, _nearestRadius]);

//	[[[allMissionObjects "Maniken_Base"],"z\addons\dayz_code\compile\DisableSimulation.sqf"],"BIS_fnc_execVM",nil,true] spawn BIS_fnc_MP;

//	nul = [] call server_ObjectInBuildingSpawner; //Start spawn object in buildings