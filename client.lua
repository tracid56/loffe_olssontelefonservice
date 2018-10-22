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

-------------------- ESX --------------------

local PlayerData = {}
ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-------------------- Config --------------------

local breakphone = true -- false = telefon får inte virus random, telefon går inte sönder random vid ragdoll
local ragdollBreak = 20 -- % 0 - 100 att telefonen går sönder när man ragdollar. Default: 5%
local virusRisk = 5 -- % 0 - 100 att telefonen får virus varje 10 minuter. Default: 5%
local olssonOnline = 0

local teleports = { 
    ["~w~[~g~E~w~] Ta hissen upp"] = { ["x"] = -1075.59, ["y"] = -252.94, ["z"] = 36.91, ["tpx"] = -1075.49, ["tpy"] = -253.09, ["tpz"] = 43.17, ["tph"] = 26.0}, 
    ["~w~[~g~E~w~] Ta hissen ner"] = { ["x"] = -1075.49, ["y"] = -253.09, ["z"] = 43.17, ["tpx"] = -1075.59, ["tpy"] = -252.94, ["tpz"] = 36.91, ["tph"] = 26.0},
} 

local callforjob = { 
    ["~w~[~g~E~w~] Kalla hit anställda."] = { ["x"] = -1082.74, ["y"] = -247.84, ["z"] = 36.91}, 
} 

-------------------- Teleporters, kalla på jobbande personer --------------------

