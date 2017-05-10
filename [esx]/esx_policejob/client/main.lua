local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local SpawnedVehicles          = {}
local PID                      = 0
local PlayerData               = {}
local GUI                      = {}
GUI.Time                       = 0
local hasAlreadyEnteredMarker  = false;
local lastZone                 = nil;
local PoliceMenuTargetPlayerId = nil;
local PlayerIsHandcuffed       = false
local CurrentFine              = nil

function GetClosestPlayerInArea(positions, radius)

	local playerPed             = GetPlayerPed(-1)
	local playerServerId        = GetPlayerServerId(PlayerId())
	local playerCoords          = GetEntityCoords(playerPed)
	local closestPlayer         = -1
	local closestDistance       = math.huge

	for k, v in pairs(positions) do

    if tonumber(k) ~= playerServerId then
      
      local otherPlayerCoords = positions[k]
      local distance          = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, otherPlayerCoords.x, otherPlayerCoords.y, otherPlayerCoords.z, true)

      if distance <= radius and distance < closestDistance then
      	closestPlayer   = tonumber(k)
      	closestDistance = distance
      end
   	end
  end

  return closestPlayer

end

function GetClosestPlayerInAreaNotInAnyVehicle(positions, radius)

	local playerPed             = GetPlayerPed(-1)
	local playerServerId        = GetPlayerServerId(PlayerId())
	local playerCoords          = GetEntityCoords(playerPed)
	local closestPlayer         = -1
	local closestDistance       = math.huge

	for k, v in pairs(positions) do

    if tonumber(k) ~= playerServerId then
      
      local otherPlayerPed    = GetPlayerPed(GetPlayerFromServerId(tonumber(k)))
      local otherPlayerCoords = positions[k]
      local distance          = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, otherPlayerCoords.x, otherPlayerCoords.y, otherPlayerCoords.z, true)

      if distance <= radius and distance < closestDistance and not IsPedInAnyVehicle(otherPlayerPed,  false) then
      	closestPlayer   = tonumber(k)
      	closestDistance = distance
      end
   	end
  end

  return closestPlayer

end

AddEventHandler('playerSpawned', function(spawn)
	PID = GetPlayerServerId(PlayerId())
	TriggerServerEvent('esx_policejob:requestPlayerData', 'playerSpawned')
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	TriggerEvent('esx_phone:addContact', 'Police', 'police', 'special', false)
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(zone)

	if zone == 'CloakRoom' then
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'cop' then
			SendNUIMessage({
				showControls = true,
				controls     = 'cloakroom'
			})
		end
	end

	if zone == 'Armory' then
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'cop' then
			SendNUIMessage({
				showControls = true,
				controls     = 'armory'
			})
		end
	end

	if zone == 'VehicleSpawner' then
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'cop' then
			SendNUIMessage({
				showControls = true,
				controls     = 'vehiclespawner'
			})
		end
	end

	if zone == 'HelicopterLandingPadSpawner1' then

		if SpawnedVehicles['Polmav1'] ~= nil and not DoesEntityExist(GetPedInVehicleSeat(SpawnedVehicles['Polmav1'], -1)) then
			DeleteVehicle(SpawnedVehicles['Polmav1'])
			SpawnedVehicles['Polmav1'] = nil
		end

		Citizen.CreateThread(function()

			local coords      = Config.Zones.HelicopterLandingPad1.Pos
			local vehicleModel = GetHashKey('polmav')

			RequestModel(vehicleModel)

			while not HasModelLoaded(vehicleModel) do
				Citizen.Wait(0)
			end

			if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 10.0) then
				SpawnedVehicles['Polmav1'] = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, 0.0, true, false)
				SetVehicleHasBeenOwnedByPlayer(SpawnedVehicles['Polmav1'],  true)
				SetEntityAsMissionEntity(SpawnedVehicles['Polmav1'],  true,  true)
				local id = NetworkGetNetworkIdFromEntity(SpawnedVehicles['Polmav1'])
				SetNetworkIdCanMigrate(id, true)
			end

		end)

	end

	if zone == 'VehicleDeleter1' or zone == 'VehicleDeleter2' then

		local playerPed = GetPlayerPed(-1)

		if IsPedInAnyVehicle(playerPed, 0) then

			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			DeleteVehicle(vehicle)

		end

	end

end)

