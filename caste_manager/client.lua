local VORPcore = exports.vorp_core:GetCore()
local playerCaste 

RegisterNetEvent("vorp:SelectedCharacter", function(charid)
    TriggerClientEvent('getUserCaste', targetServerId)
 end)

 RegisterNetEvent('getUserCaste')
 AddEventHandler('getUserCaste', function(source)
     local Character = VORPcore.getUser(source).getUsedCharacter 
     local CharID = Character.Identifier
     playerCaste = VORPcore.Callback.TriggerAwait('getPlayerCaste', CharID)
     if playerCaste then 
         Debug.print("Player Caste Updated: " .. playerCaste)
     else
         Debug.print("No Caste. Defaulting to Human")
         playerCaste = Config.DefaultCaste
     end
 end)

-- Sundrain
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local weather = VORPcore.Callback.TriggerAwait('sendWeathertoClient', source)
        Debug.print(weather)

        if playerCaste == "Vampire" and isWeatherInConditions(weather) then
            Debug.print("Player is vampire and weather is " .. weather)
            local currentHealth = GetEntityHealth(playerPed)
            if currentHealth > 0 then
                SetEntityHealth(playerPed, currentHealth - 1) -- Reduce health by 1
            end
        end
        Citizen.Wait(5000) --maybe once a minute is plenty here but this is for testing
    end
end)

---Weather Table Compare
function isWeatherInConditions(weather)
    for _, condition in ipairs(Config.SundrainWeather) do
        if weather == condition then
            return true
        end
    end
    return false
end