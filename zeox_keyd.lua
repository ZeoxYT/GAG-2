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
	CommunityIcon = "rbxassetid://83781775444786", -- أيقونة الكومينيتي
	NotifIcon     = "rbxassetid://101956991637378", -- أيقونة الإشعارات
	PreloadAsset1 = "rbxassetid://4560909609",  -- preload 1
	PreloadAsset2 = "rbxassetid://12187376174", -- preload 2
}
-- ============================================================

-- CONFIG
local FIXED_KEY = "Zeox-2026" -- المفتاح الثابت

local isSupport = _G.loadCustomId or "Zeox-Key-System827474788991757772"

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
UI_LOCK = true

function isNotLocked(v)
	if not v:GetAttribute("Locked") and UI_LOCK == false then
		return true
	end
end

do	
	HOHO_Passcheck = Instance.new("ScreenGui")
	INTRO = Instance.new("CanvasGroup")
	Wallpaper = Instance.new("ImageLabel")
	TextHolder = Instance.new("Frame")
	Status = Instance.new("TextLabel")
	UITextSizeConstraint = Instance.new("UITextSizeConstraint")
	Gradient = Instance.new("Frame")
	UIGradient = Instance.new("UIGradient")
	Pattern = Instance.new("ImageLabel")
	Logo = Instance.new("ImageLabel")
	Main = Instance.new("ImageLabel")
	UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	Loader = Instance.new("Frame")
	Content = Instance.new("Frame")
	UIStroke = Instance.new("UIStroke")
	ImageLabel = Instance.new("ImageLabel")
	UIAspectRatioConstraint_1 = Instance.new("UIAspectRatioConstraint")
	UICorner = Instance.new("UICorner")
	GET_KEY = Instance.new("CanvasGroup")
	UICorner_1 = Instance.new("UICorner")
	Logo_1 = Instance.new("ImageLabel")
	UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
	Get = Instance.new("TextButton")
	UICorner_2 = Instance.new("UICorner")
	UIStroke_1 = Instance.new("UIStroke")
	Title = Instance.new("TextLabel")
	Submit = Instance.new("TextButton")
	UICorner_3 = Instance.new("UICorner")
	UIStroke_2 = Instance.new("UIStroke")
	Title_1 = Instance.new("TextLabel")
	Pfp = Instance.new("ImageLabel")
	UICorner_4 = Instance.new("UICorner")
	Support = Instance.new("TextButton")
	UICorner_5 = Instance.new("UICorner")
	UIStroke_3 = Instance.new("UIStroke")
	Title_2 = Instance.new("TextLabel")
	Credit = Instance.new("TextLabel")
	Close = Instance.new("TextButton")
	Title_3 = Instance.new("TextLabel")
	UIStroke_4 = Instance.new("UIStroke")
	UICorner_6 = Instance.new("UICorner")
	Frame = Instance.new("Frame")
	UIStroke_5 = Instance.new("UIStroke")
	UIGradient_2 = Instance.new("UIGradient")
	UIGradient_3 = Instance.new("UIGradient")
	UICorner_7 = Instance.new("UICorner")
	Frame_1 = Instance.new("TextLabel")
	Frame_2 = Instance.new("TextBox")
	UIStroke_6 = Instance.new("UIStroke")
	UICorner_8 = Instance.new("UICorner")
	UICorner_9 = Instance.new("UICorner")
	Gradient_1 = Instance.new("Frame")
	UIGradient_1 = Instance.new("UIGradient")
	Pattern_1 = Instance.new("ImageLabel")
	Hover = Instance.new("ImageLabel")
	local Hover_2
	Gradient_Frame = Instance.new("Frame")
	UIGradient_4 = Instance.new("UIGradient")

	HOHO_Passcheck.IgnoreGuiInset = true
	HOHO_Passcheck.ResetOnSpawn = false
	HOHO_Passcheck.Name = "Zeox_Passcheck"
	HOHO_Passcheck.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	HOHO_Passcheck.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CoreGuiAdd(HOHO_Passcheck)
	HOHO_Passcheck.Enabled = true

	INTRO.BorderSizePixel = 0
	INTRO.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	INTRO.AnchorPoint = Vector2.new(0.5, 0.5)
	INTRO.Size = UDim2.new(0.455271, 0, 0.46186, 0)
	INTRO.ZIndex = 1000
	INTRO.Name = "INTRO"
	INTRO.Position = UDim2.new(0.5, 0, 0.5, 0)
	INTRO.BorderColor3 = Color3.fromRGB(0, 0, 0)
	INTRO.Parent = HOHO_Passcheck

	Hover.ImageColor3 = Color3.fromRGB(220, 0, 0)
	Hover.BorderSizePixel = 0
	Hover.SliceCenter = Rect.new(205, 197, 828, 828)
	Hover.ScaleType = Enum.ScaleType.Slice
	Hover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Hover.ImageTransparency = 1
	Hover.Position = UDim2.new(0.5, 0, 0.5, 0)
	Hover.Name = "Hover"
	Hover.AnchorPoint = Vector2.new(0.5, 0.5)
	Hover.Image = UI_ASSETS.HoverEffect
	Hover.Size = UDim2.new(1.055, 0, 1.45, 0)
	Hover.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Hover.BackgroundTransparency = 1
	Hover.Parent = Get

	Hover_2 = Hover:Clone()
	Hover_2.Parent = Submit

	Wallpaper.BorderSizePixel = 0
	Wallpaper.ScaleType = Enum.ScaleType.Fit
	Wallpaper.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Wallpaper.Position = UDim2.new(-0.0361702, 0, -0.158876, 0)
	Wallpaper.Name = "Wallpaper"
	Wallpaper.Image = IS_CUSTOM_UI_MODE and CUSTOM_UI_MODE_DATA.Background or UI_ASSETS.Wallpaper
	Wallpaper.Size = UDim2.new(1.11064, 0, 1.59989, 0)
	Wallpaper.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Wallpaper.Parent = INTRO

	TextHolder.BorderSizePixel = 0
	TextHolder.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	TextHolder.Size = UDim2.new(1, 0, 0.284847, 0)
	TextHolder.BorderColor3 = Color3.fromRGB(8, 8, 8)
	TextHolder.Name = "TextHolder"
	TextHolder.Position = UDim2.new(0, 0, 0.753631, 0)
	TextHolder.Parent = INTRO

	Status.TextWrapped = true
	Status.BorderSizePixel = 0
	Status.TextScaled = true
	Status.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Status.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Italic)
	Status.Position = UDim2.new(0.120042, 0, 0.254529, 0)
	Status.Name = "Status"
	Status.TextSize = 20
	Status.Size = UDim2.new(0.79993, 0, 0.464041, 0)
	Status.ZIndex = 50
	Status.TextColor3 = Color3.fromRGB(255, 255, 255)
	Status.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Status.Text = IS_CUSTOM_UI_MODE and CUSTOM_UI_MODE_DATA.IntroText or "Preparing your HUB for an amazing experience."
	Status.BackgroundTransparency = 1
	Status.Parent = TextHolder
	Status:SetAttribute("EngText",Status.Text)

	UITextSizeConstraint.MaxTextSize = 20
	UITextSizeConstraint.Parent = Status

	Gradient.BorderSizePixel = 0
	Gradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Gradient.Size = UDim2.new(1, 0, 1, 0)
	Gradient.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Gradient.Name = "Gradient"
	Gradient.Position = UDim2.new(0, 0, 2.11993e-08, 0)
	Gradient.Parent = TextHolder

	UIGradient.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 0.9) }
	UIGradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)), ColorSequenceKeypoint.new(0.466321, Color3.fromRGB(130, 0, 0)), ColorSequenceKeypoint.new(0.797927, Color3.fromRGB(40, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8)) }
	UIGradient.Rotation = -90
	UIGradient.Parent = Gradient

	Pattern.SliceCenter = Rect.new(0, 256, 0, 256)
	Pattern.ScaleType = Enum.ScaleType.Tile
	Pattern.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Pattern.ImageTransparency = 0.6
	Pattern.Position = UDim2.new(6.64996e-05, 0, 0.00124399, 0)
	Pattern.Name = "Pattern"
	Pattern.Image = "rbxassetid://2151741365"
	Pattern.TileSize = UDim2.new(0, 250, 0, 250)
	Pattern.Size = UDim2.new(1, 0, 1, 0)
	Pattern.ZIndex = 0
	Pattern.BackgroundTransparency = 1
	Pattern.Parent = Gradient

	Logo.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Logo.BorderSizePixel = 0
	Logo.ScaleType = Enum.ScaleType.Fit
	Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Logo.ImageTransparency = 0.5
	Logo.Position = UDim2.new(0.271609, 0, 0.122057, 0)
	Logo.Name = "Logo"
	Logo.Image = IS_CUSTOM_UI_MODE and CUSTOM_UI_MODE_DATA.Logo or UI_ASSETS.Logo
	Logo.Size = UDim2.new(0.453191, 0, 0.550704, 0)
	Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Logo.ZIndex = 50
	Logo.BackgroundTransparency = 1
	Logo.Parent = INTRO

	Main.BorderSizePixel = 0
	Main.ScaleType = Enum.ScaleType.Fit
	Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Name = "Main"
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Image = UI_ASSETS.Logo
	Main.Size = UDim2.new(0.95, 0, 0.95, 0)
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BackgroundTransparency = 1
	Main.Parent = Logo

	UIAspectRatioConstraint.AspectRatio = 2.08357
	UIAspectRatioConstraint.Parent = INTRO

	Loader.BorderSizePixel = 0
	Loader.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
	Loader.Size = UDim2.new(0.999948, 0, 0.0285966, 0)
	Loader.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Loader.Name = "Loader"
	Loader.Position = UDim2.new(0, 0, 0.751682, 0)
	Loader.ZIndex = 50
	Loader.Parent = INTRO

	Content.BorderSizePixel = 0
	Content.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
	Content.Size = UDim2.new(0.462745, 0, 1, 0)
	Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Content.Name = "Content"
	Content.Parent = Loader

	UIStroke.Transparency = 0.5
	UIStroke.Parent = Content

	ImageLabel.ImageColor3 = Color3.fromRGB(220, 0, 0)
	ImageLabel.BorderSizePixel = 0
	ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel.Position = UDim2.new(1, 0, .5, 0)
	ImageLabel.AnchorPoint = Vector2.new(.5,.5)
	ImageLabel.Image = UI_ASSETS.LoaderGlow
	ImageLabel.Size = UDim2.new(0.671884, 0, 15.1201, 0)
	ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Parent = Content

	UIAspectRatioConstraint_1.AspectRatio = 1.49814
	UIAspectRatioConstraint_1.Parent = ImageLabel

	UICorner.CornerRadius = UDim.new(0, 30)
	UICorner.Parent = INTRO

	GET_KEY.BorderSizePixel = 0
	GET_KEY.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	GET_KEY.AnchorPoint = Vector2.new(0.5, 0.5)
	GET_KEY.Size = UDim2.new(0.359117, 0, 0.665296, 0)
	GET_KEY.ZIndex = 1000
	GET_KEY.Name = "GET_KEY"
	GET_KEY.Position = UDim2.new(0.5, 0, 0.5, 0)
	GET_KEY.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GET_KEY.Parent = HOHO_Passcheck


	UICorner_1.CornerRadius = UDim.new(0.075, 0)
	UICorner_1.Parent = GET_KEY

	Logo_1.BorderSizePixel = 0
	Logo_1.ScaleType = Enum.ScaleType.Fit
	Logo_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Logo_1.Position = UDim2.new(0.256362, 0, 0.0700547, 0)
	Logo_1.Name = "Logo"
	Logo_1.Image = IS_CUSTOM_UI_MODE and CUSTOM_UI_MODE_DATA.Logo or UI_ASSETS.Logo
	Logo_1.Size = UDim2.new(0.481145, 0, 0.133585, 0)
	Logo_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Logo_1.ZIndex = 50
	Logo_1.BackgroundTransparency = 1
	Logo_1.Parent = GET_KEY

	UIAspectRatioConstraint_2.AspectRatio = 1.14096
	UIAspectRatioConstraint_2.Parent = GET_KEY

	Get.TextWrapped = true
	Get.ZIndex = 50
	Get.BorderSizePixel = 0
	Get.AutoButtonColor = true
	Get.TextScaled = true
	Get.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	Get.Position = UDim2.new(0.336, 0, 0.45377, 0)
	Get.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	Get.Name = "Get"
	Get.AnchorPoint = Vector2.new(0.5, 0.5)
	Get.Active = true
	Get.TextSize = 20
	Get.Size = UDim2.new(0.51, 0, 0.095, 0)
	Get.TextColor3 = Color3.fromRGB(255, 255, 255)
	Get.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Get.Text = ""
	Get.Selectable = true
	Get.BackgroundTransparency = 0.01
	Get.Parent = GET_KEY

	UICorner_2.CornerRadius = UDim.new(0, 7)
	UICorner_2.Parent = Get

	UIStroke_1.Color = Color3.fromRGB(220, 0, 0)
	UIStroke_1.Transparency = 0.5
	UIStroke_1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke_1.Parent = Get

	Title.TextWrapped = true
	Title.BorderSizePixel = 0
	Title.TextScaled = true
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	Title.Position = UDim2.new(0.5, 0, 0.5, 0)
	Title.Name = "Title"
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.Size = UDim2.new(1, 0, 0.546077, 0)
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title.Text = "GET KEY"
	Title.BackgroundTransparency = 1
	Title.Parent = Get
	Title:SetAttribute("EngText",Title.Text)

	Submit.TextWrapped = true
	Submit.ZIndex = 50
	Submit.BorderSizePixel = 0
	Submit.AutoButtonColor = true
	Submit.TextScaled = true
	Submit.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	Submit.Position = UDim2.new(0.50063, 0, 0.578448, 0)
	Submit.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	Submit.Name = "Submit"
	Submit.AnchorPoint = Vector2.new(0.5, 0.5)
	Submit.Active = true
	Submit.TextSize = 20
	Submit.Size = UDim2.new(0.838618, 0, 0.095, 0)
	Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
	Submit.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Submit.Text = ""
	Submit.Selectable = true
	Submit.BackgroundTransparency = 0.01
	Submit.Parent = GET_KEY

	UICorner_3.CornerRadius = UDim.new(0, 7)
	UICorner_3.Parent = Submit

	UIStroke_2.Color = Color3.fromRGB(220, 0, 0)
	UIStroke_2.Transparency = 0.5
	UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke_2.Parent = Submit

	Title_1.TextWrapped = true
	Title_1.BorderSizePixel = 0
	Title_1.TextScaled = true
	Title_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title_1.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	Title_1.Position = UDim2.new(0.5, 0, 0.48, 0)
	Title_1.Name = "Title"
	Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Title_1.Size = UDim2.new(1, 0, 0.546, 0)
	Title_1.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title_1.Text = "SUBMIT KEY"
	Title_1.BackgroundTransparency = 1
	Title_1.Parent = Submit
	Title_1:SetAttribute("EngText",Title_1.Text)

    Get2 = Get:Clone()
    Get2.Name = "Get2"
	Get2.Position = UDim2.new(0.764, 0, 0.45377, 0)
	Get2.Size = UDim2.new(0.312, 0, 0.095, 0)
    Get2.Title.Text = "Get Key - zeox.xyz"
	Get2.Parent = GET_KEY

	Pfp.BorderSizePixel = 0
	Pfp.ScaleType = Enum.ScaleType.Fit
	Pfp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Pfp.Position = UDim2.new(0.0810142, 0, 0.652851, 0)
	Pfp.Name = "Pfp"
	Pfp.Image = IS_CUSTOM_UI_MODE and CUSTOM_UI_MODE_DATA.CommunityIcon or UI_ASSETS.CommunityIcon
	Pfp.Size = UDim2.new(0.229672, 0, 0.261163, 0)
	Pfp.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Pfp.ZIndex = 50
	Pfp.BackgroundTransparency = 1
	Pfp.Parent = GET_KEY

	UICorner_4.CornerRadius = UDim.new(0.075, 0)
	UICorner_4.Parent = Pfp

	Support.TextWrapped = true
	Support.ZIndex = 50
	Support.BorderSizePixel = 0
	Support.AutoButtonColor = true
	Support.TextScaled = true
	Support.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Support.Position = UDim2.new(0.626422, 0, 0.765503, 0)
	Support.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	Support.Name = "Support"
	Support.AnchorPoint = Vector2.new(0.5, 0.5)
	Support.Active = true
	Support.TextSize = 20
	Support.Size = UDim2.new(0.58195, 0, 0.0811856, 0)
	Support.TextColor3 = Color3.fromRGB(255, 255, 255)
	Support.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Support.Text = ""
	Support.BackgroundTransparency = 0.01
	Support.Selectable = true
	Support.Parent = GET_KEY

	UICorner_5.CornerRadius = UDim.new(0, 7)
	UICorner_5.Parent = Support

	UIStroke_3.Color = Color3.fromRGB(255, 0, 0)
	UIStroke_3.Thickness = 1.25
	UIStroke_3.Transparency = 0.25
	UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke_3.Parent = Support

	Title_2.TextWrapped = true
	Title_2.BorderSizePixel = 0
	Title_2.TextScaled = true
	Title_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title_2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	Title_2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Title_2.Name = "Title"
	Title_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Title_2.Size = UDim2.new(1, 0, 0.6, 0)
	Title_2.TextColor3 = Color3.fromRGB(255, 0, 0)
	Title_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title_2.Text = "SUPPORT US"
	Title_2.BackgroundTransparency = 1
	Title_2.Parent = Support
	Title_2:SetAttribute("EngText",Title_2.Text)

	Credit.TextWrapped = true
	Credit.BorderSizePixel = 0
	Credit.RichText = true
	Credit.TextScaled = true
	Credit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Credit.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	Credit.Position = UDim2.new(0.627693, 0, 0.67966, 0)
	Credit.Name = "Credit"
	Credit.AnchorPoint = Vector2.new(0.5, 0.5)
	Credit.Size = UDim2.new(0.584491, 0, 0.0536177, 0)
	Credit.ZIndex = 50
	Credit.TextColor3 = Color3.fromRGB(255, 255, 255)
	Credit.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Credit.Text = [[<font color="#cc0000">DISCORD</font> .gg/row | <font color="#ffffff">Zeox Key System</font>]]
	if IS_CUSTOM_UI_MODE then
        local dc = '<font color="#cc0000">DISCORD</font> .gg/' .. (CUSTOM_UI_MODE_DATA.Discord or "row")
        Credit.Text = dc .. " | <font color='#ffffff'>Zeox Key System</font>"
    end
	Credit.BackgroundTransparency = 1
	Credit.Parent = GET_KEY

	Close.TextWrapped = true
	Close.ZIndex = 50
	Close.BorderSizePixel = 0
	Close.AutoButtonColor = true
	Close.TextScaled = true
	Close.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Close.Position = UDim2.new(0.626422, 0, 0.871296, 0)
	Close.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	Close.Name = "Close"
	Close.AnchorPoint = Vector2.new(0.5, 0.5)
	Close.Active = true
	Close.TextSize = 20
	Close.Size = UDim2.new(0.582, 0, 0.081, 0)
	Close.TextColor3 = Color3.fromRGB(255, 255, 255)
	Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Close.Text = ""
	Close.BackgroundTransparency = 0.01
	Close.Selectable = true
	Close.Parent = GET_KEY

	Title_3.TextWrapped = true
	Title_3.BorderSizePixel = 0
	Title_3.TextScaled = true
	Title_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title_3.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	Title_3.Position = UDim2.new(0.5, 0, 0.5, 0)
	Title_3.Name = "Title"
	Title_3.AnchorPoint = Vector2.new(0.5, 0.5)
	Title_3.Size = UDim2.new(1, 0, 0.6, 0)
	Title_3.TextColor3 = Color3.fromRGB(255, 0, 0)
	Title_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title_3.Text = "CLOSE UI"
	Title_3.BackgroundTransparency = 1
	Title_3.Parent = Close
	Title_3:SetAttribute("EngText",Title_3.Text)

	UIStroke_4.Color = Color3.fromRGB(255, 0, 0)
	UIStroke_4.Thickness = 1.25
	UIStroke_4.Transparency = 0.25
	UIStroke_4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke_4.Parent = Close

	UICorner_6.CornerRadius = UDim.new(0, 7)
	UICorner_6.Parent = Close

	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Size = UDim2.new(0.838618, 0, 0.11308, 0)
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.Position = UDim2.new(0.50063, 0, 0.308795, 0)
	Frame.ZIndex = 50
	Frame.Parent = GET_KEY

	UIStroke_5.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_5.Thickness = 1.25
	UIStroke_5.Transparency = 0.5
	UIStroke_5.Parent = Frame

	UIGradient_2.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.9, 0.995), NumberSequenceKeypoint.new(1, 1) }
	UIGradient_2.Rotation = -90
	UIGradient_2.Color = ColorSequence.new(Color3.fromRGB(210, 0, 0))
	UIGradient_2.Parent = UIStroke_5

	UIStroke_5.Thickness = 2

	UIGradient_3.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.9, 0.995), NumberSequenceKeypoint.new(1, 1) }
	UIGradient_3.Rotation = -90
	UIGradient_3.Parent = UIStroke_6

	UICorner_7.CornerRadius = UDim.new(0, 7)

	Frame_1.TextWrapped = true
	Frame_1.BorderSizePixel = 0
	Frame_1.TextScaled = true
	UICorner_7.Parent = Frame
	Frame_1.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	Frame_1.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	Frame_1.Position = UDim2.new(0.265781, 0, 0.485383, 0)
	Frame_1.Name = "Title"
	Frame_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame_1.Size = UDim2.new(0.393164, 0, 0.523336, 0)
	Frame_1.TextColor3 = Color3.fromRGB(255, 255, 255)
	Frame_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_1.Text = "ENTER KEY HERE"
	Frame_1.BackgroundTransparency = 1
	Frame_1.TextXAlignment = Enum.TextXAlignment.Left
	Frame_1.Parent = Frame
	Frame_1:SetAttribute("EngText",Frame_1.Text)

	Frame_2.TextWrapped = true
	Frame_2.BorderSizePixel = 0
	Frame_2.Position = UDim2.new(0.780933, 0, 0.498203, 0)
	Frame_2.TextScaled = true
	Frame_2.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	Frame_2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	Frame_2.Active = true
	Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame_2.PlaceholderText = "..."
	Frame_2.Size = UDim2.new(0.302255, 0, 0.600259, 0)
	Frame_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_2.Text = ""
	Frame_2.Selectable = true
	Frame_2.Name = "Textbox"
	Frame_2.Parent = Frame

	UIStroke_6.Color = Color3.fromRGB(210, 0, 0)
	UIStroke_6.Thickness = 1.25
	UIStroke_6.Transparency = 0.5
	UIStroke_6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke_6.Parent = Frame_2

	UICorner_8.CornerRadius = UDim.new(0, 7)
	UICorner_8.Parent = Frame_2

	Gradient_1.BorderSizePixel = 0
	Gradient_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Gradient_1.Size = UDim2.new(1, 0, 1, 0)
	Gradient_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Gradient_1.Name = "Gradient"
	Gradient_1.Position = UDim2.new(0, 0, 2.11993e-08, 0)
	Gradient_1.Parent = GET_KEY

	UIGradient_1.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 0.9) }
	UIGradient_1.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(157, 2, 31)), ColorSequenceKeypoint.new(0.468048, Color3.fromRGB(46.7098, 28.0691, 31.4853)), ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8)) }
	UIGradient_1.Rotation = -90
	UIGradient_1.Parent = Gradient_1

	Pattern_1.SliceCenter = Rect.new(0, 256, 0, 256)
	Pattern_1.ScaleType = Enum.ScaleType.Tile
	Pattern_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Pattern_1.ImageTransparency = 0.6
	Pattern_1.Position = UDim2.new(6.64996e-05, 0, 0.00124399, 0)
	Pattern_1.Name = "Pattern"
	Pattern_1.Image = "rbxassetid://2151741365"
	Pattern_1.TileSize = UDim2.new(0, 250, 0, 250)
	Pattern_1.Size = UDim2.new(1, 0, 1, 0)
	Pattern_1.ZIndex = 0
	Pattern_1.BackgroundTransparency = 1
	Pattern_1.Parent = Gradient_1

	Gradient_Frame.BorderSizePixel = 0
	Gradient_Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Gradient_Frame.Size = UDim2.new(1, 0, 1, 0)
	Gradient_Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Gradient_Frame.Name = "Gradient"
	Gradient_Frame.Position = UDim2.new(0, 0, 2.11993e-08, 0)
	Gradient_Frame.ZIndex = 0
	Gradient_Frame.BackgroundTransparency = 1
	Gradient_Frame.Parent = Frame

	UIGradient_4.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 0)), ColorSequenceKeypoint.new(0.531952, Color3.fromRGB(40, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8)) }
	UIGradient_4.Rotation = -90
	UIGradient_4.Parent = Gradient_Frame

	UICorner_9.CornerRadius = UDim.new(0, 10)
	UICorner_9.Parent = Gradient_Frame

	HOHO_Gen4 = Instance.new("ScreenGui")
	NOTIFICATION_ZONE = Instance.new("Frame")
	UIListLayout_Main = Instance.new("UIListLayout")
	UIAspectRatioConstraint_Main = Instance.new("UIAspectRatioConstraint")

	HOHO_Gen4.IgnoreGuiInset = true
	HOHO_Gen4.Enabled = true
	HOHO_Gen4.ResetOnSpawn = false
	HOHO_Gen4.Name = "Hоhо_gеn4"
	HOHO_Gen4.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	HOHO_Passcheck.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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

	GET_KEY.Visible = false
	INTRO.GroupTransparency = 1
	GET_KEY.GroupTransparency = 1

	local function EnterKey(v)
		local textbox = v["Textbox"]
		local gradient = v.Gradient
		local stroke = v.UIStroke

		local tween_1_in = TweenService:Create(gradient,INFO_DOT25_QUAD,{BackgroundTransparency = 0})
		local tween_2_in = TweenService:Create(stroke.UIGradient,INFO_DOT25_QUAD,{Offset = Vector2.new(0,-.5)})

		local tween_1_out = TweenService:Create(gradient,INFO_DOT25_QUAD,{BackgroundTransparency = 1})
		local tween_2_out = TweenService:Create(stroke.UIGradient,INFO_DOT25_QUAD,{Offset = Vector2.new(0,0)})

		textbox.Focused:Connect((function()
			tween_1_in:Play()
			tween_2_in:Play()
		end))

		textbox.FocusLost:Connect((function()
			tween_1_out:Play()
			tween_2_out:Play()
		end))
	end

	EnterKey(Frame)

	for i,v in pairs({Get,Submit,Close,Support}) do
		if isNotLocked(v) then
			if v == Get or v == Submit then
				v.MouseEnter:Connect((function()
					TweenService:Create(v.Hover,INFO_DOT25_QUAD,{ImageTransparency = .25}):Play()
				end))
				v.MouseLeave:Connect((function()
					TweenService:Create(v.Hover,INFO_DOT25_QUAD,{ImageTransparency = 1}):Play()
				end))
			else
				v.MouseEnter:Connect((function()
					TweenService:Create(v,INFO_DOT25_QUAD,{BackgroundTransparency = .1}):Play()
					TweenService:Create(v["Title"],INFO_DOT25_QUAD,{TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end))
				v.MouseLeave:Connect((function()
					TweenService:Create(v,INFO_DOT25_QUAD,{BackgroundTransparency = 1}):Play()
					TweenService:Create(v["Title"],INFO_DOT25_QUAD,{TextColor3 = Color3.fromRGB(210, 0, 0)}):Play()
				end))
			end
		end
	end

    if (isfile("Zeox_Intro.txt") and (tick() - tonumber(readfile("Zeox_Intro.txt"))) >= 86400) or not isfile("Zeox_Intro.txt") then
        writefile("Zeox_Intro.txt", tostring(tick())) 
        
        local preload_content = {}
        for i,v in pairs(HOHO_Passcheck:GetDescendants()) do
            table.insert(preload_content,v)
        end
        for i,v in pairs(PreloadID) do
            table.insert(preload_content,v)
        end
    
        ContentProvider:PreloadAsync(preload_content)
    
        Content.Size = UDim2.new(0,0,1,0)
    
        TweenService:Create(INTRO,INFO_DOT25_QUAD,{GroupTransparency = 0}):Play()
        task.wait(.5)
        for i = 1, #preload_content do
            local asset = preload_content[i]
            local progress = i / #preload_content
            TweenService:Create(Content,TweenInfo.new(.1,Enum.EasingStyle.Quad),{Size = UDim2.new(progress,0,1,0)}):Play()
            task.wait(math.random(1,5)/50)
        end
    
        TweenService:Create(INTRO,INFO_DOT25_QUAD,{GroupTransparency = 1}):Play()
    end

	GET_KEY.Visible = true
	TweenService:Create(GET_KEY,INFO_DOT25_QUAD,{GroupTransparency = 0}):Play()
	UI_LOCK = false

	local destroyUI = function()
		HOHO_Passcheck:Destroy()
		HOHO_Gen4:Destroy()
	end

	local do_check_key = function(key)
	key = key:gsub("[\r\n%z]", " "):gsub("[ \t]", ""):gsub("[ \n]", ""):gsub("[ \t]+%f[\r\n%z]", "")

	if key == FIXED_KEY then
		StarterGui:SetCore("SendNotification", {
			Title = "Key System",
			Text = "Key Correct! Loading...",
			Icon = UI_ASSETS.NotifIcon
		})

		TweenService:Create(GET_KEY, INFO_DOT25_QUAD, {
			GroupTransparency = 1
		}):Play()

		task.delay(0.2, function()
			destroyUI()
			loadstring(game:HttpGet("https://script.zeox.xyz/raw/srjfe257fg24vr37.lua"))()
		end)

	else
		StarterGui:SetCore("SendNotification", {
			Title = "Key System",
			Text = "Invalid Key! Please try again.",
			Icon = UI_ASSETS.NotifIcon
		})
	end
	end
	Submit.Activated:Connect(function()
	do_check_key(Frame.Textbox.Text)
end)
    Support.Activated:Once(function()
        setclipboard("https://discord.gg/row")
        StarterGui:SetCore("SendNotification",{
            Title = "Key System",
            Text = "Discord link copied!",
            Icon = UI_ASSETS.NotifIcon
        })
	end)

	Close.Activated:Once(function()
		destroyUI()
	end)

	Get.Activated:Connect(function()
		setclipboard('https://zeox.xyz/home')
		StarterGui:SetCore("SendNotification",{
			Title = "Key System",
			Text = "Key Link Copied!",
			Icon = UI_ASSETS.NotifIcon
		})
	end)

    Get2.Activated:Connect(function()
        setclipboard('https://zeox.xyz/tutorial')
        StarterGui:SetCore("SendNotification",{
            Title = "Key System",
            Text = "Tutorial Link Copied!",
            Icon = UI_ASSETS.NotifIcon
        })
	end)
end
