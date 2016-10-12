/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private ["_zombie","_local"];

_zombie = _this select 0;
_local = _this select 1;

if !(_local) exitWith {};
deleteVehicle _zombie;
