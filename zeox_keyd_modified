
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local ContentProvider = game:GetService("ContentProvider")

repeat task.wait() until game:IsLoaded() and Players.LocalPlayer

plr = Players.LocalPlayer

-- ============================================================
--   ASSET IDs - عدّل هنا براحتك
-- ============================================================
local UI_ASSETS = {
	Wallpaper     = "rbxassetid://139213622869074", -- خلفية الإنترو
	Logo          = "rbxassetid://104041288319444", -- اللوقو
	LoaderGlow    = "rbxassetid://16073652319", -- ضوء بار التحميل
	HoverEffect   = "rbxassetid://16261022724", -- تأثير هوفر الأزرار
	CommunityIcon = "rbxassetid://71378730274638", -- أيقونة الكومينيتي
	NotifIcon     = "rbxassetid://16276677105", -- أيقونة الإشعارات
	PreloadAsset1 = "rbxassetid://4560909609",  -- preload 1
	PreloadAsset2 = "rbxassetid://12187376174", -- preload 2
    TabIcon       = "rbxassetid://104041288319444", -- أيقونة افتراضية للتابات
}
-- ============================================================

-- CONFIG
INFO_DOT25_QUAD = TweenInfo.new(.25,Enum.EasingStyle.Quad)

function CoreGuiAdd(gui)
    repeat wait() until pcall(function()
        gui.Parent = CoreGui
    end)
end

PreloadID = {
	UI_ASSETS.PreloadAsset1,
	UI_ASSETS.PreloadAsset2,
}
UI_LOCK = false -- No key system, so UI is not locked by default

function isNotLocked(v)
	if not v:GetAttribute("Locked") and UI_LOCK == false then
		return true
	end
end

