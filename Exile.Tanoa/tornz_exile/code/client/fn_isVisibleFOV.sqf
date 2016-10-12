/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private [ "_fov"];

if (isBleeding player) exitWith {true};
_fov = _this getRelDir player;
if (!((_fov <= 80) || (_fov >= 280))) exitWith {false};
true
