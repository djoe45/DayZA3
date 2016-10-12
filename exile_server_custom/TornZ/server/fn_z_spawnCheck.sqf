/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_player","_zombiesNearbyCount","_zombiesToSpawn","_playerPos"];

_player = _this;


if ((random 1) < TornZ_zombiesSpawnChance) then
{
	if (!(alive _player)) exitWith {};
	if (!(isObjectHidden (vehicle _player))) then
	{
		_zombiesNearbyCount = _player getVariable ["TornZ_C_ZombiesNearbyCount",-1];
		if (_zombiesNearbyCount < TornZ_zombiesMaxLocal) then
		{
			if (_zombiesNearbyCount < TornZ_zombiesMaxTotal) then
			{
				_playerPos  = getPosATL _player;
				if (!(_playerPos call ExileClient_util_world_isInTraderZone)) then
				{
					_zombiesToSpawn = round ( (TornZ_zombiesMaxTotal - _zombiesNearbyCount) min (3 + (random 3)) );
					_zombiesToSpawn = _zombiesToSpawn min (TornZ_zombiesMaxLocal - _zombiesNearbyCount);
					[_player, _playerPos, _zombiesToSpawn, TornZ_zombiesDistance, TornZ_zombiesTypes, TornZ_zombiesSpawnOutsideChance] call TornZ_fnc_z_spawn;
				};
			};
		};
	};
};
