/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */


// Create / Retreive Player Zombie Group
private["_zombieGroupVarName","_zombieGroup"];
_zombieGroupVarName = format["TornZ_zombieGroup_%1", owner _player];
if (isNil _zombieGroupVarName) then {
  _zombieGroup = createGroup east;
  missionNamespace setVariable [_zombieGroupVarName, _zombieGroup];
};
_zombieGroup = missionNamespace getVariable _zombieGroupVarName;
_zombieGroup
