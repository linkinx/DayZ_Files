private["_itemType","_iPos","_indexLootSpawn","_iArray","_iItem","_iClass","_item","_qty","_max","_tQty","_arrayLootSpawn","_canType","_holderItem"];
// [_itemType,_weights]
_iItem =        _this select 0;
_iClass =       _this select 1;
_iPos =         _this select 2;
_radius =       _this select 3;
_holderItem = _iItem;
switch (_iItem) do {
        case "M4A1_HWS_GL_camo": { _holderItem = "BAF_L85A2_RIS_Holo"};
        case "BAF_AS50_scoped": { _holderItem = "M4SPR"};
  	case "SVD_CAMO": { _holderItem = "BAF_LRR_scoped_W"};
        case "M107_DZ": { _holderItem = "DMR"};
		case "AKS_74_U": { _holderItem = "huntingrifle"};
		case "DMR": { _holderItem = "SVD"};
		case "M1014": { _holderItem= "Saiga12K"};
		case "Mk_48_DZ": { _holderItem= "RPK_74"};
		case "Crossbow": { _holderItem= "Sa61_EP1"};
        case "M16A2": { _holderItem = "G36c"};
		case "M4A1_AIM_SD_camo": { _holderItem = "G36_C_SD_eotech"};
		case "FN_FAL_ANPVS4": { _holderItem = "AK_107_pso"};
        case "M1014": { _holderItem = "M16A2"};
		case "MP5SD": { _holderItem = "AKS_74_UN_kobra"};
		case "M4A1_Aim": { _holderItem= "AK_107_kobra"};
        case "MR43": { _holderItem = "AK_74"};
        case "10Rnd_127x99_m107": { _holderItem = "5Rnd_86x70_L115A1"};
		case "ItemFlashlightRed": { _holderItem = "DZ_Assault_Pack_EP1"};
        case "WeaponHolder_MeleeCrowbar": { _holderItem = "DZ_Patrol_Pack_EP1"};
		case "ItemWire": { _holderItem = "ItemSandbag"};
		case "8Rnd_B_Beneli_74Slug": { _holderItem = "8Rnd_B_Saiga12_74Slug"};
		case "30Rnd_556x45_G36": { _holderItem = "75Rnd_545x39_RPK"};
		case "BoltSteel": { _holderItem = "20Rnd_B_765x17_Ball"};
		case "30rnd_9x19_MP5SD": { _holderItem = "30Rnd_545x39_AKSD"};
        case "2Rnd_shotgun_74Slug": { _holderItem = "8Rnd_B_Beneli_74Slug"};
        case "2Rnd_shotgun_74Pellets": { _holderItem = "8Rnd_B_Beneli_Pellets"};
        default {};
        };
_iItem = _holderItem;
switch (_iClass) do {
        default {
                //Item is food, add random quantity of cans along with an item (if exists)
                _item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
                _arrayLootSpawn = [] + getArray (configFile >> "cfgLoot" >> _iClass);
                _itemType = _arrayLootSpawn select 0;
                _weights = _arrayLootSpawn call fnc_buildWeightedArray;
                _qty = 0;
                _max = ceil(random 4) + 1;
                //diag_log ("LOOTSPAWN: QTY: " + str(_max) + " ARRAY: " + str(_arrayLootSpawn));
                while {_qty < _max} do {
                        private["_tQty","_indexLootSpawn","_canType"];
                        _tQty = floor(random 3) + 1;
                        //diag_log ("LOOTSPAWN: ITEM QTY: " + str(_tQty));
                        
                        _indexLootSpawn = _weights call BIS_fnc_selectRandom;
                        _canType = _itemType select _indexLootSpawn;
                        
                        _holderItem = _canType;
                        switch (_canType) do {
                                case "10Rnd_127x99_m107": { _holderItem = "5Rnd_86x70_L115A1"};
								case "30Rnd_556x45_G36": { _holderItem = "75Rnd_545x39_RPK"};
								case "BoltSteel": { _holderItem = "20Rnd_B_765x17_Ball"};
								case "8Rnd_B_Beneli_74Slug": { _holderItem = "8Rnd_B_Saiga12_74Slug"};
                                case "2Rnd_shotgun_74Slug": { _holderItem = "8Rnd_B_Beneli_74Slug"};
								case "30rnd_9x19_MP5SD": { _holderItem = "30Rnd_545x39_AKSD"};
                                case "2Rnd_shotgun_74Pellets": { _holderItem = "8Rnd_B_Beneli_Pellets"};
                                default {};
                                };
                        _canType = _holderItem;
                        
                        //diag_log ("LOOTSPAWN: ITEM: " + str(_canType));
                        _item addMagazineCargoGlobal [_canType,_tQty];
                        _qty = _qty + _tQty;
                };
                if (_iItem != "") then {
                        _item addWeaponCargoGlobal [_iItem,1];
                };
        };
        case "weapon": {
                //Item is a weapon, add it and a random quantity of magazines
                _item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
                _item addWeaponCargoGlobal [_iItem,1];
                _mags = [] + getArray (configFile >> "cfgWeapons" >> _iItem >> "magazines");
                if (count _mags > 0) then {
                        _item addMagazineCargoGlobal [(_mags select 0),(round(random 4))];
                };
        };
        case "magazine": {
                //Item is one magazine
                _item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
                _item addMagazineCargoGlobal [_iItem,1];
        };
        case "object": {
                //Item is one magazine
                _item = createVehicle [_iItem, _iPos, [], _radius, "CAN_COLLIDE"];
        };
};
if (count _iPos > 2) then {
        _item setPosATL _ipos;
};
