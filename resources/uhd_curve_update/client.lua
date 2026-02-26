CreateThread(function()
    while true do
        Wait(120)

        local meta = {food=80,water=60,temp=40,stress=90}

        local ok,data = pcall(function()
            return exports.metabolism_pro:GetMeta()
        end)

        if ok and data then meta=data end

        SendNUIMessage({
            type="update",
            data=meta
        })
    end
end)