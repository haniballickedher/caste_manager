local VORPcore = exports.vorp_core:GetCore()
local playerCaste
local isTransformed

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


Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local weather = VORPcore.Callback.TriggerAwait('sendWeathertoClient', source)
        local isNight = VORPcore.Callback.TriggerAwait('isNight', source)
        local interiorId = GetInteriorFromEntity(playerPed)
        -- Fetch user caste if not already fetched
        if playerCaste == nil then
            TriggerEvent('getUserCaste')
        end
        -- Find player caste configuration
        local found, playerCasteConfig = tableContainsField(Castes, "castename", playerCaste)
        -- Check if player caste config is found and sun drain conditions are met
        
        if found and playerCasteConfig.sundrain and tableContains(Config.SundrainWeather, weather) and not isNight and interiorId == 0 then
            print("Player caste is in SunDrainCastes, weather is " ..
            weather .. ", and it is daytime and they are not indoors")
            local currentHealth = GetEntityHealth(playerPed)
            if currentHealth > 0 then
                print("sundrain " .. Config.SunDrainHealthPoints)
                SetEntityHealth(playerPed, currentHealth - Config.SunDrainHealthPoints)     -- Reduce health
            end
            Citizen.Wait(Config.SunDrainTick)
        end

        --autotransform night

        if found then 
                print("found it") 
                print(playerCasteConfig)
            else 
                print("not found") 
            end
    --and tableContains(Config.AutoTransformWeather, weather) ADD THIS BACK WHEN YOU FIX EVERYTHING ELSE
        if found and playerCasteConfig.autotransform and isNight then
            --met the conditioners but skip if already transformed
            if not isTransformed then
                local transformModel = playerCasteConfig.transformmodel
                transformInto(transformModel)
                print("Transformed to model:", transformModel)
                isTransformed = true
            end           
        --so the conditions are NOT met, and therefore if they are transformed, the transformation needs to be removed.  
        elseif isTransformed then
            ExecuteCommand('rc')
            isTransformed =false

        end 

        --autotransform day
    end
end)







RegisterNetEvent("caste_manager:useTransformItem")
AddEventHandler("caste_manager:useTransformItem", function(item)
    if playerCaste then
        local found, casteInfo = tableContainsField(Castes, "castename", playerCaste)
        if found then
            print(casteInfo.castename .. ": " .. casteInfo.transformitem .. " vs " .. playerCaste .. ": " .. item)
            if casteInfo.transform and casteInfo.transformitem == item then
                local transformModel = casteInfo.transformmodel
                transformInto(transformModel)
                print("Transformed to model:", transformModel)
                return -- Exit the function once transformation is done
            else
                print("This item does not work for this player")
            end
        else
            print("No matching transformation found for player caste:", playerCaste)
        end
    else
        print("Failed to retrieve player caste.")
    end
end)


RegisterCommand("setCaste", function()
    local myInput = {
        type = "enableinput",
        inputType = "input",
        button = "Set",
        placeholder = "Caste",
        style = "block",
        attributes = {
            inputHeader = "Set User Caste",
            type = "text",
            pattern = "[A-Za-z]+",
            title = "Caste Name",
            style = "border-radius: 10px; background-color: ; border:none;"
        }
    }

    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
        if result and result ~= "" then
            print("Entered caste:", result)
            local found, _ = tableContainsField(Castes, "castename", result)
            if found then
                print("Caste exists in config. Updating...")
                TriggerServerEvent('caste_manager:setCaste', result)
                playerCaste = result
            else
                print("Caste does not exist in config.")
                -- Handle the case where the entered caste does not exist in the configuration
            end
        else
            print("Input is empty")
            -- Handle the case where the input is empty
        end
    end)
end)

RegisterCommand("casteMenu", function()
    FeatherMenu = exports['feather-menu'].initiate()
    OpenCasteMenu()
end)