AddEventHandler('esx_policejob:hasExitedMarker', function(zone)
	SendNUIMessage({
		showControls = false,
		showMenu     = false,
	})
end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()

	PlayerIsHandcuffed = not PlayerIsHandcuffed;
	local playerPed    = GetPlayerPed(-1)

	Citizen.CreateThread(function()

		if PlayerIsHandcuffed then
			
			RequestAnimDict('mp_arresting')
			
			while not HasAnimDictLoaded('mp_arresting') do
				Wait(100)
			end
			
			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			SetEnableHandcuffs(playerPed, true)
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed,  true)
		
		else
			
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed,  true)
			FreezeEntityPosition(playerPed, false)
		
		end

	end)
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()

	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then

    	local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
    	local freeSeat = nil

    	for i=maxSeats - 1, 0, -1 do
    		if IsVehicleSeatFree(vehicle,  i) then
    			freeSeat = i
    			break
    		end
    	end

    	if freeSeat ~= nil then
    		SetPedIntoVehicle(playerPed,  vehicle,  freeSeat)
    	end

    end

  end	

end)

RegisterNetEvent('esx_policejob:confiscatePlayerWeapon')
AddEventHandler('esx_policejob:confiscatePlayerWeapon', function(weaponName)
	local playerPed = GetPlayerPed(-1)
	RemoveWeaponFromPed(playerPed,  GetHashKey(weaponName))
end)

RegisterNetEvent('esx_policejob:requestPlayerWeapons')
AddEventHandler('esx_policejob:requestPlayerWeapons', function(playerId, reason)

	local playerPed = GetPlayerPed(-1)
	local weapons   = {}

	for i=1, #Config.Weapons, 1 do
		
		local weaponHash = GetHashKey(Config.Weapons[i].name)

		if HasPedGotWeapon(playerPed,  weaponHash,  false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then

			local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)

			table.insert(weapons, {
				name = Config.Weapons[i].name,
				ammo = ammo,
			})

		end
	end

	TriggerServerEvent('esx_policejob:responsePlayerWeapons', weapons, playerId, reason)

end)

