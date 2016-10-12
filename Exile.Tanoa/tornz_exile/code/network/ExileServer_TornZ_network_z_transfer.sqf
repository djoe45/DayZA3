/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_sessionID","_params","_zombie","_player"];
_sessionID = _this select 0;
_params = _this select 1;

_player = _params select 0;
_zombie = _params select 1;

if (isNull _zombie) exitWith {};
if (!(_zombie isKindOf "TornZ_Base")) exitWith {};
if (isNull _player) exitWith
{
	deleteVehicle _zombie;
};
if (!(isPlayer _player)) exitWith {};
if ((owner _zombie) isEqualTo _player) exitWith {};
_zombie removeAllEventHandlers "local";

// Create / Retreive Player Zombie Group
_zombieGroupVarName = format["TornZ_zombieGroup_%1", owner _player];
if (isNil _zombieGroupVarName) then {
	_zombieGroup = createGroup east;
	missionNamespace setVariable [_zombieGroupVarName, _zombieGroup];
};
_zombieGroup = missionNamespace getVariable _zombieGroupVarName;
if (isNull _zombieGroup) then
{
	_zombieGroup = createGroup east;
	missionNamespace setVariable [_zombieGroupVarName, _zombieGroup];
};
if (isNull _zombieGroup) then
{
	//throw "Error Creating / Retreiving Player Zombie Group";
	deleteVehicle _zombie;
} else {
	deleteWaypoint [_zombieGroup, 0]; // Delete Default Waypoint
	[_zombie] joinSilent _zombieGroup;
	if (!(_zombieGroup setGroupOwner (owner _player))) then {
		TornZ_transferQueue pushBack [_player, [_zombie]];
	} else {
		_zombie addEventHandler ["local", {_this call TornZ_fnc_z_locality;}];
		[_player, "z_init", [(getPOSATL player), [_zombie]]] call ExileServer_system_network_send_to;
	};
};
