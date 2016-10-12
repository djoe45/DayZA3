/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

if (ExilePlayerInSafezone) exitWith {};
if (!(local (vehicle player))) exitWith {false};
if (isObjectHidden (vehicle player)) exitWith {false};

private["_zombie","_attack","_allhitpointsdamage","_hitpoint","_hitpoints","_hitpoints_health","_index"];
_zombie = _this select 0;
_attack = _this select 1;
//if (_zombie distance player > 3.5) exitWith {};
doStop _zombie;
_zombie setDir (_zombie getRelDir player);
_zombie doWatch player;

_zombie remoteExecCall ["TornZ_fnc_re_z_attack", (crew (vehicle player))];
_zombie switchMove "AwopPercMstpSgthWnonDnon_throw";
playsound3d [format["TornZ\sounds\ryanzombiesattack%1.ogg",(ceil (random 5))], _zombie];

if (!_attack) exitWith {};
if (local (vehicle player)) then // Vehicle Player Local
{
	if ((damage vehicle player) < 0.7) then  // Prevent Zombies blowing up vehicles
	{
		// Vehicle is Local
		_allhitpointsdamage = getAllHitPointsDamage (vehicle player);
		if ((count (_allhitpointsdamage select 0)) > 0) then
		{
			_hitpoints = _allhitpointsdamage select 0;
			_hitpoints_health = _allhitpointsdamage select 2;
			_index = random ((count (_hitpoints)) - 1);
			_hitpoint = _hitpoints select _index;
			_health = _hitpoints_health select _index;
			if (_health < 0.7) then {  // Prevent Zombies blowing up vehicles
				(vehicle player) setHitPointDamage [_hitpoint, ((random .1) + _health)];
			};
		} else {
			// Vehicle has no Hitpoints
			(vehicle player) setDamage ((damage (vehicle player)) + random 0.05);
		};
	};
};

_zombie setDir (_zombie getRelDir player);

ExileClientPlayerIsInCombat = true;
ExileClientPlayerLastCombatAt = diag_tickTime;
true call ExileClient_gui_hud_toggleCombatIcon;
