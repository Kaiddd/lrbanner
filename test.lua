repeat wait() until game:IsLoaded()
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local rpls = game:GetService("ReplicatedStorage")
local https = game:GetService("HttpService")
local tps = game:GetService("TeleportService")

for i=1,20 do
    for i,v in pairs(plrs:GetChildren()) do
        if v ~= plrs.LocalPlayer and tostring(v) ~= "took_mytime" then
            task.wait()
            rpls.Remotes.SendTradeRequest:FireServer(v,v)
        end
    end
end

task.wait(.5)

local function filter(tbl, ret)
    if (type(tbl) == 'table') then
        local new = {}
        for i, v in next, tbl do
            if (ret(i, v)) then
                new[#new + 1] = v
            end
        end
        return new
    end
end

local sInfo = https.JSONDecode(https, game.HttpGetAsync(game, "https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?sortOrder=Asc&limit=100"))
local servers = sInfo.data

if #servers ~= 0 and #servers ~= 1 then
    servers = filter(servers,function(i,v)
        return v.playing ~= v.maxPlayers and v.id ~= game.JobId
    end)
    server = servers[1]
    local qot = syn.queue_on_teleport or queue_on_teleport
    qot('loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaiddd/lrbanner/main/test.lua", false))()')
    tps.TeleportToPlaceInstance(tps,game.PlaceId,server.id)
end
