DodgeMaster = {}
local DM = DodgeMaster
local Init = false

local function DefaultSettings()
end

local function Initialize()
    if not DodgeMasterSettings then
        DodgeMasterSettings = {
            Draw = true,
            Sound = true,
            Developer = false
        }
    end
    DM.Settings = DodgeMasterSettings
    Init = true
end

local f = CreateFrame("Frame", "DoMeWhen", UIParent)
f:SetScript(
    "OnUpdate",
    function(self, elapsed)
        DM.Time = GetTime()
        if EWT ~= nil then
            LibStub("LibDrawDM-1.0").clearCanvas()
            if not Init then
                Initialize()
            end
            DM.UpdateOM()
        end
    end
)
