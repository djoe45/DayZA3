/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

private["_unit","_attacker","_distance","_weapon","_muzzle","_mode","_ammo","_targets","_firednear_targets","_audibleFire","_caliber","_distanceSound"];

_unit = _this select 0;  // zombie
_attacker = _this select 1; // player
_distance = _this select 2;
_weapon = _this select 3;
_muzzle = _this select 4;
_mode = _this select 5;
_ammo = _this select 6;

_targets = _unit getVariable ["TornZ_C_Targets", []];
if (_attacker in _targets) exitWith {};

_firednear_targets = _unit getVariable ["TornZ_L_FiredNearTargets",[]];
if (_attacker in _firednear_targets) exitWith {};

if (isObjectHidden (vehicle player)) exitWith {};
if (!(alive _unit)) exitWith {};
if (!(isPlayer _attacker)) exitWith {};
if (_weapon isEqualTo "Throw") exitWith {};


_audibleFire = getNumber (configFile >> "CfgAmmo" >> _ammo >> "audibleFire");
_caliber = getNumber (configFile >> "CfgAmmo" >> _ammo >> "caliber");
_distanceSound = round(_audibleFire * _caliber * 7.5);

switch  (_weapon) do
{
	case (primaryWeapon _unit):
	{
		if ((primaryWeaponItems _unit) select 0) then
		{
			_distanceSound = _distanceSound / 2;
		};
	};
	case (handgunWeapon _unit):
	{
		if ((handgunItems _unit) select 0) then
		{
			_distanceSound = _distanceSound / 2;
		};
	};
	case (secondaryWeapon _unit):
	{
		if ((secondaryWeaponItems _unit) select 0) then
		{
			_distanceSound = _distanceSound / 2;
		};
	};
};
if (_distance > _distanceSound) exitWith {};

_firednear_targets pushBack _attacker;
_unit setVariable ["TornZ_L_FiredNearTargets", _firednear_targets];
