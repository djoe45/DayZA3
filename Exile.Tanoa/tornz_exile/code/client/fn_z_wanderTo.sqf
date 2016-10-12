/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_zombie","_dest","_return","_pos","_dest","_dir"];
_zombie = _this select 0;
_dest = _this select 1;
_return = true;

_pos = getPosATL _zombie;
if ((_pos distance _dest) > 5) then
{
	_return = false;
};

_zombie doMove _dest;
_zombie setSpeedMode "LIMITED";
_zombie setUnitPos "UPRIGHT";
_return
