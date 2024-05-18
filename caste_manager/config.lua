Config = {}
Config.Debug = true
Config.DefaultCaste = "Human"
Config.SundrainWeather = {"sunny", "cloudy"}
Config.SunDrainCastes = {"Vampire", "Werewolf"}  -- All Castes that have damage due to sun.
Config.SunDrainHealthPoints = 10  --Health Drain per "Tic"
Config.SunDrainTick = 5000 --Milliseconds, less frequently is better
Config.HeathBoostCastes = {}  -- All castes that are tanky
Config.SunProtectionItems = {}  -- Items that protect from Sun Damage
Config.InvisibilityCastes = {}
Config.CasteHeights = {
    {"Bezerker", 1.3},
    {"Gnome", .6},
}


Config.TransformCastes = {
    {
        {"Vampire", "A_C_Bat_01"},
        {"Bezerker", "A_C_Bear_01"},
        {"Werewolf", "A_C_Wolf"}

    }

}
Config.TransformCommand = "transform"
Config.NightStart = 22  --hour on a 24 hour clock - 22 = 10:00 pm
Config.NightEnd = 5 --hour on a 24 hour clock 

Config.Webhooks={
    URL ='https://discord.com/api/webhooks/1208339239113072650/3kmLfypiWqhYVCtavLrVcy9kj64kuQDSHVjRAaBRPH9W1utA3u9ipWV4v8Un1TN4cLSV',
    Color = '16711680',
    WebhookName = 'Election Bot',
    WebhookLogo = ''
}