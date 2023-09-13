ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent("Lindholm_garage:updatevehicles")
AddEventHandler("Lindholm_garage:updatevehicles", function(label, model, plate, garagename, props)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.insert('INSERT INTO vehicle_garage (identifier, label, model, plate, garage, props) VALUES (?, ?, ?, ?, ?, ?)', {xPlayer.identifier, label, model, plate, garagename, json.encode(props)},
    function(fixed)
        print("worked")
    end)
end)


ESX.RegisterServerCallback("lindholm_garage:getVehicleData",function(source, cb, plate)
    MySQL.Async.fetchAll("Select * FROM `vehicle_garage` WHERE plate = @plate ", {
        ["@plate"] = plate,
    }, function(response)
        if response then 
            MySQL.Async.execute('DELETE FROM `vehicle_garage` WHERE plate = @plate', {
                ["@plate"] = plate,
            }, function(executed)
                print("Deleted: ", plate)
            end)
            cb(response[1])
        end
    end)
end)
ESX.RegisterServerCallback("lindholm_garage:getVehicles",function(source, cb, garage)
    local garage = garage
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicles = {}

    MySQL.Async.fetchAll("Select * FROM `vehicle_garage` WHERE identifier = @identifier AND garage = @garage", {
        ["@identifier"] = xPlayer.identifier,
        ["@garage"] = garage,
    }, function(response)
        for k,v in pairs(response) do
            table.insert(vehicles,
        {
            plate = v.plate,
            model = v.model,
            props = v.props,
            label = v.label
        })
    end
    cb(vehicles)

    end)
end)