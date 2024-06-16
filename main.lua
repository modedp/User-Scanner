--[[ Credits To:
   __   .  
  /_/  / /   /   |
 /__/ / /__ /__  .
       __  __
      /_/ /_ 
     /  .__/.

To actually use you must copy paste this whole script into the command bar.
]]

--[[ TARGET RANGE ]]
_G = _G
local start = 21820000 --[[starting user id, usually the first user ID of the day]]
local limit = 28000
local mustHaves = {20418658,139152472} --[[inventory items to look for in non termed accounts]]
_G.i = _G.i or limit --[[how many accounts to scan for, from top to bottom, usually the amount of users after that user that exist on that day]]
--[[dont touch]]
_G.gets = _G.gets or {}
_G.going = true --[[manually type true or false in console to stop or cancel any ongoing searches]]
_G.fails = 0
_G.findtermed = true

while _G.going do 
    local success, attempt = pcall(function()
        return game:GetService("Players"):GetCharacterAppearanceInfoAsync(start+_G.i) or game:GetService("Players"):GetHumanoidDescriptionFromUserId(start+_G.i) 
    end) 
    if success then
        _G.fails = 0
        _G.i = math.clamp(_G.i - 1,0,28000) --[[ scan for successful accounts / avatars wont load for termed users]]
        if not _G.findtermed and attempt.assets then
          local gots = {} 
          for i = 1, #attempt.assets do 
              local info = attempt.assets[i] 
              if table.find(mustHaves,info.id) then 
                  table.insert(gots,info.id) 
              end 
          end 
          if _G.i == 0 then print("ALL DONE") break end
          task.wait(0.1)
        end
    elseif tostring(attempt or ""):find("failed because HTTP 400") and _G.fails > 10 then
        print("passed term check")
        if _G.findtermed then
          _G.fails = 0
          local p,user = pcall(game:GetService("Players").GetNameFromUserIdAsync,game.Players,start+_G.i)
          --[[usually users are wiped with name and id both not working]]
          _G.gets[start+_G.i] = p and user or _G.i
          _G.i = math.clamp(_G.i - 1,0,28000)
        end
    end
    _G.fails = _G.fails + 1
    task.wait(0.1)
    if (_G.fails>100) then break end
end 
