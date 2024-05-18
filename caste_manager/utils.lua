-- Function to determine if the current hour is nighttime
function isNighttime(hour)
    if Config.NightStart < Config.NightEnd then
      -- Case where night start and end are on the same day
      return hour >= Config.NightStart and hour < Config.NightEnd
    else
      -- Case where night wraps around midnight
      return hour >= Config.NightStart or hour < Config.NightEnd
    end
  end
  
  -- Utility function to get the height of a caste
  function getCasteHeight(caste)
    for _, pair in ipairs(Config.CasteHeights) do
        if pair[1] == caste then
            return pair[2]
        end
    end
    return nil
  end

  --Any Table Compare
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end