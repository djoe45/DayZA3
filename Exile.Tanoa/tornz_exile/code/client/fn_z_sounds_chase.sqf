/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_zombie"];
_zombie = _this;
if ((time - (_zombie getVariable ["TornZ_L_SoundsChaseTimeStamp",-100])) >=25) then
{
  if ((typeOf _zombie) in TornZ_zombiesTypes_Crawler) then
  {
    playsound3d [format["tornz\sounds\ryanzombiesaggressivespider%1.ogg", (ceil (random 32))],_zombie];
  } else {
    playsound3d [format["tornz\sounds\ryanzombiesaggressive%1.ogg", (ceil (random 66))],_zombie];
  };
  _zombie setVariable ["TornZ_L_SoundsChaseTimeStamp",time];
};
