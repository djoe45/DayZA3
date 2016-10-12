/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

if (!isServer) exitWith {};
private["_zombie"];
_zombie = _this select 0;
if (_zombie isKindOf "TornZ_Legacy_Base") then
{
  _zombie setface (selectRandom TornZ_Legacy_Faces);
  _zombie setMimic "dead";
} else {
  _zombie setface (selectRandom TornZ_RyanZombies_Faces);
  _zombie setMimic "safe";
};
_zombie setBehaviour "CARELESS";
_zombie setCombatMode "RED";

_zombie disableAI "AIMINGERROR";
_zombie disableAI "SUPPRESSION";
_zombie disableAI "FSM";
_zombie disableAI "AUTOTARGET";
_zombie disableAI "TARGET";
_zombie setDamage 0.7;
_zombie setspeaker "NoVoice";
