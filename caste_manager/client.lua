local VORPcore = exports.vorp_core:GetCore()
local playerCaste 

RegisterNetEvent("vorp:SelectedCharacter", function(charid)
    TriggerEvent('getUserCaste')
 end)

 RegisterNetEvent('getUserCaste')
 AddEventHandler('getUserCaste', function(source)
     playerCaste = VORPcore.Callback.TriggerAwait('getPlayerCaste')
     if playerCaste then 
         print("Player Caste Updated: " .. playerCaste)
     else
         print("No Caste. Defaulting to Human")
         playerCaste = Config.DefaultCaste
     end
 end)

-- Sundrain
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local weather = VORPcore.Callback.TriggerAwait('sendWeathertoClient', source)
        local isNight = VORPcore.Callback.TriggerAwait('isNight', source)
        print(weather)
        if playerCaste == nil then TriggerEvent('getUserCaste') end
        if table.contains(Config.SunDrainCastes, playerCaste) and table.contains(Config.SundrainWeather, weather) and not isNight then
            print("Player caste is in SunDrainCastes, weather is " .. weather .. ", and it is nighttime")
            local currentHealth = GetEntityHealth(playerPed)
            if currentHealth > 0 then
                SetEntityHealth(playerPed, currentHealth - Config.SunDrainHealthPoints) -- Reduce health
            end
        end
        Citizen.Wait(Config.SunDrainTick) -- maybe once a minute is plenty here but this is for testing
    end
end)


--Any Table Compare
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end