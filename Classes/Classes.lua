local DM = DodgeMaster
DM.Classes = {}
local Classes = DM.Classes
local function Class()
    local cls = {}
    cls.__index = cls
    setmetatable(
        cls,
        {
            __call = function(self, ...)
                local instance = setmetatable({}, self)
                instance:New(...)
                return instance
            end
        }
    )
    return cls
end

Classes.Unit = Class()
Classes.LocalPlayer = Class()
Classes.GameObject = Class()
Classes.AreaTrigger = Class()