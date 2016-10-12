/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_sessionID","_params","_zombie"];
_sessionID = _this select 0;
_params = _this select 1;

_zombie = _params select 0;

if (isNull _zombie) exitWith {};
if (!(_zombie isKindOf "TornZ_Base")) exitWith {};

_zombie removeAllMPEventHandlers "MPKilled"; // No Loot
_zombie setDamage 1;
