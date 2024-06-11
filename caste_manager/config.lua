Config = {}
Config.Debug = true


Config.SunDrainTick = 5000 --Milliseconds, less frequently is better
Config.HeathBoostCastes = {}  -- All castes that are tanky
Config.SunProtectionItems = {}  -- Items that protect from Sun Damage
Config.InvisibilityCastes = {}

Config = {
    DefaultCaste = "Human",
    SundrainWeather = {"sunny", "cloudy"},
    SunDrainHealthPoints = 10, --Health Drain per "Tic"
    AutoTransformWeather = {"sunny", "cloudy"},
}


Config.TransformCommand = "transform"
Config.NightStart = 22  --hour on a 24 hour clock - 22 = 10:00 pm
Config.NightEnd = 5 --hour on a 24 hour clock 

Config.Webhooks={
    URL ='https://discord.com/api/webhooks/1208339239113072650/3kmLfypiWqhYVCtavLrVcy9kj64kuQDSHVjRAaBRPH9W1utA3u9ipWV4v8Un1TN4cLSV',
    Color = '16711680',
    WebhookName = 'Caste Manager Bot',
    WebhookLogo = ''
}