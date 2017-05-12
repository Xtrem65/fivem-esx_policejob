require "resources/[essential]/es_extended/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "foo")

RegisterServerEvent('esx_policejob:requestPlayerData')
AddEventHandler('esx_policejob:requestPlayerData', function(reason)
	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
		TriggerEvent('esx_skin:requestPlayerSkinInfosCb', source, function(skin, jobSkin)

			local data = {
				job       = xPlayer.job,
				inventory = xPlayer.inventory,
				skin      = skin
			}

			TriggerClientEvent('esx_policejob:responsePlayerData', source, data, reason)
		end)
	end)
end)

RegisterServerEvent('esx_policejob:requestOtherPlayerData')
AddEventHandler('esx_policejob:requestOtherPlayerData', function(playerId, reason)
	TriggerClientEvent('esx_policejob:requestPlayerWeapons', playerId, source, reason)
end)

RegisterServerEvent('esx_policejob:responsePlayerWeapons')
AddEventHandler('esx_policejob:responsePlayerWeapons', function(weapons, playerId, reason)

	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

		local data = {
			name       = GetPlayerName(source),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = weapons
		}

		TriggerClientEvent('esx_policejob:responseOtherPlayerData', playerId, data, reason)

	end)
end)

RegisterServerEvent('esx_policejob:requestPlayerPositions')
AddEventHandler('esx_policejob:requestPlayerPositions', function(reason)
	
	local _source = source

	TriggerEvent('esx:getPlayers', function(xPlayers)

		local positions = {}

		for k, v in pairs(xPlayers) do
			positions[tostring(k)] = v.player.coords
		end

		TriggerClientEvent('esx_policejob:responsePlayerPositions', _source, positions, reason)

	end)

end)

RegisterServerEvent('esx_policejob:confiscatePlayerBlackMoney')
AddEventHandler('esx_policejob:confiscatePlayerBlackMoney', function(playerId, amount)
	TriggerEvent('esx:getPlayerFromId', playerId, function(xPlayer)
		xPlayer:removeAccountMoney('black_money', amount)
	end)
	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
		xPlayer:addAccountMoney('black_money', amount)
	end)
end)

RegisterServerEvent('esx_policejob:confiscatePlayerWeapon')
AddEventHandler('esx_policejob:confiscatePlayerWeapon', function(playerId, weaponName)
	TriggerClientEvent('esx_policejob:confiscatePlayerWeapon', playerId, weaponName);
end)

RegisterServerEvent('esx_policejob:confiscatePlayerInventoryItem')
AddEventHandler('esx_policejob:confiscatePlayerInventoryItem', function(playerId, itemName, count)
	TriggerEvent('esx:getPlayerFromId', playerId, function(xPlayer)
		xPlayer:removeInventoryItem(itemName, count)
	end)
end)

RegisterServerEvent('esx_policejob:addPlayerInventoryItem')
AddEventHandler('esx_policejob:addPlayerInventoryItem', function(playerId, itemName, count)
	TriggerEvent('esx:getPlayerFromId', playerId, function(xPlayer)
		xPlayer:addInventoryItem(itemName, count)
	end)
end)

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(playerId)
	TriggerClientEvent('esx_policejob:handcuff', playerId)
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(playerId)
	TriggerClientEvent('esx_policejob:putInVehicle', playerId)
end)

RegisterServerEvent('esx_policejob:requestFineData')
AddEventHandler('esx_policejob:requestFineData', function(category)

	local executed_query = MySQL:executeQuery("SELECT * FROM fine_types WHERE category = '@category'", {['@category'] = category})
	local result         = MySQL:getResults(executed_query, {'id', 'label', 'amount', 'category'}, 'id')
	local data           = {}

	for i=1, #result, 1 do
		table.insert(data, {
			id     = result[i].id,
			label  = result[i].label,
			amount = result[i].amount
		})
	end

	TriggerClientEvent('esx_policejob:responseFineData', source, data)

end)

RegisterServerEvent('esx_policejob:applyFine')
AddEventHandler('esx_policejob:applyFine', function(playerId, fineId)
	
	TriggerClientEvent('esx:showNotification', source, 'Vous avez mis une ammende')

	TriggerEvent('esx:getPlayerFromId', playerId, function(xPlayer)
		MySQL:executeQuery("INSERT INTO fines (identifier, fine_id) VALUES ('@identifier', '@fine_id')", {['@identifier'] = xPlayer.identifier, ['@fine_id'] = fineId})
		TriggerClientEvent('esx:showNotification', xPlayer.player.source, 'Vous avez recu une amende')
	end)

end)

RegisterServerEvent('esx_policejob:requestFineList')
AddEventHandler('esx_policejob:requestFineList', function()
	
	local _source        = source
	local executed_query = MySQL:executeQuery("SELECT * FROM fine_types")
	local result         = MySQL:getResults(executed_query, {'id', 'label', 'amount', 'category'}, 'id')

	local fineTypes      = {}

	for i=1, #result, 1 do
		fineTypes[result[i].id] = {
			label  = result[i].label,
			amount = result[i].amount
		}
	end

	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

		local executed_query = MySQL:executeQuery("SELECT * FROM fines WHERE identifier = '@identifier'", {['@identifier'] = xPlayer.identifier})
		local result         = MySQL:getResults(executed_query, {'id', 'fine_id'}, 'id')
		local fines          = {}

		for i=1, #result, 1 do
			table.insert(fines, {
				id     = result[i].id,
				label  = fineTypes[result[i].fine_id].label,
				amount = fineTypes[result[i].fine_id].amount
			})
		end

		TriggerClientEvent('esx_policejob:responseFineList', _source, fines)

	end)

end)

RegisterServerEvent('esx_policejob:requestPayFine')
AddEventHandler('esx_policejob:requestPayFine', function(fineId, amount, playerName)
	
	local _source = source

	MySQL:executeQuery("DELETE FROM fines WHERE id = '@id'", {['@id'] = fineId})

	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
		xPlayer:removeMoney(amount)
		TriggerClientEvent('esx:showNotification', _source, 'Vous avez payé une ammende de $' .. amount)
		TriggerClientEvent('esx_policejob:hasPayedFine', -1, playerName, amount)
	end)
end)

TriggerEvent('esx_phone:registerCallback', 'special', function(source, phoneNumber, playerName, type, message)

	if phoneNumber == 'police' then

		TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
			TriggerEvent('esx:getPlayers', function(xPlayers)
				for k, v in pairs(xPlayers) do
					if v.job.name == 'cop' then
						
						RconPrint('Message => ' .. playerName .. ' ' .. message)
						
						TriggerClientEvent('esx_phone:onMessage', v.player.source, xPlayer.phoneNumber, playerName, type, message, xPlayer.player.coords, {
							reply     = 'Répondre',
							gps       = 'GPS',
							copy_that = 'Bien reçu'
						})
						
					end
				end
			end)
		end)

	end
end)
