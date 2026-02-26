-- =========================================
-- HUD CURVE (SYNC REAL STRESS + SAFE HIDE)
-- =========================================

SetNuiFocus(false,false)

-- ⭐ cache ค่า stress จริง
local currentStress = 79.0

-- ⭐ รับค่าจาก metabolism_pro / DRUNK ENGINE
RegisterNetEvent("hud_curve:updateStress")
AddEventHandler("hud_curve:updateStress", function(value)
    currentStress = value or currentStress
end)

-- =========================================
-- MAIN UPDATE LOOP
-- =========================================
CreateThread(function()

    while true do
        Wait(150)

        local ped = PlayerPedId()
        if not DoesEntityExist(ped) then
            goto continue
        end

        local coords = GetEntityCoords(ped)
        local temperature = GetTemperatureAtCoords(coords.x, coords.y, coords.z)

        local meta = {
            food   = 100.0,
            water  = 100.0,
            stress = currentStress,
            temp   = temperature
        }

        -- ดึงเฉพาะ food / water
        local ok, data = pcall(function()
            return exports.metabolism_pro:GetMeta()
        end)

        if ok and data then
            if data.food  then meta.food  = data.food  end
            if data.water then meta.water = data.water end
        end

        SendNUIMessage({
            type = "update",
            data = meta
        })

        ::continue::
    end

end)

-- =========================================
-- AUTO HIDE LIKE ROCKSTAR UI
-- =========================================
CreateThread(function()

    while true do
        Wait(100)

        local hide = false

        -- 🗺️ เปิด MAP
        if IsAppActive and IsAppActive(`MAP`) then
            hide = true
        end

        -- 🎯 Weapon Wheel (TAB)
        if IsControlPressed(0, 0x4CC0E2FE) then
            hide = true
        end

        -- ⏸️ Pause Menu
        if IsPauseMenuActive() then
            hide = true
        end

        -- 🎬 เกมซ่อน HUD (cinematic / cutscene)
        if IsHudHidden() then
            hide = true
        end

        SendNUIMessage({
            type = "toggle",
            show = not hide
        })

    end

end)