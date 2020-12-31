local DM = DodgeMaster
DM.Units, DM.GameObjects, DM.AreaTriggers = {}, {}, {}
local Units, GameObjects, AreaTriggers = DM.Units, DM.GameObjects, DM.AreaTriggers
local Unit, GameObject, AreaTrigger = DM.Classes.Unit, DM.Classes.GameObject, DM.Classes.AreaTrigger

function DM.Remove(Pointer)
    if Units[Pointer] ~= nil then
        Units[Pointer] = nil
    end
    if GameObjects[Pointer] ~= nil then
        GameObjects[Pointer] = nil
    end
    if AreaTriggers[Pointer] ~= nil then
        AreaTriggers[Pointer] = nil
    end
end

local function UpdateUnits()
    for Pointer, Unit in pairs(Units) do
        if not Unit.NextUpdate or Unit.NextUpdate < DM.Time then
            Unit:Update()
        end
    end
end

local function UpdateGameObjects()
    for _, Object in pairs(GameObjects) do
        if not Object.NextUpdate or Object.NextUpdate < DM.Time then
            Object:Update()
        end
    end
end

local function UpdateAreaTriggers()
    for _, AreaTrigger in pairs(AreaTriggers) do
        if not AreaTrigger.NextUpdate or AreaTrigger.NextUpdate < DM.Time then
            AreaTrigger:Update()
        end
    end
end

function DM.UpdateOM()
    if not DM.Player then
        local Pointer = ObjectPointer("player")
        Units[Pointer] = Unit(Pointer)
        Units[Pointer]:Update()
        DM.Player = Units[Pointer]
    end
    local _, updated, added, removed = GetObjectCount(true, "DM4")
    if updated and #removed > 0 then
        for _, v in pairs(removed) do
            DM.Remove(v)
        end
    end
    if updated and #added > 0 then
        for _, v in pairs(added) do
            if not Units[v] and ObjectIsUnit(v) then
                Units[v] = Unit(v)
            -- elseif not GameObjects[v] and ObjectIsGameObject(v) then
            --     GameObjects[v] = GameObject(v)
            elseif not AreaTriggers[v] and ObjectIsAreaTrigger(v) then
                AreaTriggers[v] = AreaTrigger(v)
            end
        end
    end
    UpdateUnits()
    -- UpdateGameObjects()
    UpdateAreaTriggers()
end
