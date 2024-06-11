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

-- Utility function to generate a random height within plus or minus 0.1 of the given heightmod

function generateRandomHeight(heightmod)

  local minHeight = math.floor((heightmod - 0.1) * 10) / 10
  local maxHeight = math.ceil((heightmod + 0.1) * 10) / 10
  local randomHeight = math.random(minHeight * 10, maxHeight * 10) / 10
  
  return randomHeight
end


-- Utility function to get the height of a caste
function getCasteHeight(caste)
  for _, casteInfo in ipairs(Castes) do
    if casteInfo.castename == caste then
      if casteInfo.heightmod then
        local heightmod = casteInfo.heightmod
      local randomHeight = generateRandomHeight(heightmod)
      return randomHeight
      end
      end
  end
  return nil
end

-- Function to check if a table contains a value
function tableContains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

-- Helper function to check if a table contains an element with a specific field value
function tableContainsField(table, field, value)
  for _, element in pairs(table) do
    if element[field] == value then
      return true, element
    end
  end
  return false, nil
end

-- Function to get the transform model for a given caste
function getTransformModel(playerCaste)
  for _, casteInfo in ipairs(Castes) do
    if casteInfo.castename == playerCaste then
      return casteInfo.transformmodel
    end
  end
  return nil
end

-- Function to transform the player into a given model
function transformInto(name)
  local model = GetHashKey(name)
  local player = PlayerId()
  if not IsModelValid(model) then return end
  PerformRequest(model)
  if HasModelLoaded(model) then
    Citizen.InvokeNative(0xED40380076A31506, player, model, false)
    Citizen.InvokeNative(0x283978A15512B2FE, PlayerPedId(), true)
    SetModelAsNoLongerNeeded(model)
  end
end

-- Helper function to request a model
function PerformRequest(hash)
  RequestModel(hash, 0)
  local ham = 1
  while not Citizen.InvokeNative(0x1283B8B89DD5D1B6, hash) do
    Citizen.InvokeNative(0xFA28FE3A6246FC30, hash, 0)
    ham = ham + 1
    Citizen.Wait(0)
    if ham >= 100 then break end
  end
end

--Function to create our caste feather menu
function OpenCasteMenu()
  local casteSelected =Config.DefaultCaste
  local MyMenu = FeatherMenu:RegisterMenu('feather:character:menu', {
    top = '40%',
    left = '20%',
    ['720width'] = '500px',
    ['1080width'] = '600px',
    ['2kwidth'] = '700px',
    ['4kwidth'] = '900px',
    style = {
        -- ['height'] = '500px'
        -- ['border'] = '5px solid white',
        -- ['background-image'] = 'none',
        -- ['background-color'] = '#515A5A'
    },
    contentslot = {
        style = { --This style is what is currently making the content slot scoped and scrollable. If you delete this, it will make the content height dynamic to its inner content.
            ['height'] = '300px',
            ['min-height'] = '300px'
        }
    },
    draggable = true,
    --canclose = false
}, {
    opened = function()
        print("MENU OPENED!")
    end,
    closed = function()
        print("MENU CLOSED!")
    end,
    topage = function(data)
        print("PAGE CHANGED ", data.pageid)
    end
})
local MyFirstPage = MyMenu:RegisterPage('first:page')
MyFirstPage:RegisterElement('header', {
  value = 'Caste Menu',
  slot = "header",
  style = {}
})
MyFirstPage:RegisterElement('subheader', {
  value = "Select a Caste",
  slot = "header",
  style = {}
})

-- Generate caste options from the Castes table
local casteOptions = buildCasteOptions(Castes)

-- Register the element with dynamic caste options
MyFirstPage:RegisterElement('arrows', {
  label = "Caste",
  start = 2,
  options = casteOptions
}, function(data)

  print(data.value)
  casteSelected = data.value
  
  
end)

--Button
MyFirstPage:RegisterElement('button', {
  label = "Set Caste",
  style = {

  },

}, function()
  print("here- setting caste")
  TriggerServerEvent('caste_manager:setCaste', casteSelected)
end)

MyMenu:Open({

  startupPage = MyFirstPage,

})
end

function buildCasteOptions(castesTable)
  local options = {}
  for _, caste in ipairs(castesTable) do
      table.insert(options, caste.castename)
  end
  return options
end

