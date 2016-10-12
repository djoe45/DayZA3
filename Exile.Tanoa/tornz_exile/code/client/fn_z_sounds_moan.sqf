/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_zombie","_rnd"];
_zombie = _this;
_rnd = (ceil (random 4));
if (_rnd > 2) exitWith {}; // 50% Chance, no point generating 2 random numbers
if ((time - (_zombie getVariable ["TornZ_L_SoundsMoanTimeStamp", -100])) >=25) then
{
  playsound3d [format["TornZ\sounds\RyanZombiesMoan%1.ogg", _rnd],_zombie];
  _zombie setVariable ["TornZ_L_MoanTimeStamp", (time + _rnd)];
};
