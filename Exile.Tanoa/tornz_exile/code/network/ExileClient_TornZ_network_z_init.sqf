/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

if (isDedicated) exitWith {};

_this spawn {
	private["_pos","_zombies","_buildings","_handle","_localZombies"];
	_pos = _this select 0;
	_zombies = _this select 1;

	//_zombies joinSilent grpNull; Still returns as a group with waypoints, so why bother
	_buildings = nearestObjects [_pos, ["HOUSE"], 150];

	if ((count _zombies) > 1) then {
		uisleep 0.4;  // Prevent FSM starting while zombie is climbing out from dirt
	};
	{
		_handle = [_x, _buildings, _forEachIndex] execFSM "tornz_exile\fsm\zombie_brain.fsm";
		//_x setVariable ["TornZ_L_Handle", _handle]; // Debug code
		_x addEventHandler ["firedNear", {_this call TornZ_fnc_firedNear;}];
	} forEach _zombies;

	_localZombies = player getVariable ["TornZ_C_ZombiesLocal",[]];
	if (!((typeName _localZombies) isEqualTo "ARRAY")) then
	{
		_localZombies = [];
	};
	_localZombies = _localZombies + _zombies;
	player setVariable ["TornZ_C_LocalCount", _localZombies, true];

	deleteWaypoint [group (_zombies select 0), 0]; // Do here instead of on server (would require nested if statements todo correctly on server)
};
