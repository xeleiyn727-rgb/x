--[[
    CustomHubUI - UI library
    Load it with:
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/<user>/<repo>/main/CustomHubUI.lua"))()
    then:
        local Window = Library.CreateWindow({ Title = "My Hub", Subtitle = "v1.0" })
        local Tab = Window:AddTab("Main", "house") -- icon: Lucide name, "rbxassetid://<id>", a single character, or nil
        Tab:AddToggle({ Title = "Auto Farm", Description = "...", Default = false, Callback = function(v) end })
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local Library = {}
Library.Version = "1.1.0"

-- ===== Theme Palettes =====
local Palettes = {
    Dark = {
        Background = Color3.fromRGB(16, 16, 20),
        Sidebar = Color3.fromRGB(19, 19, 23),
        Card = Color3.fromRGB(30, 30, 36),
        CardHover = Color3.fromRGB(35, 36, 43),
        Tile = Color3.fromRGB(38, 40, 48),
        Accent = Color3.fromRGB(80, 145, 190),
        SelectedBG = Color3.fromRGB(48, 68, 92),
        SelectedTile = Color3.fromRGB(66, 96, 130),
        HoverBG = Color3.fromRGB(28, 30, 37),
        Text = Color3.fromRGB(230, 232, 240),
        SubText = Color3.fromRGB(135, 140, 152),
        Line = Color3.fromRGB(38, 38, 46),
        Stroke = Color3.fromRGB(40, 40, 48),
        Toggle_Off = Color3.fromRGB(48, 50, 60),
        PillBG = Color3.fromRGB(22, 38, 54),
        PillText = Color3.fromRGB(70, 175, 235),
        OnAccentText = Color3.fromRGB(255, 255, 255),
    },
    Light = {
        Background = Color3.fromRGB(226, 228, 234),
        Sidebar = Color3.fromRGB(218, 221, 228),
        Card = Color3.fromRGB(255, 255, 255),
        CardHover = Color3.fromRGB(244, 246, 250),
        Tile = Color3.fromRGB(200, 206, 220),
        Accent = Color3.fromRGB(56, 140, 220),
        SelectedBG = Color3.fromRGB(160, 192, 228),
        SelectedTile = Color3.fromRGB(120, 160, 212),
        HoverBG = Color3.fromRGB(208, 212, 222),
        Text = Color3.fromRGB(24, 26, 34),
        SubText = Color3.fromRGB(100, 106, 122),
        Line = Color3.fromRGB(198, 202, 212),
        Stroke = Color3.fromRGB(196, 200, 210),
        Toggle_Off = Color3.fromRGB(208, 214, 228),
        PillBG = Color3.fromRGB(220, 236, 250),
        PillText = Color3.fromRGB(30, 130, 210),
        OnAccentText = Color3.fromRGB(255, 255, 255),
    },
}

-- ===== Font =====
local FAMILY = "rbxasset://fonts/families/Montserrat.json"
local F_Medium = Font.new(FAMILY, Enum.FontWeight.Medium)
local F_Semi   = Font.new(FAMILY, Enum.FontWeight.SemiBold)
local F_Bold   = Font.new(FAMILY, Enum.FontWeight.Bold)

-- ===== Logo (built-in sticker) : {x, y, length, r, g, b} =====
local LOGO_W, LOGO_H = 34, 36
local LOGO_RUNS = {{17,6,1,48,96,96},{16,7,1,96,168,192},{17,7,1,144,216,240},{18,7,1,72,120,144},{15,8,1,96,168,192},{16,8,1,120,216,255},{17,8,1,120,216,240},{18,8,1,144,240,255},{19,8,1,72,120,144},{14,9,1,120,192,216},{15,9,1,144,240,255},{16,9,1,96,168,192},{17,9,1,24,72,96},{18,9,1,120,192,216},{19,9,1,120,192,240},{20,9,1,72,96,144},{25,9,1,72,72,72},{26,9,1,96,96,96},{13,10,1,72,96,120},{14,10,1,96,144,168},{15,10,1,72,120,144},{18,10,1,24,48,48},{19,10,1,72,120,144},{20,10,1,96,120,144},{21,10,1,120,120,144},{22,10,1,144,144,144},{23,10,1,192,192,192},{24,10,1,240,240,240},{25,10,1,192,192,192},{26,10,1,48,48,48},{14,11,1,48,48,48},{15,11,1,96,96,96},{16,11,1,144,144,120},{17,11,1,192,168,168},{18,11,1,192,192,192},{19,11,1,216,216,216},{20,11,1,240,240,240},{21,11,3,255,255,255},{24,11,1,192,192,192},{9,12,1,48,48,48},{10,12,1,72,72,72},{11,12,1,144,120,120},{12,12,1,192,192,192},{13,12,1,216,216,216},{14,12,1,240,240,240},{15,12,4,255,255,255},{19,12,1,240,240,240},{20,12,1,240,240,216},{21,12,1,240,240,240},{22,12,1,255,255,255},{23,12,1,144,144,144},{9,13,1,216,192,192},{10,13,6,255,255,255},{16,13,1,240,240,240},{17,13,1,192,192,192},{18,13,1,96,96,96},{19,13,1,120,144,144},{20,13,1,216,216,216},{21,13,1,255,255,255},{22,13,1,144,144,144},{9,14,1,48,48,72},{10,14,1,216,216,216},{11,14,1,240,255,255},{12,14,1,240,240,240},{13,14,1,240,216,216},{14,14,1,168,168,168},{15,14,1,120,120,120},{16,14,2,48,48,48},{18,14,1,144,144,144},{19,14,1,240,240,240},{20,14,1,255,255,255},{21,14,1,120,120,120},{24,14,1,96,120,144},{25,14,1,24,48,72},{8,15,1,96,96,144},{9,15,1,72,72,120},{10,15,1,48,48,48},{11,15,1,216,216,216},{12,15,1,255,255,255},{13,15,1,240,240,240},{14,15,1,216,216,216},{15,15,1,120,120,120},{17,15,1,48,48,48},{18,15,1,192,192,192},{19,15,1,255,255,255},{20,15,1,96,96,96},{23,15,1,96,120,144},{24,15,1,144,192,255},{25,15,1,144,168,216},{7,16,1,72,96,144},{8,16,1,144,144,216},{9,16,1,168,192,240},{12,16,1,216,216,216},{13,16,3,255,255,255},{16,16,1,216,216,216},{17,16,1,96,96,96},{23,16,1,72,96,144},{24,16,1,96,144,216},{25,16,1,144,192,240},{26,16,1,144,168,192},{6,17,1,72,120,168},{7,17,1,120,168,240},{8,17,1,144,168,240},{9,17,1,48,72,96},{13,17,1,192,192,192},{14,17,4,255,255,255},{18,17,1,216,216,216},{19,17,1,96,96,96},{24,17,1,48,72,120},{25,17,1,120,144,216},{26,17,1,144,168,240},{27,17,1,144,168,216},{6,18,1,96,144,192},{7,18,1,120,168,240},{8,18,1,144,168,240},{9,18,1,48,72,96},{14,18,1,120,120,144},{15,18,1,216,216,216},{16,18,1,255,255,255},{17,18,1,240,240,240},{18,18,2,255,255,255},{20,18,1,216,216,216},{21,18,1,72,72,72},{25,18,1,72,96,168},{26,18,1,120,144,240},{27,18,1,144,192,240},{28,18,1,144,144,168},{7,19,1,96,120,192},{8,19,1,120,168,240},{9,19,1,144,192,240},{10,19,1,72,72,96},{16,19,1,120,120,120},{17,19,1,216,216,216},{18,19,2,255,255,255},{20,19,1,255,255,240},{21,19,1,240,240,240},{22,19,1,72,72,72},{24,19,1,48,48,72},{25,19,1,96,120,192},{26,19,1,144,168,240},{27,19,1,144,168,192},{8,20,1,96,144,192},{9,20,1,120,168,240},{10,20,1,168,192,240},{11,20,1,48,48,72},{13,20,1,72,72,72},{14,20,1,240,240,240},{15,20,1,192,192,192},{16,20,1,72,72,72},{18,20,1,120,120,120},{19,20,1,216,216,216},{20,20,1,240,240,240},{21,20,1,255,255,255},{22,20,1,240,240,240},{23,20,1,72,48,72},{24,20,1,48,48,96},{25,20,1,144,192,240},{26,20,1,120,168,192},{9,21,1,96,120,144},{10,21,1,48,72,96},{12,21,1,72,96,96},{13,21,1,240,240,240},{14,21,1,255,255,255},{15,21,1,168,168,168},{16,21,1,72,72,72},{18,21,1,48,48,48},{19,21,1,144,144,144},{20,21,1,216,216,216},{21,21,2,240,240,240},{23,21,1,240,216,240},{24,21,1,48,48,72},{25,21,1,48,72,96},{11,22,1,96,96,96},{12,22,1,255,255,255},{13,22,1,240,240,240},{14,22,1,144,144,144},{15,22,1,96,96,96},{16,22,1,168,168,168},{17,22,1,240,240,240},{18,22,2,255,255,255},{20,22,1,255,255,240},{21,22,3,255,255,255},{24,22,1,216,240,240},{10,23,1,120,120,120},{11,23,4,240,240,240},{15,23,3,255,255,255},{18,23,1,240,240,240},{19,23,1,216,240,216},{20,23,1,192,192,192},{21,23,1,168,168,168},{22,23,1,120,120,120},{23,23,1,96,96,96},{24,23,1,72,72,72},{9,24,1,144,144,144},{10,24,2,255,255,255},{12,24,1,240,240,255},{13,24,1,216,216,216},{14,24,1,192,192,192},{15,24,1,168,144,168},{16,24,1,120,120,120},{17,24,1,96,96,96},{18,24,1,48,48,48},{8,25,1,168,168,168},{9,25,1,216,216,216},{10,25,1,144,144,144},{11,25,1,96,96,96},{12,25,1,72,72,96},{13,25,1,72,96,120},{14,25,1,48,96,120},{15,25,1,72,120,120},{18,25,1,72,96,120},{19,25,1,144,192,216},{20,25,1,120,168,192},{21,25,1,72,96,120},{13,26,1,24,48,72},{14,26,1,120,168,192},{15,26,1,144,240,240},{16,26,1,96,168,168},{17,26,1,48,120,144},{18,26,1,144,216,240},{19,26,1,120,192,216},{20,26,1,72,120,144},{15,27,1,96,168,168},{16,27,2,120,216,240},{18,27,1,96,192,216},{19,27,1,72,120,120},{16,28,1,96,168,192},{17,28,1,120,192,216},{18,28,1,48,120,120},{17,29,1,72,96,96}}

-- ===== Helpers =====
local function Tween(obj, time, props, style, dir)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(time, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

local function Round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function AddPressEffect(btn, scaleTo)
    local s = Instance.new("UIScale")
    s.Parent = btn
    btn.MouseButton1Down:Connect(function()
        Tween(s, 0.08, { Scale = scaleTo or 0.97 })
    end)
    local function release()
        Tween(s, 0.15, { Scale = 1 }, Enum.EasingStyle.Back)
    end
    btn.MouseButton1Up:Connect(release)
    btn.MouseLeave:Connect(release)
end

local function GetGuiParent()
    local ok, res = pcall(function()
        if gethui then return gethui() end
        return game:GetService("CoreGui")
    end)
    if ok and res then return res end
    return PlayerGui
end

-- ===== Lucide icon resolver =====
local IconLib = nil
local IconLibTried = false

local function ResolveLucide(name)
    if not IconLibTried then
        IconLibTried = true
        local ok, mod = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
        end)
        if ok and type(mod) == "table" then
            IconLib = mod
            if mod.SetIconsType then pcall(mod.SetIconsType, "lucide") end
        end
    end
    if not IconLib then return nil end

    local fn = IconLib.Icon or IconLib.GetIcon
    if not fn then return nil end
    local ok, data = pcall(fn, name)
    if not ok or type(data) ~= "table" then return nil end

    -- supports both {image, {ImageRectSize, ImageRectPosition}} and named fields
    local image = data[1] or data.Image or data.Id
    local rect = data[2] or data
    if not image then return nil end
    return image, rect.ImageRectPosition, rect.ImageRectSize
end

-- =====================================================================
--  Library.CreateWindow(config)
--  config: Title, Subtitle, ToggleKey (Enum.KeyCode), Theme ("Dark"/"Light"), Size (UDim2)
-- =====================================================================
function Library.CreateWindow(config)
    config = config or {}
    local titleString = config.Title or config.Name or "Custom Hub"
    local subtitleString = config.Subtitle
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightShift
    local currentTheme = (config.Theme == "Light") and "Light" or "Dark"
    local windowSize = config.Size or UDim2.fromOffset(500, 400)

    local Theme = {}
    for k, v in pairs(Palettes[currentTheme]) do Theme[k] = v end

    local bindings = {}
    local connections = {}
    local destroyed = false

    local function Connect(signal, fn)
        local c = signal:Connect(fn)
        connections[#connections + 1] = c
        return c
    end

    -- Bind(): keeps a property in sync with the current theme. Call AFTER setting Parent.
    local function Bind(obj, prop, fn)
        bindings[#bindings + 1] = { obj = obj, prop = prop, fn = fn }
        obj[prop] = fn()
    end

    local function ApplyTheme(name)
        if not Palettes[name] then return end
        currentTheme = name
        for k, v in pairs(Palettes[name]) do Theme[k] = v end
        local alive = {}
        for _, b in ipairs(bindings) do
            if b.obj and b.obj.Parent then
                Tween(b.obj, 0.3, { [b.prop] = b.fn() })
                alive[#alive + 1] = b
            end
        end
        bindings = alive -- drop bindings of destroyed objects
    end

    local Window = {}

    -- ===== ScreenGui =====
    local GuiParent = GetGuiParent()
    for _, p in ipairs({ GuiParent, PlayerGui }) do
        local old = p:FindFirstChild("CustomHubUI")
        if old then old:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.AutoLocalize = false
    ScreenGui.DescendantAdded:Connect(function(inst)
        local ok = pcall(function() inst.AutoLocalize = false end)
    end)
    local okParent = pcall(function() ScreenGui.Parent = GuiParent end)
    if not okParent or not ScreenGui.Parent then
        ScreenGui.Parent = PlayerGui
    end

    -- ===== Main Window =====
    local Main = Instance.new("CanvasGroup")
    Main.Name = "Main"
    Main.Size = windowSize
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BorderSizePixel = 0
    Main.GroupTransparency = 1
    Main.Parent = ScreenGui
    Round(Main, 16)
    Bind(Main, "BackgroundColor3", function() return Theme.Background end)

    local MainScale = Instance.new("UIScale")
    MainScale.Scale = 0.85
    MainScale.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1
    MainStroke.Parent = Main
    Bind(MainStroke, "Color", function() return Theme.Stroke end)

    local isOpen = false
    local function OpenWindow()
        isOpen = true
        Main.GroupTransparency = 0
        MainScale.Scale = 1
        Main.Visible = true
    end

    local function CloseWindow()
        isOpen = false
        Main.Visible = false
    end

    -- ===== Title Bar =====
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 46)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Round(TitleBar, 16)
    Bind(TitleBar, "BackgroundColor3", function() return Theme.Background end)

    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 16)
    TitleFix.Position = UDim2.new(0, 0, 1, -16)
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar
    Bind(TitleFix, "BackgroundColor3", function() return Theme.Background end)

    local TitleLine = Instance.new("Frame")
    TitleLine.Size = UDim2.new(1, 0, 0, 1)
    TitleLine.Position = UDim2.new(0, 0, 1, -1)
    TitleLine.BorderSizePixel = 0
    TitleLine.ZIndex = 2
    TitleLine.Parent = TitleBar
    Bind(TitleLine, "BackgroundColor3", function() return Theme.Line end)

    -- Logo sticker
    local LogoIcon = Instance.new("Frame")
    LogoIcon.Name = "LogoSticker"
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Size = UDim2.fromOffset(LOGO_W, LOGO_H)
    LogoIcon.Position = UDim2.fromOffset(9, 5)
    LogoIcon.Parent = TitleBar

    for _, r in ipairs(LOGO_RUNS) do
        local Bar = Instance.new("Frame")
        Bar.BorderSizePixel = 0
        Bar.BackgroundColor3 = Color3.fromRGB(r[4], r[5], r[6])
        Bar.Position = UDim2.fromScale(r[1] / LOGO_W, r[2] / LOGO_H)
        Bar.Size = UDim2.new(r[3] / LOGO_W, 0, 1 / LOGO_H, 1)
        Bar.Parent = LogoIcon
    end

    -- Title + subtitle pill laid out horizontally
    local TitleHolder = Instance.new("Frame")
    TitleHolder.BackgroundTransparency = 1
    TitleHolder.Position = UDim2.fromOffset(50, 0)
    TitleHolder.Size = UDim2.fromOffset(0, 46)
    TitleHolder.AutomaticSize = Enum.AutomaticSize.X
    TitleHolder.Parent = TitleBar

    local TitleLayout = Instance.new("UIListLayout")
    TitleLayout.FillDirection = Enum.FillDirection.Horizontal
    TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TitleLayout.Padding = UDim.new(0, 9)
    TitleLayout.Parent = TitleHolder

    local TitleText = Instance.new("TextLabel")
    TitleText.BackgroundTransparency = 1
    TitleText.Size = UDim2.fromOffset(0, 46)
    TitleText.AutomaticSize = Enum.AutomaticSize.X
    TitleText.FontFace = F_Medium
    TitleText.TextSize = 15
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Text = titleString
    TitleText.LayoutOrder = 1
    TitleText.Parent = TitleHolder
    Bind(TitleText, "TextColor3", function() return Theme.Text end)

    local SubTitlePill = Instance.new("Frame")
    SubTitlePill.Size = UDim2.fromOffset(0, 20)
    SubTitlePill.AutomaticSize = Enum.AutomaticSize.X
    SubTitlePill.LayoutOrder = 2
    SubTitlePill.Visible = subtitleString ~= nil and subtitleString ~= ""
    SubTitlePill.Parent = TitleHolder
    Round(SubTitlePill, 4)
    Bind(SubTitlePill, "BackgroundColor3", function() return Theme.PillBG end)

    local PillPad = Instance.new("UIPadding")
    PillPad.PaddingLeft = UDim.new(0, 6)
    PillPad.PaddingRight = UDim.new(0, 6)
    PillPad.Parent = SubTitlePill

    local SubTitleText = Instance.new("TextLabel")
    SubTitleText.BackgroundTransparency = 1
    SubTitleText.Size = UDim2.fromOffset(0, 20)
    SubTitleText.AutomaticSize = Enum.AutomaticSize.X
    SubTitleText.FontFace = F_Medium
    SubTitleText.TextSize = 11
    SubTitleText.Text = subtitleString or ""
    SubTitleText.Parent = SubTitlePill
    Bind(SubTitleText, "TextColor3", function() return Theme.PillText end)

    -- ===== Sidebar =====
    local SIDEBAR_W = 148

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -46)
    Sidebar.Position = UDim2.new(0, 0, 0, 46)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    Round(Sidebar, 16)
    Bind(Sidebar, "BackgroundColor3", function() return Theme.Sidebar end)

    local SidebarFixTop = Instance.new("Frame")
    SidebarFixTop.Size = UDim2.new(1, 0, 0, 16)
    SidebarFixTop.BorderSizePixel = 0
    SidebarFixTop.Parent = Sidebar
    Bind(SidebarFixTop, "BackgroundColor3", function() return Theme.Sidebar end)

    local SidebarFixRight = Instance.new("Frame")
    SidebarFixRight.Size = UDim2.new(0, 16, 1, 0)
    SidebarFixRight.Position = UDim2.new(1, -16, 0, 0)
    SidebarFixRight.BorderSizePixel = 0
    SidebarFixRight.Parent = Sidebar
    Bind(SidebarFixRight, "BackgroundColor3", function() return Theme.Sidebar end)

    local SideLine = Instance.new("Frame")
    SideLine.Size = UDim2.new(0, 1, 1, 0)
    SideLine.Position = UDim2.new(1, -1, 0, 0)
    SideLine.BorderSizePixel = 0
    SideLine.ZIndex = 2
    SideLine.Parent = Sidebar
    Bind(SideLine, "BackgroundColor3", function() return Theme.Line end)

    -- Search box
    local SearchBox = Instance.new("Frame")
    SearchBox.Size = UDim2.new(1, -24, 0, 34)
    SearchBox.Position = UDim2.fromOffset(12, 14)
    SearchBox.Parent = Sidebar
    Round(SearchBox, 10)
    Bind(SearchBox, "BackgroundColor3", function() return Theme.Card end)

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Thickness = 1
    SearchStroke.Transparency = 1
    SearchStroke.Parent = SearchBox
    Bind(SearchStroke, "Color", function() return Theme.Accent end)

    local SearchInput = Instance.new("TextBox")
    SearchInput.BackgroundTransparency = 1
    SearchInput.Size = UDim2.new(1, -20, 1, 0)
    SearchInput.Position = UDim2.fromOffset(12, 0)
    SearchInput.FontFace = F_Medium
    SearchInput.TextSize = 13
    SearchInput.PlaceholderText = "Search..."
    SearchInput.Text = ""
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.Parent = SearchBox
    Bind(SearchInput, "TextColor3", function() return Theme.Text end)
    Bind(SearchInput, "PlaceholderColor3", function() return Theme.SubText end)

    SearchInput.Focused:Connect(function()
        Tween(SearchStroke, 0.2, { Transparency = 0 })
        Tween(SearchBox, 0.2, { BackgroundColor3 = Theme.CardHover })
    end)
    SearchInput.FocusLost:Connect(function()
        Tween(SearchStroke, 0.2, { Transparency = 1 })
        Tween(SearchBox, 0.2, { BackgroundColor3 = Theme.Card })
    end)

    -- Menu Holder
    local MenuHolder = Instance.new("ScrollingFrame")
    MenuHolder.BackgroundTransparency = 1
    MenuHolder.BorderSizePixel = 0
    MenuHolder.Size = UDim2.new(1, -24, 1, -59)
    MenuHolder.Position = UDim2.fromOffset(12, 59)
    MenuHolder.ScrollBarThickness = 0
    MenuHolder.CanvasSize = UDim2.new()
    MenuHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    MenuHolder.Parent = Sidebar

    local sidebarList = Instance.new("UIListLayout")
    sidebarList.Padding = UDim.new(0, 8)
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarList.Parent = MenuHolder

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -SIDEBAR_W, 1, -46)
    ContentArea.Position = UDim2.new(0, SIDEBAR_W, 0, 46)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = Main

    local PAGE_POS = UDim2.fromOffset(5, 0)

    local menuButtons = {}
    local contentPages = {}
    local tabObjects = {}
    local tabCount = 0
    local currentMenu = nil

    local ExitSearch -- assigned in the Search section

    local function SelectMenu(name, instant)
        if currentMenu == name or not contentPages[name] then return end
        currentMenu = name

        for n, btn in pairs(menuButtons) do
            local sel = (n == name)
            local time = instant and 0 or 0.2
            Tween(btn, time, { BackgroundColor3 = sel and Theme.SelectedBG or Theme.Sidebar })
            Tween(btn.Tile, time, { BackgroundColor3 = sel and Theme.SelectedTile or Theme.Tile })
            Tween(btn.Label, time, { TextColor3 = sel and Theme.Text or Theme.SubText })
            local iconProp = btn.Tile.Icon:IsA("ImageLabel") and "ImageColor3" or "TextColor3"
            Tween(btn.Tile.Icon, time, { [iconProp] = sel and Theme.Text or Theme.SubText })
        end

        for n, page in pairs(contentPages) do
            if n == name then
                page.Visible = true
                if not instant then
                    page.Position = UDim2.fromOffset(5 + 24, 0)
                    Tween(page, 0.35, { Position = PAGE_POS }, Enum.EasingStyle.Quint)
                end
            else
                page.Visible = false
            end
        end
    end

    -- ===== Search (results page) =====
    local searching = false
    local resultButtons = {}
    local searchCounter = 0

    local SearchPage = Instance.new("ScrollingFrame")
    SearchPage.Name = "Search_Page"
    SearchPage.Size = UDim2.new(1, -23, 1, 0)
    SearchPage.Position = PAGE_POS
    SearchPage.BackgroundTransparency = 1
    SearchPage.BorderSizePixel = 0
    SearchPage.ScrollBarThickness = 3
    SearchPage.CanvasSize = UDim2.new()
    SearchPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SearchPage.Visible = false
    SearchPage.Parent = ContentArea
    Bind(SearchPage, "ScrollBarImageColor3", function() return Theme.Accent end)

    local SearchPad = Instance.new("UIPadding")
    SearchPad.PaddingTop = UDim.new(0, 15)
    SearchPad.PaddingBottom = UDim.new(0, 15)
    SearchPad.Parent = SearchPage

    local SearchList = Instance.new("UIListLayout")
    SearchList.Padding = UDim.new(0, 9)
    SearchList.SortOrder = Enum.SortOrder.LayoutOrder
    SearchList.Parent = SearchPage

    local SearchTitle = Instance.new("TextLabel")
    SearchTitle.BackgroundTransparency = 1
    SearchTitle.Size = UDim2.new(1, 0, 0, 24)
    SearchTitle.FontFace = F_Semi
    SearchTitle.TextSize = 18
    SearchTitle.TextXAlignment = Enum.TextXAlignment.Left
    SearchTitle.Text = "Search"
    SearchTitle.LayoutOrder = 0
    SearchTitle.Parent = SearchPage
    Bind(SearchTitle, "TextColor3", function() return Theme.Text end)

    local NoResults = Instance.new("TextLabel")
    NoResults.BackgroundTransparency = 1
    NoResults.Size = UDim2.new(1, 0, 0, 40)
    NoResults.FontFace = F_Medium
    NoResults.TextSize = 12
    NoResults.Text = "No results found"
    NoResults.LayoutOrder = 5000
    NoResults.Visible = false
    NoResults.Parent = SearchPage
    Bind(NoResults, "TextColor3", function() return Theme.SubText end)

    local function FlashCard(obj)
        if obj.BackgroundTransparency ~= 0 then return end
        Tween(obj, 0.2, { BackgroundColor3 = Theme.SelectedBG })
        task.delay(0.7, function()
            if obj.Parent then
                Tween(obj, 0.4, { BackgroundColor3 = Theme.Card })
            end
        end)
    end

    ExitSearch = function()
        if not searching then return end
        searching = false
        SearchPage.Visible = false
        local p = contentPages[currentMenu]
        if p then
            p.Visible = true
            p.Position = PAGE_POS
        end
    end

    -- Called by every component: adds it to the search results pool
    local function Register(tabName, title, desc, obj)
        searchCounter += 1
        local index = searchCounter
        local entry = { title = title, desc = desc or "", page = tabName, obj = obj }

        local R = Instance.new("TextButton")
        R.Size = UDim2.new(1, 0, 0, 54)
        R.AutoButtonColor = false
        R.Text = ""
        R.Visible = false
        R.LayoutOrder = index
        R.Parent = SearchPage
        Round(R, 12)
        AddPressEffect(R, 0.98)
        Bind(R, "BackgroundColor3", function() return Theme.Card end)

        local RT = Instance.new("TextLabel")
        RT.BackgroundTransparency = 1
        RT.Position = UDim2.fromOffset(13, 11)
        RT.Size = UDim2.new(1, -110, 0, 16)
        RT.FontFace = F_Medium
        RT.TextSize = 13
        RT.TextXAlignment = Enum.TextXAlignment.Left
        RT.TextTruncate = Enum.TextTruncate.AtEnd
        RT.Text = entry.title
        RT.Parent = R
        Bind(RT, "TextColor3", function() return Theme.Text end)

        local RD = Instance.new("TextLabel")
        RD.BackgroundTransparency = 1
        RD.Position = UDim2.fromOffset(13, 28)
        RD.Size = UDim2.new(1, -110, 0, 16)
        RD.FontFace = F_Medium
        RD.TextSize = 11
        RD.TextXAlignment = Enum.TextXAlignment.Left
        RD.TextTruncate = Enum.TextTruncate.AtEnd
        RD.Text = entry.desc
        RD.Parent = R
        Bind(RD, "TextColor3", function() return Theme.SubText end)

        local Pill = Instance.new("Frame")
        Pill.AnchorPoint = Vector2.new(1, 0.5)
        Pill.Position = UDim2.new(1, -12, 0.5, 0)
        Pill.Size = UDim2.fromOffset(0, 20)
        Pill.AutomaticSize = Enum.AutomaticSize.X
        Pill.Parent = R
        Round(Pill, 4)
        Bind(Pill, "BackgroundColor3", function() return Theme.PillBG end)

        local PP = Instance.new("UIPadding")
        PP.PaddingLeft = UDim.new(0, 6)
        PP.PaddingRight = UDim.new(0, 6)
        PP.Parent = Pill

        local PL = Instance.new("TextLabel")
        PL.BackgroundTransparency = 1
        PL.Size = UDim2.fromOffset(0, 20)
        PL.AutomaticSize = Enum.AutomaticSize.X
        PL.FontFace = F_Medium
        PL.TextSize = 11
        PL.Text = entry.page
        PL.Parent = Pill
        Bind(PL, "TextColor3", function() return Theme.PillText end)

        R.MouseEnter:Connect(function()
            Tween(R, 0.15, { BackgroundColor3 = Theme.CardHover })
        end)
        R.MouseLeave:Connect(function()
            Tween(R, 0.15, { BackgroundColor3 = Theme.Card })
        end)

        R.MouseButton1Click:Connect(function()
            SearchInput.Text = ""
            ExitSearch()
            SelectMenu(entry.page)
            task.delay(0.1, function()
                local page = contentPages[entry.page]
                if page and entry.obj.Parent then
                    local y = entry.obj.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y - 10
                    page.CanvasPosition = Vector2.new(0, math.max(0, y))
                    FlashCard(entry.obj)
                end
            end)
        end)

        resultButtons[#resultButtons + 1] = { btn = R, entry = entry, index = index }
    end

    local function RunSearch()
        local q = SearchInput.Text:lower():match("^%s*(.-)%s*$")
        if q == "" then
            ExitSearch()
            return
        end

        if not searching then
            searching = true
            for _, p in pairs(contentPages) do p.Visible = false end
            SearchPage.CanvasPosition = Vector2.new(0, 0)
            SearchPage.Visible = true
            SearchPage.Position = UDim2.fromOffset(5 + 24, 0)
            Tween(SearchPage, 0.35, { Position = PAGE_POS }, Enum.EasingStyle.Quint)
        end

        local count = 0
        for _, r in ipairs(resultButtons) do
            local e = r.entry
            local inTitle = e.title:lower():find(q, 1, true) ~= nil
            local hit = inTitle
                or e.desc:lower():find(q, 1, true) ~= nil
                or e.page:lower():find(q, 1, true) ~= nil
            r.btn.Visible = hit
            if hit then
                count += 1
                r.btn.LayoutOrder = inTitle and r.index or (100000 + r.index)
            end
        end

        NoResults.Visible = (count == 0)
        SearchTitle.Text = "Search (" .. count .. ")"
    end

    SearchInput:GetPropertyChangedSignal("Text"):Connect(RunSearch)

    -- =================================================================
    --  Components (each returns a control object)
    -- =================================================================
    local function MakeCard(page, tabName, order, title, desc, height, rightMargin)
        title = title or ""
        desc = desc or ""

        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, 0, 0, height)
        Card.LayoutOrder = order
        Card.Parent = page
        Round(Card, 12)
        Bind(Card, "BackgroundColor3", function() return Theme.Card end)

        local T = Instance.new("TextLabel")
        T.BackgroundTransparency = 1
        T.FontFace = F_Medium
        T.TextSize = 13
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.Text = title
        T.Parent = Card
        Bind(T, "TextColor3", function() return Theme.Text end)

        local D = Instance.new("TextLabel")
        D.BackgroundTransparency = 1
        D.Position = UDim2.fromOffset(13, 28)
        D.Size = UDim2.new(1, -rightMargin, 0, math.max(16, height - 30))
        D.FontFace = F_Medium
        D.TextSize = 11
        D.TextXAlignment = Enum.TextXAlignment.Left
        D.TextYAlignment = Enum.TextYAlignment.Top
        D.TextWrapped = true
        D.Text = desc
        D.Parent = Card
        Bind(D, "TextColor3", function() return Theme.SubText end)

        if desc == "" then
            -- no description: center the title vertically (top part of the card only)
            local topH = (height > 60) and 54 or height
            T.Position = UDim2.fromOffset(13, 0)
            T.Size = UDim2.new(1, -rightMargin, 0, topH)
            T.TextYAlignment = Enum.TextYAlignment.Center
            D.Visible = false
        else
            T.Position = UDim2.fromOffset(13, 11)
            T.Size = UDim2.new(1, -rightMargin, 0, 16)
        end

        Card.MouseEnter:Connect(function()
            Tween(Card, 0.15, { BackgroundColor3 = Theme.CardHover })
        end)
        Card.MouseLeave:Connect(function()
            Tween(Card, 0.15, { BackgroundColor3 = Theme.Card })
        end)

        Register(tabName, title, desc, Card)
        return Card, T, D
    end

    local function BuildLabel(page, tabName, order, opts)
        local Card = MakeCard(page, tabName, order, opts.Title, opts.Description, 54, 26)
        return { Instance = Card }
    end

    local function BuildSection(page, tabName, order, text)
        local Holder = Instance.new("Frame")
        Holder.BackgroundTransparency = 1
        Holder.Size = UDim2.new(1, 0, 0, 24)
        Holder.LayoutOrder = order
        Holder.Parent = page

        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.fromOffset(6, 6)
        Dot.Position = UDim2.fromOffset(2, 14)
        Dot.Parent = Holder
        Round(Dot, 3)
        Bind(Dot, "BackgroundColor3", function() return Theme.PillText end)

        local L = Instance.new("TextLabel")
        L.BackgroundTransparency = 1
        L.Position = UDim2.fromOffset(16, 5)
        L.Size = UDim2.new(1, -16, 0, 18)
        L.FontFace = F_Semi
        L.TextSize = 13
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.Text = text
        L.Parent = Holder
        Bind(L, "TextColor3", function() return Theme.Text end)

        Register(tabName, text, "Section", Holder)
        return { Instance = Holder }
    end

    local function BuildButton(page, tabName, order, opts)
        local text = opts.Title or opts.Text or "Button"
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 48)
        Btn.AutoButtonColor = false
        Btn.FontFace = F_Medium
        Btn.TextSize = 12
        Btn.Text = text
        Btn.LayoutOrder = order
        Btn.Parent = page
        Round(Btn, 12)
        AddPressEffect(Btn, 0.97)
        Bind(Btn, "BackgroundColor3", function() return Theme.Card end)
        Bind(Btn, "TextColor3", function() return Theme.Text end)

        Btn.MouseEnter:Connect(function()
            Tween(Btn, 0.15, { BackgroundColor3 = Theme.CardHover })
        end)
        Btn.MouseLeave:Connect(function()
            Tween(Btn, 0.15, { BackgroundColor3 = Theme.Card })
        end)
        Btn.MouseButton1Click:Connect(function()
            if opts.Callback then task.spawn(opts.Callback) end
        end)

        Register(tabName, text, opts.Description or "Button", Btn)
        return { Instance = Btn }
    end

    local function BuildToggle(page, tabName, order, opts)
        local Card = MakeCard(page, tabName, order, opts.Title, opts.Description, 54, 80)
        local state = opts.Default == true

        local SwitchBG = Instance.new("Frame")
        SwitchBG.Size = UDim2.fromOffset(42, 22)
        SwitchBG.Position = UDim2.new(1, -54, 0.5, -11)
        SwitchBG.Parent = Card
        Round(SwitchBG, 11)
        Bind(SwitchBG, "BackgroundColor3", function() return state and Theme.Accent or Theme.Toggle_Off end)

        local OnPos = UDim2.new(1, -20, 0.5, -9)
        local OffPos = UDim2.new(0, 2, 0.5, -9)

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.fromOffset(18, 18)
        Knob.Position = state and OnPos or OffPos
        Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Knob.Parent = SwitchBG
        Round(Knob, 9)

        local Click = Instance.new("TextButton")
        Click.BackgroundTransparency = 1
        Click.Size = UDim2.fromScale(1, 1)
        Click.Text = ""
        Click.Parent = SwitchBG

        local control = { Instance = Card }

        local function setState(v, fire)
            state = v and true or false
            Tween(Knob, 0.1, { Size = UDim2.fromOffset(24, 18) })
            task.delay(0.1, function()
                if Knob.Parent then
                    Tween(Knob, 0.25, {
                        Size = UDim2.fromOffset(18, 18),
                        Position = state and OnPos or OffPos,
                    }, Enum.EasingStyle.Back)
                end
            end)
            Tween(SwitchBG, 0.2, { BackgroundColor3 = state and Theme.Accent or Theme.Toggle_Off })
            if fire and opts.Callback then task.spawn(opts.Callback, state) end
        end

        Click.MouseButton1Click:Connect(function() setState(not state, true) end)

        function control:Set(v) setState(v, true) end
        function control:Get() return state end
        return control
    end

    local function BuildSlider(page, tabName, order, opts)
        local min = opts.Min or 0
        local max = opts.Max or 100
        local increment = opts.Increment or 1
        local default = math.clamp(opts.Default or min, min, max)
        local callback = opts.Callback

        local Card = MakeCard(page, tabName, order, opts.Title, opts.Description, 86, 90)

        -- typeable value box
        local ValueBox = Instance.new("Frame")
        ValueBox.Size = UDim2.fromOffset(52, 24)
        ValueBox.Position = UDim2.new(1, -65, 0, 8)
        ValueBox.Parent = Card
        Round(ValueBox, 8)
        Bind(ValueBox, "BackgroundColor3", function() return Theme.Tile end)

        local ValueStroke = Instance.new("UIStroke")
        ValueStroke.Thickness = 1
        ValueStroke.Transparency = 1
        ValueStroke.Parent = ValueBox
        Bind(ValueStroke, "Color", function() return Theme.Accent end)

        local ValueInput = Instance.new("TextBox")
        ValueInput.BackgroundTransparency = 1
        ValueInput.Size = UDim2.fromScale(1, 1)
        ValueInput.FontFace = F_Semi
        ValueInput.TextSize = 12
        ValueInput.Text = tostring(default)
        ValueInput.ClearTextOnFocus = false
        ValueInput.Parent = ValueBox
        Bind(ValueInput, "TextColor3", function() return Theme.Text end)

        local Track = Instance.new("Frame")
        Track.Size = UDim2.new(1, -26, 0, 6)
        Track.Position = UDim2.fromOffset(13, 58)
        Track.Parent = Card
        Round(Track, 3)
        Bind(Track, "BackgroundColor3", function() return Theme.Toggle_Off end)

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new(0, 0, 1, 0)
        Fill.BorderSizePixel = 0
        Fill.Parent = Track
        Round(Fill, 3)
        Bind(Fill, "BackgroundColor3", function() return Theme.Accent end)

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.fromOffset(14, 14)
        Knob.AnchorPoint = Vector2.new(0.5, 0.5)
        Knob.Position = UDim2.new(0, 0, 0.5, 0)
        Knob.ZIndex = 2
        Knob.Parent = Track
        Round(Knob, 7)
        Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local KnobStroke = Instance.new("UIStroke")
        KnobStroke.Thickness = 1
        KnobStroke.Parent = Knob
        Bind(KnobStroke, "Color", function() return Theme.Accent end)

        local value = default
        local function setValue(v, fire)
            v = min + math.floor((v - min) / increment + 0.5) * increment
            v = math.clamp(v, min, max)
            v = math.floor(v * 10000 + 0.5) / 10000 -- kill float noise
            value = v
            local alpha = (max == min) and 0 or (v - min) / (max - min)
            Fill.Size = UDim2.new(alpha, 0, 1, 0)
            Knob.Position = UDim2.new(alpha, 0, 0.5, 0)
            ValueInput.Text = tostring(v)
            if fire and callback then task.spawn(callback, value) end
        end
        setValue(default, false)

        local badChars = (min < 0) and "[^%d%-%.]" or "[^%d%.]"
        ValueInput:GetPropertyChangedSignal("Text"):Connect(function()
            local cleaned = (ValueInput.Text:gsub(badChars, ""))
            if cleaned ~= ValueInput.Text then ValueInput.Text = cleaned end
        end)
        ValueInput.Focused:Connect(function()
            Tween(ValueStroke, 0.2, { Transparency = 0 })
        end)
        ValueInput.FocusLost:Connect(function()
            Tween(ValueStroke, 0.2, { Transparency = 1 })
            local n = tonumber(ValueInput.Text)
            if n then setValue(n, true) else ValueInput.Text = tostring(value) end
        end)

        local dragging = false
        local function updateFromInput(input)
            local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            setValue(min + rel * (max - min), true)
        end

        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateFromInput(input)
            end
        end)
        Connect(UserInputService.InputChanged, function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateFromInput(input)
            end
        end)
        Connect(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        local control = { Instance = Card }
        function control:Set(v) setValue(v, true) end
        function control:Get() return value end
        return control
    end

    local function BuildDropdown(page, tabName, order, opts)
        local CARD_H = 54
        local options = opts.Options or {}
        local callback = opts.Callback
        local BOX_W = 130
        local ROW_H = 42

        local Card = MakeCard(page, tabName, order, opts.Title, opts.Description, CARD_H, BOX_W + 26)

        local selected = opts.Default or options[1] or ""

        -- Closed box: solid blue fill (Theme.SelectedBG), matches the requested swatch
        local Box = Instance.new("TextButton")
        Box.Size = UDim2.fromOffset(BOX_W, 30)
        Box.Position = UDim2.new(1, -(BOX_W + 13), 0.5, -15)
        Box.AutoButtonColor = false
        Box.Text = ""
        Box.ZIndex = 3
        Box.Parent = Card
        Round(Box, 8)
        Bind(Box, "BackgroundColor3", function() return Theme.SelectedBG end)

        local BoxLabel = Instance.new("TextLabel")
        BoxLabel.BackgroundTransparency = 1
        BoxLabel.Size = UDim2.new(1, -32, 1, 0)
        BoxLabel.Position = UDim2.fromOffset(12, 0)
        BoxLabel.FontFace = F_Medium
        BoxLabel.TextSize = 12
        BoxLabel.TextXAlignment = Enum.TextXAlignment.Left
        BoxLabel.TextTruncate = Enum.TextTruncate.AtEnd
        BoxLabel.ZIndex = 4
        BoxLabel.Text = tostring(selected)
        BoxLabel.Parent = Box
        Bind(BoxLabel, "TextColor3", function() return Theme.Text end)

        local Chevron = Instance.new("TextLabel")
        Chevron.AnchorPoint = Vector2.new(0.5, 0.5)
        Chevron.BackgroundTransparency = 1
        Chevron.Size = UDim2.fromOffset(20, 20)
        Chevron.Position = UDim2.new(1, -16, 0.5, 0)
        Chevron.FontFace = F_Bold
        Chevron.TextSize = 11
        Chevron.ZIndex = 4
        Chevron.Text = "<" -- static left-pointing arrow, matches the reference pill
        Chevron.Rotation = 0
        Chevron.Parent = Box
        Bind(Chevron, "TextColor3", function() return Theme.Text end)

        -- Backdrop: full-screen invisible button, closes the list on outside click
        local Backdrop = Instance.new("TextButton")
        Backdrop.Size = UDim2.fromScale(1, 1)
        Backdrop.BackgroundTransparency = 1
        Backdrop.Text = ""
        Backdrop.ZIndex = 90
        Backdrop.Visible = false
        Backdrop.Parent = ScreenGui

        -- Flyout list: top-level so it can extend past the window without being clipped.
        -- Sized to match the Box's own width, and anchored to the Box itself (not the window edge).
        local ListHolder = Instance.new("Frame")
        ListHolder.Size = UDim2.fromOffset(BOX_W, 0)
        ListHolder.ClipsDescendants = true
        ListHolder.ZIndex = 91
        ListHolder.Visible = false
        ListHolder.Parent = ScreenGui
        Round(ListHolder, 10)
        Bind(ListHolder, "BackgroundColor3", function() return Theme.Background end)

        local ListStroke = Instance.new("UIStroke")
        ListStroke.Thickness = 1
        ListStroke.Transparency = 0
        ListStroke.Parent = ListHolder
        Bind(ListStroke, "Color", function() return Theme.Line end)

        local ListPad = Instance.new("UIPadding")
        ListPad.PaddingTop = UDim.new(0, 6)
        ListPad.PaddingBottom = UDim.new(0, 6)
        ListPad.PaddingLeft = UDim.new(0, 6)
        ListPad.PaddingRight = UDim.new(0, 6)
        ListPad.Parent = ListHolder

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Parent = ListHolder

        local open = false
        local function closeList()
            open = false
            Backdrop.Visible = false
            Tween(ListHolder, 0.15, { Size = UDim2.fromOffset(BOX_W, 0) }).Completed:Connect(function()
                if not open then ListHolder.Visible = false end
            end)
        end

        local function openList()
            open = true

            -- Anchor to the whole UI window (Main), not the individual card: the flyout
            -- opens flush against the window's right edge, top-aligned with this dropdown's
            -- own card. Flips to the left edge if there isn't room on the right.
            local targetH = #options * ROW_H + 12
            local screenW = ScreenGui.AbsoluteSize.X
            local mainRight = Main.AbsolutePosition.X + Main.AbsoluteSize.X
            local mainLeft = Main.AbsolutePosition.X
            local y = Card.AbsolutePosition.Y

            local x
            if mainRight + BOX_W <= screenW then
                x = mainRight -- starts exactly at the UI's right edge
            else
                x = mainLeft - BOX_W
            end

            ListHolder.Position = UDim2.fromOffset(x, y)
            ListHolder.Visible = true
            Backdrop.Visible = true
            Tween(ListHolder, 0.18, { Size = UDim2.fromOffset(BOX_W, targetH) }, Enum.EasingStyle.Quint)
        end

        local optionButtons = {}
        local function choose(opt, fire)
            selected = opt
            BoxLabel.Text = tostring(opt)
            closeList()
            if fire and callback then task.spawn(callback, opt) end
        end

        local function buildOptions()
            for _, b in ipairs(optionButtons) do b:Destroy() end
            optionButtons = {}
            for i, opt in ipairs(options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, ROW_H)
                OptBtn.BackgroundTransparency = 1
                OptBtn.AutoButtonColor = false
                OptBtn.FontFace = F_Medium
                OptBtn.TextSize = 13
                OptBtn.Text = "  " .. tostring(opt)
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.ZIndex = 92
                OptBtn.LayoutOrder = i
                OptBtn.Parent = ListHolder
                Round(OptBtn, 8)
                Bind(OptBtn, "TextColor3", function() return Theme.Text end)

                OptBtn.MouseEnter:Connect(function()
                    Tween(OptBtn, 0.1, { BackgroundTransparency = 0, BackgroundColor3 = Theme.SelectedTile })
                end)
                OptBtn.MouseLeave:Connect(function()
                    Tween(OptBtn, 0.1, { BackgroundTransparency = 1 })
                end)
                OptBtn.MouseButton1Click:Connect(function() choose(opt, true) end)

                optionButtons[#optionButtons + 1] = OptBtn
            end
        end
        buildOptions()

        Box.MouseButton1Click:Connect(function()
            if open then closeList() else openList() end
        end)
        Backdrop.MouseButton1Click:Connect(closeList)
        Box.MouseEnter:Connect(function() Tween(Box, 0.15, { BackgroundColor3 = Theme.SelectedTile }) end)
        Box.MouseLeave:Connect(function() Tween(Box, 0.15, { BackgroundColor3 = Theme.SelectedBG }) end)

        local control = { Instance = Card }
        function control:Set(v) choose(v, true) end
        function control:Get() return selected end
        function control:Refresh(newOptions, keepSelection)
            options = newOptions or {}
            buildOptions()
            if not keepSelection then
                choose(options[1] or "", false)
            end
            closeList()
        end
        return control
    end

    local function BuildKeybind(page, tabName, order, opts)
        local Card = MakeCard(page, tabName, order, opts.Title, opts.Description, 54, 140)
        local currentKey = opts.Default or Enum.KeyCode.E
        local listening = false

        local Box = Instance.new("TextButton")
        Box.Size = UDim2.fromOffset(110, 30)
        Box.Position = UDim2.new(1, -123, 0.5, -15)
        Box.AutoButtonColor = false
        Box.Text = ""
        Box.Parent = Card
        Round(Box, 8)
        Bind(Box, "BackgroundColor3", function() return listening and Theme.Accent or Theme.Tile end)

        local BoxLabel = Instance.new("TextLabel")
        BoxLabel.BackgroundTransparency = 1
        BoxLabel.Size = UDim2.new(1, -12, 1, 0)
        BoxLabel.Position = UDim2.fromOffset(6, 0)
        BoxLabel.FontFace = F_Semi
        BoxLabel.TextSize = 12
        BoxLabel.TextXAlignment = Enum.TextXAlignment.Center
        BoxLabel.TextTruncate = Enum.TextTruncate.AtEnd
        BoxLabel.Text = currentKey.Name
        BoxLabel.Parent = Box
        Bind(BoxLabel, "TextColor3", function() return listening and Theme.OnAccentText or Theme.Text end)

        Box.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            BoxLabel.Text = "..."
            Tween(Box, 0.15, { BackgroundColor3 = Theme.Accent })
            Tween(BoxLabel, 0.15, { TextColor3 = Theme.OnAccentText })
        end)

        Connect(UserInputService.InputBegan, function(input, gpe)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

            if listening then
                if input.KeyCode == Enum.KeyCode.Escape then
                    listening = false
                    BoxLabel.Text = currentKey.Name
                    Tween(Box, 0.15, { BackgroundColor3 = Theme.Tile })
                    Tween(BoxLabel, 0.15, { TextColor3 = Theme.Text })
                    return
                end
                currentKey = input.KeyCode
                listening = false
                BoxLabel.Text = currentKey.Name
                Tween(Box, 0.15, { BackgroundColor3 = Theme.Tile })
                Tween(BoxLabel, 0.15, { TextColor3 = Theme.Text })
                if opts.Callback then task.spawn(opts.Callback, currentKey) end
                return
            end

            -- Optional: run an action when the bound key is pressed
            if not gpe and opts.Pressed and input.KeyCode == currentKey then
                task.spawn(opts.Pressed)
            end
        end)

        Box.MouseEnter:Connect(function()
            if not listening then Tween(Box, 0.15, { BackgroundColor3 = Theme.CardHover }) end
        end)
        Box.MouseLeave:Connect(function()
            if not listening then Tween(Box, 0.15, { BackgroundColor3 = Theme.Tile }) end
        end)

        local control = { Instance = Card }
        function control:Get() return currentKey end
        function control:Set(key)
            currentKey = key
            BoxLabel.Text = key.Name
            if opts.Callback then task.spawn(opts.Callback, key) end
        end
        return control
    end

    -- =================================================================
    --  Window API
    -- =================================================================
    function Window:AddTab(name, icon)
        name = tostring(name)
        if tabObjects[name] then return tabObjects[name] end

        tabCount += 1
        local Tab = {}

        local Btn = Instance.new("TextButton")
        Btn.Name = name
        Btn.Size = UDim2.new(1, 0, 0, 42)
        Btn.AutoButtonColor = false
        Btn.Text = ""
        Btn.LayoutOrder = tabCount
        Btn.Parent = MenuHolder
        Round(Btn, 12)
        AddPressEffect(Btn, 0.96)
        local isSel = function() return currentMenu == name end
        Bind(Btn, "BackgroundColor3", function() return isSel() and Theme.SelectedBG or Theme.Sidebar end)

        local Tile = Instance.new("Frame")
        Tile.Name = "Tile"
        Tile.Size = UDim2.fromOffset(26, 26)
        Tile.Position = UDim2.fromOffset(8, 8)
        Tile.Parent = Btn
        Round(Tile, 10)
        Bind(Tile, "BackgroundColor3", function() return isSel() and Theme.SelectedTile or Theme.Tile end)

        -- The icon is up to the user of the library:
        --   "rbxassetid://123" or just 123  -> image icon
        --   a Lucide name longer than 2 chars (e.g. "house") -> resolved to a Lucide image
        --   a short text (e.g. "★")          -> text icon
        --   nil / ""                         -> no icon at all
        icon = (icon ~= nil) and tostring(icon) or ""
        local isImage = icon:match("^rbxassetid://") or icon:match("^https?://") or icon:match("^%d+$")

        local imgId, rectPos, rectSize
        if not isImage and icon ~= "" and (utf8.len(icon) or #icon) > 2 then
            -- longer than 2 characters: treat as a Lucide icon name
            imgId, rectPos, rectSize = ResolveLucide(icon)
            if imgId then
                isImage = true
            else
                icon = "" -- not found: show no icon (avoids text overflowing onto the tab name)
            end
        end

        Tile.ClipsDescendants = true

        local Icon
        if isImage then
            Icon = Instance.new("ImageLabel")
            Icon.Image = imgId or (icon:match("^%d+$") and ("rbxassetid://" .. icon) or icon)
            if rectPos and rectSize then
                Icon.ImageRectOffset = rectPos
                Icon.ImageRectSize = rectSize
            end
            Icon.ScaleType = Enum.ScaleType.Fit
            Icon.AnchorPoint = Vector2.new(0.5, 0.5)
            Icon.Position = UDim2.fromScale(0.5, 0.5)
            Icon.Size = UDim2.fromOffset(16, 16)
        else
            Icon = Instance.new("TextLabel")
            Icon.Size = UDim2.fromScale(1, 1)
            Icon.FontFace = F_Bold
            Icon.TextSize = 13
            Icon.Text = icon
        end
        Icon.Name = "Icon"
        Icon.BackgroundTransparency = 1
        Icon.Parent = Tile
        Bind(Icon, isImage and "ImageColor3" or "TextColor3", function() return isSel() and Theme.Text or Theme.SubText end)

        local hasIcon = icon ~= "" or isImage
        Tile.Visible = hasIcon
        local baseX = hasIcon and 43 or 13 -- label x position (moves left when there is no icon)

        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, -(baseX + 1), 1, 0)
        Label.Position = UDim2.fromOffset(baseX, 0)
        Label.FontFace = F_Medium
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = name
        Label.Parent = Btn
        Bind(Label, "TextColor3", function() return isSel() and Theme.Text or Theme.SubText end)

        menuButtons[name] = Btn

        Btn.MouseEnter:Connect(function()
            if currentMenu ~= name then
                Tween(Btn, 0.15, { BackgroundColor3 = Theme.HoverBG })
                Tween(Label, 0.15, { Position = UDim2.fromOffset(baseX + 3, 0), TextColor3 = Theme.Text })
            end
        end)
        Btn.MouseLeave:Connect(function()
            Tween(Label, 0.15, { Position = UDim2.fromOffset(baseX, 0) })
            if currentMenu ~= name then
                Tween(Btn, 0.15, { BackgroundColor3 = Theme.Sidebar })
                Tween(Label, 0.15, { TextColor3 = Theme.SubText })
            end
        end)
        Btn.MouseButton1Click:Connect(function()
            SearchInput.Text = ""
            ExitSearch()
            SelectMenu(name)
        end)

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "_Page"
        Page.Size = UDim2.new(1, -23, 1, 0)
        Page.Position = PAGE_POS
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 3
        Page.CanvasSize = UDim2.new()
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.Parent = ContentArea
        Bind(Page, "ScrollBarImageColor3", function() return Theme.Accent end)

        local PagePad = Instance.new("UIPadding")
        PagePad.PaddingTop = UDim.new(0, 15)
        PagePad.PaddingBottom = UDim.new(0, 15)
        PagePad.Parent = Page

        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 12)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Parent = Page

        contentPages[name] = Page

        -- page heading (the tab name)
        local Heading = Instance.new("TextLabel")
        Heading.BackgroundTransparency = 1
        Heading.Size = UDim2.new(1, 0, 0, 24)
        Heading.FontFace = F_Semi
        Heading.TextSize = 18
        Heading.TextXAlignment = Enum.TextXAlignment.Left
        Heading.Text = name
        Heading.LayoutOrder = 0
        Heading.Parent = Page
        Bind(Heading, "TextColor3", function() return Theme.Text end)

        local order = 0
        local function nextOrder()
            order += 1
            return order
        end

        function Tab:AddSection(text)
            return BuildSection(Page, name, nextOrder(), tostring(text or ""))
        end
        function Tab:AddLabel(opts)
            return BuildLabel(Page, name, nextOrder(), opts or {})
        end
        function Tab:AddButton(opts)
            return BuildButton(Page, name, nextOrder(), opts or {})
        end
        function Tab:AddToggle(opts)
            return BuildToggle(Page, name, nextOrder(), opts or {})
        end
        function Tab:AddSlider(opts)
            return BuildSlider(Page, name, nextOrder(), opts or {})
        end
        function Tab:AddDropdown(opts)
            return BuildDropdown(Page, name, nextOrder(), opts or {})
        end
        function Tab:AddKeybind(opts)
            return BuildKeybind(Page, name, nextOrder(), opts or {})
        end
        function Tab:Select()
            SearchInput.Text = ""
            ExitSearch()
            SelectMenu(name)
        end

        tabObjects[name] = Tab

        -- the first tab is selected automatically
        if not currentMenu then
            SelectMenu(name, true)
        end

        return Tab
    end

    -- Optional ready-made settings tab (theme + toggle key). Call it only if you want it.
    function Window:AddSettingsTab(name, icon)
        local Tab = Window:AddTab(name or "Settings", icon)
        Tab:AddSection("Appearance")
        Tab:AddDropdown({
            Title = "Theme",
            Description = "Switch between dark and light",
            Options = { "Dark", "Light" },
            Default = currentTheme,
            Callback = function(opt) Window:SetTheme(opt) end,
        })
        Tab:AddKeybind({
            Title = "Toggle Key",
            Description = "Click the box, then press a key to rebind it",
            Default = toggleKey,
            Callback = function(key) Window:SetToggleKey(key) end,
        })
        return Tab
    end

    function Window:SetTheme(name) ApplyTheme(name) end
    function Window:GetTheme() return currentTheme end
    function Window:SetToggleKey(key) toggleKey = key end
    function Window:GetToggleKey() return toggleKey end
    function Window:Open() if not isOpen then OpenWindow() end end
    function Window:Close() if isOpen then CloseWindow() end end
    function Window:Toggle() if isOpen then CloseWindow() else OpenWindow() end end
    function Window:SelectTab(name)
        local t = tabObjects[tostring(name)]
        if t then t:Select() end
    end
    function Window:Destroy()
        if destroyed then return end
        destroyed = true
        for _, c in ipairs(connections) do c:Disconnect() end
        connections = {}
        ScreenGui:Destroy()
    end

    -- ===== Window dragging =====
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    Connect(UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    -- ===== Global toggle key =====
    Connect(UserInputService.InputBegan, function(input, gpe)
        if not gpe and input.KeyCode == toggleKey then
            Window:Toggle()
        end
    end)

    OpenWindow()
    return Window
end

return Library
