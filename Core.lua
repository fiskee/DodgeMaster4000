DodgeMaster = {}
local DM = DodgeMaster
local Init = false
local LibDraw = LibStub("LibDrawDM-1.0")

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
            LibDraw.clearCanvas()
            LibDraw.SetColorRaw(0, 1, 0)
            if not Init then
                Initialize()
            end
            DM.UpdateOM()
        end
    end
)
