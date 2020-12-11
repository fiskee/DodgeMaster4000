local DM = DodgeMaster
local GameObject = DM.Classes.GameObject

function GameObject:New(Pointer)
    self.Pointer = Pointer
    self.Name = ObjectName(Pointer)
    self.ObjectID = ObjectID(Pointer)
    self.TypeID, self.Type = GetGameObjectType(Pointer)
end

function GameObject:Update()
    self.NextUpdate = DM.Time + (math.random(100, 800) / 1000)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Distance = self:GetDistance()
    if not self.Name or self.Name == "" then
        self.Name = ObjectName(self.Pointer)
    end
end

function GameObject:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DM.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2))
end

