/**
 * TornZ_Exile
 * © 2015 Declan Ireland <http://github.com/torndeco>
 */

if (ExilePlayerInSafezone) exitWith {};
if (isObjectHidden (vehicle player)) exitWith {false};

private["_zombie","_attack"];
_zombie = _this select 0;
_attack = _this select 1;

doStop _zombie;

_zombie setDir (_zombie getRelDir player);
_zombie doWatch player;

if (_zombie distance player > 3.5) exitWith {};

_zombie remoteExecCall ["TornZ_fnc_re_z_attack", -2];
_zombie switchMove "AwopPercMstpSgthWnonDnon_throw";
playsound3d [format["tornz\sounds\ryanzombiesattack%1.ogg",(ceil (random 5))], _zombie];

if (!_attack) exitWith {};
// Player on Foot
if ((speed player) > 14) then {
	if ((random 1) > 0.4) then {
		player setdamage ((damage player) + random(0.1));
		playsound3d [format["tornz\sounds\ryanzombieseathit.wav"], _zombie];
		call TornZ_fnc_blurEffect;
	};
} else {
	player setdamage ((damage player) + 0.02 + random(0.05));
	playsound3d [format["tornz\sounds\ryanzombieseathit.wav"], _zombie];
	call TornZ_fnc_blurEffect;
};

_zombie setDir (_zombie getRelDir player);

ExileClientPlayerIsInCombat = true;
ExileClientPlayerLastCombatAt = diag_tickTime;
true call ExileClient_gui_hud_toggleCombatIcon;
