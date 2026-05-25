ZMS = ZMS or {}
ZMS.Rec765 = ZMS.Rec765 or {}


CreateClientConVar("765_rec_dur1", "0", true, true)
CreateClientConVar("765_rec_dur2", "0", true, true)
CreateClientConVar("765_rec1", "https://steamusercontent-a.akamaihd.net/ugc/13614774836284261489/0D1AFCAED2F09DCB354A1DB285231C025695E2E0/", true, true)
CreateClientConVar("765_rec2", "https://steamusercontent-a.akamaihd.net/ugc/9499205620757309889/D44F090374929A59ED4BF5C7FA3A2A642547BE30/", true, true)

local TRACK_KEYS = {
    {
        urlKey = "765.Rec1",
        urlcvar = "765_rec1",
        durcvar = "765_rec_dur1"
    },
    {
        urlKey = "765.Rec2",
        urlcvar = "765_rec2",
        durcvar = "765_rec_dur2"
    }
}

if SERVER then
    util.AddNetworkString("765.RecReady")

    ZMS.Rec765.Ready = {}

    net.Receive("765.RecReady", function(_, ply)
        local str = net.ReadString()
        ZMS.Rec765.Ready[ply] = table.Flip(string.Explode(",", str))
    end)

    function ZMS.Rec765.AllReady(targetPly, idx)
        local key = string.format("%s.%d", targetPly:SteamID64(), idx)
        for _, ply in player.Iterator() do
            if not ZMS.Rec765.Ready[ply] or not ZMS.Rec765.Ready[ply][key] then
                return false
            end
        end
        return true
    end

    function ZMS.Rec765.GetDuration(ply, idx)
        local cvar = TRACK_KEYS[idx] and TRACK_KEYS[idx].durcvar
        if not cvar then return 0 end

        local url = Cfg765.MapMessages and Cfg765.MapMessages[idx] or ply:GetInfo(TRACK_KEYS[idx].urlcvar, "")
        if #url < 7 or string.sub(url, 1, 7) ~= "file://" then return ply:GetInfoNum(cvar, 0) end

        local _, dur = unpack(string.Explode(",", string.sub(url, 8)))
        return tonumber(dur) or ply:GetInfoNum(cvar, 0)
    end

    timer.Create("765.RecUrls", 1, 0, function()
        for _, ply in player.Iterator() do
            for idx, info in ipairs(TRACK_KEYS) do
                ply:SetNW2String(info.urlKey, ply:GetInfo(info.urlcvar) or "")
            end
        end
    end)

    hook.Add("PlayerDisconnected", "765.RecDisconnected", function(ply)
        ZMS.Rec765.Ready[ply] = nil
    end)

    return
end


ZMS.Rec765.PlySeen = {}
ZMS.Rec765.SndCache = {}

local function ensureTable(tbl, key)
    tbl[key] = tbl[key] or {}
    return tbl[key]
end

local function isValidAudioURL(url)
    if not url or url == "" then return false end
    url = string.Trim(url)
    return (
        string.StartWith(url, "http://") or
        string.StartWith(url, "https://")
    )
end

local function setDurationConVar(durcvar, duration)
    duration = tonumber(duration) or 0
    RunConsoleCommand(durcvar, tostring(duration))
end

local function destroySound(snd)
    if IsValid(snd) then snd:Stop() end
    if snd and snd.__gc then snd:__gc() end
end

local function precacheURL(url, cacheOnly, onReady)
    if cacheOnly and ZMS.Rec765.SndCache[url] and ZMS.Rec765.SndCache[url].ready then
        if onReady then
            onReady(ZMS.Rec765.SndCache[url].duration)
        end
        return
    end

    sound.PlayURL(url, "3d noplay mono noblock", function(snd, errid, errname)
        local duration = IsValid(snd) and snd:GetLength() or 0
        ZMS.Rec765.SndCache[url] = {
            duration = duration,
            ready = true
        }

        if errid then
            destroySound(snd)
            if errid ~= 41 then
                MsgC(Color(255, 0, 0), Format("[765 REC CACHE] Sound:'%s'\n\tErrCode:%s, ErrName:%s\n", url, errid, errname))
            elseif GetConVar("metrostroi_drawdebug"):GetInt() ~= 0 then
                MsgC(Color(255, 255, 0), Format("[765 REC CACHE] Sound:'%s'\n\tBASS_ERROR_UNKNOWN (it's normal),ErrCode:%s, ErrName:%s\n", url, errid, errname))
                precacheURL(url, cacheOnly, onReady)
            end
            return
        end

        snd:Play()
        snd:Pause()

        if onReady then
            onReady(duration, snd)
        end

        if cacheOnly then
            print(string.format( "[765 REC CACHE] Cached '%s' (%.2fs)", url, duration ))
            -- Keep the channel alive briefly so BASS fully buffers/caches
            -- then stop it.
            timer.Simple(2, function()
                destroySound(snd)
            end)
        end
    end)
