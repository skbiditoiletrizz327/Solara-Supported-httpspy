--> NOTE: This is only a simple spy and you can improve it however you want
local oldGame = game

local Stored = {
    request
}

local BlacklistedUrls = {
    "https://roblox.com" -- blacklisted go in here
}

local function hooked(Url)
    if table.find(BlacklistedUrls,Url) then 
        print(`A blacklisted url was called: {Url}`)
        return 
    end 

    print(`Url called: {Url}`)
    return oldGame:HttpGet(Url)
end

getgenv().request = function(info)
    if info.Url and not table.find(BlacklistedUrls,info.Url) then 
        print(`A http request was made to {info.Url}`)
        return Stored[1](info)
    end 
end 

getgenv().game = setmetatable({}, {
    __index = function(index, method)
        local success,response = pcall(function()
            return oldGame[method]
        end)

        if method == "HttpGet" then
            return function(index, url)
                return hooked(url) or hooked
            end
        elseif response and type(response) == "function" then
            return function(index,func)
                return response(oldGame, func)
            end
        else
            return oldGame:GetService(method) or oldGame[method]
        end
    end
})