RegisterNetEvent('esx_policejob:responsePlayerPositions')
AddEventHandler('esx_policejob:responsePlayerPositions', function(positions, reason)

	if reason == 'identity_card' then

		local closestPlayer = GetClosestPlayerInArea(positions, 3.0)

    if closestPlayer ~= -1 then
    	PoliceMenuTargetPlayerId = closestPlayer;
    	TriggerServerEvent('esx_policejob:requestOtherPlayerData', closestPlayer, 'identity_card')
		end

	end

	if reason == 'body_search' then

		local closestPlayer = GetClosestPlayerInArea(positions, 3.0)

    if closestPlayer ~= -1 then
    	PoliceMenuTargetPlayerId = closestPlayer;
    	TriggerServerEvent('esx_policejob:requestOtherPlayerData', closestPlayer, 'body_search')
		end

	end

	if reason == 'handcuff' then

		local closestPlayer = GetClosestPlayerInArea(positions, 3.0)

    if closestPlayer ~= -1 then
    	PoliceMenuTargetPlayerId = closestPlayer;
    	TriggerServerEvent('esx_policejob:handcuff', closestPlayer);
		end

	end

	if reason == 'put_in_vehicle' then

		local closestPlayer = GetClosestPlayerInAreaNotInAnyVehicle(positions, 3.0)

    if closestPlayer ~= -1 then
    	PoliceMenuTargetPlayerId = closestPlayer;
    	TriggerServerEvent('esx_policejob:putInVehicle', closestPlayer);
		end

	end

	if reason == 'fine_data' then

		local closestPlayer = GetClosestPlayerInArea(positions, 3.0)

    if closestPlayer ~= -1 then
    	PoliceMenuTargetPlayerId = closestPlayer;
    	TriggerServerEvent('esx_policejob:applyFine', closestPlayer, CurrentFine);
		end

	end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_policejob:responsePlayerData')
AddEventHandler('esx_policejob:responsePlayerData', function(data, reason)
	PlayerData = data
end)

RegisterNetEvent('esx_policejob:responseOtherPlayerData')
AddEventHandler('esx_policejob:responseOtherPlayerData', function(data, reason)
	
	if reason == 'identity_card' then

		local jobLabel = nil

		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
		else
			jobLabel = 'Job : ' .. data.job.label
		end

		local items = {
			{label = 'Nom : ' .. data.name, value = nil},
			{label = jobLabel,              value = nil}
		}

		SendNUIMessage({
			showControls = false,
			showMenu     = true,
			menu         = 'identity_card',
			items        = items
		})

	end

	if reason == 'body_search' then

		local items = {}
		
		local blackMoney = 0

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' then
				blackMoney = data.accounts[i].money
			end
		end

		table.insert(items, {
			label          = 'Confisquer argent sale : $' .. blackMoney,
			value          = blackMoney,
			type           = 'black_money',
			removeOnSelect = true
		})

		table.insert(items, {label = '--- Armes ---', value = nil})

		for i=1, #data.weapons, 1 do
			table.insert(items, {
				label          = 'Confisquer ' .. data.weapons[i].name,
				value          = data.weapons[i].name,
				type           = 'weapon',
				count          = data.ammo,
				removeOnSelect = true
			})
		end

		table.insert(items, {label = '--- Inventaire ---', value = nil})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(items, {
					label          = 'Confisquer x' .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
					value          = data.inventory[i].item,
					type           = 'inventory_item',
					count          = data.inventory[i].count,
					removeOnSelect = true
				})
			end
		end

		SendNUIMessage({
			showControls = false,
			showMenu     = true,
			menu         = 'body_search',
			items        = items
		})

	end

end)

RegisterNetEvent('esx_policejob:responseFineData')
AddEventHandler('esx_policejob:responseFineData', function(data)

	local items = {}

	for i=1, #data, 1 do
		table.insert(items, {
			label = data[i].label .. ' : $' .. data[i].amount,
			value = data[i].id
		})
	end

	SendNUIMessage({
		showControls = false,
		showMenu     = true,
		menu         = 'fine_data',
		items        = items
	})

end)

RegisterNetEvent('esx_policejob:responseFineList')
AddEventHandler('esx_policejob:responseFineList', function(fines)

	local items = {}

	for i=1, #fines, 1 do
		table.insert(items, {
			label          = 'Payer $' .. fines[i].amount .. ' pour ' .. fines[i].label,
			value          = fines[i].id,
			count          = fines[i].amount,
			removeOnSelect = true
		})
	end

	SendNUIMessage({
		showControls = false,
		showMenu     = true,
		menu         = 'fine_list',
		items        = items
	})

end)

RegisterNetEvent('esx_policejob:hasPayedFine')
AddEventHandler('esx_policejob:hasPayedFine', function(playerName, amount)
	if PlayerData.job ~= nil and PlayerData.job.name == 'cop' then
		TriggerEvent('esx:showNotification', playerName .. ' a payé une amende de $' .. amount)
	end
end)

RegisterNUICallback('select', function(data, cb)

		if data.menu == 'cloakroom' then

			if data.val == 'civilian_wear' then
				TriggerEvent('esx_skin:loadSkin', PlayerData.skin)
			end

			if data.val == 'policeman_wear' then
				if PlayerData.skin.sex == 0 then
					TriggerEvent('esx_skin:loadJobSkin', PlayerData.skin, PlayerData.job.skin_male)
				else
					TriggerEvent('esx_skin:loadJobSkin', PlayerData.skin, PlayerData.job.skin_female)
				end
			end

		end

		if data.menu == 'armory' then

	    local playerPed = GetPlayerPed(-1)
	    local weapon    = GetHashKey(data.val)

			GiveWeaponToPed(playerPed, weapon, 1000, false, true)

			TriggerEvent('esx:showNotification', 'Vous avez recu votre arme')
		end

		if data.menu == 'vehiclespawner' then

	    local playerPed = GetPlayerPed(-1)

			Citizen.CreateThread(function()

				local coords       = Config.Zones.VehicleSpawnPoint.Pos
				local vehicleModel = GetHashKey(data.val)

				RequestModel(vehicleModel)

				while not HasModelLoaded(vehicleModel) do
					Citizen.Wait(0)
				end

				if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
					local vehicle = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, 90.0, true, true)
					SetVehicleHasBeenOwnedByPlayer(vehicle,  true)
					SetEntityAsMissionEntity(vehicle,  true,  true)
					local id = NetworkGetNetworkIdFromEntity(vehicle)
					SetNetworkIdCanMigrate(id, true)
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				end

			end)

			SendNUIMessage({
				showControls = false,
				showMenu     = false,
			})

		end

		if data.menu == 'citizen_interaction' then

			if data.val == 'identity_card' then
				TriggerServerEvent('esx_policejob:requestPlayerPositions', 'identity_card')
			end

			if data.val == 'body_search' then
				TriggerServerEvent('esx_policejob:requestPlayerPositions', 'body_search')
			end

			if data.val == 'handcuff' then
				TriggerServerEvent('esx_policejob:requestPlayerPositions', 'handcuff')
			end

			if data.val == 'put_in_vehicle' then
				TriggerServerEvent('esx_policejob:requestPlayerPositions', 'put_in_vehicle')
			end

			if data.val == 'fine' then
				SendNUIMessage({
					showControls = false,
					showMenu     = true,
					menu         = 'fine',
				})
			end

		end

		if data.menu == 'body_search' then

			if data.type == 'black_money' then
				local playerServerId = GetPlayerServerId(PlayerId())
				TriggerServerEvent('esx_policejob:confiscatePlayerBlackMoney', PoliceMenuTargetPlayerId, data.val)
			end

			if data.type == 'weapon' then
				local playerPed = GetPlayerPed(-1)
				TriggerServerEvent('esx_policejob:confiscatePlayerWeapon', PoliceMenuTargetPlayerId, data.val)
				GiveWeaponToPed(playerPed,  GetHashKey(data.val),  0,  false,  false)
			end

			if data.type == 'inventory_item' then
				local playerServerId = GetPlayerServerId(PlayerId())
				TriggerServerEvent('esx_policejob:confiscatePlayerInventoryItem', PoliceMenuTargetPlayerId, data.val, tonumber(data.count))
				TriggerServerEvent('esx_policejob:addPlayerInventoryItem',        playerServerId,           data.val, tonumber(data.count))
			end

		end

		if data.menu == 'fine' then
			TriggerServerEvent('esx_policejob:requestFineData', data.val)
		end

		if data.menu == 'fine_data' then
			CurrentFine = data.val
			TriggerServerEvent('esx_policejob:requestPlayerPositions', 'fine_data')
		end

		if data.menu == 'fine_list' then
			TriggerServerEvent('esx_policejob:requestPayFine', data.val, data.count, GetPlayerName(PlayerId()))
		end

		if data.menu == 'vehicle_interaction' then

			if data.val == 'vehicle_infos' then

				local playerPed = GetPlayerPed(-1)
	      local coords    = GetEntityCoords(playerPed)

	      if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

	        local vehicle = nil

	        if IsPedInAnyVehicle(playerPed, false) then
	          vehicle = GetVehiclePedIsIn(playerPed, false)
	        else
	          vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
	        end

	        if DoesEntityExist(vehicle) then
	        	
	        	local plateText = GetVehicleNumberPlateText(vehicle)
						local items     = {}

						table.insert(items, {label = 'N°: ' .. plateText, value = nil})

						local ownerName = 'IA'

						SendNUIMessage({
							showControls = false,
							showMenu     = true,
							menu         = 'vehicle_infos',
							items        = items
						})

	        end

	      end

			end

			if data.val == 'hijack_vehicle' then

	      local playerPed = GetPlayerPed(-1)
	      local coords    = GetEntityCoords(playerPed)

	      if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

	        local vehicle = nil

	        if IsPedInAnyVehicle(playerPed, false) then
	          vehicle = GetVehiclePedIsIn(playerPed, false)
	        else
	          vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
	        end

	        if DoesEntityExist(vehicle) then
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            TriggerEvent('esx:showNotification', 'Véhicule déverouillé')

	        end

	      end

			end

		end

		cb('ok')

end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k,v in pairs(Config.Zones) do

			if(PlayerData.job ~= nil and PlayerData.job.name == 'cop' and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end

	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		if(PlayerData.job ~= nil and PlayerData.job.name == 'cop') then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_policejob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_policejob:hasExitedMarker', lastZone)
			end

		end

	end
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if PlayerIsHandcuffed then
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(425.130, -979.558, 30.711)
  
  SetBlipSprite (blip, 60)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.2)
  SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Commissariat")
  EndTextCommandSetBlipName(blip)

end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if PlayerData.job ~= nil and PlayerData.job.name == 'cop' and IsControlPressed(0, Keys['F6']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				showControls = false,
				showMenu     = true,
				menu         = 'police_actions'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['F7']) and (GetGameTimer() - GUI.Time) > 300 then

			TriggerServerEvent('esx_policejob:requestFineList')

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['ENTER']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				enterPressed = true
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['BACKSPACE']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				backspacePressed = true
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['LEFT']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'LEFT'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['RIGHT']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'RIGHT'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['TOP']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'UP'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['DOWN']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'DOWN'
			})

			GUI.Time = GetGameTimer()

		end

	end
end)