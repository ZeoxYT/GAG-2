--[[
    Zeox Professional UI Library
    Author: Manus (Based on Zeox Style)
    Features: Toggles, Sliders, Dropdowns, Buttons, Custom Tab Images, Professional Animations
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}

-- ============================================================
--   GLOBAL CONFIG & ASSETS
-- ============================================================
local UI_ASSETS = {
    Logo          = "rbxassetid://104041288319444",
    HoverEffect   = "rbxassetid://16261022724",
    LoaderGlow    = "rbxassetid://16073652319",
    Pattern       = "rbxassetid://2151741365",
    Wallpaper     = "rbxassetid://139213622869074",
}

local THEME = {
    MainColor     = Color3.fromRGB(200, 0, 0),
    DarkColor     = Color3.fromRGB(8, 8, 8),
    LightDark     = Color3.fromRGB(15, 15, 15),
    BorderColor   = Color3.fromRGB(40, 40, 40),
    TextColor     = Color3.fromRGB(255, 255, 255),
    SubTextColor  = Color3.fromRGB(180, 180, 180),
}

local TWEEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ============================================================
--   UTILITY FUNCTIONS
-- ============================================================
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ============================================================
--   LIBRARY CORE
-- ============================================================
function Library:CreateWindow(title)
    local ZeoxUI = Instance.new("ScreenGui")
    ZeoxUI.Name = "Zeox_Library"
    ZeoxUI.Parent = CoreGui
    ZeoxUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ZeoxUI
    Main.BackgroundColor3 = THEME.DarkColor
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = THEME.MainColor
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.5
    MainStroke.Parent = Main

    -- Background Pattern
    local Pattern = Instance.new("ImageLabel")
    Pattern.Name = "Pattern"
    Pattern.Parent = Main
    Pattern.BackgroundTransparency = 1
    Pattern.Image = UI_ASSETS.Pattern
    Pattern.ImageTransparency = 0.95
    Pattern.ScaleType = Enum.ScaleType.Tile
    Pattern.TileSize = UDim2.new(0, 128, 0, 128)
    Pattern.Size = UDim2.new(1, 0, 1, 0)
    Pattern.ZIndex = 0

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = THEME.LightDark
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Name = "Line"
    SidebarLine.Parent = Sidebar
    SidebarLine.BackgroundColor3 = THEME.MainColor
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.BackgroundTransparency = 0.5

    -- Logo & Title
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Sidebar
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 60)

    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = Header
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 10, 0, 10)
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.Image = UI_ASSETS.Logo

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = Header
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 55, 0, 10)
    TitleLabel.Size = UDim2.new(0, 100, 0, 40)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = title or "ZEOX HUB"
    TitleLabel.TextColor3 = THEME.TextColor
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Tabs Container
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Parent = Sidebar
    TabScroll.BackgroundTransparency = 1
    TabScroll.Position = UDim2.new(0, 0, 0, 70)
    TabScroll.Size = UDim2.new(1, 0, 1, -80)
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ScrollBarThickness = 0

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabScroll
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = Main
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 160, 0, 0)
    ContentArea.Size = UDim2.new(1, -160, 1, 0)

    MakeDraggable(Main, Header)

    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    function Window:CreateTab(name, imageId)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "_Tab"
        TabButton.Parent = TabScroll
        TabButton.BackgroundColor3 = THEME.MainColor
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(0, 140, 0, 35)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.Text = ""
        TabButton.TextColor3 = THEME.SubTextColor
        TabButton.TextSize = 14

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 8, 0.5, -10)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Image = imageId or UI_ASSETS.Logo
        TabIcon.ImageColor3 = THEME.SubTextColor

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Parent = TabButton
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, 35, 0, 0)
        TabLabel.Size = UDim2.new(1, -35, 1, 0)
        TabLabel.Font = Enum.Font.SourceSansBold
        TabLabel.Text = name
        TabLabel.TextColor3 = THEME.SubTextColor
        TabLabel.TextSize = 14
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "_Page"
        Page.Parent = ContentArea
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = THEME.MainColor

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = Page
        PagePadding.PaddingLeft = UDim.new(0, 15)
        PagePadding.PaddingRight = UDim.new(0, 15)
        PagePadding.PaddingTop = UDim.new(0, 15)
        PagePadding.PaddingBottom = UDim.new(0, 15)

        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 30)
        end)

        -- Background Image for each Tab
        local PageBg = Instance.new("ImageLabel")
        PageBg.Parent = Page
        PageBg.BackgroundTransparency = 1
        PageBg.Position = UDim2.new(0.5, -100, 0.5, -100)
        PageBg.Size = UDim2.new(0, 200, 0, 200)
        PageBg.Image = imageId or UI_ASSETS.Logo
        PageBg.ImageTransparency = 0.93
        PageBg.ZIndex = 0

        local Tab = {
            Elements = {}
        }

        function Tab:Activate()
            if Window.CurrentTab then
                Window.CurrentTab.Page.Visible = false
                TweenService:Create(Window.CurrentTab.Button, TWEEN_INFO, {BackgroundTransparency = 1}):Play()
                TweenService:Create(Window.CurrentTab.Button.TabLabel, TWEEN_INFO, {TextColor3 = THEME.SubTextColor}):Play()
                TweenService:Create(Window.CurrentTab.Button.TabIcon, TWEEN_INFO, {ImageColor3 = THEME.SubTextColor}):Play()
            end
            Page.Visible = true
            TweenService:Create(TabButton, TWEEN_INFO, {BackgroundTransparency = 0.2}):Play()
            TweenService:Create(TabLabel, TWEEN_INFO, {TextColor3 = THEME.TextColor}):Play()
            TweenService:Create(TabIcon, TWEEN_INFO, {ImageColor3 = THEME.TextColor}):Play()
            Window.CurrentTab = {Page = Page, Button = TabButton}
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Activate()
        end)

        if not Window.CurrentTab then
            Tab:Activate()
        end

        -- ============================================================
        --   ELEMENTS (Button, Toggle, Slider, Dropdown)
        -- ============================================================
        
        function Tab:CreateButton(text, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Parent = Page
            ButtonFrame.BackgroundColor3 = THEME.LightDark
            ButtonFrame.Size = UDim2.new(1, 0, 0, 38)
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = ButtonFrame

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = THEME.BorderColor
            Stroke.Parent = ButtonFrame

            local Btn = Instance.new("TextButton")
            Btn.Parent = ButtonFrame
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Font = Enum.Font.SourceSansBold
            Btn.Text = text
            Btn.TextColor3 = THEME.TextColor
            Btn.TextSize = 14

            Btn.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TWEEN_INFO, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                TweenService:Create(Stroke, TWEEN_INFO, {Color = THEME.MainColor}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TWEEN_INFO, {BackgroundColor3 = THEME.LightDark}):Play()
                TweenService:Create(Stroke, TWEEN_INFO, {Color = THEME.BorderColor}):Play()
            end)
            Btn.MouseButton1Click:Connect(function()
                local Circle = Instance.new("ImageLabel")
                Circle.Parent = ButtonFrame
                Circle.BackgroundTransparency = 1
                Circle.Image = "rbxassetid://266543268"
                Circle.ImageColor3 = THEME.MainColor
                Circle.ImageTransparency = 0.6
                Circle.ZIndex = 5
                
                local mousePos = UserInputService:GetMouseLocation()
                local relativePos = mousePos - ButtonFrame.AbsolutePosition
                Circle.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y - 36)
                
                Circle:TweenSizeAndPosition(UDim2.new(0, 400, 0, 400), UDim2.new(0, relativePos.X - 200, 0, relativePos.Y - 236), "Out", "Quad", 0.5, true)
                TweenService:Create(Circle, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
                game:GetService("Debris"):AddItem(Circle, 0.5)
                
                callback()
            end)
        end

        function Tab:CreateToggle(text, default, callback)
            local Toggled = default or false
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = THEME.LightDark
            ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = ToggleFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = ToggleFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Font = Enum.Font.SourceSansBold
            Label.Text = text
            Label.TextColor3 = THEME.SubTextColor
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ToggleOuter = Instance.new("Frame")
            ToggleOuter.Parent = ToggleFrame
            ToggleOuter.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleOuter.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleOuter.Size = UDim2.new(0, 35, 0, 20)
            
            local TOCorner = Instance.new("UICorner")
            TOCorner.CornerRadius = UDim.new(1, 0)
            TOCorner.Parent = ToggleOuter

            local ToggleInner = Instance.new("Frame")
            ToggleInner.Parent = ToggleOuter
            ToggleInner.BackgroundColor3 = THEME.TextColor
            ToggleInner.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleInner.Size = UDim2.new(0, 16, 0, 16)
            
            local TICorner = Instance.new("UICorner")
            TICorner.CornerRadius = UDim.new(1, 0)
            TICorner.Parent = ToggleInner

            local Btn = Instance.new("TextButton")
            Btn.Parent = ToggleFrame
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Text = ""

            local function Update()
                if Toggled then
                    TweenService:Create(ToggleOuter, TWEEN_INFO, {BackgroundColor3 = THEME.MainColor}):Play()
                    TweenService:Create(ToggleInner, TWEEN_INFO, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                    TweenService:Create(Label, TWEEN_INFO, {TextColor3 = THEME.TextColor}):Play()
                else
                    TweenService:Create(ToggleOuter, TWEEN_INFO, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                    TweenService:Create(ToggleInner, TWEEN_INFO, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                    TweenService:Create(Label, TWEEN_INFO, {TextColor3 = THEME.SubTextColor}):Play()
                end
                callback(Toggled)
            end

            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Update()
            end)
            Update()
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Page
            SliderFrame.BackgroundColor3 = THEME.LightDark
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = SliderFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 5)
            Label.Size = UDim2.new(1, -24, 0, 20)
            Label.Font = Enum.Font.SourceSansBold
            Label.Text = text
            Label.TextColor3 = THEME.TextColor
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -60, 0, 5)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Font = Enum.Font.SourceSansBold
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = THEME.MainColor
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local SliderBar = Instance.new("Frame")
            SliderBar.Parent = SliderFrame
            SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderBar.Position = UDim2.new(0, 12, 0, 32)
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            
            local SBCorner = Instance.new("UICorner")
            SBCorner.CornerRadius = UDim.new(1, 0)
            SBCorner.Parent = SliderBar

            local Fill = Instance.new("Frame")
            Fill.Parent = SliderBar
            Fill.BackgroundColor3 = THEME.MainColor
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            
            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(1, 0)
            FCorner.Parent = Fill

            local Circle = Instance.new("Frame")
            Circle.Parent = Fill
            Circle.AnchorPoint = Vector2.new(0.5, 0.5)
            Circle.BackgroundColor3 = THEME.TextColor
            Circle.Position = UDim2.new(1, 0, 0.5, 0)
            Circle.Size = UDim2.new(0, 12, 0, 12)
            
            local CCorner = Instance.new("UICorner")
            CCorner.CornerRadius = UDim.new(1, 0)
            CCorner.Parent = Circle

            local Dragging = false
            local function Update(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                ValueLabel.Text = tostring(val)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                callback(val)
            end

            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    Update(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
        end

        function Tab:CreateDropdown(text, list, callback)
            local Expanded = false
            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = Page
            DropFrame.BackgroundColor3 = THEME.LightDark
            DropFrame.Size = UDim2.new(1, 0, 0, 38)
            DropFrame.ClipsDescendants = true
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = DropFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = DropFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -40, 0, 38)
            Label.Font = Enum.Font.SourceSansBold
            Label.Text = text
            Label.TextColor3 = THEME.TextColor
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Arrow = Instance.new("ImageLabel")
            Arrow.Parent = DropFrame
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -30, 0, 9)
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Image = "rbxassetid://6034818372"
            Arrow.ImageColor3 = THEME.MainColor

            local ListFrame = Instance.new("Frame")
            ListFrame.Parent = DropFrame
            ListFrame.BackgroundTransparency = 1
            ListFrame.Position = UDim2.new(0, 0, 0, 38)
            ListFrame.Size = UDim2.new(1, 0, 0, #list * 30)

            local UIList = Instance.new("UIListLayout")
            UIList.Parent = ListFrame
            UIList.SortOrder = Enum.SortOrder.LayoutOrder

            for i, v in pairs(list) do
                local Item = Instance.new("TextButton")
                Item.Parent = ListFrame
                Item.BackgroundColor3 = THEME.LightDark
                Item.BackgroundTransparency = 1
                Item.Size = UDim2.new(1, 0, 0, 30)
                Item.Font = Enum.Font.SourceSans
                Item.Text = v
                Item.TextColor3 = THEME.SubTextColor
                Item.TextSize = 13

                Item.MouseEnter:Connect(function()
                    TweenService:Create(Item, TWEEN_INFO, {TextColor3 = THEME.MainColor}):Play()
                end)
                Item.MouseLeave:Connect(function()
                    TweenService:Create(Item, TWEEN_INFO, {TextColor3 = THEME.SubTextColor}):Play()
                end)
                Item.MouseButton1Click:Connect(function()
                    Label.Text = text .. ": " .. v
                    Expanded = false
                    TweenService:Create(DropFrame, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 38)}):Play()
                    TweenService:Create(Arrow, TWEEN_INFO, {Rotation = 0}):Play()
                    callback(v)
                end)
            end

            local Btn = Instance.new("TextButton")
            Btn.Parent = DropFrame
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 0, 38)
            Btn.Text = ""

            Btn.MouseButton1Click:Connect(function()
                Expanded = not Expanded
                if Expanded then
                    TweenService:Create(DropFrame, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 38 + #list * 30 + 5)}):Play()
                    TweenService:Create(Arrow, TWEEN_INFO, {Rotation = 180}):Play()
                else
                    TweenService:Create(DropFrame, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 38)}):Play()
                    TweenService:Create(Arrow, TWEEN_INFO, {Rotation = 0}):Play()
                end
            end)
        end

        return Tab
    end

    return Window
end

-- ============================================================
--   EXAMPLE USAGE (FOR TESTING)
-- ============================================================
--[[
local Win = Library:CreateWindow("ZEOX PREMIUM")

local Tab1 = Win:CreateTab("Combat", "rbxassetid://104041288319444")
Tab1:CreateToggle("Kill Aura", false, function(v) print("Kill Aura:", v) end)
Tab1:CreateSlider("Range", 1, 50, 20, function(v) print("Range:", v) end)
Tab1:CreateDropdown("Method", {"Legit", "Blatant", "Silent"}, function(v) print("Method:", v) end)
Tab1:CreateButton("Reset Config", function() print("Config Reset!") end)

local Tab2 = Win:CreateTab("Visuals", "rbxassetid://16276677105")
Tab2:CreateToggle("ESP", true, function(v) print("ESP:", v) end)
Tab2:CreateToggle("Tracer", false, function(v) print("Tracer:", v) end)

local Tab3 = Win:CreateTab("Misc", "rbxassetid://71378730274638")
Tab3:CreateButton("Teleport to Spawn", function() print("Teleporting...") end)
]]

return Library