do	
	-- Main ScreenGui for the new UI
	local MainScreenGui = Instance.new("ScreenGui")
	MainScreenGui.IgnoreGuiInset = true
	MainScreenGui.ResetOnSpawn = false
	MainScreenGui.Name = "Zeox_MainUI"
	MainScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CoreGuiAdd(MainScreenGui)
	MainScreenGui.Enabled = true

	-- Main container for the UI
	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0.6, 0, 0.8, 0)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.BorderSizePixel = 0
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = MainScreenGui

	local UICorner_MainFrame = Instance.new("UICorner")
	UICorner_MainFrame.CornerRadius = UDim.new(0, 10)
	UICorner_MainFrame.Parent = MainFrame

	-- Search Bar
	local SearchFrame = Instance.new("Frame")
	SearchFrame.Size = UDim2.new(0.9, 0, 0.08, 0)
	SearchFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
	SearchFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	SearchFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.Name = "SearchFrame"
	SearchFrame.Parent = MainFrame

	local UICorner_Search = Instance.new("UICorner")
	UICorner_Search.CornerRadius = UDim.new(0, 8)
	UICorner_Search.Parent = SearchFrame

	local SearchTextBox = Instance.new("TextBox")
	SearchTextBox.Size = UDim2.new(0.95, 0, 0.8, 0)
	SearchTextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	SearchTextBox.AnchorPoint = Vector2.new(0.5, 0.5)
	SearchTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	SearchTextBox.BorderSizePixel = 0
	SearchTextBox.PlaceholderText = "Search..."
	SearchTextBox.TextScaled = true
	SearchTextBox.TextColor3 = Color3.fromRGB(200, 200, 200)
	SearchTextBox.TextXAlignment = Enum.TextXAlignment.Left
	SearchTextBox.Font = Enum.Font.SourceSans
	SearchTextBox.TextSize = 18
	SearchTextBox.Name = "SearchTextBox"
	SearchTextBox.Parent = SearchFrame

	-- Image ID Display (under Search)
	local ImageIDDisplay = Instance.new("ImageLabel")
	ImageIDDisplay.Size = UDim2.new(0.9, 0, 0.2, 0)
	ImageIDDisplay.Position = UDim2.new(0.5, 0, 0.25, 0)
	ImageIDDisplay.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageIDDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	ImageIDDisplay.BorderSizePixel = 0
	ImageIDDisplay.Image = UI_ASSETS.Logo -- Using existing logo as a placeholder
	ImageIDDisplay.ScaleType = Enum.ScaleType.Fit
	ImageIDDisplay.Name = "ImageIDDisplay"
	ImageIDDisplay.Parent = MainFrame

	local UICorner_ImageID = Instance.new("UICorner")
	UICorner_ImageID.CornerRadius = UDim.new(0, 8)
	UICorner_ImageID.Parent = ImageIDDisplay

	-- Tabs Container
	local TabsContainer = Instance.new("ScrollingFrame")
	TabsContainer.Size = UDim2.new(0.9, 0, 0.5, 0)
	TabsContainer.Position = UDim2.new(0.5, 0, 0.65, 0)
	TabsContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	TabsContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	TabsContainer.BorderSizePixel = 0
	TabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated dynamically
	TabsContainer.ScrollBarImageColor3 = Color3.fromRGB(200, 0, 0)
	TabsContainer.ScrollBarThickness = 6
	TabsContainer.Name = "TabsContainer"
	TabsContainer.Parent = MainFrame

	local UICorner_TabsContainer = Instance.new("UICorner")
	UICorner_TabsContainer.CornerRadius = UDim.new(0, 8)
	UICorner_TabsContainer.Parent = TabsContainer

	local UIGridLayout_Tabs = Instance.new("UIGridLayout")
	UIGridLayout_Tabs.FillDirection = Enum.FillDirection.Horizontal
	UIGridLayout_Tabs.CellSize = UDim2.new(0.48, 0, 0.48, 0) -- For 2x2 grid, slightly less than 0.5 to allow spacing
	UIGridLayout_Tabs.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
	UIGridLayout_Tabs.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIGridLayout_Tabs.VerticalAlignment = Enum.VerticalAlignment.Top
	UIGridLayout_Tabs.Parent = TabsContainer

	-- Function to create a tab (similar to search box style)
	local function CreateTab(name, description, iconAssetId)
		local TabFrame = Instance.new("Frame")
		TabFrame.Size = UDim2.new(1, 0, 1, 0) -- Sized by UIGridLayout
		TabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		TabFrame.BorderSizePixel = 0
		TabFrame.Name = name:gsub(" ", "_") .. "_Tab"
		TabFrame.Parent = TabsContainer

		local UICorner_Tab = Instance.new("UICorner")
		UICorner_Tab.CornerRadius = UDim.new(0, 8)
		UICorner_Tab.Parent = TabFrame

		local TabTitle = Instance.new("TextLabel")
		TabTitle.Size = UDim2.new(0.8, 0, 0.2, 0)
		TabTitle.Position = UDim2.new(0.1, 0, 0.1, 0)
		TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabTitle.BackgroundTransparency = 1
		TabTitle.Text = "Setting"
		TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabTitle.TextScaled = true
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left
		TabTitle.Font = Enum.Font.SourceSansBold
		TabTitle.Name = "TabTitle"
		TabTitle.Parent = TabFrame

		local TabName = Instance.new("TextLabel")
		TabName.Size = UDim2.new(0.8, 0, 0.2, 0)
		TabName.Position = UDim2.new(0.1, 0, 0.3, 0)
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1
		TabName.Text = name
		TabName.TextColor3 = Color3.fromRGB(200, 200, 200)
		TabName.TextScaled = true
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.Font = Enum.Font.SourceSans
		TabName.Name = "TabName"
		TabName.Parent = TabFrame

		local TabDescription = Instance.new("TextLabel")
		TabDescription.Size = UDim2.new(0.8, 0, 0.3, 0)
		TabDescription.Position = UDim2.new(0.1, 0, 0.5, 0)
		TabDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabDescription.BackgroundTransparency = 1
		TabDescription.Text = description
		TabDescription.TextColor3 = Color3.fromRGB(150, 150, 150)
		TabDescription.TextScaled = true
		TabDescription.TextWrapped = true
		TabDescription.TextXAlignment = Enum.TextXAlignment.Left
		TabDescription.Font = Enum.Font.SourceSans
		TabDescription.Name = "TabDescription"
		TabDescription.Parent = TabFrame

		local TabIcon = Instance.new("ImageLabel")
		TabIcon.Size = UDim2.new(0.4, 0, 0.8, 0)
		TabIcon.Position = UDim2.new(0.9, 0, 0.5, 0)
		TabIcon.AnchorPoint = Vector2.new(1, 0.5)
		TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabIcon.BackgroundTransparency = 1
		TabIcon.Image = iconAssetId or UI_ASSETS.TabIcon
		TabIcon.ScaleType = Enum.ScaleType.Fit
		TabIcon.Name = "TabIcon"
		TabIcon.Parent = TabFrame
	end

	-- Example Tabs
	CreateTab("Tab One", "Description for Tab One", UI_ASSETS.CommunityIcon)
	CreateTab("Tab Two", "Description for Tab Two", UI_ASSETS.NotifIcon)
	CreateTab("Tab Three", "Description for Tab Three", UI_ASSETS.Logo)
	CreateTab("Tab Four", "Description for Tab Four", UI_ASSETS.HoverEffect)
    CreateTab("Tab Five", "Another example tab", UI_ASSETS.CommunityIcon)
    CreateTab("Tab Six", "Yet another example tab", UI_ASSETS.NotifIcon)

	-- Adjust CanvasSize for ScrollingFrame based on content
	TabsContainer.CanvasSize = UDim2.new(0, 0, 0, (UIGridLayout_Tabs.AbsoluteContentSize.Y / TabsContainer.AbsoluteSize.Y) + UIGridLayout_Tabs.CellPadding.Y.Scale * 2)

	-- Clean up old UI elements if they exist (from original script)
	-- Assuming HOHO_Passcheck and INTRO are the old key UI elements
	-- If they are not created, these lines will just do nothing.
	-- local HOHO_Passcheck = MainScreenGui:FindFirstChild("Zeox_Passcheck")
	-- if HOHO_Passcheck then HOHO_Passcheck:Destroy() end
	-- local INTRO = MainScreenGui:FindFirstChild("INTRO")
	-- if INTRO then INTRO:Destroy() end

	-- The original script had a HOHO_Gen4 for notifications, let's keep it if it's meant to be a general notification system.
	-- If not, it should be removed.
	-- For now, assuming it's a separate system and not directly tied to the key system UI.

	HOHO_Gen4 = Instance.new("ScreenGui")
	NOTIFICATION_ZONE = Instance.new("Frame")
	UIListLayout_Main = Instance.new("UIListLayout")
	UIAspectRatioConstraint_Main = Instance.new("UIAspectRatioConstraint")

	HOHO_Gen4.IgnoreGuiInset = true
	HOHO_Gen4.Enabled = true
	HOHO_Gen4.ResetOnSpawn = false
	HOHO_Gen4.Name = "Hоhо_gеn4"
	HOHO_Gen4.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- Changed from HOHO_Passcheck
    CoreGuiAdd(HOHO_Gen4)

	NOTIFICATION_ZONE.BorderSizePixel = 0
	NOTIFICATION_ZONE.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	NOTIFICATION_ZONE.AnchorPoint = Vector2.new(1, 1)
	NOTIFICATION_ZONE.Size = UDim2.new(0.213415, 0, 1, 0)
	NOTIFICATION_ZONE.ClipsDescendants = true
	NOTIFICATION_ZONE.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NOTIFICATION_ZONE.BackgroundTransparency = 1
	NOTIFICATION_ZONE.Name = "NOTIFICATION_ZONE"
	NOTIFICATION_ZONE.Position = UDim2.new(1, 0, 1, 0)
	NOTIFICATION_ZONE.Parent = HOHO_Gen4

	UIListLayout_Main.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_Main.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout_Main.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_Main.Parent = NOTIFICATION_ZONE

	UIAspectRatioConstraint_Main.AspectRatio = 0.424757
	UIAspectRatioConstraint_Main.Parent = NOTIFICATION_ZONE

	-- No key system, so no need for GET_KEY or INTRO transparency tweens
	-- UI_LOCK is already false

	local destroyUI = function()
		MainScreenGui:Destroy()
		HOHO_Gen4:Destroy()
	end

	-- Example of how to use a tab (e.g., clicking a tab could print its name)
	for _, tab in ipairs(TabsContainer:GetChildren()) do
		if tab:IsA("Frame") and tab.Name:match("_Tab") then
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, 0, 1, 0)
			button.BackgroundTransparency = 1
			button.Text = ""
			button.Parent = tab

			button.Activated:Connect(function()
				print("Tab clicked: " .. tab.Name)
				-- Add your tab specific logic here
				StarterGui:SetCore("SendNotification",{
					Title = "Tab System",
					Text = "You clicked " .. tab.Name:gsub("_", " "):gsub("Tab", ""),
					Icon = UI_ASSETS.NotifIcon
				})
			end)

			-- Hover effect for tabs (similar to original buttons)
			local HoverEffect = Instance.new("ImageLabel")
			HoverEffect.ImageColor3 = Color3.fromRGB(220, 0, 0)
			HoverEffect.BorderSizePixel = 0
			HoverEffect.SliceCenter = Rect.new(205, 197, 828, 828)
			HoverEffect.ScaleType = Enum.ScaleType.Slice
			HoverEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HoverEffect.ImageTransparency = 1
			HoverEffect.Position = UDim2.new(0.5, 0, 0.5, 0)
			HoverEffect.Name = "Hover"
			HoverEffect.AnchorPoint = Vector2.new(0.5, 0.5)
			HoverEffect.Image = UI_ASSETS.HoverEffect
			HoverEffect.Size = UDim2.new(1.055, 0, 1.45, 0)
			HoverEffect.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HoverEffect.BackgroundTransparency = 1
			HoverEffect.Parent = button

			button.MouseEnter:Connect(function()
				TweenService:Create(HoverEffect, INFO_DOT25_QUAD, {ImageTransparency = .25}):Play()
			end)
			button.MouseLeave:Connect(function()
				TweenService:Create(HoverEffect, INFO_DOT25_QUAD, {ImageTransparency = 1}):Play()
			end)
		end
	end

	-- Close button for the main UI (if needed, or can be removed)
	local CloseButton = Instance.new("TextButton")
	CloseButton.Size = UDim2.new(0.1, 0, 0.05, 0)
	CloseButton.Position = UDim2.new(0.95, 0, 0.05, 0)
	CloseButton.AnchorPoint = Vector2.new(1, 0)
	CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	CloseButton.BorderSizePixel = 0
	CloseButton.Text = "X"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.TextScaled = true
	CloseButton.Font = Enum.Font.SourceSansBold
	CloseButton.Name = "CloseButton"
	CloseButton.Parent = MainFrame

	local UICorner_CloseButton = Instance.new("UICorner")
	UICorner_CloseButton.CornerRadius = UDim.new(0, 5)
	UICorner_CloseButton.Parent = CloseButton

	CloseButton.Activated:Connect(function()
		destroyUI()
	end)

	-- Initial UI visibility
	MainScreenGui.Enabled = true

