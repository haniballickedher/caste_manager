local VORPcore = exports.vorp_core:GetCore()


VORPcore.Callback.Register('sendWeathertoClient', function(source, callback)
  local weather = exports.weathersync:getWeather()
  callback(weather)
end)

VORPcore.Callback.Register('isNight', function(source, callback)
  local timeTable = exports.weathersync:getTime()
  local hours = timeTable.hour
  -- Determine if the current hour is nighttime
  local nighttime = isNighttime(hours)
  -- Print the result
  if nighttime then
    callback(true)
  else
    callback(false)
  end
end)




VORPcore.Callback.Register('getPlayerCaste', function(source, callback)
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
  local character = user.getUsedCharacter()   -- Call the function to obtain the character object
  local charId = character.charIdentifier
  local newCaste = caste
  local rows = MySQL.update.await('UPDATE characters SET caste = ? WHERE charidentifier = ?', {
    newCaste, charId
  })
  if rows then
    print("Successfully updated caste")
    -- Check if the new caste is in Config.CasteHeights and get its height
    local height = getCasteHeight(newCaste)
    if height then
      -- Update ped height to new size
      local currentSkin = character.skin

      -- Convert the JSON string to a Lua table
      local currentSkinTable = json.decode(currentSkin)

      -- Update the scale in the skin table
      currentSkinTable.scale = height

      -- Convert the Lua table back to a JSON string
      local updatedSkin = json.encode(currentSkinTable)

      -- Update the character's skin with the modified scale
      Character.updateSkin(updatedSkin)

      print("Scale updated to:", height)
    
    end
  else
    print("No caste update")
  end
end)



exports('setPlayerCaste', function(source, caste)
  TriggerClientEvent('setCaste', source, caste)
end)
