local VORPcore = exports.vorp_core:GetCore()


VORPcore.Callback.Register('sendWeathertoClient', function(source,callback)
    local weather = exports.weathersync:getWeather()
    callback(weather)
  end)

  VORPcore.Callback.Register('sendCastetoClient', function(source,callback)
    local _source = source
    local Character = VORPcore.getUser(source).getUsedCharacter 
    local CharID  = Character.charidentifier
    local caste 
    MySQL.single('SELECT caste from characters WHERE `charidentifier` = ?', {
        CharID
    }, function(row)
        if not row then 
            caste = nil
        else
            caste = row.caste
        end
        print(caste)
       callback(caste)
    end)
  end)


  RegisterServerEvent('setCaste')
  AddEventHandler('setCaste', function()
      local source = source  -- Get the source of the event
      TriggerClientEvent('updateCaste', source)  -- Pass the source to the client event
  end)