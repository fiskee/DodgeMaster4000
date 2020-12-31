local DM = DodgeMaster
local AreaTrigger = DM.Classes.AreaTrigger
local LibDraw = LibStub("LibDrawDM-1.0")

function AreaTrigger:New(Pointer)
    self.Pointer = Pointer
    self.Name = ObjectName(Pointer)
    self.ObjectID = ObjectID(Pointer)
end

function AreaTrigger:Update()
    self.NextUpdate = DM.Time + (math.random(100, 800) / 1000)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Distance = self:GetDistance()
    if not self.Name or self.Name == "" then
        self.Name = ObjectName(self.Pointer)
    end
    if DM.Settings.Draw then
        self:Draw()
    end
end

function AreaTrigger:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DM.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2))
end

function AreaTrigger:Draw()
    local Trigger = DM.Enums.Triggers[self.ObjectID]
    if Trigger then
        LibDraw.SetColorRaw(0, 1, 0)
        if Trigger[1] == "rect" then
            self:DrawRect(Trigger[2], Trigger[3])
        elseif Trigger[1] == "cone" then
            self:DrawCone(Trigger[2], Trigger[3])
        end
        self.NextUpdate = DM.Time
    end
end

function AreaTrigger:DrawRect(Length, Width)
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

function AreaTrigger:DrawCone(Angle, Length)
    local Rotation = select(2, ObjectFacing(self.Pointer))
    if UnitIsFacing(self.Pointer, "player", Angle / 2) and self:RawDistance(DM.Player) <= Length then
        LibDraw.SetColorRaw(1, 0, 0)
    end
    LibDraw.Arc(self.PosX, self.PosY, self.PosZ, Length, Angle, Rotation)
end
