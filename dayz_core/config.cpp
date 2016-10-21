class CfgPatches {
	class dayz_core {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"A3_Characters_F", "A3_Weapons_F", "A3_Weapons_F_Acc", "A3_Structures_F"};
	};
};

class CfgFunctions {
	class dayz_core {
		class Bootstrap {
			file = "dayz_core\boot";

			class preInit {
				preInit = 1;
			};

			class postInit {
				postInit = 1;
			};
		};
	};
};

class CfgAISkill {
	aimingaccuracy[] = {0, 0, 1, 1};
	aimingshake[] = {0, 0, 1, 1};
	aimingspeed[] = {0, 0, 1, 1};
	commanding[] = {0, 0, 1, 1};
	courage[] = {0, 1, 1, 1};
	endurance[] = {0, 0, 1, 1};
	general[] = {0, 0, 1, 1};
	reloadspeed[] = {0, 0, 1, 1};
	spotdistance[] = {0, 0, 1, 0.6};
	spottime[] = {0, 0, 1, 1};
};
