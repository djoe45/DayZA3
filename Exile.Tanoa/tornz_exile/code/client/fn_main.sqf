/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

if (!isNil "TornZ_playerLoop") exitWith {};
TornZ_playerLoop = true;
TornZ_playerInBuilding = false;

private ["_zombiesTypes","_zombiesDistanceLosInital","_zombiesDistanceLosMax","_zombiesDistanceEngineOff","_zombiesMaxLocal","_zombiesMaxLocalOverFlow","_fovCheck","_distance","_zombies","_targets","_rndIndex","_fov","_localZombies","_owner"];
_zombiesTypes = +TornZ_zombiesTypes;
_zombiesDistanceLosInital = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_distanceLosInital");
_zombiesDistanceLosMax = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_distanceLosMax");
_zombiesDistanceEngineOff = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_distanceLosInital_EngineOff");

_zombiesMaxLocal = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_maxLocal");
_zombiesMaxLocalOverFlow = getNumber ((if (isClass (missionConfigFile >> "CfgTornZ_Exile")) then {missionConfigFile >> "CfgTornZ_Exile"} else {configFile >> "CfgTornZ_Exile"}) >> "zombies_maxLocalOverFlow");


while {true} do
{
	_localZombies = player getVariable ["TornZ_C_ZombiesLocal", []];
	if (!((typeName _localZombies) isEqualTo "ARRAY")) then
	{
		_localZombies = [];
	};
	if ((count _localZombies) > _zombiesMaxLocalOverFlow) then {
		// Kill a Random Zombie
		_localZombies = _localZombies - [objNull];
		_rndIndex = random ((count _localZombies) - 1);
		_zombie = _localZombies select _rndIndex;
		_localZombies deleteAt _rndIndex;
		player setVariable ["TornZ_C_ZombiesLocal",_localZombies,true];
		[_zombie] call TornZ_fnc_z_kill;
	};


	if (alive player) then
	{
		_fovCheck = false;
		_distance = _zombiesDistanceLosInital;
		_zombies = (getPOSATL player) nearEntities [_zombiesTypes,_distance];
		_zombiesCount = count _zombies;
		if ((player getVariable["TornZ_C_ZombiesNearbyCount",-1]) != _zombiesCount) then
		{
			player setVariable ["TornZ_C_ZombiesNearbyCount", _zombiesCount, true];
		};

		if (!((vehicle player) isEqualTo player)) then
		{
			if (isEngineOn (vehicle player)) then
			{
				_distance = _zombiesDistanceEngineOff;
			} else {
				_distance = _zombiesDistanceLosMax;
			};
		} else {
			// Players will expect going crouch / prone to help them sneak past zombies damn DayZ
			_fovCheck = true;
			_player_velocity = velocity player;
			_player_velocity = (abs (_player_velocity select 0)) + (abs (_player_velocity select 1)) + (abs (_player_velocity select 2));
			switch (stance player) do
			{
				case "PRONE":
				{
					_distance = 20 + (10 * _player_velocity);
				};
				case "CROUCH":
				{
					_distance = (_distance * 0.75) + (10 * _player_velocity);
				};
				default
				{
					_distance = _distance + (10 * _player_velocity);
				};
			};
		};
		TornZ_playerInBuilding = player call TornZ_fnc_inBuilding; // Used in zombies FSM

		{
			// Zombie LOS Checks + Sounds
			if ((_x distance player) <= _distance) then
			{
				_targets = _x getVariable ["TornZ_C_Targets", []];
				if (!((typeName _targets) isEqualTo "ARRAY")) then   // Error Checking incase Hacker messes with Zombie Variables
				{
					_targets = [];
				};
				if (!(player in _targets)) then
				{
					_fov = if (_fovCheck) then {_x call TornZ_fnc_isVisibleFOV} else {true};
					if (_fov) then
					{
						if (_x call TornZ_fnc_isVisible) then
						{
							_targets pushBack player;
							_x setVariable ["TornZ_C_Targets", _targets,true];
						};
					};
				};
			};
			uisleep 0.01;
		} forEach _zombies;
	};
	sleep 2;
};
