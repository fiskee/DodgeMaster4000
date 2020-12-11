local DM = DodgeMaster
local Unit = DM.Classes.Unit
local LibDraw = LibStub("LibDrawDM-1.0")

function Unit:New(Pointer)
    self.Pointer = Pointer
    self.Name = not UnitIsUnit(Pointer, "player") and UnitName(Pointer) or "LocalPlayer"
    self.CombatReach = UnitCombatReach(Pointer)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(Pointer)
    self.ObjectID = ObjectID(Pointer)
    self.LoSCache = {}
end

function Unit:Update()
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    if self.Name == "LocalPlayer" then
        self.NextUpdate = DM.Time
    else
        self.NextUpdate = DM.Time + (math.random(300, 1500) / 10000)
        self.Distance = self:GetDistance()
        if self.Distance > 50 then
            self.NextUpdate = DM.Time + (math.random(500, 1000) / 1000)
        end 
        if self.Name == "Unknown" then
            self.Name = UnitName(self.Pointer)
        end
    end
    if DM.Settings.Draw then
        self:Draw()
    end
end

function Unit:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DM.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2)) - ((self.CombatReach or 0) + (OtherUnit.CombatReach or 0))
end

function Unit:RawDistance(OtherUnit)
    OtherUnit = OtherUnit or DM.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2))
end

function Unit:LineOfSight(OtherUnit)
    OtherUnit = OtherUnit or DM.Player
    if self.LoSCache.Result ~= nil and self.PosX == self.LoSCache.PosX and self.PosY == self.LoSCache.PosY and self.PosZ == self.LoSCache.PosZ and OtherUnit.PosX == self.LoSCache.OPosX and OtherUnit.PosY == self.LoSCache.OPosY and OtherUnit.PosZ == self.LoSCache.OPosZ then
        return self.LoSCache.Result
    end
    self.LoSCache.Result = TraceLine(self.PosX, self.PosY, self.PosZ + 2, OtherUnit.PosX, OtherUnit.PosY, OtherUnit.PosZ + 2, 0x100010) == nil
    self.LoSCache.PosX, self.LoSCache.PosY, self.LoSCache.PosZ = self.PosX, self.PosY, self.PosZ
    self.LoSCache.OPosX, self.LoSCache.OPosY, self.LoSCache.OPosZ = OtherUnit.PosX, OtherUnit.PosY, OtherUnit.PosZ
    return self.LoSCache.Result
end

function Unit:HasFlag(Flag)
    return bit.band(ObjectDescriptor(self.Pointer, GetOffset("CGUnitData__Flags"), "int"), Flag) > 0
end

function Unit:HasMovementFlag(Flag)
    local SelfFlag = UnitMovementFlags(self.Pointer)
    if SelfFlag then
        return bit.band(UnitMovementFlags(self.Pointer), Flag) > 0
    end
    return false
end

function Unit:Draw()
    local CastID, ChannelID = UnitCastID(self.Pointer)
    local Cast = DM.Enums.Casts[CastID] or DM.Enums.Casts[ChannelID]
    if Cast then
        LibDraw.SetColorRaw(0, 1, 0)
        if Cast[1] == "rect" then
            self:DrawRect(Cast[2], Cast[3])
        elseif Cast[1] == "cone" then
            self:DrawCone(Cast[2], Cast[3])
        end
        self.NextUpdate = DM.Time
    end
end

function Unit:DrawRect(Width, Length)
    local function IsInside(x, y, ax, ay, bx, by, dx, dy)
        local bax = bx - ax
        local bay = by - ay
        local dax = dx - ax
        local day = dy - ay
        if ((x - ax) * bax + (y - ay) * bay <= 0.0) then
            return false
        end
        if ((x - bx) * bax + (y - by) * bay >= 0.0) then
            return false
        end
        if ((x - ax) * dax + (y - ay) * day <= 0.0) then
            return false
        end
        if ((x - dx) * dax + (y - dy) * day >= 0.0) then
            return false
        end
        return true
    end
    local Rotation = select(2, ObjectFacing(self.Pointer)) or 0
    local halfWidth = Width / 2
    local nlX, nlY, nlZ = GetPositionFromPosition(self.PosX, self.PosY, self.PosZ, halfWidth, Rotation + rad(90), 0)
    local nrX, nrY, nrZ = GetPositionFromPosition(self.PosX, self.PosY, self.PosZ, halfWidth, Rotation + rad(270), 0)
    local flX, flY, flZ = GetPositionFromPosition(nlX, nlY, nlZ, Length, Rotation, 0)
    local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, Length, Rotation, 0)
    if IsInside(DM.Player.PosX, DM.Player.PosY, nlX, nlY, nrX, nrY, frX, frY) then
        LibDraw.SetColorRaw(1, 0, 0)
    end
    DM.Helpers.DrawLine(flX, flY, DM.Player.PosZ, nlX, nlY, DM.Player.PosZ)
    DM.Helpers.DrawLine(frX, frY, DM.Player.PosZ, nrX, nrY, DM.Player.PosZ)
    DM.Helpers.DrawLine(frX, frY, DM.Player.PosZ, flX, flY, DM.Player.PosZ)
    DM.Helpers.DrawLine(nlX, nlY, DM.Player.PosZ, nrX, nrY, DM.Player.PosZ)
end

function Unit:DrawCone(Angle, Length)
    local Rotation = select(2, ObjectFacing(self.Pointer))
    if UnitIsFacing(self.Pointer, "player", Angle / 2) and self:RawDistance(DM.Player) <= Length then
        LibDraw.SetColorRaw(1, 0, 0)
    end
    LibDraw.Arc(self.PosX, self.PosY, self.PosZ, Length, Angle, Rotation)
end