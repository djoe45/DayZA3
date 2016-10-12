/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_zombie","_pos1","_dest","_distance","_dir"];
_zombie = _this select 0;
_pos = _this select 1;

_dest = [];
_distance = (_zombie distance _pos);
_dir = _zombie getRelDir _pos;
_distance = _distance - 0.8;
_dest = _zombie getRelPos [_distance, _dir];
_dest set [2, (_pos select 2)];
_zombie doMove _dest;
_zombie setSpeedMode "LIMITED";
_zombie setUnitPos "UPRIGHT";
