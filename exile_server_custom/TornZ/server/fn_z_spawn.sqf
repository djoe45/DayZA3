/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_player","_playerPos","_zombiesToSpawn","_zombiesSpawnDist","_zombiesTypes","_zombiesSpawnOutsideChance","_pos","_zombies","_zombieGroupVarName","_zombieGroup","_spawnOutSide"];

_player = _this select 0;
_playerPos = _this select 1;

_zombiesToSpawn = _this select 2;
_zombiesSpawnDist = _this select 3;
_zombiesTypes = _this select 4;
_zombiesSpawnOutsideChance = _this select 5;

_pos = [];
_zombies = [];


try
{
	// Create / Retreive Player Zombie Group
	_zombieGroupVarName = format["TornZ_zombieGroup_%1", (owner _player)];
	if (isNil _zombieGroupVarName) then {
		_zombieGroup = createGroup east;
		missionNamespace setVariable [_zombieGroupVarName, _zombieGroup];
	};
	_zombieGroup = missionNamespace getVariable format["TornZ_zombieGroup_%1", (owner _player)];
	if (isNull _zombieGroup) then
	{
		_zombieGroup = createGroup east;
		missionNamespace setVariable [_zombieGroupVarName, _zombieGroup];
		if (isNull _zombieGroup) then
		{
			missionNamespace setVariable [_zombieGroupVarName, nil];
			throw "Error Creating / Retreiving Player Zombie Group";
		};
	};

	// Spawn Zombies
	_spawnOutSide = true;
	if ((random 1) > _zombiesSpawnOutsideChance) then {
		_spawnOutSide = false;
	} else {
		_zombiesToSpawn = round (_zombiesToSpawn/2); // Reduce Number of Zombies Spawning in the Open
	};
	if (!_spawnOutSide) then {
		private ["_buildings", "_buildingsCount","_building","_buildingType","_buildingPositions"];

		// Spawn Zombies in Building
		_buildings = nearestObjects [_playerPos, ["House","Wreck_Base"], _zombiesSpawnDist];
		_buildingsCount = count _buildings;
		if (_buildingsCount > 0) then {
			_building = selectRandom _buildings;
			if !(_building getVariable ["ExileLootDisabled", false]) then
			{
				if ((diag_tickTime - (_building getVariable ["TornZ_S_zombieSpawnTimestamp", -300])) > 300) then {
					if (!([(getPOSATL _building), 5] call TornZ_fnc_isPlayerInRange)) then {
						// Spawn Zombies in Building Position
						_building setVariable ["TornZ_S_zombieSpawnTimestamp", diag_tickTime];
						_pos = _building buildingPos 0;
						if ((_pos select 0) == 0) then
						{
							_buildingType = typeOf _building;
							if (isClass(configFile >> "CfgBuildings" >> _buildingType)) then
							{
								_buildingPositions = getArray (configFile >> "CfgBuildings" >> _buildingType >> "positions");
								if ((count _buildingPositions) > 0) then {
									_pos = ASLToATL (AGLToASL (_building modelToWorld (_buildingPositions select 0)));
									for "_i" from 1 to _zombiesToSpawn do
									{
										_zombie = _zombieGroup createUnit [(selectRandom _zombiesTypes), _pos, [], 3, "NONE"];
										_zombie hideObjectGlobal true;
										_zombie addMPEventHandler ["MPKilled", {_this call TornZ_fnc_z_mpkilled;}];
										_zombies pushBack _zombie;
									};
								};
							} else {
								_pos = (getPosATL _building) findEmptyPosition [10, 50, (_zombiesTypes select 0)];
								if (!(_pos isEqualTo [])) then {
									for "_i" from 1 to _zombiesToSpawn do
									{
										_zombie = _zombieGroup createUnit [(selectRandom _zombiesTypes), _pos, [], 3, "NONE"];
										_zombie hideObjectGlobal true;
										_zombie addMPEventHandler ["MPKilled", {_this call TornZ_fnc_z_mpkilled;}];
										_zombies pushBack _zombie;
									};
								};
							};
						} else {
							for "_i" from 1 to _zombiesToSpawn do
							{
								_zombie = _zombieGroup createUnit [(selectRandom _zombiesTypes), _pos, [], 3, "NONE"];
								_zombie hideObjectGlobal true;
								_zombie addMPEventHandler ["MPKilled", {_this call TornZ_fnc_z_mpkilled;}];
								_zombies pushBack _zombie;
							};
						};
					};
				};
			};
		};
	};


	if (_spawnOutSide) then {
		// Spawn Zombies in the Open
		if ((diag_ticktime - (_player getVariable ["TornZ_S_PlayerSpawnTimestamp",0])) > 300) then {
			private["_zombiesSpawnDistX2","_zombiesSpawnDistX4","_zombie_pos"];

			_player setVariable ["TornZ_S_PlayerSpawnTimestamp",diag_ticktime];

			_zombiesSpawnDistX2 = _zombiesSpawnDist *2;
			_zombiesSpawnDistX4 = _zombiesSpawnDist *4;
			_pos = _playerPos;
			_pos set [0,((_pos select 0) + (_zombiesSpawnDistX2 - (random _zombiesSpawnDistX4)))];
			_pos set [1,((_pos select 1) + (_zombiesSpawnDistX2 - (random _zombiesSpawnDistX4)))];

			if (!(surfaceIsWater _pos)) then {
				if (!([_pos, 50] call TornZ_fnc_isPlayerInRange)) then {
					// Check if Flag to Close
					_radius = getArray(missionConfigFile >> "CfgTerritories" >> "prices");
					_radius = (_radius select ((count _radius) -1)) select 1;

					_flagToClose = false;
					_flags = _pos nearObjects ["Exile_Construction_Flag_Static", _radius];
					{
						_flagRadius = (_x getVariable ["ExileTerritorySize",1]) * 2;
						if ((_pos distance2D _x) < _flagRadius) exitWith {_flagToClose = true;};
					} forEach _flags;

					if (!_flagToClose) then {
						// Spawn Zombies
						for "_i" from 0 to _zombiesToSpawn do
						{
							_zombie_pos = _pos findEmptyPosition [0, 50, (_zombiesTypes select 0)];
							if (!(_zombie_pos isEqualTo [])) then {
								_zombie = _zombieGroup createUnit [(selectRandom _zombiesTypes), _zombie_pos, [], 3, "NONE"];
								_zombie hideObjectGlobal true;
								_zombie addMPEventHandler ["MPKilled", {_this call TornZ_fnc_z_mpkilled;}];
								_zombies pushBack _zombie;
							};
						};
					};
				};
			};
		};
	};

	if (isNull _zombieGroup) throw "Error Zombie Group Null, Caused by a Race Condition";

	if (!(_zombies isEqualTo [])) then
	{
		//diag_log format["DEBUG: _zombies: %1, _diag_tickTime: %2", _zombies, diag_tickTime];
		{
			waitUntil {(!(isNull _x))}; // Not exactly ideal, debug statements left in to check if has effect on busy server.
		} forEach _zombies;
		//diag_log format["DEBUG: _zombies: %1, _diag_tickTime: %2", _zombies, diag_tickTime];

		// Transfer Zombies
		if (_zombieGroup setGroupOwner (owner _player)) then {
			_zombies remoteExecCall ["TornZ_fnc_re_z_initAll", -2];
			{
				_x addEventHandler ["local", {_this call TornZ_fnc_z_locality;}];
				_x hideObjectGlobal false;
			} forEach _zombies;
			[_player, "z_init", [_pos, _zombies]] call ExileServer_system_network_send_to;
		} else {
			TornZ_transferQueue pushBack [_player, _zombies];
		};
	};
}
catch
{
	diag_log format["TornZ_fnc_z_spawn: _exception: %1", _exception];
};
