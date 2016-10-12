private ["_crashModel","_lootTable","_guaranteedLoot","_randomizedLoot","_frequency","_variance","_spawnChance","_spawnMarker","_spawnRadius","_spawnFire","_timeAdjust","_timeToSpawn","_crashName","_position","_crash","_clutter","_config","_newHeight","_itemTypes","_index","_weights","_cntWeights","_itemType","_nearby","_nearBy"];

//_crashModel	= _this select 0;
//_lootTable	= _this select 1;
_guaranteedLoot = _this select 0;
_randomizedLoot = _this select 1;
_frequency	= _this select 2;
_variance	= _this select 3;
_spawnChance	= _this select 4;
_spawnMarker	= _this select 5;
_spawnRadius	= _this select 6;
_spawnFire	= _this select 7;

diag_log("CRASHSPAWNER: Starting spawn logic for Crash Spawner");

while {(server_totalCrashes <= 18)} do {
	private["_timeAdjust","_timeToSpawn","_spawnRoll","_crash","_hasAdjustment","_newHeight","_adjustedPos"];
	// Allows the variance to act as +/- from the spawn frequency timer
	_timeToSpawn = 30;
	//_timeAdjust = round(random(_variance * 2) - _variance);
	//_timeToSpawn = time + _frequency + _timeAdjust;
	
	//Selecting random crash type
	_crashModel = ["Land_Wreck_Heli_Attack_01_F","Land_Wreck_Heli_Attack_02_F"] call BIS_fnc_selectRandom;

	_lootTable = "HeliCrash";
	
	_crashName	= getText (configFile >> "CfgVehicles" >> _crashModel >> "displayName");

	diag_log(format["CRASHSPAWNER: %1%2 chance to spawn '%3' with loot table '%4' at %5", round(_spawnChance * 100), '%', _crashName, _lootTable, _timeToSpawn]);
	
	// Apprehensive about using one giant long sleep here given server time variances over the life of the server daemon
	while {time < _timeToSpawn} do {
		sleep 10;
	};

	// Percentage roll
	if (random 1 <= _spawnChance) then {
		_position = [getMarkerPos _spawnMarker,0,_spawnRadius,10,0,2000,0] call BIS_fnc_findSafePos;
		diag_log(format["CRASHSPAWNER: Spawning '%1' with loot table '%2' NOW! (%3) at: %4 - (%5)", _crashName, _lootTable, time, str(_position),mapGridPosition _position]);

		_crash = createVehicle [_crashModel,_position, [], 0, "CAN_COLLIDE"];
        server_totalCrashes = server_totalCrashes + 10;
		
		// Randomize the direction the wreck is facing
		_crash setDir round(random 360);

		// Using "custom" wrecks (using the destruction model of a vehicle vs. a prepared wreck model) will result
		// in the model spawning halfway in the ground.  To combat this, an OPTIONAL configuration can be tied to
		// the CfgVehicles class you've created for the custom wreck to define how high above the ground it should
		// spawn.  This is optional.
		_config = configFile >> "CfgVehicles" >> _crashModel >> "heightAdjustment";
		_newHeight = 0;
		if ( isNumber(_config)) then {
			_newHeight = getNumber(_config);
		};
		
		//essai marker
		Crash_Cords = _position;
		currentAO = createMarker["Crash_Zone", Crash_Cords];
		"Crash_Zone" setMarkerShape "ELLIPSE";
		"Crash_Zone" setMarkerSize[200, 200];
		"Crash_Zone" setMarkerColor "ColorBlue";
		"Crash_Zone" setMarkerBrush "DIAGGRID";
		"Crash_Zone" setMarkerAlpha 1;
		currentAO2 = createMarker["Crash_Zone1", Crash_Cords];
		"Crash_Zone1" setMarkerType "mil_dot";
		"Crash_Zone1" setMarkerText "Crash Helico";
		_crash_text = "<t align='center' size='2.0'>Crash Helico</t><br/>
		Un crash d'hélico vient d'avoir lieu<br/>
		explorer la zone!";
		GlobalHint = _crash_text;
		publicVariable "GlobalHint";
		
		// Must setPos after a setDir otherwise the wreck won't level itself with the terrain
		_crash setPos  [(_position select 0), (_position select 1), _newHeight];

	        _itemTypes = [
			/*Drink and Food - 10*/
			["ItemSodaRbull","vest"],["ItemSodaOrangeSherbet","vest"],["FoodWalkNSons","vest"],["WhiskeyNoodle","vest"],["water_epoch","vest"],["sardines_epoch","vest"],["meatballs_epoch","vest"],["scam_epoch","vest"],["sweetcorn_epoch","vest"],["honey_epoch","vest"],
			/*Fish and Carcass - 8*/
			["ItemTrout","vest"],["ItemSeaBass","vest"],["ItemTuna","vest"],["SnakeCarcass_EPOCH","vest"],["RabbitCarcass_EPOCH","vest"],["ChickenCarcass_EPOCH","vest"],["GoatCarcass_EPOCH","vest"],["SheepCarcass_EPOCH","vest"],
			/*Meat - 5*/
			["FoodBioMeat","vest"],["FoodMeeps","vest"],["FoodSnooter","vest"],["Pelt_EPOCH","vest"],["Venom_EPOCH","vest"],
			/*Cooked - 8*/
			["ItemTroutCooked","vest"],["ItemSeaBassCooked","vest"],["ItemTunaCooked","vest"],["SnakeMeat_EPOCH","vest"],["CookedRabbit_EPOCH","vest"],["CookedChicken_EPOCH","vest"],["CookedGoat_EPOCH","vest"],["CookedSheep_EPOCH","vest"],
			/*Stone - 16*/
			["ItemTopaz","vest"],["ItemOnyx","vest"],["ItemSapphire","vest"],["ItemAmethyst","vest"],["ItemEmerald","vest"],["ItemCitrine","vest"],["ItemRuby","vest"],["ItemQuartz","vest"],["ItemJade","vest"],["ItemGarnet","vest"],["ItemSilverBar","vest"],["ItemGoldBar","vest"],["ItemGoldBar10oz","vest"],["PartOre","vest"],["PartOreSilver","vest"],["PartOreGold","vest"],
			/*Multi Gun - 6*/
			["MultiGun","weapon"],["Heal_EPOCH","vest"],["Defib_EPOCH","vest"],["Repair_EPOCH","vest"],["EnergyPack","vest"],["EnergyPackLg","vest"],
			/*Repair and Heal - 6*/
			["FAK","vest"],["VehicleRepair","vest"],["VehicleRepairLg","vest"],["Towelette","vest"],["HeatPack","vest"],["ColdPack","vest"],
			/*Items - 16*/
			["Exile_Item_Laptop","vest"],["Exile_Item_BaseCameraKit","vest"],["Exile_Item_MetalHedgehogKit","vest"],["Exile_Headgear_GasMask","vest"],["Exile_Item_Cement","vest"],["Exile_Item_Sand","vest"],["Exile_Item_DuctTape","vest"],["Exile_Item_Rope","vest"],["Exile_Item_ExtensionCord","vest"],["Exile_Item_JunkMetal","vest"],["Exile_Item_LightBulb","vest"],["Exile_Item_MetalBoard","vest"],["Exile_Item_MetalPole","vest"],["Exile_Item_SafeKit","vest"],["Exile_Item_CodeLock","vest"],["Exile_Item_CanOpener","vest"],
			/*Weapon - 2*/
			["LMG_Mk200_F","weapon"],["srifle_DMR_06_camo_F","weapon"]];
			
			_itemChance = [
			/*Drink and Food - 10*/
			0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,
			/*Fish and Carcass - 8*/
			0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,
			/*Meat - 5*/
			0.2,0.2,0.2,0.2,0.2,
			/*Cooked - 8*/
			0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,
			/*Stone - 16*/
			0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,
			/*Multi Gun - 6*/
			0.03,0.05,0.05,0.05,0.05,0.05,
			/*Repair and Heal - 6*/
			0.2,0.2,0.2,0.2,0.2,0.2,
			/*Items - 16*/
			0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,
			/*Weapon - 2*/
			0.1,0.1];
	        _weights = [];
	        _weights = [_itemTypes,_itemChance] call fnc_buildWeightedArray;
	        _cntWeights = count _weights;
	        _index = _weights call BIS_fnc_selectRandom;

		for "_x" from 1 to (round(random _randomizedLoot) + _guaranteedLoot) do {
			//create loot
			_index = floor(random _cntWeights);
			_index = _weights select _index;
			_itemType = _itemTypes select _index;
			[_itemType select 0, _itemType select 1, _position, (sizeOf(_crashModel))/2] call spawn_loot;

			diag_log(format["CRASHSPAWNER: Loot spawn at '%1' dropped item is '%2'", _crashName, str(_itemType)]); 

			// ReammoBox is preferred parent class here, as groundweaponHolder wouldn't match MedBox0 and other such items.
			_nearby = _position nearObjects ["ReammoBox_F", sizeOf(_crashModel)];
			{
				_x setVariable ["permaLoot",true];
			} forEach _nearBy;
		};

	} else {
		diag_log(format["CRASHSPAWNER: %1%2 chance to spawn '%3' with loot table '%4' at %5 FAILED (chance)", round(_spawnChance * 100), '%', _crashName, _lootTable, _timeToSpawn]);	
	};
};