ESX = exports["es_extended"]:getSharedObject()



  CreateThread(function()  
	while true do 
        local sleep = 1000
        local isinside, distance, garage, garagename, garagelabel
        for k,v in pairs(Config.Garage) do
            local playerc = GetEntityCoords(PlayerPedId())
            local coords = v.Pos
            local disttomarker = #(playerc - coords)
            if disttomarker < 10 then
                distance = disttomarker
                isinside = true
                garage = v
                garagename = k
            end
        end
        if isinside then
            sleep = 3
            local x,y,z = table.unpack(garage.Pos)
            DrawMarker(36, x, y, z , 0.0, 0.0, 0.0, 0.0, 0, 0.0, 1.0, 1.0, 1.0, 128, 128, 0, 50, false, true, 2, nil, nil, false)
            if distance < 5 then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    lib.showTextUI('Tryk [E] for at parkere')
                    if IsControlJustPressed(0, 38) then
                        Parker(garagename)
                    end
                else
                    lib.showTextUI('Tryk [E] For at tilgå garagen')
                    if IsControlJustPressed(0, 38) then
                        openGarage(garagename, garage.Label)
                    end
                end
            else
                lib.hideTextUI()
            end
        else
            sleep = 1000
        end
        Wait(sleep)
	end
end)

function Parker(garagename)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local plate = ESX.Game.GetVehicleProperties(vehicle).plate
    local archetypeName = GetEntityArchetypeName(vehicle)
    local props = ESX.Game.GetVehicleProperties(vehicle)
    local label = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
   
    TriggerServerEvent("Lindholm_garage:updatevehicles", label, archetypeName, plate, garagename, props)
    ESX.Game.DeleteVehicle(vehicle)
end

function openGarage(garagename, garagelabel)
    ESX.TriggerServerCallback("lindholm_garage:getVehicles", function(vehicles)
        SendNUIMessage({
            opengarage = true,
            garage = garagelabel,
            vehicles = json.encode(vehicles),
        })
    end, garagename)
    SetNuiFocus(true, true)
end

RegisterNUICallback("garage", function(data,cb)
    local action = data.action

    if action == "close" then
        SetNuiFocus(false)
        cb("ok")
    elseif action == "spawncar" then
        local model, plate = data.model, data.plate
        SpawnVehicle(model, plate)
        cb("ok")
        SetNuiFocus(false)
    end
end)

function SpawnVehicle(model, plate)
    local model = model
    local playerPed = PlayerPedId()
    local playerc = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    
    ESX.TriggerServerCallback("lindholm_garage:getVehicleData", function(resp)
        ESX.Game.SpawnVehicle(resp.model, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function(vehicle)
            SetVehicleNumberPlateText(vehicle, resp.plate)
            ESX.Game.SetVehicleProperties(vehicle, json.decode(resp.props))
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        end)
    end, plate)


end