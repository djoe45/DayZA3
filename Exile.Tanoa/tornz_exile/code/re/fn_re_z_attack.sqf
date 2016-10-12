/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

// Note: This doesn't use Exile Network Framework

private ["_zombie"];
_zombie = _this;
if (!(alive _zombie)) exitWith {};
if (local _zombie) exitWith {};
if ((player distance2D _zombie) > viewDistance) exitWith {};
_zombie switchMove "AwopPercMstpSgthWnonDnon_throw";
