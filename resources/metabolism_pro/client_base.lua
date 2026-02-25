-- =========================================
-- METABOLISM PRO (FINAL STABLE EXPORT FIX)
-- =========================================

print("^2SURVIVAL PRO MODE STARTED^0")

META = {
    food   = 100,
    water  = 100,
    temp   = 0,
    stress = 79 -- ⭐ เริ่มเข้าเกมที่ 79
}

-- ⭐ export ให้ HUD อ่านได้
exports("GetMeta", function()
    return META
end)

-- ==============================
-- FOOD / WATER DECAY
-- ==============================
CreateThread(function()
    while true do
        Wait(60000)
        META.food  = math.max(0, META.food - 1)
        META.water = math.max(0, META.water - 1)
    end
end)

-- ==============================
-- STRESS FROM COMBAT
-- ==============================
CreateThread(function()

    while true do
        Wait(400)

        local ped = PlayerPedId()

        -- ยิงปืน
        if IsPedShooting(ped) then
            META.stress = math.min(100, META.stress + 3.2)
        end

        -- หมัด / melee
        if IsPedInMeleeCombat(ped) then
            META.stress = math.min(100, META.stress + 1.6)
        end

        -- วิ่ง (นิดเดียว)
        if IsPedSprinting(ped) then
            META.stress = math.min(100, META.stress + 1.1)
        end

        -- ลด stress ช้า ๆ
        if not IsPedShooting(ped) then
            META.stress = math.max(0, META.stress - 1.3)
        end

    end
end)