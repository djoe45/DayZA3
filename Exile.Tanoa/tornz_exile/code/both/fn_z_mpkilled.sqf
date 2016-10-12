/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private ["_unit", "_killer", "_killerVeh", "_score"];

if (!isServer) exitWith {};

_unit = _this select 0;
_killer = _this select 1;
_playerObj = objNull;
_killerVeh = vehicle _killer;
_unit removeAllMPEventHandlers "MPKilled";
_ZombieRespect = getNumber (missionconfigFile >> "CfgTornZ_Exile" >> "ZombieRespect");
_roadKillBonus = getNumber (missionconfigFile >> "CfgTornZ_Exile" >> "RoadKillBonus");
_minDistance = getNumber (missionconfigFile >> "CfgTornZ_Exile" >> "MinDistance");
_respect = _playerObj getVariable ["ExileScore", 0];
_money = _playerObj getVariable ["ExileMoney", 0];
diag_log "kill zed";
if (isNull _killer) exitWith {};
if (!(isPlayer _killer)) exitWith {};

_killMsg = ["ZOMBIE WACKED","ZOMBIE CLIPPED","ZOMBIE DISABLED","ZOMBIE DISQUALIFIED","ZOMBIE WIPED","ZOMBIE WIPED","ZOMBIE ERASED","ZOMBIE LYNCHED","ZOMBIE WRECKED","ZOMBIE NEUTRALIZED","ZOMBIE SNUFFED","ZOMBIE WASTED","ZOMBIE ZAPPED"] call BIS_fnc_selectRandom;
_killMsgRoad = ["ZOMBIE ROADKILL","ZOMBIE SMASHED","ERMAHGERD ROADKILL"] call BIS_fnc_selectRandom;
_roadKilled    			= false;
_respectChange  		= 0;
_killerRespectPoints 	= [];
//Roadkill or not
if (isPlayer _killer) then
{
	_veh = vehicle _killer;
	_playerObj = _killer;
	if (!(_killer isKindOf "Exile_Unit_Player") && {!isNull (gunner _killer)}) then
	{
			_playerObj = gunner _killer;
	};

	if (!(_veh isEqualTo _killer) && {(driver _veh) isEqualTo _killer}) then
	{
			_playerObj = driver _veh;
			_roadKilled = true;
	};
};

if (!(_killerVeh isEqualTo _killer) && {(driver _killerVeh) isEqualTo _killer}) then
{
  playsound3d [format["tornz\sounds\ryanzombiesvehiclehit%1.ogg", (ceil (random 3))], _unit];
};

_unit setVariable ["ExileDiedAt",time];
if ((random 1) < TornZ_zombiesLootChance) exitWith {};

private["_holder","_zombieClassName","_lootTable","_itemClassName","_cargoType"];
_holder = createVehicle ["LootWeaponHolder", (getPosATL _unit), [], 0, "CAN_COLLIDE"];
_holder attachTo [_unit,[0,0,0]];

_zombieClassName = typeOf _unit;
_lootTable = switch true do
{
  case (_zombieClassName in TornZ_zombiesDoctor): {"zombies_doctor"};
  case (_zombieClassName in TornZ_zombiesPriest): {"zombies_priest"};
  case (_zombieClassName in TornZ_zombiesPolice): {"zombies_police"};
  case (_zombieClassName in TornZ_zombiesSoldier): {"zombies_soldier"};
  default {"zombies"};
};
_itemClassName = _lootTable call ExileServer_system_lootManager_dropItem;
_cargoType = _itemClassName call ExileClient_util_cargo_getType;
switch (_cargoType) do
{
  case 1:
  {
    if (_itemClassName isEqualTo "Exile_Item_MountainDupe") then
    {
      _holder addMagazineCargoGlobal [_itemClassName, 2];
    }
    else
    {
      _holder addMagazineCargoGlobal [_itemClassName, 1];
    };
  };
  case 3:
  {
    _holder addBackpackCargoGlobal [_itemClassName, 1];
  };
  case 2:
  {
    _holder addWeaponCargoGlobal [_itemClassName, 1];
    if (_itemClassName != "Exile_Melee_Axe") then
    {
      private["_magazineClassName","_magazineClassNames"];
      _magazineClassNames = getArray(configFile >> "CfgWeapons" >> _itemClassName >> "magazines");
      if (count(_magazineClassNames) > 0) then
      {
        _magazineClassName = selectRandom _magazineClassNames;
        _holder addMagazineCargoGlobal [_magazineClassName, ceil(random 2)];
      };
    };
  };
  default { _holder addItemCargoGlobal [_itemClassName,1]; };
};

if ((!isNull _playerObj) && {((getPlayerUID _playerObj) != "") && {_playerObj isKindOf "Exile_Unit_Player"}}) then
{
	//Default
	_killerRespectPoints pushBack [(format ["%1",_killMsg]), _zombieRespect];
	//RoadkillBonus
	if (_roadKilled) then
	{
		_killerRespectPoints pushBack [(format ["%1",_killMsgRoad]), _roadKillBonus];
	}
	else
	//DistanceBonus
	{
		_distance = _unit distance _playerObj;
		if (_distance > _minDistance) then
		{
			_distanceBonus = (floor (_distance / _distanceBonusDivider));
			_killerRespectPoints pushBack [(format ["%1m RANGE BONUS", (round _distance)]), _distanceBonus];			
		};
		if (_distance <= _cqbDistance) then
		{
			_distanceBonus = round((floor ((_cqbDistance + 1) - _distance)) * ( _cqbBonus /_cqbDistance));
			_killerRespectPoints pushBack [(format ["%1m CQB BONUS", (round _distance)]), _distanceBonus];
		};
	};
	
	// Calculate killer's respect and money
	{
		_respectChange = (_respectChange + (_x select 1));
	}
	forEach _killerRespectPoints;
	_respect = (_respect + _respectChange);


		[_playerObj, "showFragRequest", [_killerRespectPoints]] call ExileServer_system_network_send_to;
		_playerObj setVariable ["ExileScore", _respect];
		ExileClientPlayerScore = _respect;
		(owner _playerObj) publicVariableClient "ExileClientPlayerScore";
		ExileClientPlayerScore = nil;

		// Update client database entry
		format["setAccountMoneyAndRespect:%1:%2:%3", _money, _respect, (getPlayerUID _playerObj)] call ExileServer_system_database_query_fireAndForget;
};