end

	-- Main ScreenGui for the new UI
	local MainScreenGui = Instance.new("ScreenGui")
	MainScreenGui.IgnoreGuiInset = true
	MainScreenGui.ResetOnSpawn = false
	MainScreenGui.Name = "Zeox_MainUI"
	MainScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CoreGuiAdd(MainScreenGui)
	MainScreenGui.Enabled = true

	-- Main container for the UI
	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0.6, 0, 0.8, 0)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.BorderSizePixel = 0
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = MainScreenGui

	local UICorner_MainFrame = Instance.new("UICorner")
	UICorner_MainFrame.CornerRadius = UDim.new(0, 10)
	UICorner_MainFrame.Parent = MainFrame

	-- Search Bar
	local SearchFrame = Instance.new("Frame")
	SearchFrame.Size = UDim2.new(0.9, 0, 0.08, 0)
	SearchFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
	SearchFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	SearchFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.Name = "SearchFrame"
	SearchFrame.Parent = MainFrame

	local UICorner_Search = Instance.new("UICorner")
	UICorner_Search.CornerRadius = UDim.new(0, 8)
	UICorner_Search.Parent = SearchFrame

	local SearchTextBox = Instance.new("TextBox")
	SearchTextBox.Size = UDim2.new(0.95, 0, 0.8, 0)
	SearchTextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	SearchTextBox.AnchorPoint = Vector2.new(0.5, 0.5)
	SearchTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	SearchTextBox.BorderSizePixel = 0
	SearchTextBox.PlaceholderText = "Search..."
	SearchTextBox.TextScaled = true
	SearchTextBox.TextColor3 = Color3.fromRGB(200, 200, 200)
	SearchTextBox.TextXAlignment = Enum.TextXAlignment.Left
	SearchTextBox.Font = Enum.Font.SourceSans
	SearchTextBox.TextSize = 18
	SearchTextBox.Name = "SearchTextBox"
	SearchTextBox.Parent = SearchFrame

	-- Image ID Display (under Search)
	local ImageIDDisplay = Instance.new("ImageLabel")
	ImageIDDisplay.Size = UDim2.new(0.9, 0, 0.2, 0)
	ImageIDDisplay.Position = UDim2.new(0.5, 0, 0.25, 0)
	ImageIDDisplay.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageIDDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	ImageIDDisplay.BorderSizePixel = 0
	ImageIDDisplay.Image = UI_ASSETS.Logo -- Using existing logo as a placeholder
	ImageIDDisplay.ScaleType = Enum.ScaleType.Fit
	ImageIDDisplay.Name = "ImageIDDisplay"
	ImageIDDisplay.Parent = MainFrame

	local UICorner_ImageID = Instance.new("UICorner")
	UICorner_ImageID.CornerRadius = UDim.new(0, 8)
	UICorner_ImageID.Parent = ImageIDDisplay

	-- Tabs Container
	local TabsContainer = Instance.new("ScrollingFrame")
	TabsContainer.Size = UDim2.new(0.9, 0, 0.5, 0)
	TabsContainer.Position = UDim2.new(0.5, 0, 0.65, 0)
	TabsContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	TabsContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	TabsContainer.BorderSizePixel = 0
	TabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated dynamically
	TabsContainer.ScrollBarImageColor3 = Color3.fromRGB(200, 0, 0)
	TabsContainer.ScrollBarThickness = 6
	TabsContainer.Name = "TabsContainer"
	TabsContainer.Parent = MainFrame

	local UICorner_TabsContainer = Instance.new("UICorner")
	UICorner_TabsContainer.CornerRadius = UDim.new(0, 8)
	UICorner_TabsContainer.Parent = TabsContainer

	local UIGridLayout_Tabs = Instance.new("UIGridLayout")
	UIGridLayout_Tabs.FillDirection = Enum.FillDirection.Horizontal
	UIGridLayout_Tabs.CellSize = UDim2.new(0.48, 0, 0.48, 0) -- For 2x2 grid, slightly less than 0.5 to allow spacing
	UIGridLayout_Tabs.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
	UIGridLayout_Tabs.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIGridLayout_Tabs.VerticalAlignment = Enum.VerticalAlignment.Top
	UIGridLayout_Tabs.Parent = TabsContainer

	-- Function to create a tab (similar to search box style)
	local function CreateTab(name, description, iconAssetId)
		local TabFrame = Instance.new("Frame")
		TabFrame.Size = UDim2.new(1, 0, 1, 0) -- Sized by UIGridLayout
		TabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		TabFrame.BorderSizePixel = 0
		TabFrame.Name = name:gsub(" ", "_") .. "_Tab"
		TabFrame.Parent = TabsContainer

		local UICorner_Tab = Instance.new("UICorner")
		UICorner_Tab.CornerRadius = UDim.new(0, 8)
		UICorner_Tab.Parent = TabFrame

		local TabTitle = Instance.new("TextLabel")
		TabTitle.Size = UDim2.new(0.8, 0, 0.2, 0)
		TabTitle.Position = UDim2.new(0.1, 0, 0.1, 0)
		TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabTitle.BackgroundTransparency = 1
		TabTitle.Text = "Setting"
		TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabTitle.TextScaled = true
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left
		TabTitle.Font = Enum.Font.SourceSansBold
		TabTitle.Name = "TabTitle"
		TabTitle.Parent = TabFrame

		local TabName = Instance.new("TextLabel")
		TabName.Size = UDim2.new(0.8, 0, 0.2, 0)
		TabName.Position = UDim2.new(0.1, 0, 0.3, 0)
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1
		TabName.Text = name
		TabName.TextColor3 = Color3.fromRGB(200, 200, 200)
		TabName.TextScaled = true
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.Font = Enum.Font.SourceSans
		TabName.Name = "TabName"
		TabName.Parent = TabFrame

		local TabDescription = Instance.new("TextLabel")
		TabDescription.Size = UDim2.new(0.8, 0, 0.3, 0)
		TabDescription.Position = UDim2.new(0.1, 0, 0.5, 0)
		TabDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabDescription.BackgroundTransparency = 1
		TabDescription.Text = description
		TabDescription.TextColor3 = Color3.fromRGB(150, 150, 150)
		TabDescription.TextScaled = true
		TabDescription.TextWrapped = true
		TabDescription.TextXAlignment = Enum.TextXAlignment.Left
		TabDescription.Font = Enum.Font.SourceSans
		TabDescription.Name = "TabDescription"
		TabDescription.Parent = TabFrame

		local TabIcon = Instance.new("ImageLabel")
		TabIcon.Size = UDim2.new(0.4, 0, 0.8, 0)
		TabIcon.Position = UDim2.new(0.9, 0, 0.5, 0)
		TabIcon.AnchorPoint = Vector2.new(1, 0.5)
		TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabIcon.BackgroundTransparency = 1
		TabIcon.Image = iconAssetId or UI_ASSETS.TabIcon
		TabIcon.ScaleType = Enum.ScaleType.Fit
		TabIcon.Name = "TabIcon"
		TabIcon.Parent = TabFrame
	end

	-- Example Tabs
	CreateTab("Tab One", "Description for Tab One", UI_ASSETS.CommunityIcon)
	CreateTab("Tab Two", "Description for Tab Two", UI_ASSETS.NotifIcon)
	CreateTab("Tab Three", "Description for Tab Three", UI_ASSETS.Logo)
	CreateTab("Tab Four", "Description for Tab Four", UI_ASSETS.HoverEffect)
    CreateTab("Tab Five", "Another example tab", UI_ASSETS.CommunityIcon)
    CreateTab("Tab Six", "Yet another example tab", UI_ASSETS.NotifIcon)

	-- Adjust CanvasSize for ScrollingFrame based on content
	TabsContainer.CanvasSize = UDim2.new(0, 0, 0, (UIGridLayout_Tabs.AbsoluteContentSize.Y / TabsContainer.AbsoluteSize.Y) + UIGridLayout_Tabs.CellPadding.Y.Scale * 2)

	-- Clean up old UI elements if they exist (from original script)
	-- Assuming HOHO_Passcheck and INTRO are the old key UI elements
	-- If they are not created, these lines will just do nothing.
	-- local HOHO_Passcheck = MainScreenGui:FindFirstChild("Zeox_Passcheck")
	-- if HOHO_Passcheck then HOHO_Passcheck:Destroy() end
	-- local INTRO = MainScreenGui:FindFirstChild("INTRO")
	-- if INTRO then INTRO:Destroy() end

	-- The original script had a HOHO_Gen4 for notifications, let's keep it if it's meant to be a general notification system.
	-- If not, it should be removed.
	-- For now, assuming it's a separate system and not directly tied to the key system UI.

	HOHO_Gen4 = Instance.new("ScreenGui")
	NOTIFICATION_ZONE = Instance.new("Frame")
	UIListLayout_Main = Instance.new("UIListLayout")
	UIAspectRatioConstraint_Main = Instance.new("UIAspectRatioConstraint")

	HOHO_Gen4.IgnoreGuiInset = true
	HOHO_Gen4.Enabled = true
	HOHO_Gen4.ResetOnSpawn = false
	HOHO_Gen4.Name = "Hоhо_gеn4"
	HOHO_Gen4.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- Changed from HOHO_Passcheck
    CoreGuiAdd(HOHO_Gen4)

	NOTIFICATION_ZONE.BorderSizePixel = 0
	NOTIFICATION_ZONE.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	NOTIFICATION_ZONE.AnchorPoint = Vector2.new(1, 1)
	NOTIFICATION_ZONE.Size = UDim2.new(0.213415, 0, 1, 0)
	NOTIFICATION_ZONE.ClipsDescendants = true
	NOTIFICATION_ZONE.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NOTIFICATION_ZONE.BackgroundTransparency = 1
	NOTIFICATION_ZONE.Name = "NOTIFICATION_ZONE"
	NOTIFICATION_ZONE.Position = UDim2.new(1, 0, 1, 0)
	NOTIFICATION_ZONE.Parent = HOHO_Gen4

	UIListLayout_Main.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_Main.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout_Main.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_Main.Parent = NOTIFICATION_ZONE

	UIAspectRatioConstraint_Main.AspectRatio = 0.424757
	UIAspectRatioConstraint_Main.Parent = NOTIFICATION_ZONE

	-- No key system, so no need for GET_KEY or INTRO transparency tweens
	-- UI_LOCK is already false

	local destroyUI = function()
		MainScreenGui:Destroy()
		HOHO_Gen4:Destroy()
	end

	-- Example of how to use a tab (e.g., clicking a tab could print its name)
	for _, tab in ipairs(TabsContainer:GetChildren()) do
		if tab:IsA("Frame") and tab.Name:match("_Tab") then
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, 0, 1, 0)
			button.BackgroundTransparency = 1
			button.Text = ""
			button.Parent = tab

			button.Activated:Connect(function()
				print("Tab clicked: " .. tab.Name)
				-- Add your tab specific logic here
				StarterGui:SetCore("SendNotification",{
					Title = "Tab System",
					Text = "You clicked " .. tab.Name:gsub("_", " "):gsub("Tab", ""),
					Icon = UI_ASSETS.NotifIcon
				})
			end)

			-- Hover effect for tabs (similar to original buttons)
			local HoverEffect = Instance.new("ImageLabel")
			HoverEffect.ImageColor3 = Color3.fromRGB(220, 0, 0)
			HoverEffect.BorderSizePixel = 0
			HoverEffect.SliceCenter = Rect.new(205, 197, 828, 828)
			HoverEffect.ScaleType = Enum.ScaleType.Slice
			HoverEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HoverEffect.ImageTransparency = 1
			HoverEffect.Position = UDim2.new(0.5, 0, 0.5, 0)
			HoverEffect.Name = "Hover"
			HoverEffect.AnchorPoint = Vector2.new(0.5, 0.5)
			HoverEffect.Image = UI_ASSETS.HoverEffect
			HoverEffect.Size = UDim2.new(1.055, 0, 1.45, 0)
			HoverEffect.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HoverEffect.BackgroundTransparency = 1
			HoverEffect.Parent = button

			button.MouseEnter:Connect(function()
				TweenService:Create(HoverEffect, INFO_DOT25_QUAD, {ImageTransparency = .25}):Play()
			end)
			button.MouseLeave:Connect(function()
				TweenService:Create(HoverEffect, INFO_DOT25_QUAD, {ImageTransparency = 1}):Play()
			end)
		end
	end

	-- Close button for the main UI (if needed, or can be removed)
	local CloseButton = Instance.new("TextButton")
	CloseButton.Size = UDim2.new(0.1, 0, 0.05, 0)
	CloseButton.Position = UDim2.new(0.95, 0, 0.05, 0)
	CloseButton.AnchorPoint = Vector2.new(1, 0)
	CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	CloseButton.BorderSizePixel = 0
	CloseButton.Text = "X"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.TextScaled = true
	CloseButton.Font = Enum.Font.SourceSansBold
	CloseButton.Name = "CloseButton"
	CloseButton.Parent = MainFrame

	local UICorner_CloseButton = Instance.new("UICorner")
	UICorner_CloseButton.CornerRadius = UDim.new(0, 5)
	UICorner_CloseButton.Parent = CloseButton

	CloseButton.Activated:Connect(function()
		destroyUI()
	end)

	-- Initial UI visibility
	MainScreenGui.Enabled = true

end
