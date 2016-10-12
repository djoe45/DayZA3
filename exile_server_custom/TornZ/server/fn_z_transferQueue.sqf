/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_deleteAt","_deleteVehicle","_zombie","_player","_zombieGroupVarName","_zombieGroup","_newOwner","_currentOwner"];
if (TornZ_transferQueue isEqualTo []) exitWith {true};

{
	_deleteAt = false;
	_deleteVehicle = false;

	_player = _x select 0;
	_newOwner = owner _player;
	_zombies = _x select 1;
	if ((isNil "_player") || (isNil "_zombies") ) then
	{
		_deleteAt = true;
		if (!(isNil "_zombies")) then
		{
			_deleteVehicle = true;
		};
	} else {
		if ((isNull _player) || (!(isPlayer _player))) then
		{
			_deleteAt = true;
			_deleteVehicle = true;
		} else {

			try
			{
				// Create / Retreive Player Zombie Group
				_zombieGroupVarName = format["TornZ_zombieGroup_%1", (owner _player)];
				_zombieGroup = missionNamespace getVariable [_zombieGroupVarName, objNull];
				if (isNull _zombieGroup) then
				{
					_zombieGroup = createGroup east;
					if (isNull _zombieGroup) then
					{
						missionNamespace setVariable [_zombieGroupVarName, nil];
						throw "Error Creating / Retreiving Player Zombie Group";
					};
					missionNamespace setVariable [_zombieGroupVarName, _zombieGroup];
				};

				// Transfer Zombies
				_status = true;
				{
					if ((owner _x) != _newOwner) exitWith
					{
						_status = _zombieGroup setGroupOwner _newOwner;
					};
				} forEach _zombies;

				if (_status) then
				{
					[_player, "z_init", [(getPOSATL player), _zombies]] call ExileServer_system_network_send_to;
					if ((count _zombies) > 1) then
					{
						_zombies remoteExecCall ["TornZ_fnc_re_z_initAll", -2];
						{
							_x hideObjectGlobal false;
						} forEach _zombies;
					};
					_deleteAt = true;
				} else {
					diag_log format["TornZ: Transfer Queue: Create Group: Error: %1", _zombies];
				};
			}
			catch
			{
				diag_log format["TornZ: Transfer Queue: ERROR _exception: %1", _exception];
			};
		};
	};

	if (_deleteAt) then
	{
		if (_deleteVehicle) then
		{
			{
				deleteVehicle _x;
			} forEach _zombies;
		};
		TornZ_transferQueue set [_forEachIndex, objNull];
	};
} forEach TornZ_transferQueue;
TornZ_transferQueue = TornZ_transferQueue - [objNull];
true
