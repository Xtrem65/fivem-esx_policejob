Config              = {}
Config.DrawDistance = 100.0

Config.Zones = {

	CloakRoom = {
		Pos   = {x = 452.60083007813, y = -993.30603027344, z = 29.75},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1
	},

	Armory = {
		Pos   = {x = 451.69906616211, y = -980.35217285156, z = 29.68959236145},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1
	},

	HelicopterLandingPad1 = {
		Pos   = {x = 450.04470825195, y = -981.14404296875, z = 43.691673278809},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	HelicopterLandingPadSpawner1 = {
		Pos   = {x = 465.86563110352, y = -983.94213867188, z = 43.691806793213},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	VehicleSpawner = {
		Pos   = {x = 454.69107055664, y = -1017.4814453125, z = 27.430767059326},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1
	},

	VehicleSpawnPoint = {
		Pos   = {x = 438.42617797852, y = -1018.3353881836, z = 27.757459640503},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	VehicleDeleter1 = {
		Pos   = {x = 462.74353027344, y = -1014.4481811523, z = 28.065481185913},
		Size  = {x = 3, y = 3, z = 3.0},
		Type  = -1
	},

	VehicleDeleter2 = {
		Pos   = {x = 462.40914916992, y = -1019.7089233398, z = 28.104162216187},
		Size  = {x = 3, y = 3, z = 3.0},
		Type  = -1
	}

}

Config.Weapons = {

	{name = 'WEAPON_UNARMED'},
	{name = 'WEAPON_ANIMAL'},
	{name = 'WEAPON_COUGAR'},
	{name = 'WEAPON_KNIFE'},
	{name = 'WEAPON_NIGHTSTICK'},
	{name = 'WEAPON_HAMMER'},
	{name = 'WEAPON_BAT'},
	{name = 'WEAPON_GOLFCLUB'},
	{name = 'WEAPON_CROWBAR'},
	{name = 'WEAPON_PISTOL'},
	{name = 'WEAPON_COMBATPISTOL'},
	{name = 'WEAPON_APPISTOL'},
	{name = 'WEAPON_PISTOL50'},
	{name = 'WEAPON_MICROSMG'},
	{name = 'WEAPON_SMG'},
	{name = 'WEAPON_ASSAULTSMG'},
	{name = 'WEAPON_ASSAULTRIFLE'},
	{name = 'WEAPON_CARBINERIFLE'},
	{name = 'WEAPON_ADVANCEDRIFLE'},
	{name = 'WEAPON_MG'},
	{name = 'WEAPON_COMBATMG'},
	{name = 'WEAPON_PUMPSHOTGUN'},
	{name = 'WEAPON_SAWNOFFSHOTGUN'},
	{name = 'WEAPON_ASSAULTSHOTGUN'},
	{name = 'WEAPON_BULLPUPSHOTGUN'},
	{name = 'WEAPON_STUNGUN'},
	{name = 'WEAPON_SNIPERRIFLE'},
	{name = 'WEAPON_HEAVYSNIPER'},
	{name = 'WEAPON_REMOTESNIPER'},
	{name = 'WEAPON_GRENADELAUNCHER'},
	{name = 'WEAPON_GRENADELAUNCHER_SMOKE'},
	{name = 'WEAPON_RPG'},
	{name = 'WEAPON_PASSENGER_ROCKET'},
	{name = 'WEAPON_AIRSTRIKE_ROCKET'},
	{name = 'WEAPON_STINGER'},
	{name = 'WEAPON_MINIGUN'},
	{name = 'WEAPON_GRENADE'},
	{name = 'WEAPON_STICKYBOMB'},
	{name = 'WEAPON_SMOKEGRENADE'},
	{name = 'WEAPON_BZGAS'},
	{name = 'WEAPON_MOLOTOV'},
	{name = 'WEAPON_FIREEXTINGUISHER'},
	{name = 'WEAPON_PETROLCAN'},
	{name = 'WEAPON_DIGISCANNER'},
	{name = 'WEAPON_BRIEFCASE'},
	{name = 'WEAPON_BRIEFCASE_02'},
	{name = 'WEAPON_BALL'},
	{name = 'WEAPON_FLARE'},
	{name = 'WEAPON_VEHICLE_ROCKET'},
	{name = 'WEAPON_BARBED_WIRE'},
	{name = 'WEAPON_DROWNING'},
	{name = 'WEAPON_DROWNING_IN_VEHICLE'},
	{name = 'WEAPON_BLEEDING'},
	{name = 'WEAPON_ELECTRIC_FENCE'},
	{name = 'WEAPON_EXPLOSION'},
	{name = 'WEAPON_FALL'},
	{name = 'WEAPON_EXHAUSTION'},
	{name = 'WEAPON_HIT_BY_WATER_CANNON'},
	{name = 'WEAPON_RAMMED_BY_CAR'},
	{name = 'WEAPON_RUN_OVER_BY_CAR'},
	{name = 'WEAPON_HELI_CRASH'},
	{name = 'WEAPON_FIRE'},
	--DLC Weapons
	{name = 'WEAPON_SNSPISTOL'},
	{name = 'WEAPON_BOTTLE'},
	{name = 'WEAPON_GUSENBERG'},
	{name = 'WEAPON_SPECIALCARBINE'},
	{name = 'WEAPON_HEAVYPISTOL'},
	{name = 'WEAPON_BULLPUPRIFLE'},
	{name = 'WEAPON_DAGGER'},
	{name = 'WEAPON_VINTAGEPISTOL'},
	{name = 'WEAPON_FIREWORK'},
	{name = 'WEAPON_MUSKET'},
	{name = 'WEAPON_HEAVYSHOTGUN'},
	{name = 'WEAPON_MARKSMANRIFLE'},
	{name = 'WEAPON_HOMINGLAUNCHER'},
	{name = 'WEAPON_PROXMINE'},
	{name = 'WEAPON_SNOWBALL'},
	{name = 'WEAPON_FLAREGUN'},
	{name = 'WEAPON_GARBAGEBAG'},
	{name = 'WEAPON_HANDCUFFS'},
	{name = 'WEAPON_COMBATPDW'},
	{name = 'WEAPON_MARKSMANPISTOL'},
	{name = 'WEAPON_KNUCKLE'},
	{name = 'WEAPON_HATCHET'},
	{name = 'WEAPON_RAILGUN'},
	{name = 'WEAPON_MACHETE'},
	{name = 'WEAPON_MACHINEPISTOL'},
	{name = 'WEAPON_AIR_DEFENCE_GUN'},
	{name = 'WEAPON_SWITCHBLADE'},
	{name = 'WEAPON_REVOLVER'},
	{name = 'WEAPON_DBSHOTGUN'},
	{name = 'WEAPON_COMPACTRIFLE'},
	{name = 'WEAPON_AUTOSHOTGUN'},
	{name = 'WEAPON_BATTLEAXE'},
	{name = 'WEAPON_COMPACTLAUNCHER'},
	{name = 'WEAPON_MINISMG'},
	{name = 'WEAPON_PIPEBOMB'},
	{name = 'WEAPON_POOLCUE'},
	{name = 'WEAPON_WRENCH'}
}