Citizen.CreateThread(function()
	while true do
      
	Citizen.Wait(5)
	
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k, v in pairs(teleports) do
			if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 100 then
				DrawMarker(27, v["x"], v["y"], v["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 1.5 then
					DrawText3D(v["x"], v["y"], v["z"]+0.9, k, 0.80)
					if IsControlPressed(0, 38) then
						TriggerEvent('esx_status:setDisplay', 0.0)
						DoScreenFadeOut(1000)
						Wait(1000)
						SetEntityCoords(GetPlayerPed(-1), v["tpx"], v["tpy"], v["tpz"])
						SetEntityHeading(GetPlayerPed(-1), v["tph"])
						Wait(500)
						SetEntityCoords(GetPlayerPed(-1), v["tpx"], v["tpy"], v["tpz"])
						SetEntityHeading(GetPlayerPed(-1), v["tph"])
						DoScreenFadeIn(1000)
						TriggerEvent('esx_status:setDisplay', 1.0)
					end
				end
			end
		end
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k, v in pairs(callforjob) do
			if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 100 then
				DrawMarker(27, v["x"], v["y"], v["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 1.5 then
					DrawText3D(v["x"], v["y"], v["z"]+0.9, '' .. k .. ' Det är just nu: ' .. olssonOnline .. ' i tjänst!', 0.80)
					if IsControlPressed(0, 38) then
						local name = KeyboardInput("Vad är ditt förnamn?", "", 15)
						local help = KeyboardInput("Vad behöver du hjälp med?", "Jag behöver hjälp med ", 100)
						TriggerServerEvent('loffe_olssontelefonservice:jobNotification', name, help)
						SendNotification('Alla anställda hos Olssons Telefon serivce AB har nu fått ett meddelande att du behöver hjälp. Var vänlig och vänta i lobbyn.', 'success')
					end
				end
			end
		end
	end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght

	AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input
	blockinput = true --Blocks new input while typing if **blockinput** is used

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
end

RegisterNetEvent('loffe_olssontelefonservice:jobOnline')
AddEventHandler('loffe_olssontelefonservice:jobOnline', function(jobOnline)
	Wait(500)
	olssonOnline = jobOnline
	Wait(500)
end)

RegisterNetEvent('loffe_olssontelefonservice:onMessage')
AddEventHandler('loffe_olssontelefonservice:onMessage', function()
	PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(250)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(250)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
	Blip = AddBlipForCoord(-1087.56, -270.13, 36.91)
	SetBlipRoute(Blip, true)
	SetBlipColour(Blip, 11)
	SetBlipRouteColour(Blip, 11)
	while GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1083.22, -248.5, 36.91) > 50 do
		Wait(1000) -- så den tar bort blipen när man är nära den
	end
	RemoveBlip(Blip)
end)

-------------------- Ta sönder telefon random --------------------

AddEventHandler("playerSpawned", function(spawn)
	print("Joinade servern, väntar 5 minuter innan telefonen kan gå sönder....")
    Wait(300000)
	print("Telefonen kan nu gå sönder")
		Citizen.CreateThread(function()
		while true do
			Citizen.Wait(500)
			if breakphone then
				if IsPedRagdoll(GetPlayerPed(-1)) then
					local randomBreak = math.random(100)
					if randomBreak <= ragdollBreak then
						TriggerServerEvent('loffe_olssontelefonservice:breakPhone', true) -- spräck telefonen
						print('Telefonen gick sönder pga ragdoll, randomBreak = ' .. randomBreak)
						while IsPedRagdoll(GetPlayerPed(-1)) do
							Wait(500) -- så den bara gör det en gång när man ragdollar
						end
					else
						print('Telefonen gick inte sönder random, randomBreak = ' .. randomBreak)
						while IsPedRagdoll(GetPlayerPed(-1)) do
							Wait(500) -- så den bara gör det en gång när man ragdollar
						end
					end
				end
			end
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(600000) -- varje 10 minuter
		if breakPhone then
			local randomBreak = math.random(100)
			if randomBreak <= virusRisk then
				TriggerServerEvent('loffe_olssontelefonservice:breakPhone', false) -- ge telefonen virus
			end
		end
	end
end)

-------------------- Scriptet --------------------

local locations = { 
    ["~w~[~g~E~w~] Öppna lager"] = { ["action"] = 'openstock', ["x"] = -1051.87, ["y"] = -232.97, ["z"] = 43.17}, 
    ["~w~[~g~E~w~] Ta ut bil"] = { ["action"] = 'car', ["x"] = -1096.63, ["y"] = -252.75, ["z"] = 36.85, ["spawnx"] = -1099.08, ["spawny"] = -257.25, ["spawnz"] = 36.83, ["spawnh"] = 146.86},
	["~w~[~g~E~w~] Ställ in bil"] = { ["action"] = 'removecar', ["x"] = -1099.05, ["y"] = -257.27, ["z"] = 36.64}, 
	["~w~[~g~E~w~] Chefsmeny"] = { ["action"] = 'bossactions', ["x"] = -1048.24, ["y"] = -240.92, ["z"] = 43.17}, 
	["~w~[~g~E~w~] Ta bort virus"] = { ["action"] = 'removeVirus', ["x"] = -1057.59, ["y"] = -244.25, ["z"] = 43.17, ["h"] = 116.08}, 
	["~w~[~g~E~w~] Laga skärmen"] = { ["action"] = 'repairScreen', ["x"] = -1053.37, ["y"] = -244.45, ["z"] = 43.17, ["h"] = 117.43}, 
} 

local onoffduty = { 
    ["~w~[~g~E~w~]"] = { ["action"] = 'onoffduty', ["x"] = -1066.17, ["y"] = -241.76, ["z"] = 38.88}, 
} 

Citizen.CreateThread(function()
		while true do
      
		Citizen.Wait(5)
		for k, v in pairs(locations) do
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'olsson' then
				local coords = GetEntityCoords(GetPlayerPed(-1))
				if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 100 and v["action"] ~= 'bossactions' and v["action"] ~= 'repairScreen' and v["action"] ~= 'removeVirus' then
					DrawMarker(27, v["x"], v["y"], v["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 100, 255, 0, 100, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 1.5 then
						DrawText3D(v["x"], v["y"], v["z"]+0.9, k, 0.80)
						if IsControlPressed(0,  Keys['E']) then
							if v["action"] == 'openstock' then
								OpenStock()
							elseif v["action"] == 'car' then
								local closestVehicle = GetClosestVehicle(v["spawnx"], v["spawny"], v["spawnz"], 5.0, 0, 70)
								if not DoesEntityExist(closestVehicle) then
									local vehicleModel = GetHashKey("burrito3")
									RequestModel(vehicleModel)
									while not HasModelLoaded(vehicleModel) do
										Citizen.Wait(0)
									end
									local job_car = CreateVehicle(vehicleModel, v["spawnx"], v["spawny"], v["spawnz"], v["spawnh"], true, false)
									SetVehicleOnGroundProperly(job_car)
									TaskWarpPedIntoVehicle(GetPlayerPed(-1), job_car, -1)
									Wait(100)
								else
									SendNotification('En bil är för nära!', "error")
									Wait(3000)
								end
							elseif v["action"] == 'removecar' then
								DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
							end
						end
					end
				end
				if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 100 and v["action"] == 'bossactions' and ESX.PlayerData.job.grade_name == 'boss' then
					DrawMarker(27, v["x"], v["y"], v["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 100, 255, 0, 100, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 1.5 then
						DrawText3D(v["x"], v["y"], v["z"]+0.9, k, 0.80)
						if IsControlPressed(0,  Keys['E']) then
							OpenBossMenu()
						end
					end
				end
				if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 100 and v["action"] == 'repairScreen' and ESX.PlayerData.job.grade_name == 'boss' or (GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 100 and v["action"] == 'repairScreen' and ESX.PlayerData.job.grade_name == 'technician') or (GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 100 and v["action"] == 'removeVirus' and ESX.PlayerData.job.grade_name == 'boss' or (GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 100 and v["action"] == 'removeVirus' and ESX.PlayerData.job.grade_name == 'technician')) then
					DrawMarker(27, v["x"], v["y"], v["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 100, 255, 0, 100, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 1.5 then
						DrawText3D(v["x"], v["y"], v["z"]+0.9, k, 0.80)
						if IsControlPressed(0,  Keys['E']) then
							Wait(500)
							ESX.TriggerServerCallback('loffe_olssontelefonservice:getPhones', function(virusPhone, crackedPhone)
								if v["action"] == 'removeVirus' then
									print(v["action"])
									if virusPhone > 0 then
										TriggerEvent("mhacking:show")
										TriggerEvent("mhacking:start",3,45,mycb)
									else
										SendNotification('Du har ingen telefon med virus!', "error")
									end
								else
									print(v["action"])
									if crackedPhone > 0 then
										SetEntityCoords(GetPlayerPed(-1), v["x"], v["y"], v["z"])
										SetEntityHeading(GetPlayerPed(-1), v["h"])
										TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
										FreezeEntityPosition(GetPlayerPed(-1), true)
										Wait(10000)
										TriggerServerEvent('loffe_olssontelefonservice:repair', true)
										ClearPedTasks(GetPlayerPed(-1))
										Wait(2500)
										FreezeEntityPosition(GetPlayerPed(-1), false)
									else
										SendNotification('Du har ingen sprucken telefon!', "error")
									end
								end
							end)
						end
					end
				end
			end
		end
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k, v in pairs(onoffduty) do
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'olssonoffduty' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'olsson' then
				if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 100 then
					DrawMarker(27, v["x"], v["y"], v["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(coords, v["x"], v["y"], v["z"], true) < 1.5 then
						if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'olssonoffduty' then
							DrawText3D(v["x"], v["y"], v["z"]+0.9, '' .. k .. ' gå i tjänst', 0.80)
							if IsControlPressed(0, 38) then
								TriggerServerEvent('loffe_olssontelefonservice:duty', true)
								SendNotification('Du gick i tjänst.', "success")
								Wait(5000)
							end
						else
							DrawText3D(v["x"], v["y"], v["z"]+0.9, '' .. k .. ' gå ur tjänst', 0.80)
							if IsControlPressed(0, 38) then
								TriggerServerEvent('loffe_olssontelefonservice:duty', false)
								SendNotification('Du gick ur tjänst.', "success")
								Wait(5000)
							end
						end
					end
				end
			end
		end
	end
end)

function mycb(success, timeremaining)
	if success then
		TriggerEvent('mhacking:hide')
		TriggerServerEvent('loffe_olssontelefonservice:repair', false)
	else
		TriggerEvent('mhacking:hide')
		SendNotification('Du lyckades inte ta bort virusen. Bättre lycka nästa gång!', "error")
	end
end


local blips = {
    {title="Olssons Telefonservice AB", colour=30, id=459, x = -1081.87, y = -260.73, z = 36.95};
}

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.35)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

function OpenBossMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'olsson_boss_menu',
        {
            title    = 'Chefsmeny',
            elements = {
				{label = 'Företagsmeny', value = 'job'},
				{label = 'Köp in telefon', value = 'buy'},
            }
        },
        function(data, menu)
            local value = data.current.value
			if value == 'job' then
				TriggerEvent('esx_society:openBossMenu', 'olsson', function(data, menu)
						menu.close()
						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = ('open_bossmenu')
						CurrentActionData = {}
				end, { wash = false }) -- disable washing money
		    else
				print(value)
				TriggerServerEvent('loffe_olssontelefonservice:stockFunction', 'buy')
				Wait(250)
		    end
			menu.close()
			Wait(250)
        end,
    function(data, menu)
        menu.close()
	end)
end

function OpenStock()
    ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('loffe_olssontelefonservice:getStock', function(stock, inventory)
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'olsson_telefon_stock',
        {
            title    = 'Lager',
            elements = {
				{label = 'Ta ut telefon [x ' .. stock ..' telefoner i lager]', value = 'remove'},
				{label = 'Lägg in telefon [x ' .. inventory ..' telefoner i ditt förråd]', value = 'put'},
            }
        },
        function(data, menu)
            local value = data.current.value
			if value == 'remove' then
				print(value)
				TriggerServerEvent('loffe_olssontelefonservice:stockFunction', 'remove')
				Wait(250)
				OpenStock()
		    else
				print(value)
				TriggerServerEvent('loffe_olssontelefonservice:stockFunction', 'put')
				Wait(250)
				OpenStock()
		    end
			menu.close()
			Wait(250)
        end,
    function(data, menu)
        menu.close()
		end)
    end)
end

function DrawText3D(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
 
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)
 
    AddTextComponentString(text)
    DrawText(_x, _y)
 
    local factor = (string.len(text)) / 230
    DrawRect(_x, _y + 0.0250, 0.095 + factor, 0.06, 41, 11, 41, 100)
end

function SendNotification(text, type)
	TriggerEvent("pNotify:SendNotification",{
		text = (text),
		type = type,
		timeout = (5000),
		layout = "bottomCenter",
		queue = "global"
	})
end

--[[
--]]
