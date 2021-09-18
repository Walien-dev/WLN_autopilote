local speed = 20.0
local autopilotActive = false
local blipX = 0.0
local blipY = 0.0
local blipZ = 0.0
local keypressed = false


local ElectricVehicles = {
	"imorgon",
	"neon",
	"raiden",
	"cyclone",
	"voltic",
	"tezeract",
	"dilettan"
}

local function contains(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

RegisterNetEvent("autopilot:start")
AddEventHandler("autopilot:start", function(source)
	local player = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(player, false)
	local model = GetEntityModel(vehicle)
	local displaytext = GetDisplayNameFromVehicleModel(model)
	local blip = GetFirstBlipInfoId(8)
	if (blip ~= nil and blip ~= 0) then
		local coord = GetBlipCoords(blip)
		blipX = coord.x
		blipY = coord.y
		blipZ = coord.z
		TaskVehicleDriveToCoordLongrange(player, vehicle, blipX, blipY, blipZ, speed, 447, 2.0)
		autopilotActive = true
		ShowNotification("~b~Autopilote activé!")
	else
		ShowNotification("~r~Définis d'abbord le GPS")
	end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		if autopilotActive then
			local coords = GetEntityCoords(GetPlayerPed(-1))
			local blip = GetFirstBlipInfoId(8)
			local dist = Vdist(coords.x, coords.y, coords.z, blipX, blipY, coords.z)
			if dist <= 10 then
				local player = GetPlayerPed(-1)
				local vehicle = GetVehiclePedIsIn(player, false)
				ClearPedTasks(player)
				SetVehicleForwardSpeed(vehicle, 19.0)
				Citizen.Wait(200)
				SetVehicleForwardSpeed(vehicle, 15.0)
				Citizen.Wait(200)
				SetVehicleForwardSpeed(vehicle, 11.0)
				Citizen.Wait(200)
				SetVehicleForwardSpeed(vehicle, 6.0)
				Citizen.Wait(200)
				SetVehicleForwardSpeed(vehicle, 0.0)
				ShowNotification("~g~Vous êtes arrivés")
				autopilotActive = false
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local player = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(player, false)
		if GetPedInVehicleSeat(vehicle, -1) == player then	
			if keypressed then
				keypressed = false
				local model = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
				if contains(ElectricVehicles, model) then
					if not autopilotActive then
						TriggerEvent("autopilot:start")
					else
						TaskVehicleDriveToCoordLongrange(player, vehicle, GetEntityCoords(player), speed, 447, 2.0)
						autopilotActive = false
						ShowNotification("~b~Autopilote désactivé!")
					end
				end
			end
		end
	end
end)


RegisterCommand('+autopilotActive', function()
	keypressed = true
end, false)


RegisterCommand('-autopilotActive', function()
	keypressed = false
end, false)

RegisterKeyMapping('+autopilotActive', 'ON/OFF autopilote', 'keyboard', 'g')