end

local ready = nil

local function processPlayer(ply)
    if not IsValid(ply) then return end

    local plySeen = ensureTable(ZMS.Rec765.PlySeen, ply)

    for idx, info in ipairs(TRACK_KEYS) do
        local url = Cfg765.MapMessages and Cfg765.MapMessages[idx] or ply:GetNW2String(info.urlKey)
        url = string.Trim(url)
        local valid = isValidAudioURL(url)

        if not valid or ZMS.Rec765.SndCache[url] and ZMS.Rec765.SndCache[url].ready then
            table.insert(ready, string.format("%s.%d", ply:SteamID64(), idx))
        end

        if not valid then continue end
        if plySeen[info.urlKey] == url then continue end
        plySeen[info.urlKey] = url

        print(string.format( "[765 REC CACHE] %s changed %s to '%s'", ply:Nick(), info.urlKey, url ))

        precacheURL(url, true, function(duration)
            setDurationConVar(info.durcvar, duration)
        end)
    end
end


function ZMS.Rec765.GetSoundPath(soundId)
    local steamid, idx = unpack(string.Explode(".", soundId))
    idx = tonumber(idx) or 0
    local k = TRACK_KEYS[idx]
    k = k and k.urlKey
    if not k then return end
    local ply = player.GetBySteamID64(steamid)
    if not IsValid(ply) and not (Cfg765.MapMessages and Cfg765.MapMessages[idx]) then return end

    local url = Cfg765.MapMessages and Cfg765.MapMessages[idx] or ply:GetNW2String(k, "")
    if #url < 7 or string.sub(url, 1, 7) ~= "file://" then return end
    local path, dur = unpack(string.Explode(",", string.sub(url, 8)))
    return path, tonumber(dur)
end

function ZMS.Rec765.GetSound(soundId, callback)
    local steamid, idx = unpack(string.Explode(".", soundId))
    idx = tonumber(idx) or 0
    local k = TRACK_KEYS[idx]
    k = k and k.urlKey
    if not k then return end
    local ply = player.GetBySteamID64(steamid)
    if not IsValid(ply) and not (Cfg765.MapMessages and Cfg765.MapMessages[idx]) then return end

    local url = Cfg765.MapMessages and Cfg765.MapMessages[idx] or ply:GetNW2String(k, "")
    if not isValidAudioURL(url) then return end

    precacheURL(url, false, function(duration, snd)
        callback(snd)
    end)
end


local lastPost = ""
timer.Create("765.UserSoundCache", 2, 0, function()
    ready = {}
    for _, ply in ipairs(player.GetAll()) do
        processPlayer(ply)
    end
    local post = table.concat(ready, ",")
    if post ~= lastPost then
        lastPost = post
        net.Start("765.RecReady")
            net.WriteString(post)
        net.SendToServer()
    end
end)


local function ConfigureEntry(e, idx)
    if Cfg765.MapMessages and Cfg765.MapMessages[idx] then
        e:SetEnabled(false)
    else
        e:SetEnabled(true)
    end
end

local function ChuraClientPanel(panel)
    panel:ClearControls()
    panel:SetPadding(0)
    panel:SetSpacing(0)
    panel:Dock( FILL )

    panel:Help("Экстренные сообщения БУ-ИК")
    panel:ControlHelp("Применяются ко всем заспавненным вами 81-760Э и обновляются при каждом изменении.")
    panel:ControlHelp("Становятся доступны как только все игроки кэшировали звук. Если в меню БУ-ИК \"Доп. инфо\" на записи висит маркировка \"запись\" - значит кто-то все еще ее кэширует/скачивает. Видно только на БУ-ИК варианта Метроспецтехники.")
    ConfigureEntry(panel:TextEntry("Запись №1", "765_rec1"), 1)
    ConfigureEntry(panel:TextEntry("Запись №2", "765_rec2"), 2)
    panel:ControlHelp("Только прямые ссылки на звук. Некоторые форматы неподдерживаются, гуглите особенности BASS, если необходимо узнать подробности.")
end

hook.Add("PopulateToolMenu", "765.ClientPanel", function()
    spawnmenu.AddToolMenuOption("Utilities", "Metrostroi", "metrostroi765_client_panel", "81-760Э", "", "", ChuraClientPanel)
end)
