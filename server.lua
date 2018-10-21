ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local phoneName = 'esx_phone3' -- ändra till namnet på telefonens item
local price = 250 -- pris att köpa in ny telefon

RegisterServerEvent('loffe_olssontelefonservice:jobNotification')
AddEventHandler('loffe_olssontelefonservice:jobNotification', function(name, help)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'olsson' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], 'En person behöver ~b~hjälp~s~ på ~g~Olssons Telefonservice AB')
			TriggerClientEvent('esx:showNotification', xPlayers[i], '~g~' .. name .. '~w~: ' .. help)
		    TriggerClientEvent('loffe_olssontelefonservice:onMessage', xPlayers[i])
		end
	end
end)

RegisterServerEvent('loffe_olssontelefonservice:breakPhone')
AddEventHandler('loffe_olssontelefonservice:breakPhone', function(crack)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    local currentPhones = xPlayer.getInventoryItem(phoneName).count
	
	if currentPhones > 0 then
		if crack then
			xPlayer.removeInventoryItem(phoneName, 1)
			xPlayer.addInventoryItem('crackedphone', 1)
			TriggerClientEvent('esx:showNotification', src, 'Din telefon fick en ~r~spricka~w~!')
		else
			xPlayer.removeInventoryItem(phoneName, 1)
			xPlayer.addInventoryItem('virusphone', 1)
			TriggerClientEvent('esx:showNotification', src, 'Din telefon har blivit infekterad med ~r~virus~w~ och går därför inte längre att använda!')
		end
    end
end)

RegisterServerEvent('loffe_olssontelefonservice:repair')
AddEventHandler('loffe_olssontelefonservice:repair', function(cracked)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    local crackedPhone = xPlayer.getInventoryItem('crackedphone').count
	local virusPhone = xPlayer.getInventoryItem('virusphone').count
	
	if cracked then
		if crackedPhone > 0 then
			xPlayer.removeInventoryItem('crackedphone', 1)
			xPlayer.addInventoryItem(phoneName, 1)
			sendNotification(src, 'Du satte på en ny skärm på telefonen!', 'success', 3500)
		end
	else
		if virusPhone > 0 then
			xPlayer.removeInventoryItem('virusphone', 1)
			xPlayer.addInventoryItem(phoneName, 1)
			sendNotification(src, 'Du tog bort virusen från telefonen!', 'success', 3500)
		end
	end
end)

RegisterServerEvent('loffe_olssontelefonservice:stockFunction')
AddEventHandler('loffe_olssontelefonservice:stockFunction', function(action)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
	if action == 'remove' then
		MySQL.Async.fetchScalar('SELECT lager FROM olssonslager',
		{
		}, function(stock)
    
				if stock >= 1 then
						xPlayer.addInventoryItem(phoneName, 1)
						local newStock = stock - 1
						MySQL.Sync.execute("UPDATE olssonslager SET lager=@lager",
						{
							['@lager'] = newStock
						})
						sendNotification(_source, 'Du tog ut en telefon!', 'success', 2500)
				else
					sendNotification(_source, 'Det finns inte tillräckligt i lager!', 'error', 2500)
				end
		end)
	elseif action == 'put' then
		local xPlayer = ESX.GetPlayerFromId(source)
		local items = xPlayer.getInventoryItem(phoneName).count
		if items > 0 then
			MySQL.Async.fetchScalar('SELECT lager FROM olssonslager',
			{
			}, function(stock)
    
				xPlayer.removeInventoryItem(phoneName, 1)
				local newStock = stock + 1
				MySQL.Sync.execute("UPDATE olssonslager SET lager=@lager",
				{
					['@lager'] = newStock
				})
				sendNotification(_source, 'Du lade in en telefon!', 'success', 2500)
			end)
		else
			sendNotification(_source, 'Du har ingen telefon!', 'error', 2500)
		end
	elseif action == 'buy' then
		local xPlayer = ESX.GetPlayerFromId(source)
		local money = xPlayer.getMoney()
		if(money >= price) then
			xPlayer.removeMoney(price)
			MySQL.Async.fetchScalar('SELECT lager FROM olssonslager',
			{
			}, function(stock)
				local newStock = stock + 1
				MySQL.Sync.execute("UPDATE olssonslager SET lager=@lager",
				{
					['@lager'] = newStock
				})
				sendNotification(_source, 'Du köpte en telefon för ' .. price .. 'kr', 'success', 2500)
			end)
		else
			sendNotification(_source, 'Du har inte råd! Du behöver ' .. price - money .. ' kr!' , 'error', 2500)
		end
	end
end)

ESX.RegisterServerCallback('loffe_olssontelefonservice:getPhones', function(source, cb)
	MySQL.Async.fetchScalar('SELECT lager FROM olssonslager',
    {
    }, function(lager)
	local xPlayer = ESX.GetPlayerFromId(source)
	local phones = xPlayer.getInventoryItem('virusphone').count
	local items = xPlayer.getInventoryItem('crackedphone').count
	cb(phones, items)
	end)
end)

ESX.RegisterServerCallback('loffe_olssontelefonservice:getStock', function(source, cb)
    MySQL.Async.fetchScalar('SELECT lager FROM olssonslager',
    {
    }, function(lager)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.getInventoryItem(phoneName).count
	cb(lager, items)
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local JobOnline = 0

		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			
			if xPlayer.job.name == 'olsson' then
				JobOnline = JobOnline + 1
			end
			TriggerClientEvent('loffe_olssontelefonservice:jobOnline', xPlayers[i], JobOnline)
		end
	end
end)

RegisterServerEvent('loffe_olssontelefonservice:duty')
AddEventHandler('loffe_olssontelefonservice:duty', function(duty)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local grade = xPlayer.job.grade
    
	if duty then
        xPlayer.setJob('olsson', grade)
	else
		xPlayer.setJob('olssonoffduty', grade)
	end

end)

function sendNotification(xSource, message, messageType, messageTimeout)
    TriggerClientEvent("pNotify:SendNotification", xSource, {
        text = message,
        type = messageType,
        queue = "lmfao",
        timeout = messageTimeout,
        layout = "bottomCenter"
    })
end

--[[
--]]
