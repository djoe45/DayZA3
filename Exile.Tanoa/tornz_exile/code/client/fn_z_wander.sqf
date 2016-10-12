/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_zombie","_pos","_distance","_dir"];

_zombie = _this select 0;
_pos = _this select 1;
_distance = _this select 2;

_dir = random 360;
_distance = random (_distance *2);
_pos = [(_pos select 0) + _distance*sin _dir, (_pos select 1) + _distance*cos _dir, _pos select 2];

if (surfaceIsWater _pos) exitWith {};

_zombie doMove _pos;
_zombie setSpeedMode "LIMITED";
_zombie setUnitPos "UPRIGHT";
