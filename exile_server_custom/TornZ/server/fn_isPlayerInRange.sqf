/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_position","_distance","_return"];
_position = _this select 0;
_distance = _this select 1;
_return = false;
{
	if ((_x distance _position) <= _distance) exitWith {
		_return = true;
	};
} forEach allPlayers;
_return
