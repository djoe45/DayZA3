/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private [ "_zombie", "_zombie_eye","_player_eye","_list"];
if (ExilePlayerInSafezone) exitWith {false};
if (!(local (vehicle player))) exitWith {false};
if (isObjectHidden (vehicle player)) exitWith {false};

_zombie = _this;
_zombie_eye = eyepos _zombie;
_player_eye = eyepos player;

if (terrainintersectasl [_zombie_eye, _player_eye]) exitWith {false};
_list = lineIntersectsObjs  [_zombie_eye, _player_eye, _zombie, player, false, 4];
if ((count _list) > 0) exitWith {false};
true
