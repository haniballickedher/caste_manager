local VORPcore = exports.vorp_core:GetCore()


VORPcore.Callback.Register('sendWeathertoClient', function(source,callback)
    local weather = exports.weathersync:getWeather()
    callback(weather)
  end)

  VORPcore.Callback.Register('getPlayerCaste', function(source,callback)
    local _source = source
    local user = VORPcore.getUser(_source)
    local charId = (user.getUsedCharacter).charIdentifier
    print(charId)
    local caste 
    local row = MySQL.single.await('SELECT caste from characters WHERE charidentifier = ?', {
        charId
    })
        if not row then 
            print("query returned no caste")
            caste = nil
        else
            caste = row.caste
        end
        print(caste)
       callback(caste)
    end)
 


  RegisterServerEvent('setCaste')
  AddEventHandler('setCaste', function(source, caste)
      local _source = source
      local user = VORPcore.getUser(_source)
      local charId = (user.getUsedCharacter).charIdentifier
      local newCaste= caste
      local rows = MySQL.update.await('UPDATE characters set caste = ? WHERE charidentifier = ?', {
        newCaste, charId
    })
    if rows then print("successfully updated caste") else print("no caste update") end
     
  end)


