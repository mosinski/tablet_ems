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

local PoliceGUI   = false
local PlayerData  = {}
local CurrentTask = {}
local tabletEntity = nil
local tabletModel = "prop_cs_tablet"
local tabletDict = "amb@world_human_seat_wall_tablet@female@base"
local tabletAnim = "base"

ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
  end

  Citizen.Wait(5000)
  PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('tablet_ems:setPlayerName')
AddEventHandler('tablet_ems:setPlayerName', function(data)
  SendNUIMessage({
    type = 'setPlayerName', 
    name = data
  });
end)

RegisterNetEvent('tablet_ems:showTreatments')
AddEventHandler('tablet_ems:showTreatments', function(data)
  SendNUIMessage({
    type = 'getTreatments', 
    treatments = data
  });
end)

RegisterNetEvent('tablet_ems:autocompletePatients')
AddEventHandler('tablet_ems:autocompletePatients', function(data)
  SendNUIMessage({
    type = 'autocompletePatients', 
    patients = data
  });
end)

RegisterNetEvent('tablet_ems:setClosestPlayer')
AddEventHandler('tablet_ems:setClosestPlayer', function(id, name)
  SendNUIMessage({
	type = 'closestPlayer',
	id = id,
	name = name
  });
end)

Citizen.CreateThread(function()	
  while true do
    Citizen.Wait(1)
    if PlayerData.job ~= nil and (PlayerData.job.name == Config.Job.OnDuty or PlayerData.job.name == Config.Job.OffDuty) then
        if IsControlJustPressed(0, Keys["DELETE"]) then
            if PlayerData.job.name == Config.Job.OnDuty then
                if not PoliceGUI then
                    SetNuiFocus(true, true)
                    SendNUIMessage({type = 'open'})
                    PoliceGUI = true
                end
            else
                ESX.ShowNotification("~r~Nie jesteś na służbie!")
            end
        end

        if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
            ESX.ShowNotification('Unieważniłeś/aś zajęcie')
            ESX.ClearTimeout(CurrentTask.Task)
            ClearPedTasks(PlayerPedId())

            CurrentTask.Busy = false
        end
    end
  end
end)

RegisterNUICallback('NUIFocusOff', function()
  SetNuiFocus(false, false)
  PoliceGUI = false
end)

RegisterNUICallback("getTreatments", function()
  TriggerServerEvent("tablet_ems:getTreatments")
end)

RegisterNUICallback("sign", function()
  TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "sign", 1.0)
end)

RegisterNUICallback("fillPatients", function(query)
  TriggerServerEvent("tablet_ems:getPatients", query)
end)

RegisterNUICallback("getPlayerName", function()
  TriggerServerEvent("tablet_ems:getPlayerName")
end)

RegisterNUICallback("createTreatment", function(data)
  TriggerServerEvent("tablet_ems:addTreatment", data['patient'], data['details'], data['price'], data['recovery'])
end)

RegisterNUICallback("getClosestPlayer", function()
  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  if closestPlayer == -1 or closestDistance > 3.0 then
	TriggerEvent("pNotify:SendNotification", {text = _U('no_players')})
	return
  else
    TriggerServerEvent("tablet_ems:getClosestPlayer", closestPlayer.identifier)
  end
end)

function fakturaPlayer(player, ilosc, powod)
  TriggerServerEvent("tablet_ems:SendMessage", player, ilosc, powod)
end

function startTabletAnimation()
  Citizen.CreateThread(function()
	RequestAnimDict(tabletDict)
	while not HasAnimDictLoaded(tabletDict) do
	  Citizen.Wait(0)
	end
	attachObject()
	TaskPlayAnim(GetPlayerPed(-1), tabletDict, tabletAnim, 8.0, -8.0, -1, 50, 0, false, false, false)
  end)
end

function attachObject()
  if tabletEntity == nil then
    Citizen.Wait(380)
	RequestModel(tabletModel)
	while not HasModelLoaded(tabletModel) do
	  Citizen.Wait(1)
	end
	tabletEntity = CreateObject(GetHashKey(tabletModel), 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(tabletEntity, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.12, 0.10, -0.13, 25.0, 170.0, 160.0, true, true, false, true, 1, true)
  end
end

function stopTabletAnimation()
  if tabletEntity ~= nil then
	StopAnimTask(GetPlayerPed(-1), tabletDict, tabletAnim ,8.0, -8.0, -1, 50, 0, false, false, false)
	DeleteEntity(tabletEntity)
	tabletEntity = nil
  end
end