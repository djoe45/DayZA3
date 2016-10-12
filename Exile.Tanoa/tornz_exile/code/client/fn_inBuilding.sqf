/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private ["_unit","_underPos","_abovePos","_objects","_return"];

_unit = _this;

_underPos = eyepos _unit;
_underPos set [2,(_underPos select 2) - 2];
_abovePos = +_underPos;
_abovePos set [2,(_abovePos select 2) + 12];

_objects = lineIntersectsObjs [_underPos, _abovePos, player, player, false, 2];
_return = false;
{
	if (_x isKindOf "HOUSE") exitWith {_return = true;};
} forEach _objects;
_return
