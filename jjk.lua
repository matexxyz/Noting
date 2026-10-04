
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "lightninghax [ Ikonned ]",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by @Ikonned",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ExampleHub2019",
        FileName = "Settings2019"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
})

Rayfield:Notify({
   Title = "lightninghax Successfully Loaded",
   Content = "By @Ikonned",
   Duration = 11.5,
   Image = 98381986793772,
})

local LightningHaxAlive = true
local TabletSuppressingESP = false
local function LightningAlive()
    return LightningHaxAlive
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer


local RemotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local HomeTab = Window:CreateTab("Mods", 98381986793772)
local ExploitsTab = Window:CreateTab("Exploits", 10448639430)
local ChamsTab = Window:CreateTab("ESP", 14380950090)
local SpawnsTab = Window:CreateTab("Spawns", 11278229112)
local PlushysTab = Window:CreateTab("Plushies", 11924266902)
local UtilitiesTab = Window:CreateTab("Utilities", 4483362458)
local CreditsTab = Window:CreateTab("Credits", 16587986504)

CreditsTab:CreateParagraph({
    Title = "Special Thanks",
    Content = "Huge thanks to deathgod0784 for the extensive rework, new features, fixes, testing, and improvements that helped bring lightninghax to its current state."
})
CreditsTab:CreateParagraph({
    Title = "Thanks",
    Content = "Thanks to @Ikonned for creating lightninghax."
})


HomeTab:CreateParagraph({
    Title = "Note:",
    Content = "Execute Figure or Seek MODS in the room they will spawn in"
})


local TabletViewActive=false
TabletSuppressingESP=false
local TabletESPResumeState=nil

local function SetTabletESPMode(active)
    if active then
        if TabletViewActive then return end
        TabletViewActive=true
        TabletSuppressingESP=true

        TabletESPResumeState={
            Door=DoorESPEnabled,
            Chest=ChestESPEnabled,
            Item=ItemESPEnabled,
            Objective=ObjectiveESPEnabled,
            Player=PlayerESPEnabled,
            Entity=EntityESPEnabled,
        }

        if DoorESPEnabled then
            DoorESPEnabled=false
            if DoorESPConnection then DoorESPConnection:Disconnect(); DoorESPConnection=nil end
            table.clear(DoorPending)
            RemoveNamedESP("RealDoorESP","RealDoorCrossFill","RealDoorOuterBorder","RealDoorESPLabel")
        end

        if ChestESPEnabled then
            ChestESPEnabled=false
            if ChestESPConnection then ChestESPConnection:Disconnect(); ChestESPConnection=nil end
            RemoveNamedESP("ChestESP","ChestESPLabel")
        end

        if ItemESPEnabled then
            ItemESPEnabled=false
            if ItemESPConnection then ItemESPConnection:Disconnect(); ItemESPConnection=nil end
            RemoveNamedESP("ItemESP","ItemESPLabel")
        end

        if ObjectiveESPEnabled then
            ObjectiveESPEnabled=false
            if ObjectiveConnection then ObjectiveConnection:Disconnect(); ObjectiveConnection=nil end
            RemoveNamedESP("ObjectiveESP","ObjectiveESPLabel","KeyESP","KeyESPLabel")
        end

        if PlayerESPEnabled then
            PlayerESPEnabled=false
            for player in pairs(PlayerESPObjects) do
                RemovePlayerESP(player)
            end
        end

        if EntityESPEnabled then
            EntityESPEnabled=false
            for model,data in pairs(EntityBillboards) do
                if data.gui and data.gui.Parent then data.gui:Destroy() end
                EntityBillboards[model]=nil
            end
            for _,obj in ipairs(workspace.CurrentRooms:GetDescendants()) do
                if obj.Name=="FigureESP" and obj:IsA("Highlight") then obj:Destroy() end
            end
            for hitbox,transparency in pairs(FigureHitboxTransparency) do
                if hitbox and hitbox.Parent then hitbox.Transparency=transparency end
                FigureHitboxTransparency[hitbox]=nil
            end
        end
    else
        if not TabletViewActive then return end
        TabletViewActive=false
        TabletSuppressingESP=false

        local resume=TabletESPResumeState
        TabletESPResumeState=nil
        if not resume then return end

        if resume.Door then
            DoorESPEnabled=true
            ScanDoors()
            DoorESPConnection=workspace.CurrentRooms.ChildAdded:Connect(function(room)
                if LightningHaxAlive and DoorESPEnabled and IsRoomInESPRange(room) then QueueDoor(room) end
            end)
        end

        if resume.Chest then
            ChestESPEnabled=true
            ScanChests()
            ChestESPConnection=workspace.CurrentRooms.ChildAdded:Connect(function(room)
                if LightningHaxAlive and ChestESPEnabled and IsRoomInESPRange(room) then task.delay(0.25,ScanChests) end
            end)
        end

        if resume.Item then
            ItemESPEnabled=true
            ScanItems()
            ItemESPConnection=workspace.CurrentRooms.ChildAdded:Connect(function(room)
                if LightningHaxAlive and ItemESPEnabled and IsRoomInESPRange(room) then task.delay(0.25,ScanItems) end
            end)
        end

        if resume.Objective then
            ObjectiveESPEnabled=true
            ScanObjectives()
            ObjectiveConnection=workspace.CurrentRooms.ChildAdded:Connect(function(room)
                if LightningHaxAlive and ObjectiveESPEnabled and IsRoomInESPRange(room) then task.delay(0.25,ScanObjectives) end
            end)
        end

        if resume.Player then
            PlayerESPEnabled=true
            for _,player in ipairs(Players:GetPlayers()) do AddPlayerESP(player) end
        end

        if resume.Entity then
            EntityESPEnabled=true
            EnsureEntityWatchers()
            ScanEntities()
        end
    end
end

HomeTab:CreateButton({
    Name = "Mischievous Tablet Chest [ HOTEL 0 ]",
    Callback = function()

        function giveTablet()
            local Scanner = game:GetObjects("rbxassetid://117271882843186")[1]
        
        Scanner.Parent = game.Players.LocalPlayer.Backpack
        _G.scanner_fps = 1000
        local target_fps = _G.scanner_fps or 1000
        local disable_static = _G.disable_static or false
        
        -- Variables
        local Storage = Scanner:WaitForChild("Storage")
        local Handle = Scanner:WaitForChild("Handle", 1)
        local ScannerViewportFrame = Storage.ScreenUI
        
        local ScannerActivateTickDelay = tick()
        
        local ScannerCamera = Instance.new("Camera")
        
        local TweenService = game:GetService("TweenService")
        local player = game.Players.LocalPlayer
        
        local LastScannedRoom = -1
        local CalculatedFPSWait = (1 / target_fps)
        
        local IsScannerOpened = false
        local Equipped = false
        
        local ScannerObjectives = {
            "KeyObtain",
            "LeverForGate",
            "LiveBreakerPolePickup",
            "LiveHintBook",
            "FuseObtain",
            "MinesAnchor",
            "WaterPump",
            "TimerLever",
            "RoomEntrance"
        }
        
        local StaticImageUrl = {
            "rbxassetid://8681113666",
            "rbxassetid://8681113503"
        }
        
        local LoadedAnimations = {}
        
        
        local function ScannerStaticStart()
            ScannerViewportFrame.OffScreen.Visible = false
        
            ScannerViewportFrame.Static1.ImageTransparency = 0
            ScannerViewportFrame.Static2.ImageTransparency = 0
        
            TweenService:Create(ScannerViewportFrame.Static1, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.9
            }):Play()
        
            TweenService:Create(ScannerViewportFrame.Static2, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
                ImageTransparency = 1
            }):Play()
        
            ScannerViewportFrame.ViewSpecial.ImageColor3 = Color3.fromRGB(217, 255, 206)
        
            TweenService:Create(ScannerViewportFrame.ViewSpecial, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 10, true), {
                ImageColor3 = Color3.fromRGB(53, 93, 52)
            }):Play()
        
            ScannerCamera.FieldOfView = 1
        
            TweenService:Create(ScannerCamera, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
                FieldOfView = 30
            }):Play()
        
            Scanner.Handle.Use:Play()
            Scanner.Handle.Idle:Play()
        end
        
        local function ScannerStaticStop()
            ScannerViewportFrame.OffScreen.Visible = true
            ScannerViewportFrame.OffScreen.Frame.Size = UDim2.new(1, 0, 1, 0)
        
            TweenService:Create(ScannerViewportFrame.OffScreen.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0.1, 0)
            }):Play()
        
            task.delay(0.31, function()
                TweenService:Create(ScannerViewportFrame.OffScreen.Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0), {
                    Size = UDim2.new(0, 0, 0.1, 0)
                }):Play()
            end)
        
            ScannerViewportFrame.OffScreen.BackgroundColor3 = Color3.fromRGB(39, 59, 33)
            TweenService:Create(ScannerViewportFrame.OffScreen, TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0), {
                BackgroundColor3 = Color3.fromRGB(3, 6, 2)
            }):Play()
        
            Scanner.Handle.Disable:Play()
            Scanner.Handle.Idle:Stop()
        end
        
        local function ScannerAnimateStatic()
            ScannerViewportFrame.Static1.Position = UDim2.new(0.5, math.random(-28, 28) * 6, 0.5, math.random(-18, 18) * 6)
            ScannerViewportFrame.Static2.Position = UDim2.new(0.5, math.random(-28, 28) * 6, 0.5, math.random(-18, 18) * 6)
        
            local static_image = StaticImageUrl[math.random(1, #StaticImageUrl)]
            ScannerViewportFrame.Static1.Image = static_image
        end
        
        
        local function SetupScannerView(room)
            local ScannerRoomView = Instance.new("Model", ScannerViewportFrame.ViewNormal)
            ScannerRoomView.Name = room.Name
        
            local function SetupCloneRoomPart(instance)
                if instance:IsA("BasePart") and instance.Transparency ~= 1 and instance.Size.Magnitude > 0.2 then
                    local current_room_part = instance:Clone()

                    for _, child in ipairs(current_room_part:GetDescendants()) do
                        if child:IsA("Highlight")
                            or child:IsA("BoxHandleAdornment")
                            or child:IsA("BillboardGui")
                            or string.find(child.Name, "ESP", 1, true) then
                            child:Destroy()
                        end
                    end

                    for _, child in ipairs(current_room_part:GetChildren()) do
                        if child:IsA("Highlight")
                            or child:IsA("BoxHandleAdornment")
                            or child:IsA("BillboardGui")
                            or string.find(child.Name, "ESP", 1, true) then
                            child:Destroy()
                        end
                    end
        
                    current_room_part.CanQuery = false
                    current_room_part.Parent = ScannerRoomView
        
                    if not instance.Anchored then
                        task.spawn(function()
                            while task.wait(0.5) do
                                if not instance or not instance.Parent then
                                    break
                                end
                            
                                current_room_part.Position = instance.Position
                            end
                            
                            current_room_part:Destroy()
                        end)
                    end
                end
        
                if instance:IsA("Model") and table.find(ScannerObjectives, instance.Name) then
                    local StarObjective = Storage.Star:Clone()
        
                    StarObjective.CFrame = instance.PrimaryPart.CFrame or instance:GetPivot()
                    StarObjective.Parent = ScannerViewportFrame.ViewSpecial
                end
            end
        
        
            for _, v in pairs(room:GetDescendants()) do
                SetupCloneRoomPart(v)
            end
        
            local connection = room.DescendantAdded:Connect(function(part)
        if not LightningHaxAlive then return end
                SetupCloneRoomPart(part)
            end)
        
            ScannerRoomView.AncestryChanged:Connect(function()
        if not LightningHaxAlive then return end
                connection:Disconnect()
            end)
        end
        
        local function CleanupScannerView()
            for _, v in pairs(ScannerViewportFrame.ViewNormal:GetChildren()) do
                if v:IsA("Model") then
                    v:Destroy()
                end
            end
            
            for _, v in pairs(ScannerViewportFrame.ViewSpecial:GetChildren()) do
                if v:IsA("BasePart") then
                    v:Destroy()
                end
            end
        end
        
        
        ScannerCamera.Parent = ScannerViewportFrame
        ScannerCamera.FieldOfView = 50
        
        ScannerViewportFrame.ViewNormal.CurrentCamera = ScannerCamera
        ScannerViewportFrame.ViewSpecial.CurrentCamera = ScannerCamera
        
        Scanner.Activated:Connect(function()
        if not LightningHaxAlive then return end
            if not (ScannerActivateTickDelay <= tick()) then
                return
            end
        
            if ScannerActivateTickDelay <= tick() then
                ScannerActivateTickDelay = tick() + 0.5
        
                LoadedAnimations.fire:Play(0.05, 1, 1)
        
                task.wait(0.2)
        
                IsScannerOpened = not IsScannerOpened
        
                if not IsScannerOpened then
                    return ScannerStaticStop()
                end
            end
        
            ScannerStaticStart()
        end)
        
        Scanner.Equipped:Connect(function()
        if not LightningHaxAlive then return end
            SetTabletESPMode(true)
            for _, anim in pairs(Scanner:WaitForChild("Animations"):GetChildren()) do
                LoadedAnimations[anim.Name] = player.Character.Humanoid:LoadAnimation(anim)
            end
        
            LoadedAnimations.equip:Play()
            LoadedAnimations.idle:Play()
        
            ScannerViewportFrame.Parent = player.PlayerGui
            ScannerViewportFrame.Enabled = true
            ScannerViewportFrame.Adornee = Scanner:WaitForChild("Handle"):WaitForChild("Screen")
        
            local target_room = player:GetAttribute("CurrentRoom")
            LastScannedRoom = target_room
        
            local room_instance = workspace.CurrentRooms:FindFirstChild(target_room)
            if room_instance and ScannerViewportFrame.ViewNormal:FindFirstChild(target_room) == nil then
                SetupScannerView(room_instance)
            end
        
            task.wait(0.2)
        
            Equipped = true
            IsScannerOpened = true
        
            ScannerStaticStart()
        
            while Equipped do
                if IsScannerOpened then
                    
                    local success, errormsg = pcall(function()
                        target_room = player:GetAttribute("CurrentRoom")
        
                        if not disable_static then
                            ScannerCamera.CFrame = Scanner.Handle.Screen.CFrame * CFrame.Angles(0, 3.15, 0)
                            ScannerViewportFrame.ViewNormal.LightDirection = ScannerCamera.CFrame.LookVector - Vector3.new(0, 1, 0)
                            
                            ScannerAnimateStatic()
                        end
        
                        if disable_static and not ScannerViewportFrame.Static1.Visible then
                            ScannerViewportFrame.Static1.Visible = false
                            ScannerViewportFrame.Static2.Visible = false
                        end
        
                        for _, v in pairs(ScannerViewportFrame.ViewSpecial:GetChildren()) do
                            if v:IsA("BasePart") then
                                v.CFrame = CFrame.new(v.Position, ScannerCamera.CFrame.Position)
                            end
                        end
        
                        if target_room ~= LastScannedRoom then
                            LastScannedRoom = target_room
        
                            ScannerStaticStart()
                            CleanupScannerView()
        
                            room_instance = workspace.CurrentRooms:FindFirstChild(target_room)
                            if room_instance and ScannerViewportFrame.ViewNormal:FindFirstChild(target_room) == nil then
                                SetupScannerView(room_instance)
                            end
                        end
                    end)
                    
                    if errormsg then
                        warn(errormsg)
                    end
                end
        
                if not Equipped then
                    break
                end
        
                task.wait(CalculatedFPSWait)
            end
        end)
        
        Scanner.Unequipped:Connect(function()
        if not LightningHaxAlive then return end
            SetTabletESPMode(false)
            ScannerViewportFrame.Parent = player.PlayerGui
            ScannerViewportFrame.Enabled = false
            ScannerViewportFrame.Adornee = nil
            Equipped = false
            IsScannerOpened = false
            for _, anim in pairs(LoadedAnimations) do
                pcall(function() anim:Stop(0.1) end)
            end
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
            end
            for _, v in pairs(Handle:GetChildren()) do
                if v:IsA("Sound") then
                    v:Stop()
                end
            end
        
            Scanner.Handle.Disable:Play()
        
            CleanupScannerView()
        
            LoadedAnimations.equip:Stop()
            LoadedAnimations.idle:Stop()
        end)
        end
        
        local model = game:GetObjects("rbxassetid://72100839686852")[1]
            
            local lid = model.Lid
            local Torso = model.Torso
            local P2 = Torso.Parent.Tablet.ProximityPrompt2
            model.Parent = game.Workspace
            model:SetPrimaryPartCFrame(CFrame.new(277.521, -2.986, -35.233) * CFrame.Angles(0, math.rad(14.925), 0))
            
            local Sound = model.Open
            
            local novaPosicao = Vector3.new(278.878, -1.696, -35.652)
            local novaRotacao = Vector3.new(66.559, -72.771, 180)
            
            Torso.ProximityPrompt.Triggered:Connect(function()
        if not LightningHaxAlive then return end
                Sound:Play()
                lid.Position = novaPosicao
                lid.Orientation = novaRotacao
                lid.Latches.Position = novaPosicao
                lid.Latches.Orientation = novaRotacao
                lid.Metal.Position = novaPosicao
                lid.Metal.Orientation = novaRotacao
                lid.NormalHandle.Position = novaPosicao
                lid.NormalHandle.Orientation = novaRotacao
                lid.Wood.Position = novaPosicao
                lid.Wood.Orientation = novaRotacao
                Torso.ProximityPrompt.Enabled = false
                P2.Enabled = true
            end)
            
            P2.Triggered:Connect(function()
        if not LightningHaxAlive then return end
                giveTablet()
                model.Tablet:Destroy()
            end)

    end,
})

HomeTab:CreateButton({
    Name = "Pink Tablet",
    Callback = function()

local Players = game:GetService("Players") 
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Plr = Players.LocalPlayer
local Character = Plr.Character or Plr.CharacterAdded:Wait()

local CurrentRooms = workspace:WaitForChild("CurrentRooms", 9e9)

local Assets = game:GetObjects("rbxassetid://12501464609")[1]
Assets.Parent = ReplicatedStorage

local Scanner = Assets.CrystalScanner
local UI = Assets.ScreenUICrystal
local OffS = UI.OffScreen

local ItemsToRemove = {}
local Stars = {}
local Connections = {}

local State = false
local CanUse = true

local TabletID = math.random(1, 999999999)

function MoveRoomToViewport(Room : Model)
	local Clone = Room:Clone()

	for _, v in ipairs(Clone:GetDescendants()) do
		if v:IsA("Highlight")
			or v:IsA("BoxHandleAdornment")
			or v:IsA("BillboardGui")
			or string.find(v.Name, "ESP", 1, true) then
			v:Destroy()
		end
	end

	Clone.Parent = UI.ViewNormal
	
	for _,v in pairs(Clone:QueryDescendants("Sound")) do
		v:Destroy()
	end
	
	ItemsToRemove[#ItemsToRemove + 1] = Clone
end

function MarkObject(Object, Prompt)
	if Object:GetAttribute("TabletMark_"..TabletID) then return end

	local Marked = Object.PrimaryPart
	local S = MarkObjectWithStar(Marked)
	
	if Prompt then
		local C_; C_ = Prompt.Triggered:Connect(function()
        if not LightningHaxAlive then return end
			C_:Disconnect()
			
			TweenService:Create(S, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{
				Transparency = 1
			}):Play()

			task.delay(1, function()
				S:Destroy()
			end)
		end)
	end
	
	local Room = Object:FindFirstAncestorWhichIsA("Model")
	Room.Destroying:Connect(function()
        if not LightningHaxAlive then return end
		S:Destroy()
	end)
	
	Object:SetAttribute("TabletMark_"..TabletID, true)
end

function MarkObjectWithStar(Object : BasePart)
	local NewStar = Assets.Star:Clone()
	NewStar.Parent = UI.ViewSpecial
	NewStar.Position = Object.Position
	NewStar.Color = Color3.new(1, 1, 1)
	
	local Index = #Stars + 1
	
	Object.Destroying:Connect(function()
        if not LightningHaxAlive then return end
		table.remove(Stars, Index)
		
		TweenService:Create(NewStar, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{
			Transparency = 1
		}):Play()
		
		task.delay(1, function()
			NewStar:Destroy()
		end)
	end)
	
	Stars[#Stars + 1] = NewStar
	
	return NewStar
end

function DisplayStatic()
	Scanner.Handle.Use:Play()
	UI.Static2.ImageTransparency = 0
	UI.ViewSpecial.ImageTransparency = 1
	
	TweenService:Create(UI.ViewSpecial, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{
		ImageTransparency = 0
	}):Play()
	
	TweenService:Create(UI.Static2, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{
		ImageTransparency = 1
	}):Play()
end

function TurnOffAnimation()
	Scanner.Handle.Disable:Play()
	
	OffS.Visible = true
	OffS.Frame.Size = UDim2.fromScale(1, 1)
	
	TweenService:Create(OffS.Frame, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{
		Size = UDim2.fromScale(1, .1)
	}):Play()
	
	task.wait(.5)
	
	TweenService:Create(OffS.Frame, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),{
		Size = UDim2.fromScale(0, .1)
	}):Play()
end

function Switch()
	if not CanUse then
		return false
	end
	
	CanUse = false
	
	local Anim = Character.Humanoid:LoadAnimation(Scanner.Animations.fire)
	Anim.Priority = "Action4"
	Anim:Play()
	
	task.wait(.3)
	
	if State == false then
		On()
	else
	
		Off()
	end
	
	task.wait(1)
	
	CanUse = true
end

function CameraStaticMover(Static)
	local RNG = math.random(-100, 100)
	local RNG1 = math.random(-100, 100)
	Static.Position = UDim2.new(0.5, RNG, 0.5, RNG1)
end

function Update()
	local RoomId = Plr:GetAttribute("CurrentRoom")
	local CurrentRoom = CurrentRooms:FindFirstChild(RoomId)
	
	for _, v in pairs(ItemsToRemove) do
		v:Destroy()
	end

	if CurrentRooms:FindFirstChild(RoomId - 1) then
		MoveRoomToViewport(CurrentRooms[RoomId - 1]) -- Previous room
	end

	MoveRoomToViewport(CurrentRoom) -- Current room

	if CurrentRooms:FindFirstChild(RoomId + 1) then
		MoveRoomToViewport(CurrentRooms[RoomId + 1]) -- Next room
	end

	local ToFind = {
		"LeverForGate"
	}

	for _, v in next, CurrentRoom:QueryDescendants("ProximityPrompt") do
		local ancestor = v:FindFirstAncestorWhichIsA("Model")
		if
			v.Name == "ModulePrompt"
			or v.Name == "HidingPrompt"
			or table.find(ToFind, ancestor.Name)
		then
			MarkObject(ancestor, v)
		end
	end
end

local OGLight = Scanner.Handle.Screen.SurfaceLight.Brightness

function On()
	DisplayStatic()
	OffS.Visible = false
	
	TweenService:Create(Scanner.Handle.Screen.SurfaceLight, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),{
		Brightness = OGLight
	}):Play()
	
	State = true
	
	Update()
	
	Connections.CurrentRoomChanged = Plr:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
        if not LightningHaxAlive then return end
		if State then
			DisplayStatic()
			Update()
		end
	end)
	
	task.spawn(function()
		while RunService.PreRender:Wait() do
			if not State then 
				break 
			end
			
			for _,v in pairs(Stars) do
				v.CFrame = CFrame.lookAt(v.Position, Scanner.Handle.Position)
			end
			
			CameraStaticMover(UI.Static1)
			CameraStaticMover(UI.Static2)
			
			UI.Camera.CFrame = Scanner.Handle.CFrame * CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, 0, -.3)
		end
	end)
end

function Off()
	task.spawn(function()
		TurnOffAnimation()
	end)
	
	task.spawn(function()
		TweenService:Create(Scanner.Handle.Screen.SurfaceLight, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),{
			Brightness = 0
		}):Play()
	end)
	
	for _, v in pairs(Connections) do
		v:Disconnect()
	end
	Connections = {}
	
	State = false
end

function OffUnequip()
	SetTabletESPMode(false)
	UI.Enabled = false
	UI.ViewNormal.CurrentCamera = nil
	UI.ViewSpecial.CurrentCamera = nil
	
	Off()
end

function OnEquip()
	SetTabletESPMode(true)
	UI.Enabled = true
	UI.ViewNormal.CurrentCamera = UI.Camera
	UI.ViewSpecial.CurrentCamera = UI.Camera
	
	On()
end

Scanner.Equipped:Connect(OnEquip)
Scanner.Unequipped:Connect(OffUnequip)
Scanner.Activated:Connect(Switch)

UI.Parent = Plr.PlayerGui
Scanner.Parent = Plr.Backpack
    end,
})

HomeTab:CreateButton({
    Name = "Buff Figure [ SEEK ]",
    Callback = function()

        local ToFind =
            workspace:FindFirstChild("SeekMoving")
            or workspace:FindFirstChild("SeekMovingNewClone")

        if ToFind then

            for _, Color in pairs(ToFind:GetDescendants()) do
                if Color:IsA("BasePart") or Color:IsA("Decal") then
                    Color.Transparency = 1
                end
            end

            local Figure = game:GetObjects("rbxassetid://17147503424")[1]

            Figure.Body.Weld.C0 =
                CFrame.new(0,0,0)
                * CFrame.Angles(math.rad(0), math.rad(180), math.rad(0))

            Figure.Body.Weld.Part1 =
                ToFind.SeekRig.UpperTorso

            Figure.Parent = ToFind.SeekRig
        end
    end,
})

HomeTab:CreateButton({
    Name = "Big Seek [ SEEK ]",
    Callback = function()


function Setup(SeekMoving : Model)
    for _, Color : BasePart in pairs(SeekMoving:GetDescendants()) do
        if Color:IsA("BasePart") or Color:IsA("Decal") then
            Color.Transparency = 1
        end
    end

    for _, Cheese : Beam in pairs(SeekMoving:GetDescendants()) do
        if Cheese:IsA("Beam") and Cheese.Name == "StringCheese" then
            Cheese:Destroy()
        end
    end

    task.wait()

    local Seek : Model = game:GetObjects("rbxassetid://137059330176031")[1]
    Seek.Weld.Part1 = SeekMoving.SeekRig.UpperTorso
    Seek.Parent = SeekMoving.SeekRig
end

local SeekMoving : Model = workspace:FindFirstChild("SeekMoving") or workspace:FindFirstChild("SeekMovingNewClone")
if SeekMoving then
    Setup(SeekMoving)
end
workspace.ChildAdded:Connect(function(Child : Model)
        if not LightningHaxAlive then return end
    task.wait(3)
    
    if Child.Name == "SeekMoving" or Child.Name == "SeekMovingNewClone" then
        Setup(Child)
    end
end)

    end,
})

HomeTab:CreateButton({
    Name = "Buff Figure [ FIGURE ]",
    Callback = function()


function Setup(Child : Folder)
    local Figure = Child:FindFirstChild("FigureSetup")

    if Figure then
        Figure = Figure.FigureRig
        
        for _, Obj : Object in pairs(Figure:GetDescendants()) do
            if Obj:IsA("BasePart") or Obj:IsA("Decal") then
                Obj.Transparency = 1
            end
        end

        task.wait()

        local BigFigure : Model = game:GetObjects("rbxassetid://80300729404499")[1]    
        BigFigure.Parent = Figure

        while Figure and BigFigure do
            BigFigure.Body.CFrame = Figure.Torso.CFrame * CFrame.Angles(0, math.rad(180), 0)

            task.wait()
        end
    end
end
workspace.CurrentRooms.ChildAdded:Connect(function(Child : Folder)
        if not LightningHaxAlive then return end
    task.wait(3)
    Setup(Child)
end)

for _, Child : Folder in pairs(workspace.CurrentRooms:GetChildren()) do
    Setup(Child)
end
    end,
})

HomeTab:CreateButton({
    Name = "Big Seek [ FIGURE ]",
    Callback = function()


function SetupFigure(Child)
	local Figure = Child:FindFirstChild("FigureSetup")

	if not Figure then
		return
	end

	Figure = Child.FigureSetup.FigureRig

	for _, v in pairs(Figure:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") then
			v.Transparency = 1
		end
	end

	task.wait()

	local Seek = game:GetObjects("rbxassetid://17147814210")[1]	
	Seek.Weld.Part1 = Figure.Torso
	Seek.Parent = Figure
end

workspace.CurrentRooms.ChildAdded:Connect(function(Child)
        if not LightningHaxAlive then return end
	task.wait(3)
	SetupFigure(Child)
end)
for _, Child in pairs(workspace.CurrentRooms:GetChildren()) do
	SetupFigure(Child)
end

    end,
})


local RestoreDoorCollision
local VerifyDoorLock
local DoorCollisionBackup

local BreakDoorsEnabled=false
local BreakDoorStates={}
local BreakDoorsConnection=nil
local BreakDoorsDescendantConnection=nil
local BREAK_DOOR_OFFSET=Vector3.new(0,-5000,0)

local function IsNumberedRoomDoorContainer(inst)
    if not inst or inst.Name~="Door" then return false end
    local room=inst.Parent
    return room and room.Parent==workspace.CurrentRooms and tonumber(room.Name)~=nil
end

local function GetDoorContainerFromDescendant(obj)
    local current=obj
    while current and current~=workspace.CurrentRooms do
        if IsNumberedRoomDoorContainer(current) then return current end
        current=current.Parent
    end
end

local function BreakDoorPart(container,obj)
    if not obj:IsA("BasePart") then return end
    local state=BreakDoorStates[container]
    if not state then return end

    if not state.Parts[obj] then
        state.Parts[obj]={
            CanCollide=obj.CanCollide,
            CanTouch=obj.CanTouch,
            CanQuery=obj.CanQuery,
        }
    end

    -- Relative movement is deliberate: never restore a stale pre-animation CFrame.
    obj.CFrame=obj.CFrame + BREAK_DOOR_OFFSET
    obj.CanCollide=false
    obj.CanTouch=false
    obj.CanQuery=false
end

local function SetDoorBrokenState(container,broken)
    if not IsNumberedRoomDoorContainer(container) then return end

    if broken then
        if BreakDoorStates[container] then return end

        BreakDoorStates[container]={Parts={}}
        container:SetAttribute("LightningBreakDoorsActive",true)

        for _,obj in ipairs(container:GetDescendants()) do
            BreakDoorPart(container,obj)
        end
    else
        local state=BreakDoorStates[container]
        if not state then return end

        if container and container.Parent then
            -- Undo only our relative offset. This preserves whatever CFrame the
            -- game's own open/close animation gave each piece while Break Doors ran.
            for part,data in pairs(state.Parts) do
                if part and part.Parent then
                    part.CFrame=part.CFrame - BREAK_DOOR_OFFSET
                    part.CanCollide=data.CanCollide
                    part.CanTouch=data.CanTouch
                    part.CanQuery=data.CanQuery
                end
            end

            container:SetAttribute("LightningBreakDoorsActive",nil)
            local room=container.Parent
            if room and room.Parent==workspace.CurrentRooms then
                DoorCollisionBackup[room]=nil
                task.defer(function()
                    game:GetService("RunService").Heartbeat:Wait()
                    if LightningHaxAlive and room and room.Parent then
                        VerifyDoorLock(room)
                    end
                end)
            end
        end

        BreakDoorStates[container]=nil
    end
end

local function SetBreakDoors(enabled)
    BreakDoorsEnabled=enabled

    if BreakDoorsConnection then
        BreakDoorsConnection:Disconnect()
        BreakDoorsConnection=nil
    end
    if BreakDoorsDescendantConnection then
        BreakDoorsDescendantConnection:Disconnect()
        BreakDoorsDescendantConnection=nil
    end

    if enabled then
        for _,room in ipairs(workspace.CurrentRooms:GetChildren()) do
            if tonumber(room.Name)~=nil then
                local door=room:FindFirstChild("Door")
                if door then SetDoorBrokenState(door,true) end
            end
        end

        BreakDoorsConnection=workspace.CurrentRooms.ChildAdded:Connect(function(room)
            if not LightningHaxAlive or not BreakDoorsEnabled then return end
            task.defer(function()
                local door=room:WaitForChild("Door",3)
                if door and BreakDoorsEnabled then SetDoorBrokenState(door,true) end
            end)
        end)

        -- Parts that stream/create after activation get the same relative offset.
        BreakDoorsDescendantConnection=workspace.CurrentRooms.DescendantAdded:Connect(function(obj)
            if not LightningHaxAlive or not BreakDoorsEnabled or not obj:IsA("BasePart") then return end
            local container=GetDoorContainerFromDescendant(obj)
            if container and BreakDoorStates[container] then
                task.defer(BreakDoorPart,container,obj)
            end
        end)
    else
        local restore={}
        for container in pairs(BreakDoorStates) do table.insert(restore,container) end
        for _,container in ipairs(restore) do SetDoorBrokenState(container,false) end
    end
end

local EntityGodModeEnabled=false
local EntityGodTracked={}
local EntityGodConnections={}
local EntityGodCollisionStates={}
local EntityGodOriginalHipHeight=nil
local EntityGodNoclipConnection=nil
local EntityGodWallConnection=nil
local ENTITY_GOD_HIP_HEIGHT=0.1
local RunService=game:GetService("RunService")

local EntityGodNames={
    RushMoving=true,
    AmbushMoving=true,
    BackdoorRush=true,
    BlitzMoving=true,
    Blitz=true,
}

local function GetEntityGodCharacter()
    return LocalPlayer.Character
end

local function GetEntityGodHumanoid()
    local character=GetEntityGodCharacter()
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end

local function EntityGodActiveCount()
    local count=0
    for entity in pairs(EntityGodTracked) do
        if entity and entity.Parent and entity:IsDescendantOf(workspace) then count+=1 end
    end
    return count
end

local function ApplyNormalNoclip()
    local character=GetEntityGodCharacter()
    if not character then return end
    for _,part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if EntityGodCollisionStates[part]==nil then
                EntityGodCollisionStates[part]=part.CanCollide
            end
            part.CanCollide=false
        end
    end
end

local function RestoreNormalNoclip()
    for part,oldValue in pairs(EntityGodCollisionStates) do
        if part and part.Parent then
            pcall(function() part.CanCollide=oldValue end)
        end
    end
    table.clear(EntityGodCollisionStates)
end

local function StopEntityGodRuntime()
    if EntityGodNoclipConnection then
        EntityGodNoclipConnection:Disconnect()
        EntityGodNoclipConnection=nil
    end
    if EntityGodWallConnection then
        EntityGodWallConnection:Disconnect()
        EntityGodWallConnection=nil
    end
end

local function RestoreEntityGodMode()
    StopEntityGodRuntime()
    local humanoid=GetEntityGodHumanoid()
    if humanoid and EntityGodOriginalHipHeight~=nil then
        humanoid.HipHeight=EntityGodOriginalHipHeight
    end
    RestoreNormalNoclip()
    EntityGodOriginalHipHeight=nil
end

local function StartWallGuard()
    if EntityGodWallConnection then return end

    local lastSafePosition=nil
    EntityGodWallConnection=RunService.Heartbeat:Connect(function()
        if not LightningHaxAlive then return end
        if not EntityGodModeEnabled or EntityGodActiveCount()==0 then return end

        local character=GetEntityGodCharacter()
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        if not lastSafePosition then
            lastSafePosition=root.Position
            return
        end

        local delta=root.Position-lastSafePosition
        local horizontal=Vector3.new(delta.X,0,delta.Z)

        if horizontal.Magnitude>0.001 then
            local params=RaycastParams.new()
            params.FilterType=Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances={character}
            params.IgnoreWater=true

            local origin=Vector3.new(lastSafePosition.X,root.Position.Y,lastSafePosition.Z)
            local hit=workspace:Raycast(origin,horizontal.Unit*(horizontal.Magnitude+1.25),params)

            if hit and math.abs(hit.Normal.Y)<0.55 then
                local p=root.Position
                root.CFrame=CFrame.new(lastSafePosition.X,p.Y,lastSafePosition.Z)*(root.CFrame-root.CFrame.Position)
                root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0)
                return
            end
        end

        lastSafePosition=root.Position
    end)
end

local function ApplyEntityGodMode()
    if not EntityGodModeEnabled or EntityGodActiveCount()==0 then
        RestoreEntityGodMode()
        return
    end

    local humanoid=GetEntityGodHumanoid()
    if not humanoid then return end

    if EntityGodOriginalHipHeight==nil then
        EntityGodOriginalHipHeight=humanoid.HipHeight
    end

    humanoid.HipHeight=ENTITY_GOD_HIP_HEIGHT
    ApplyNormalNoclip()

    if not EntityGodNoclipConnection then
        EntityGodNoclipConnection=RunService.Stepped:Connect(function()
        if not LightningHaxAlive then return end
            if EntityGodModeEnabled and EntityGodActiveCount()>0 then
                local currentHumanoid=GetEntityGodHumanoid()
                if currentHumanoid then currentHumanoid.HipHeight=ENTITY_GOD_HIP_HEIGHT end
                ApplyNormalNoclip()
            end
        end)
    end

    StartWallGuard()
end

local function UntrackEntityGod(entity)
    EntityGodTracked[entity]=nil
    if EntityGodActiveCount()==0 then RestoreEntityGodMode() end
end

local function TrackEntityGod(entity)
    if not EntityGodModeEnabled or not entity or not entity.Parent or not EntityGodNames[entity.Name] then return end
    if EntityGodTracked[entity] then return end

    EntityGodTracked[entity]=true
    ApplyEntityGodMode()

    local connection
    connection=entity.AncestryChanged:Connect(function()
        if not LightningHaxAlive then return end
        if not entity.Parent or not entity:IsDescendantOf(workspace) then
            if connection then connection:Disconnect() end
            UntrackEntityGod(entity)
        end
    end)
    table.insert(EntityGodConnections,connection)
end

local function ScanEntityGodMode()
    for _,entity in ipairs(workspace:GetChildren()) do
        if EntityGodNames[entity.Name] then TrackEntityGod(entity) end
    end
end

local function StopEntityGodWatchers()
    for _,connection in ipairs(EntityGodConnections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(EntityGodConnections)
    table.clear(EntityGodTracked)
    RestoreEntityGodMode()
end

ExploitsTab:CreateToggle({
    Name="Entity God Mode (Rush / Ambush / Blitz)",
    CurrentValue=false,
    Flag="EntityGodMode",
    Callback=function(value)
        EntityGodModeEnabled=value
        if value then
            ScanEntityGodMode()
            table.insert(EntityGodConnections,workspace.ChildAdded:Connect(function(entity)
        if not LightningHaxAlive then return end
                if EntityGodNames[entity.Name] then task.defer(TrackEntityGod,entity) end
            end))
        else
            StopEntityGodWatchers()
        end
    end,
})

LocalPlayer.CharacterAdded:Connect(function()
        if not LightningHaxAlive then return end
    StopEntityGodRuntime()
    table.clear(EntityGodCollisionStates)
    EntityGodOriginalHipHeight=nil
    if EntityGodModeEnabled then
        task.defer(function()
            task.wait(0.25)
            ScanEntityGodMode()
            if EntityGodActiveCount()>0 then ApplyEntityGodMode() end
        end)
    end
end)

ExploitsTab:CreateToggle({
    Name = "Break Doors",
    CurrentValue = false,
    Flag = "BreakDoors",
    Callback = SetBreakDoors,
})

local BreakElevatorsEnabled=false
local BreakElevatorStates={}
local BreakElevatorsConnection=nil

local function IsElevatorRoot(inst)
    if not inst or not inst.Parent then return false end
    if not string.find(string.lower(inst.Name),"elevator",1,true) then return false end
    local parentName=string.lower(inst.Parent.Name)
    return not string.find(parentName,"elevator",1,true)
end

local function ApplyElevatorBreakPart(state,obj)
    if not obj:IsA("BasePart") then return end
    if state[obj]==nil then
        state[obj]={
            CanCollide=obj.CanCollide,
            CanTouch=obj.CanTouch,
            CanQuery=obj.CanQuery,
            LocalTransparencyModifier=obj.LocalTransparencyModifier
        }
    end
    obj.CanCollide=false
    obj.CanTouch=false
    obj.CanQuery=false
    obj.LocalTransparencyModifier=1
end

local function SetElevatorBrokenState(inst,broken)
    if not inst then return end

    if broken then
        if not IsElevatorRoot(inst) then return end
        local state=BreakElevatorStates[inst]
        if not state then
            state={}
            BreakElevatorStates[inst]=state
        end
        if inst:IsA("BasePart") then ApplyElevatorBreakPart(state,inst) end
        for _,obj in ipairs(inst:GetDescendants()) do
            ApplyElevatorBreakPart(state,obj)
        end
    else
        local state=BreakElevatorStates[inst]
        if not state then return end
        for obj,data in pairs(state) do
            if obj and obj.Parent then
                obj.CanCollide=data.CanCollide
                obj.CanTouch=data.CanTouch
                obj.CanQuery=data.CanQuery
                obj.LocalTransparencyModifier=data.LocalTransparencyModifier
            end
        end
        BreakElevatorStates[inst]=nil
    end
end

local function SetBreakElevators(enabled)
    BreakElevatorsEnabled=enabled

    if BreakElevatorsConnection then
        BreakElevatorsConnection:Disconnect()
        BreakElevatorsConnection=nil
    end

    if enabled then
        for _,inst in ipairs(workspace:GetDescendants()) do
            if IsElevatorRoot(inst) then
                SetElevatorBrokenState(inst,true)
            end
        end

        BreakElevatorsConnection=workspace.DescendantAdded:Connect(function(inst)
            if not LightningHaxAlive or not BreakElevatorsEnabled then return end
            local current=inst
            while current and current~=workspace do
                if IsElevatorRoot(current) then
                    task.defer(SetElevatorBrokenState,current,true)
                    break
                end
                current=current.Parent
            end
        end)
    else
        local restore={}
        for inst in pairs(BreakElevatorStates) do table.insert(restore,inst) end
        for _,inst in ipairs(restore) do SetElevatorBrokenState(inst,false) end
    end
end

ExploitsTab:CreateToggle({
    Name = "Break Elevators",
    CurrentValue = false,
    Flag = "BreakElevators",
    Callback = SetBreakElevators,
})

local BypassSeek = false
local SeekConnections = {}
local SeekDeleted = {}

local function DisconnectSeekConnections()
    for _, c in pairs(SeekConnections) do
        c:Disconnect()
    end
    table.clear(SeekConnections)
end

local function DeleteSeekTrigger(trigger)
    if SeekDeleted[trigger] then return end
    SeekDeleted[trigger] = true

    for _, part in pairs(trigger:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.CanTouch = false
        end
    end
end

local function WatchForSeekTriggers()
    DisconnectSeekConnections()

    local function CheckSeek(inst)
        if not BypassSeek then return end
        if inst.Name == "TriggerEventCollision" then
            DeleteSeekTrigger(inst)
        end
    end

    for _, desc in pairs(workspace:GetDescendants()) do
        CheckSeek(desc)
    end

    SeekConnections["Added"] = workspace.DescendantAdded:Connect(CheckSeek)
end

ExploitsTab:CreateToggle({
    Name = "Delete Seek Hotel - [ TROLL ]",
    CurrentValue = false,
    Callback = function(Value)
        BypassSeek = Value

        if Value then
            WatchForSeekTriggers()
        else
            DisconnectSeekConnections()
        end
    end
})

local PadlockConnection

ExploitsTab:CreateToggle({
    Name = "Auto Padlock [ LIBRARY ]",
    CurrentValue = false,
    Flag = "AutoPadlock",
    Callback = function(Value)

        if Value then

            local function padlock_Fix()
                local Character = LocalPlayer.Character
                if not Character then
                    return {"_","_","_","_","_"}
                end

                local Paper = Character:FindFirstChild("LibraryHintPaper")
                local Hints = LocalPlayer.PlayerGui:WaitForChild("PermUI"):WaitForChild("Hints")

                local Code = {"_","_","_","_","_"}

                if Paper then
                    for _, v in ipairs(Paper.UI:GetChildren()) do
                        if v:IsA("ImageLabel") and v.Name ~= "Image" then
                            for _, img in ipairs(Hints:GetChildren()) do
                                if img:IsA("ImageLabel")
                                    and img.Visible
                                    and v.ImageRectOffset == img.ImageRectOffset then

                                    Code[tonumber(v.Name)] =
                                        img:FindFirstChild("TextLabel").Text
                                end
                            end
                        end
                    end
                end

                return Code
            end

            if PadlockConnection then
                PadlockConnection:Disconnect()
            end

            PadlockConnection = LocalPlayer.Character.ChildAdded:Connect(function(Check)
        if not LightningHaxAlive then return end

                if Check:IsA("Tool") and Check.Name == "LibraryHintPaper" then

                    local Code = table.concat(padlock_Fix())

                    if Code:find("_") then
                        return
                    end

                    Rayfield:Notify({
                        Title = "Auto Padlock",
                        Content = "Code: "..Code,
                        Duration = 5,
                        Image = 4483345998

                    })

                    RemotesFolder.PL:FireServer(Code)
                end
            end)

        else

            if PadlockConnection then
                PadlockConnection:Disconnect()
                PadlockConnection = nil
            end

        end
    end
})

local DisableRansomEnabled = false
local RansomHookInstalled = false
local RansomModuleHookInstalled = false

local function FindRansomInfect()
    local player = game:GetService("Players").LocalPlayer
    local mainUI = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainUI")
    if mainUI then
        local found = mainUI:FindFirstChild("RansomInfect", true)
        if found and found:IsA("ModuleScript") then
            return found
        end
    end

    for _,root in ipairs({
        game:GetService("ReplicatedStorage"),
        player:FindFirstChild("PlayerGui")
    }) do
        if root then
            local found = root:FindFirstChild("RansomInfect", true)
            if found and found:IsA("ModuleScript") then
                return found
            end
        end
    end
end

local function InstallRansomModuleHook()
    if RansomModuleHookInstalled then return true end
    if not hookfunction then return false end

    local module = FindRansomInfect()
    if not module then return false end

    local ok, entry = pcall(require, module)
    if not ok or type(entry) ~= "function" then return false end

    local original
    original = hookfunction(entry, function(...)
        -- Block the Ransom client routine at its entry point. This prevents its
        -- infection sequence before its own animation/sound/UI code can run.
        if LightningHaxAlive and DisableRansomEnabled then
            return
        end
        return original(...)
    end)

    RansomModuleHookInstalled = true
    return true
end

local function InstallRansomHook()
    if RansomHookInstalled then return true end
    if not hookmetamethod or not getnamecallmethod or not newcclosure then return false end

    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        -- Keep the confirmed server-side proc prevention, but do not hook
        -- generic Play/TweenService calls: those can interfere with camera,
        -- mouse and Rayfield itself.
        if LightningHaxAlive
            and DisableRansomEnabled
            and method == "FireServer"
            and typeof(self) == "Instance"
            and self.Name == "RansomAttack"
            and args[1] == "moved" then

            args[1] = "didnt"
            return old(self, unpack(args))
        end

        return old(self, ...)
    end))

    RansomHookInstalled = true
    return true
end

ExploitsTab:CreateToggle({
    Name = "Disable Ransom",
    CurrentValue = false,
    Flag = "DisableRansom",
    Callback = function(Value)
        DisableRansomEnabled = Value

        if Value then
            -- Install only the Ransom-specific hooks. No global animation,
            -- sound, tween, camera or input interception is performed.
            pcall(InstallRansomModuleHook)
            pcall(InstallRansomHook)
        end
    end
})

local DisableDupeEnabled=false
local DisableDupeConnection=nil
local DupeTouchBackup=setmetatable({}, {__mode="k"})

local function IsDupeContainer(obj)
    if not obj then return false end
    if obj.Name=="SideroomDupe" then return true end

    local p=obj.Parent
    while p and p~=workspace.CurrentRooms do
        if p.Name=="SideroomDupe" then return true end
        p=p.Parent
    end

    return false
end

local function DisableDupeTrigger(obj)
    if not DisableDupeEnabled or not obj or not obj.Parent then return end
    if obj.Name~="DoorFake" or not IsDupeContainer(obj) then return end

    if obj:IsA("BasePart") then
        if DupeTouchBackup[obj]==nil then
            DupeTouchBackup[obj]=obj.CanTouch
        end
        obj.CanTouch=false
        return
    end

    -- Some room variants wrap DoorFake in a Model/Folder.
    for _,part in ipairs(obj:GetDescendants()) do
        if part:IsA("BasePart") then
            if DupeTouchBackup[part]==nil then
                DupeTouchBackup[part]=part.CanTouch
            end
            part.CanTouch=false
        end
    end
end

local function ScanDupeTriggers()
    for _,room in ipairs(workspace.CurrentRooms:GetChildren()) do
        for _,obj in ipairs(room:GetDescendants()) do
            if obj.Name=="DoorFake" then
                DisableDupeTrigger(obj)
            end
        end
    end
end

local function SetDupeDisabled(enabled)
    DisableDupeEnabled=enabled

    if DisableDupeConnection then
        DisableDupeConnection:Disconnect()
        DisableDupeConnection=nil
    end

    if not enabled then
        for part,originalCanTouch in pairs(DupeTouchBackup) do
            if part and part.Parent then
                part.CanTouch=originalCanTouch
            end
            DupeTouchBackup[part]=nil
        end
        return
    end

    ScanDupeTriggers()

    DisableDupeConnection=workspace.CurrentRooms.DescendantAdded:Connect(function(obj)
        if not LightningHaxAlive or not DisableDupeEnabled then return end
        if obj.Name=="DoorFake" then
            task.defer(DisableDupeTrigger,obj)
        elseif obj:IsA("BasePart") and obj:FindFirstAncestor("SideroomDupe") then
            local fake=obj:FindFirstAncestor("DoorFake")
            if fake then
                task.defer(DisableDupeTrigger,fake)
            end
        end
    end)
end

ExploitsTab:CreateToggle({
    Name = "Disable Dupe",
    CurrentValue = false,
    Flag = "DisableDupe",
    Callback = function(Value)
        SetDupeDisabled(Value)
    end
})

ExploitsTab:CreateToggle({
    Name = "Disable Halt",
    CurrentValue = false,
    Flag = "DisableHalt",
    Callback = function(Value)

        local Modules = game.ReplicatedStorage.ModulesClient.EntityModules

        local Halt =
            Modules:FindFirstChild("Shade")
            or Modules:FindFirstChild("_Shade")
            or Modules:FindFirstChild("Shade_Disabled")

        if not Halt then return end

        Halt.Name = Value and "Shade_Disabled" or "Shade"
    end
})

local AntiSnareConnection

ExploitsTab:CreateToggle({
    Name = "Disable Snare",
    CurrentValue = false,
    Flag = "AntiSnare",
    Callback = function(Value)

        if AntiSnareConnection then
            AntiSnareConnection:Disconnect()
            AntiSnareConnection = nil
        end

        local function SetSnareHitbox(Snare, Enabled)
            if not Snare then
                return
            end

            local Hitbox =
                Snare:FindFirstChild("Hitbox")
                or Snare:FindFirstChild("HitboxPart")
                or Snare:FindFirstChild("HitboxMesh")

            if Hitbox and Hitbox:IsA("BasePart") then
                Hitbox.CanTouch = Enabled
            end
        end

        local function UpdateAllSnares(Enabled)
            for _, Room in ipairs(workspace.CurrentRooms:GetChildren()) do
                local Assets = Room:FindFirstChild("Assets")
                if not Assets then
                    continue
                end

                local SnaresFolder = Assets:FindFirstChild("Snares")
                if SnaresFolder then
                    for _, Snare in ipairs(SnaresFolder:GetChildren()) do
                        if Snare.Name == "Snare" then
                            SetSnareHitbox(Snare, Enabled)
                        end
                    end
                end

                local Snare = Assets:FindFirstChild("Snare")
                if Snare then
                    SetSnareHitbox(Snare, Enabled)
                end
            end
        end

        if not Value then
            UpdateAllSnares(true)
            return
        end

        UpdateAllSnares(false)

        AntiSnareConnection = workspace.DescendantAdded:Connect(function(Object)
        if not LightningHaxAlive then return end

            if Object.Name == "Snares" then
                for _, Snare in ipairs(Object:GetChildren()) do
                    if Snare.Name == "Snare" then
                        SetSnareHitbox(Snare, false)
                    end
                end
            end

            if Object.Name == "Snare" then
                SetSnareHitbox(Object, false)
            end

            if Object.Name == "Hitbox"
                or Object.Name == "HitboxPart"
                or Object.Name == "HitboxMesh" then

                local Parent = Object.Parent

                if Parent and Parent.Name == "Snare" and Object:IsA("BasePart") then
                    Object.CanTouch = false
                end
            end

        end)

    end
})

local ScreechBackup = {}

local function SetScreechDisabled(disabled)
    local rs = game:GetService("ReplicatedStorage")
    local targets = {
        {rs:FindFirstChild("RemotesFolder"), "Screech"},
        {rs:FindFirstChild("Entities"), "ScreechRetro"},
        {rs:FindFirstChild("Entities"), "Screech"},
    }

    if disabled then
        for _, entry in ipairs(targets) do
            local parent, name = entry[1], entry[2]
            local obj = parent and parent:FindFirstChild(name)
            if obj then
                local key = parent.Name .. "/" .. name
                if not ScreechBackup[key] then
                    ScreechBackup[key] = {clone = obj:Clone(), parent = parent, name = name}
                end
                obj:Destroy()
            end
        end
    else
        for _, data in pairs(ScreechBackup) do
            if data.parent and data.parent.Parent and not data.parent:FindFirstChild(data.name) then
                data.clone:Clone().Parent = data.parent
            end
        end
    end
end

ExploitsTab:CreateToggle({
    Name = "Disable Screech",
    CurrentValue = false,
    Flag = "DisableScreech",
    Callback = function(Value)
        SetScreechDisabled(Value)
    end
})

ExploitsTab:CreateToggle({
    Name = "Disable Dread",
    CurrentValue = false,
    Flag = "DisableDread",
    Callback = function(Value)

        local Modules = game.Players.LocalPlayer.PlayerGui.MainUI
            .Initiator.Main_Game.RemoteListener.Modules

        local Dread =
            Modules:FindFirstChild("Dread")
            or Modules:FindFirstChild("_Dread")
            or Modules:FindFirstChild("Dread_Disabled")

        if not Dread then return end

        Dread.Name = Value and "Dread_Disabled" or "Dread"
    end
})

local AntiFHConnection

ExploitsTab:CreateToggle({
    Name = "Anti Figure Hearing",
    CurrentValue = false,
    Flag = "AntiFigureHearing",
    Callback = function(Value)

        if AntiFHConnection then
            AntiFHConnection:Disconnect()
            AntiFHConnection = nil
        end

        if not Value then

            if RemotesFolder:FindFirstChild("Crouch") then
                RemotesFolder.Crouch:FireServer(false)
            end

            return
        end

        if RemotesFolder:FindFirstChild("Crouch") then
            RemotesFolder.Crouch:FireServer(true)
        end

        AntiFHConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not LightningHaxAlive then return end
            if RemotesFolder:FindFirstChild("Crouch") then
                RemotesFolder.Crouch:FireServer(true)
            end
        end)

    end
})

local AntiJeffConnection

ExploitsTab:CreateToggle({
    Name = "Anti Jeff",
    CurrentValue = false,
    Flag = "AntiJeff",
    Callback = function(Value)

        if AntiJeffConnection then
            AntiJeffConnection:Disconnect()
            AntiJeffConnection = nil
        end

        if not Value then
            return
        end

        local function KillJeff(Model)
            if not Model then
                return
            end

            task.delay(0.5, function()
                if not Model or not Model.Parent then
                    return
                end

                local Humanoid =
                    Model:FindFirstChild("Humanoid")
                    or Model:WaitForChild("Humanoid", 2)

                if Humanoid then
                    Humanoid.Health = 0
                end
            end)
        end

        local Existing = workspace:FindFirstChild("JeffTheKiller")
        if Existing then
            KillJeff(Existing)
        end

        AntiJeffConnection = workspace.ChildAdded:Connect(function(Object)
        if not LightningHaxAlive then return end
            if Object.Name == "JeffTheKiller" then
                KillJeff(Object)
            end
        end)

    end
})


local Lighting=game:GetService("Lighting")
local FullbrightNoFogEnabled=false
local LightingBackup=nil
local LightingConnection=nil

local function ApplyFullbrightNoFog()
    if not FullbrightNoFogEnabled then return end
    Lighting.Brightness=2
    Lighting.ClockTime=14
    Lighting.FogStart=0
    Lighting.FogEnd=1000000
    Lighting.GlobalShadows=false
    Lighting.Ambient=Color3.fromRGB(255,255,255)
    Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    for _,effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("Atmosphere") then
            effect.Density=0
            effect.Haze=0
            effect.Glare=0
        end
    end
end

ChamsTab:CreateToggle({
    Name="Fullbright + No Fog",
    CurrentValue=false,
    Flag="FullbrightNoFog",
    Callback=function(v)
        FullbrightNoFogEnabled=v
        if LightingConnection then LightingConnection:Disconnect(); LightingConnection=nil end

        if v then
            LightingBackup={
                Brightness=Lighting.Brightness,
                ClockTime=Lighting.ClockTime,
                FogStart=Lighting.FogStart,
                FogEnd=Lighting.FogEnd,
                GlobalShadows=Lighting.GlobalShadows,
                Ambient=Lighting.Ambient,
                OutdoorAmbient=Lighting.OutdoorAmbient,
                Atmospheres={}
            }
            for _,effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("Atmosphere") then
                    LightingBackup.Atmospheres[effect]={
                        Density=effect.Density,
                        Haze=effect.Haze,
                        Glare=effect.Glare
                    }
                end
            end
            ApplyFullbrightNoFog()
            LightingConnection=Lighting.Changed:Connect(function()
        if not LightningHaxAlive then return end
                task.defer(ApplyFullbrightNoFog)
            end)
        elseif LightingBackup then
            Lighting.Brightness=LightingBackup.Brightness
            Lighting.ClockTime=LightingBackup.ClockTime
            Lighting.FogStart=LightingBackup.FogStart
            Lighting.FogEnd=LightingBackup.FogEnd
            Lighting.GlobalShadows=LightingBackup.GlobalShadows
            Lighting.Ambient=LightingBackup.Ambient
            Lighting.OutdoorAmbient=LightingBackup.OutdoorAmbient
            for effect,values in pairs(LightingBackup.Atmospheres) do
                if effect and effect.Parent then
                    effect.Density=values.Density
                    effect.Haze=values.Haze
                    effect.Glare=values.Glare
                end
            end
            LightingBackup=nil
        end
    end
})

local FOVConnection
local CurrentFOV = 70

task.defer(function()
    task.wait(0.5)
    for _,gui in ipairs(game:GetService("CoreGui"):GetDescendants()) do
        if gui:IsA("ScrollingFrame") then
            gui.ClipsDescendants = true
        end
    end
end)

ChamsTab:CreateSlider({
    Name = "Field Of View",
    Range = {10, 120},
    Increment = 1,
    Suffix = " FOV",
    CurrentValue = 70,
    Flag = "FOVSlider",
    Callback = function(Value)

        CurrentFOV = Value

        if FOVConnection then
            FOVConnection:Disconnect()
            FOVConnection = nil
        end

        local Camera = workspace.CurrentCamera
        if not Camera then
            return
        end

        local Tween = game:GetService("TweenService"):Create(
            Camera,
            TweenInfo.new(
                0.25,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            ),
            {
                FieldOfView = Value
            }
        )

        Tween:Play()

        Tween.Completed:Connect(function()
        if not LightningHaxAlive then return end

            FOVConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not LightningHaxAlive then return end

                local Cam = workspace.CurrentCamera

                if Cam then
                    Cam.FieldOfView = CurrentFOV
                end

            end)

        end)

    end
})

local ESP_RED = Color3.fromRGB(255, 45, 45)
local ESP_YELLOW = Color3.fromRGB(255, 230, 0)
local ESP_GREEN = Color3.fromRGB(0, 250, 10)

local LatestRoomValue = game:GetService("ReplicatedStorage"):WaitForChild("GameData"):WaitForChild("LatestRoom")

local function GetTopRoom(obj)
    if not obj then return nil end
    local room=obj
    while room and room.Parent~=workspace.CurrentRooms do
        room=room.Parent
    end
    return room and room.Parent==workspace.CurrentRooms and room or nil
end

local function GetCurrentRoomNumber()
    local current=tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
    if current~=nil then return current end
    return tonumber(LatestRoomValue.Value)
end

local function IsRoomInESPRange(room)
    if not room or room.Parent~=workspace.CurrentRooms then return false end
    local n=tonumber(room.Name)
    local current=GetCurrentRoomNumber()
    return n~=nil and current~=nil and (n==current or n==current+1)
end

local function IsObjectInESPRange(obj)
    return IsRoomInESPRange(GetTopRoom(obj))
end

local function AddHighlight(target, name, color, fillTransparency)
    if not target or not target.Parent or target:FindFirstChild(name) then return end
    local h = Instance.new("Highlight")
    h.Name = name
    h.Adornee = target
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = fillTransparency or 0.75
    h.OutlineTransparency = 0
    h.DepthMode = TabletViewActive and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = target
    return h
end

local function RemoveNamedESP(...)
    local wanted = {}
    for _,name in ipairs({...}) do wanted[name]=true end
    for _,obj in ipairs(workspace:GetDescendants()) do
        if wanted[obj.Name] then obj:Destroy() end
    end
end

local ESPInfoLabels = {}
local function GetESPAnchor(target)
    if not target then return nil end
    if target:IsA("BasePart") then return target end
    if target:IsA("Model") then return target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart", true) end
    return target:FindFirstChildWhichIsA("BasePart", true)
end
local function AddESPInfoLabel(target, id, textProvider, color)
    local anchor = GetESPAnchor(target)
    if not anchor then return end
    local old = anchor:FindFirstChild(id)
    if old then old:Destroy() end
    local gui=Instance.new("BillboardGui")
    gui.Name=id; gui.Adornee=anchor; gui.AlwaysOnTop=not TabletViewActive; gui.Size=UDim2.fromOffset(150,28); gui.StudsOffset=Vector3.new(0,2.5,0); gui.MaxDistance=1000; gui.Parent=anchor
    local t=Instance.new("TextLabel")
    t.BackgroundTransparency=1; t.Size=UDim2.fromScale(1,1); t.Font=Enum.Font.GothamBold; t.TextSize=13; t.TextColor3=color or Color3.new(1,1,1); t.TextStrokeTransparency=.2; t.TextStrokeColor3=Color3.new(); t.Parent=gui
    ESPInfoLabels[gui]={target=target, provider=textProvider, label=t}
    local ok,res=pcall(textProvider,target) if ok then t.Text=res end
    gui.Destroying:Connect(function() ESPInfoLabels[gui]=nil end)
end
game:GetService("RunService").Heartbeat:Connect(function()
        if not LightningHaxAlive then return end
    for gui,data in pairs(ESPInfoLabels) do
        if not gui.Parent or not data.target or not data.target.Parent then ESPInfoLabels[gui]=nil
        else local ok,res=pcall(data.provider,data.target); if ok then data.label.Text=res end end
    end
end)

local InstantPromptsEnabled=false
local InstantPromptConnection=nil
local PromptHoldDurations={}

local function SetPromptInstant(prompt)
    if not prompt:IsA("ProximityPrompt") then return end
    if PromptHoldDurations[prompt]==nil then
        PromptHoldDurations[prompt]=prompt.HoldDuration
    end
    prompt.HoldDuration=0
end

ExploitsTab:CreateToggle({
    Name="Instant Proximity Prompts",
    CurrentValue=false,
    Flag="InstantProximityPrompts",
    Callback=function(v)
        InstantPromptsEnabled=v

        if InstantPromptConnection then
            InstantPromptConnection:Disconnect()
            InstantPromptConnection=nil
        end

        if v then
            task.spawn(function()
                local descendants=workspace:GetDescendants()
                for i,obj in ipairs(descendants) do
                    if not InstantPromptsEnabled then break end
                    if obj:IsA("ProximityPrompt") then
                        SetPromptInstant(obj)
                    end
                    if i%250==0 then task.wait() end
                end
            end)

            InstantPromptConnection=workspace.DescendantAdded:Connect(function(obj)
        if not LightningHaxAlive then return end
                if InstantPromptsEnabled and obj:IsA("ProximityPrompt") then
                    SetPromptInstant(obj)
                end
            end)
        else
            for prompt,duration in pairs(PromptHoldDurations) do
                if prompt and prompt.Parent then
                    prompt.HoldDuration=duration
                end
            end
            table.clear(PromptHoldDurations)
        end
    end
})

local ChestESPEnabled = false
local ChestESPConnection
local ChestNames = {"Toolshed_Small","Chest_Vine","ChestBox","ChestBoxLocked","MouseHole","Locker_Small_Locked","Toolbox_Locked","Toolbox"}
local function IsChest(obj)
    return obj and obj.Parent and obj:IsA("Model") and table.find(ChestNames,obj.Name)~=nil and IsObjectInESPRange(obj)
end
local function IsChestLocked(obj)
    if not IsChest(obj) then return false end
    if string.find(string.lower(obj.Name),"locked",1,true) then return true end
    local attr=obj:GetAttribute("Locked")
    if attr~=nil then return attr==true end
    local value=obj:FindFirstChild("Locked",true)
    if value and value:IsA("BoolValue") then return value.Value end
    local lock=obj:FindFirstChild("Lock",true)
    if lock then
        local lockAttr=lock:GetAttribute("Locked")
        if lockAttr~=nil then return lockAttr==true end
    end
    return false
end
local function MarkChest(obj)
    if not ChestESPEnabled or not IsChest(obj) then return end
    AddHighlight(obj,"ChestESP",ESP_YELLOW,0.78)
    AddESPInfoLabel(obj,"ChestESPLabel",function(target)
        return IsChestLocked(target) and "Chest  |  Locked" or "Chest"
    end,ESP_YELLOW)
end
local function ValidateAndMarkChest(obj)
    task.wait(0.12)
    if not ChestESPEnabled or not IsChest(obj) then return end
    local parent=obj.Parent
    task.wait(0.06)
    if ChestESPEnabled and IsChest(obj) and obj.Parent==parent then MarkChest(obj) end
end
local function ScanChests()
    if TabletSuppressingESP then return end
    local current=GetCurrentRoomNumber()
    for _,n in ipairs({current,current and current+1}) do
        local room=n and workspace.CurrentRooms:FindFirstChild(tostring(n))
        if room then
            for _,obj in ipairs(room:GetDescendants()) do
                if IsChest(obj) then MarkChest(obj) end
            end
        end
    end
end
ChamsTab:CreateToggle({Name="Chest ESP",CurrentValue=false,Flag="ChestESP",Callback=function(v)
    ChestESPEnabled=v
    if ChestESPConnection then ChestESPConnection:Disconnect(); ChestESPConnection=nil end
    if v then
        ScanChests()
        ChestESPConnection=workspace.CurrentRooms.ChildAdded:Connect(function(room)
        if not LightningHaxAlive then return end
            if ChestESPEnabled and IsRoomInESPRange(room) then task.delay(0.25,ScanChests) end
        end)
    else
        RemoveNamedESP("ChestESP","ChestESPLabel")
    end
end})

local ItemESPEnabled = false
local ItemESPConnection
local ItemNames = {
    "Lighter","Flashlight","Lockpick","Vitamins","Bandage","StarVial","StarBottle","StarJug","Shakelight","Straplight",
    "Bulklight","Battery","Candle","Crucifix","CrucifixWall","Glowsticks","SkeletonKey","Candy","ShieldMini","ShieldBig",
    "BandagePack","BatteryPack","RiftCandle","LaserPointer","HolyGrenade","Shears","Smoothie","Cheese","Bread","AlarmClock",
    "RiftSmoothie","GweenSoda","GlitchCube","Scanner","Bomb","Knockbomb","Nanner","BigBomb","SnakeBox","GoldGun","StopSign",
    "TipJar","Lantern","IronKey","LotusPetal","Compass","LotusPetalPickup","LanternLitItem","KeyIron","IronKeyForCrypt","LotusHolder",
    "Multitool","RiftJar","AloeVera","Donut","Lotus","BoxingGloves","Green_Herb"
}
local function IsRealPickup(obj)
    if not (obj:IsA("Model") or obj:IsA("Tool")) then return false end
    if not table.find(ItemNames, obj.Name) then return false end
    if obj.Name == "Bookcase" or obj:FindFirstAncestor("Bookcase") then return false end
    if not IsObjectInESPRange(obj) then return false end
    if obj:IsA("Tool") then return true end
    if obj:FindFirstChildWhichIsA("ProximityPrompt", true) then return true end
    if obj:FindFirstChild("Pickup", true) or obj:FindFirstChild("ModulePrompt", true) then return true end
    return false
end
local function ItemDisplayName(obj)
    local n=obj.Name
    if n=="KeyObtain" or n=="KeyHitbox" then return "Key" end
    return n
end
local function MarkItem(obj)
    if not obj or not obj.Parent then return end
    AddHighlight(obj,"ItemESP",ESP_YELLOW,0.78)
    AddESPInfoLabel(obj,"ItemESPLabel",function() return obj.Name end,ESP_YELLOW)
end
local function ScanItems()
    if TabletSuppressingESP then return end
    local current=GetCurrentRoomNumber()
    for _,n in ipairs({current,current and current+1}) do
        local room=n and workspace.CurrentRooms:FindFirstChild(tostring(n))
        if room then
            for _,obj in ipairs(room:GetDescendants()) do
                if IsRealPickup(obj) then MarkItem(obj) end
            end
        end
    end
end
ChamsTab:CreateToggle({Name="Item ESP",CurrentValue=false,Flag="ItemESP",Callback=function(v)
    ItemESPEnabled=v
    if ItemESPConnection then ItemESPConnection:Disconnect(); ItemESPConnection=nil end
    if v then
        ScanItems()
        ItemESPConnection=workspace.CurrentRooms.ChildAdded:Connect(function(room)
        if not LightningHaxAlive then return end
            if ItemESPEnabled and IsRoomInESPRange(room) then task.delay(0.25,ScanItems) end
        end)
    else RemoveNamedESP("ItemESP","ItemESPLabel") end
end})

local ObjectiveESPEnabled=false
local ObjectiveConnection
local DoorESPEnabled=false
local DoorESPConnection
local Objectives={"LeverForGate","LiveBreakerPolePickup","LiveHintBook","FuseObtain","MinesAnchor","WaterPump","TimerLever"}

local function IsDupeObject(obj)
    local p=obj
    while p and p~=workspace do
        local n=string.lower(p.Name)
        if string.find(n,"dupe",1,true) or string.find(n,"sideroom",1,true) then return true end
        p=p.Parent
    end
    return false
end

local function GetRoomModel(obj)
    local p=obj
    while p and p.Parent~=workspace.CurrentRooms do p=p.Parent end
    return p and p.Parent==workspace.CurrentRooms and p or nil
end

local ReadDoorLockForDisplay

local function MarkRealDoor(room)
    if not DoorESPEnabled or not room or tonumber(room.Name)==nil or not IsRoomInESPRange(room) then return end
    local doorContainer=room:FindFirstChild("Door")
    if not doorContainer or IsDupeObject(doorContainer) then return end

    local physicalDoor=doorContainer:FindFirstChild("Door")
    if not physicalDoor or not physicalDoor:IsA("BasePart") then return end

    local doorFill=AddHighlight(physicalDoor,"RealDoorESP",ESP_GREEN,0.80)
    if doorFill then doorFill.OutlineTransparency=1 end

    local specialDoubleAnchor=nil
    if room.Name=="49" or room.Name=="50" then
        local visibleParts={}
        local minV,maxV=nil,nil

        for _,obj in ipairs(doorContainer:GetDescendants()) do
            if obj:IsA("BasePart")
                and obj.Name~="LightningDoubleDoorESPAnchor"
                and not obj:FindFirstAncestor("Lock") then

                -- Use the real rendered geometry so Highlight actually draws.
                local lname=obj.Name:lower()
                local parentName=obj.Parent and obj.Parent.Name:lower() or ""
                if obj==physicalDoor or lname:find("door") or parentName:find("door") then
                    table.insert(visibleParts,obj)

                    local cf,size=obj.CFrame,obj.Size
                    for x=-1,1,2 do
                        for y=-1,1,2 do
                            for z=-1,1,2 do
                                local p=(cf*CFrame.new(size.X*x/2,size.Y*y/2,size.Z*z/2)).Position
                                minV=minV and Vector3.new(
                                    math.min(minV.X,p.X),math.min(minV.Y,p.Y),math.min(minV.Z,p.Z)
                                ) or p
                                maxV=maxV and Vector3.new(
                                    math.max(maxV.X,p.X),math.max(maxV.Y,p.Y),math.max(maxV.Z,p.Z)
                                ) or p
                            end
                        end
                    end
                end
            end
        end

        -- Highlight every real part belonging to either leaf, never the invisible anchor.
        if doorFill then doorFill:Destroy() end
        for _,part in ipairs(visibleParts) do
            local fill=AddHighlight(part,"RealDoorESP",ESP_GREEN,0.80)
            if fill then fill.OutlineTransparency=1 end
        end

        -- Invisible part is only a BillboardGui anchor at the exact center of both leaves.
        if minV and maxV then
            specialDoubleAnchor=Instance.new("Part")
            specialDoubleAnchor.Name="LightningDoubleDoorESPAnchor"
            specialDoubleAnchor.Anchored=true
            specialDoubleAnchor.CanCollide=false
            specialDoubleAnchor.CanTouch=false
            specialDoubleAnchor.CanQuery=false
            specialDoubleAnchor.Transparency=1
            specialDoubleAnchor.Size=Vector3.new(0.1,0.1,0.1)
            specialDoubleAnchor.CFrame=CFrame.new((minV+maxV)/2)
            specialDoubleAnchor.Parent=doorContainer
        end
    end

    local crossBoards=physicalDoor:FindFirstChild("CrossBoards")
    if crossBoards and (crossBoards:IsA("BasePart") or crossBoards:IsA("Model")) then
        local crossHighlight=AddHighlight(crossBoards,"RealDoorCrossFill",ESP_GREEN,0.80)
        if crossHighlight then crossHighlight.OutlineTransparency=1 end
    end

    local borderSignature=string.format("%.4f|%.4f|%.4f",physicalDoor.Size.X,physicalDoor.Size.Y,physicalDoor.Size.Z)
    local existingBorder=physicalDoor:FindFirstChild("RealDoorOuterBorder")
    if existingBorder and existingBorder:GetAttribute("DoorSizeSignature")~=borderSignature then
        existingBorder:Destroy()
        existingBorder=nil
    end
    if not existingBorder then
        local borderFolder=Instance.new("Folder")
        borderFolder.Name="RealDoorOuterBorder"
        borderFolder.Parent=physicalDoor

        local half=physicalDoor.Size * 0.5
        local thickness=0.035
        local function edge(name,cf,length)
            local line=Instance.new("LineHandleAdornment")
            line.Name=name
            line.Adornee=physicalDoor
            line.CFrame=cf
            line.Length=length
            line.Thickness=thickness
            line.Color3=ESP_GREEN
            line.AlwaysOnTop=true
            line.ZIndex=10
            line.Parent=borderFolder
        end

        for _,y in ipairs({-half.Y,half.Y}) do
            for _,z in ipairs({-half.Z,half.Z}) do
                edge("XEdge",CFrame.new(-half.X,y,z)*CFrame.Angles(0,math.rad(-90),0),physicalDoor.Size.X)
            end
        end
        for _,x in ipairs({-half.X,half.X}) do
            for _,z in ipairs({-half.Z,half.Z}) do
                edge("YEdge",CFrame.new(x,-half.Y,z)*CFrame.Angles(math.rad(90),0,0),physicalDoor.Size.Y)
            end
        end
        for _,x in ipairs({-half.X,half.X}) do
            for _,y in ipairs({-half.Y,half.Y}) do
                edge("ZEdge",CFrame.new(x,y,half.Z),physicalDoor.Size.Z)
            end
        end
        borderFolder:SetAttribute("DoorSizeSignature",borderSignature)
    end

    local function IsDoorActuallyLocked()
        return ReadDoorLockForDisplay(doorContainer,physicalDoor)
    end

    local function GetRealDoorNumber()
        local sign = physicalDoor:FindFirstChild("Sign")
        if sign then
            for _,desc in ipairs(sign:GetDescendants()) do
                if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                    local n = tostring(desc.Text):match("%d+")
                    if n then return tonumber(n) end
                end
            end
        end

        for _,attrName in ipairs({"DoorNumber","RoomNumber","Number"}) do
            local value = doorContainer:GetAttribute(attrName)
            if typeof(value)=="number" then return value end
            if typeof(value)=="string" and tonumber(value) then return tonumber(value) end
        end

        local roomNumber=tonumber(room.Name)
        return roomNumber and (roomNumber+1) or room.Name
    end

    AddESPInfoLabel(specialDoubleAnchor or physicalDoor,"RealDoorESPLabel",function()
        local doorNumber=GetRealDoorNumber()
        local text=string.format("Door %s",doorNumber)
        if IsDoorActuallyLocked() then
            text=text.."  |  Locked"
        end
        return text
    end,ESP_GREEN)
end

local DoorPending={}
local DoorLockState={}
DoorCollisionBackup={}

RestoreDoorCollision=function(room)
    local saved=DoorCollisionBackup[room]
    if not saved then return end
    for part,canCollide in pairs(saved) do
        if part and part.Parent then part.CanCollide=canCollide end
    end
    DoorCollisionBackup[room]=nil
end

local function SetUnlockedDoorCollision(room,unlocked)
    if not room or not room.Parent then return end
    local doorContainer=room:FindFirstChild("Door")
    if not doorContainer then return end

    if doorContainer:GetAttribute("LightningBreakDoorsActive") then
        return
    end

    if not unlocked then
        RestoreDoorCollision(room)
        return
    end

    local saved=DoorCollisionBackup[room]
    if not saved then
        saved={}
        DoorCollisionBackup[room]=saved
    end

    for _,part in ipairs(doorContainer:GetDescendants()) do
        if part:IsA("BasePart") then
            if saved[part]==nil then saved[part]=part.CanCollide end
            part.CanCollide=false
        end
    end
end

local function ReadExplicitDoorLock(doorContainer,physicalDoor)
    for _,target in ipairs({doorContainer,physicalDoor}) do
        for _,attributeName in ipairs({"Locked","IsLocked","RequiresKey"}) do
            local value=target:GetAttribute(attributeName)
            if typeof(value)=="boolean" then
                return value,true
            end
        end
    end

    for _,name in ipairs({"Locked","IsLocked","RequiresKey"}) do
        local value=doorContainer:FindFirstChild(name,true)
        if value and value:IsA("BoolValue") then
            return value.Value,true
        end
    end

    local lock=doorContainer:FindFirstChild("Lock")
    if lock then
        for _,attributeName in ipairs({"Locked","IsLocked","RequiresKey"}) do
            local value=lock:GetAttribute(attributeName)
            if typeof(value)=="boolean" then
                return value,true
            end
        end
        for _,name in ipairs({"Locked","IsLocked","RequiresKey"}) do
            local value=lock:FindFirstChild(name,true)
            if value and value:IsA("BoolValue") then
                return value.Value,true
            end
        end
    end

    return false,false
end

ReadDoorLockForDisplay=function(doorContainer,physicalDoor)
    local locked,hasExplicit=ReadExplicitDoorLock(doorContainer,physicalDoor)
    return hasExplicit and locked==true
end

VerifyDoorLock=function(room)
    local dc=room and room:FindFirstChild("Door")
    local pd=dc and dc:FindFirstChild("Door")
    if not dc or not pd or not pd:IsA("BasePart") then return false end

    local locked,hasExplicit=ReadExplicitDoorLock(dc,pd)

    if not hasExplicit then
        -- Unknown is not the same as unlocked. Never noclip a door until the
        -- game explicitly confirms an unlocked state.
        RestoreDoorCollision(room)
        pd:SetAttribute("LightningVerifiedLocked",false)
        return true
    end

    pd:SetAttribute("LightningVerifiedLocked",locked)

    if locked then
        RestoreDoorCollision(room)
        pd.CanCollide=true
    else
        SetUnlockedDoorCollision(room,true)
    end

    return true
end

task.spawn(function()
    while LightningHaxAlive do
        task.wait(0.75)
        local current=GetCurrentRoomNumber()
        for _,n in ipairs({current,current and current+1}) do
            local room=n and workspace.CurrentRooms:FindFirstChild(tostring(n))
            if room then VerifyDoorLock(room) end
        end

        for room in pairs(DoorCollisionBackup) do
            if not room.Parent then
                DoorCollisionBackup[room]=nil
                DoorLockState[room]=nil
            end
        end
    end
end)

local function DoorIsStable(room)
    if not IsRoomInESPRange(room) then return false end
    local dc=room:FindFirstChild("Door")
    local pd=dc and dc:FindFirstChild("Door")
    if not pd or not pd:IsA("BasePart") then return false end
    local size1=pd.Size
    local cf1=pd.CFrame
    task.wait(0.08)
    if not pd.Parent or not IsRoomInESPRange(room) then return false end
    return (pd.Size-size1).Magnitude<0.001 and (pd.Position-cf1.Position).Magnitude<0.001
end

local function TryMarkDoor(room)
    if not DoorESPEnabled or not IsRoomInESPRange(room) then return false end
    local doorContainer=room:FindFirstChild("Door")
    if not doorContainer or IsDupeObject(doorContainer) then return false end
    local physicalDoor=doorContainer:FindFirstChild("Door")
    if not physicalDoor or not physicalDoor:IsA("BasePart") then return false end
    if not DoorIsStable(room) then return false end
    if not VerifyDoorLock(room) then return false end
    MarkRealDoor(room)
    return physicalDoor:FindFirstChild("RealDoorESP")~=nil
end

local function QueueDoor(room)
    if TabletSuppressingESP then return end
    if DoorPending[room] or not IsRoomInESPRange(room) then return end
    DoorPending[room]=true
    task.spawn(function()
        for _=1,30 do
            if not DoorESPEnabled or not room.Parent or not IsRoomInESPRange(room) then break end
            if TryMarkDoor(room) then break end
            task.wait(0.08)
        end
        DoorPending[room]=nil
    end)
end

local function ScanDoors()
    if TabletSuppressingESP then return end
    local current=GetCurrentRoomNumber()
    for _,n in ipairs({current,current and current+1}) do
        local room=n and workspace.CurrentRooms:FindFirstChild(tostring(n))
        if room then
            local dc=room:FindFirstChild("Door")
            local pd=dc and dc:FindFirstChild("Door")
            if pd and pd:IsA("BasePart") and pd:FindFirstChild("RealDoorESP") then
                VerifyDoorLock(room)
            else
                QueueDoor(room)
            end
        end
    end
end

ChamsTab:CreateToggle({Name="Door ESP",CurrentValue=false,Flag="DoorESP",Callback=function(v)
    DoorESPEnabled=v
    if DoorESPConnection then DoorESPConnection:Disconnect(); DoorESPConnection=nil end
    if v then
        ScanDoors()
        DoorESPConnection=workspace.CurrentRooms.ChildAdded:Connect(function(room)
        if not LightningHaxAlive then return end
            if DoorESPEnabled and IsRoomInESPRange(room) then QueueDoor(room) end
        end)
    else
        table.clear(DoorPending)
        RemoveNamedESP("RealDoorESP","RealDoorCrossFill","RealDoorOuterBorder","RealDoorESPLabel")
    end
end})

local function IsObjective(obj)
    if not obj or not obj.Parent then return false end
    if not table.find(Objectives,obj.Name) then return false end
    if not IsObjectInESPRange(obj) then return false end
    if not (obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Folder")) then return false end

    if obj.Name=="LeverForGate" or obj.Name=="TimerLever" then
        local prompt=obj:FindFirstChildWhichIsA("ProximityPrompt",true)
        return prompt~=nil and prompt.Enabled
    end

    return true
end

local function ObjectiveDisplayName(obj)
    if obj.Name=="LeverForGate" or obj.Name=="TimerLever" then return "Lever" end
    if obj.Name=="LiveBreakerPolePickup" then return "Breaker" end
    if obj.Name=="LiveHintBook" then return "Book" end
    if obj.Name=="FuseObtain" then return "Fuse" end
    if obj.Name=="MinesAnchor" then return "Anchor" end
    if obj.Name=="WaterPump" then return "Water Pump" end
    return obj.Name
end

local ObjectiveStableState={}

local function IsLeverObjective(obj)
    return obj and (obj.Name=="LeverForGate" or obj.Name=="TimerLever")
end

local function IsStableObjective(obj)
    if not IsObjective(obj) then
        ObjectiveStableState[obj]=nil
        return false
    end
    if not IsLeverObjective(obj) then return true end

    local prompt=obj:FindFirstChildWhichIsA("ProximityPrompt",true)
    if not prompt or not prompt.Enabled then
        ObjectiveStableState[obj]=nil
        return false
    end

    local now=os.clock()
    local state=ObjectiveStableState[obj]
    if not state or state.parent~=obj.Parent or state.prompt~=prompt then
        ObjectiveStableState[obj]={parent=obj.Parent,prompt=prompt,since=now}
        return false
    end

    return now-state.since>=1
end

local function MarkObjective(obj)
    if IsObjective(obj) then
        if IsLeverObjective(obj) and not IsStableObjective(obj) then return end
        AddHighlight(obj,"ObjectiveESP",ESP_GREEN,0.78)
        AddESPInfoLabel(obj,"ObjectiveESPLabel",function(target)
            return ObjectiveDisplayName(target)
        end,ESP_GREEN)
    end
    if obj.Name=="KeyObtain" and obj:IsA("Model") and IsObjectInESPRange(obj) then
        AddHighlight(obj,"KeyESP",ESP_YELLOW,0.72)
        AddESPInfoLabel(obj,"KeyESPLabel",function() return "Key" end,ESP_YELLOW)
    end
end

local function ValidateObjective(obj)
    task.wait(0.20)
    if not ObjectiveESPEnabled or not obj.Parent then return end
    local parent=obj.Parent
    local valid=IsObjective(obj) or (obj.Name=="KeyObtain" and obj:IsA("Model") and IsObjectInESPRange(obj))
    if not valid then return end
    task.wait(0.10)
    if not ObjectiveESPEnabled or not obj.Parent or obj.Parent~=parent then return end
    valid=IsObjective(obj) or (obj.Name=="KeyObtain" and obj:IsA("Model") and IsObjectInESPRange(obj))
    if valid then MarkObjective(obj) end
end

local function ScanObjectives()
    if TabletSuppressingESP then return end
    local current=GetCurrentRoomNumber()
    for _,n in ipairs({current,current and current+1}) do
        local room=n and workspace.CurrentRooms:FindFirstChild(tostring(n))
        if room then
            for _,obj in ipairs(room:GetDescendants()) do
                if IsStableObjective(obj) or (obj.Name=="KeyObtain" and IsObjectInESPRange(obj)) then MarkObjective(obj) end
            end
        end
    end
end

ChamsTab:CreateToggle({Name="Objective ESP",CurrentValue=false,Flag="ObjectiveESP",Callback=function(v)
    ObjectiveESPEnabled=v
    if ObjectiveConnection then ObjectiveConnection:Disconnect(); ObjectiveConnection=nil end
    if v then
        ScanObjectives()
        ObjectiveConnection=workspace.CurrentRooms.ChildAdded:Connect(function(room)
        if not LightningHaxAlive then return end
            if ObjectiveESPEnabled and IsRoomInESPRange(room) then task.delay(0.25,ScanObjectives) end
        end)
    else
        RemoveNamedESP("ObjectiveESP","ObjectiveESPLabel","KeyESP","KeyESPLabel")
    end
end})

local RoomESPNames={
    RealDoorESP=true,RealDoorCrossFill=true,RealDoorOuterBorder=true,RealDoorESPLabel=true,
    ChestESP=true,ChestESPLabel=true,ItemESP=true,ItemESPLabel=true,
    ObjectiveESP=true,ObjectiveESPLabel=true,KeyESP=true,KeyESPLabel=true
}

local LastESPCurrentRoom=nil

local function PurgeOutOfRangeRoomESP()
    local current=GetCurrentRoomNumber()
    if current==nil or LastESPCurrentRoom==current then return end
    LastESPCurrentRoom=current

    for _,room in ipairs(workspace.CurrentRooms:GetChildren()) do
        local n=tonumber(room.Name)
        if n and n<current then
            for _,obj in ipairs(room:GetDescendants()) do
                if RoomESPNames[obj.Name] then obj:Destroy() end
            end
        end
    end
end

local function ReconcileRoomESP()
    if TabletSuppressingESP then return end
    PurgeOutOfRangeRoomESP()
    if DoorESPEnabled then ScanDoors() end
    if ChestESPEnabled then ScanChests() end
    if ItemESPEnabled then ScanItems() end
    if ObjectiveESPEnabled then ScanObjectives() end
end

LatestRoomValue:GetPropertyChangedSignal("Value"):Connect(function()
        if not LightningHaxAlive then return end
    task.defer(ReconcileRoomESP)
end)

LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
        if not LightningHaxAlive then return end
    task.defer(ReconcileRoomESP)
end)

workspace.CurrentRooms.ChildAdded:Connect(function(room)
        if not LightningHaxAlive then return end
    task.delay(0.22,function()
        if room.Parent and IsRoomInESPRange(room) then ReconcileRoomESP() end
    end)
end)

workspace.CurrentRooms.ChildRemoved:Connect(function(room)
        if not LightningHaxAlive then return end
    DoorPending[room]=nil
    DoorLockState[room]=nil
    DoorCollisionBackup[room]=nil
end)

task.spawn(function()
    while LightningHaxAlive do
        task.wait(2)
        if DoorESPEnabled or ChestESPEnabled or ItemESPEnabled or ObjectiveESPEnabled then
            ReconcileRoomESP()
        end
    end
end)


local PlayerESPEnabled=false
local PlayerESPObjects={}
local RainbowHue=0
local function RemovePlayerESP(player) local b=PlayerESPObjects[player]; if b then b:Destroy(); PlayerESPObjects[player]=nil end end
local function AddPlayerESP(player)
    if TabletSuppressingESP then return end
    if player==LocalPlayer or not PlayerESPEnabled then return end
    local char=player.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then return end
    RemovePlayerESP(player)
    local box=Instance.new("BoxHandleAdornment"); box.Name="PlayerHitboxESP"; box.Adornee=root; box.Size=Vector3.new(4,6,2); box.Color3=Color3.fromHSV(RainbowHue,1,1); box.Transparency=.35; box.AlwaysOnTop=true; box.ZIndex=5; box.Parent=root
    PlayerESPObjects[player]=box
end
game:GetService("RunService").Heartbeat:Connect(function(dt)
        if not LightningHaxAlive then return end
    if not PlayerESPEnabled then return end
    RainbowHue=(RainbowHue+dt*.025)%1; local c=Color3.fromHSV(RainbowHue,1,1)
    for _,box in pairs(PlayerESPObjects) do if box and box.Parent then box.Color3=c end end
end)
ChamsTab:CreateToggle({Name="Player ESP",CurrentValue=false,Flag="PlayerHitboxESP",Callback=function(v)
    PlayerESPEnabled=v
    if v then for _,p in ipairs(Players:GetPlayers()) do AddPlayerESP(p) end else for p in pairs(PlayerESPObjects) do RemovePlayerESP(p) end end
end})
for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then p.CharacterAdded:Connect(function() task.wait(.1); AddPlayerESP(p) end) end end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(.1); AddPlayerESP(p) end) end)
Players.PlayerRemoving:Connect(RemovePlayerESP)

local EntityESPEnabled=false
local EntityNotificationsEnabled=false
local EntityConnections={}
local EntityBillboards={}
local FigureHitboxTransparency={}
local EntityNotified={}

local function DisconnectEntityESP()
    for _,c in ipairs(EntityConnections) do pcall(function() c:Disconnect() end) end
    table.clear(EntityConnections)
    for _,gui in pairs(EntityBillboards) do if gui and gui.Parent then gui:Destroy() end end
    table.clear(EntityBillboards)
end

local function GetEntityPart(model)
    if not model or not model.Parent then return nil end
    if model:IsA("BasePart") then return model end
    if model:IsA("Model") and model.PrimaryPart then return model.PrimaryPart end
    return model:FindFirstChild("RushNew",true)
        or model:FindFirstChild("HumanoidRootPart",true)
        or model:FindFirstChild("Torso",true)
        or model:FindFirstChildWhichIsA("BasePart",true)
end

local function GetEntityDistance(model)
    local character=LocalPlayer.Character
    local playerRoot=character and character:FindFirstChild("HumanoidRootPart")
    local entityPart=GetEntityPart(model)
    if not playerRoot or not entityPart then return nil end
    return math.floor((playerRoot.Position-entityPart.Position).Magnitude+0.5)
end

local function NotifyEntity(model,displayName)
    if not EntityNotificationsEnabled or EntityNotified[model] then return end
    EntityNotified[model]=true
    Rayfield:Notify({
        Title="Entity Spawned",
        Content=displayName.." has spawned.",
        Duration=4,
        Image=4483345998
    })
end

local function AddEntityLabel(model,displayName,showDistance)
    local part=GetEntityPart(model)
    if not part or EntityBillboards[model] then return end
    local gui=Instance.new("BillboardGui")
    gui.Name="EntityESPLabel"
    gui.Adornee=part
    gui.AlwaysOnTop=not TabletViewActive
    gui.Size=UDim2.fromOffset(165,32)
    gui.StudsOffset=Vector3.new(0,3,0)
    gui.MaxDistance=1000
    gui.Parent=part
    local text=Instance.new("TextLabel")
    text.BackgroundTransparency=1
    text.Size=UDim2.fromScale(1,1)
    text.Font=Enum.Font.GothamBold
    text.TextSize=13
    text.TextColor3=ESP_RED
    text.TextStrokeTransparency=0.15
    text.TextStrokeColor3=Color3.new(0,0,0)
    text.Parent=gui
    EntityBillboards[model]={gui=gui,text=text,name=displayName,distance=showDistance}
end

local function TrackEntity(obj)
    if TabletSuppressingESP then return end
    if not obj or not obj.Parent then return end
    local displayName,showDistance
    if obj.Name=="RushMoving" then displayName,showDistance="Rush",true
    elseif obj.Name=="AmbushMoving" then displayName,showDistance="Ambush",true
    elseif obj.Name=="Eyes" and obj.Parent==workspace then displayName,showDistance="Eyes",false
    elseif obj.Name=="FigureRig" and obj:FindFirstAncestor("CurrentRooms") then displayName,showDistance="Figure",true
    else return end
    NotifyEntity(obj,displayName)
    if EntityESPEnabled then
        AddEntityLabel(obj,displayName,showDistance)
        if displayName=="Figure" then
            local hitbox=obj:FindFirstChild("Hitbox",true)
            if hitbox and hitbox:IsA("BasePart") then
                if FigureHitboxTransparency[hitbox]==nil then FigureHitboxTransparency[hitbox]=hitbox.Transparency end
                hitbox.Transparency=1
            end
            if not obj:FindFirstChild("FigureESP") then
                local h=Instance.new("Highlight")
                h.Name="FigureESP"
                h.Adornee=obj
                h.FillColor=ESP_RED
                h.FillTransparency=0.72
                h.OutlineColor=ESP_RED
                h.OutlineTransparency=0
                h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent=obj
            end
        end
    end
end

local function ScanEntities()
    if TabletSuppressingESP then return end
    TrackEntity(workspace:FindFirstChild("RushMoving"))
    TrackEntity(workspace:FindFirstChild("AmbushMoving"))
    TrackEntity(workspace:FindFirstChild("Eyes"))
    for _,room in ipairs(workspace.CurrentRooms:GetChildren()) do
        local rig=room:FindFirstChild("FigureRig")
        if not rig then
            local fs=room:FindFirstChild("FigureSetup")
            rig=fs and fs:FindFirstChild("FigureRig")
        end
        if rig then TrackEntity(rig) end
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
        if not LightningHaxAlive then return end
    for model,data in pairs(EntityBillboards) do
        if not model or not model.Parent or not data.gui or not data.gui.Parent then
            EntityBillboards[model]=nil
        elseif data.distance then
            local dist=GetEntityDistance(model)
            data.text.Text=dist and string.format("%s  |  %d studs",data.name,dist) or data.name
        else
            data.text.Text=data.name
        end
    end
end)

local function EnsureEntityWatchers()
    if #EntityConnections>0 then return end
    table.insert(EntityConnections,workspace.ChildAdded:Connect(function(obj)
        if not LightningHaxAlive then return end
        if obj.Name=="RushMoving" or obj.Name=="AmbushMoving" or obj.Name=="Eyes" then
            task.defer(TrackEntity,obj)
        end
    end))
    table.insert(EntityConnections,workspace.CurrentRooms.ChildAdded:Connect(function(room)
        if not LightningHaxAlive then return end
        task.defer(function()
            local rig=room:FindFirstChild("FigureRig")
            if not rig then
                local fs=room:FindFirstChild("FigureSetup")
                rig=fs and fs:FindFirstChild("FigureRig")
            end
            if rig then TrackEntity(rig) end
        end)
    end))
    table.insert(EntityConnections,workspace.CurrentRooms.DescendantAdded:Connect(function(obj)
        if not LightningHaxAlive then return end
        if obj:IsA("Model") and obj.Name=="FigureRig" then
            task.defer(TrackEntity,obj)
        end
    end))
end

ChamsTab:CreateToggle({Name="Entity ESP",CurrentValue=false,Flag="EntityESP",Callback=function(v)
    EntityESPEnabled=v
    EnsureEntityWatchers()
    if v then ScanEntities()
    else
        for model,data in pairs(EntityBillboards) do
            if data.gui and data.gui.Parent then data.gui:Destroy() end
            EntityBillboards[model]=nil
        end
        for _,obj in ipairs(workspace.CurrentRooms:GetDescendants()) do
            if obj.Name=="FigureESP" and obj:IsA("Highlight") then obj:Destroy() end
        end
        for hitbox,transparency in pairs(FigureHitboxTransparency) do
            if hitbox and hitbox.Parent then hitbox.Transparency=transparency end
            FigureHitboxTransparency[hitbox]=nil
        end
    end
end})

ChamsTab:CreateToggle({Name="Entity Spawn Notifications",CurrentValue=false,Flag="EntitySpawnNotifications",Callback=function(v)
    EntityNotificationsEnabled=v
    EnsureEntityWatchers()
    if not v then table.clear(EntityNotified) end
end})

local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()


SpawnsTab:CreateButton({
    Name = "Stupid horse",
    Callback = function()
local spawner = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()
		spawner.Create({
			Entity = {
				Name = "STUPID HORSE",
				Asset = "https://github.com/MateiDaBest/Utilities/raw/refs/heads/main/Doors/Other/Stupid%20Horse.rbxm",
				HeightOffset = 0
			},
			Lights = {
				Flicker = {
					Enabled = true,
					Duration = 1
				},
				Shatter = true,
				Repair = false
			},
			Earthquake = {
				Enabled = false
			},
			CameraShake = {
				Enabled = true,
				Range = 100,
				Values = {1.5, 20, 0.1, 1}
			},
			Movement = {
				Speed = 100,
				Delay = 2,
				Reversed = false
			},
			Rebounding = {
				Enabled = false,
				Type = "Ambush",
				Min = 1,
				Max = 1,
				Delay = 2
			},
			Damage = {
				Enabled = false,
				Range = 40,
				Amount = 125
			},
			Crucifixion = {
				Enabled = true,
				Range = 40,
				Resist = false,
				Break = true
			},
			Death = {
				Type = "Guiding",
				Hints = {"Stupid", "Horse", "Stupid", "Horse"},
				Cause = ""
			}
		}):Run()

    end,
})

SpawnsTab:CreateButton({
    Name = "Rebound",
    Callback = function()
local spawner = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()
		local MainEntity = game:GetObjects("rbxassetid://86937268250993")[1]
		MainEntity.Parent = workspace
		MainEntity.Rebound.CanCollide = false
		local Plr = game:GetService("Players").LocalPlayer
		local CameraShaker = require(game:GetService("ReplicatedStorage").CameraShaker)

		local CamShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(cf)
			workspace.CurrentCamera.CFrame *= cf
		end)

		CamShake:Start()

		local Reboundcolor = Instance.new("ColorCorrectionEffect", game:GetService("Lighting"))
		Reboundcolor.Name = "Warn"
		Reboundcolor.TintColor = Color3.fromRGB(65, 138, 255)
		Reboundcolor.Saturation = -0.7
		Reboundcolor.Contrast = 0.2

		local Tween = game:GetService("TweenService"):Create(Reboundcolor, TweenInfo.new(15), {TintColor = Color3.fromRGB(255, 255, 255), Saturation = 0, Contrast = 0})
		Tween:Play()
		Tween.Completed:Connect(function()
        if not LightningHaxAlive then return end
			Reboundcolor:Destroy()
		end)
		CamShake:ShakeOnce(10, 3, 0.1, 6, 2, 0.5)

		task.wait(4)

		MainEntity.Rebound.CFrame = workspace.CurrentRooms[game:GetService("ReplicatedStorage").GameData.LatestRoom.Value].RoomExit.CFrame

		for Room = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value, 0, -1 do
			local MainRoom = workspace.CurrentRooms:FindFirstChild(Room)
			if MainRoom then
				local tween = game:GetService("TweenService"):Create(MainEntity.Rebound, TweenInfo.new(2), {CFrame = MainRoom:FindFirstChild("RoomEntrance").CFrame + Vector3.new(0, 0.6, 0)})				
				tween:Play()
				tween.Completed:Wait()

				task.wait(2)
			end
		end

		MainEntity:Destroy()

    end,
})

SpawnsTab:CreateButton({
    Name = "OG Ambush",
    Callback = function()
local spawner = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()
		spawner.Create({
			Entity = {
				Name = "OG Ambush",
				Asset = "https://github.com/MateiDaBest/Utilities/raw/refs/heads/main/Doors/Other/AmbushMoving.rbxm",
				HeightOffset = 0
			},
			Lights = {
				Flicker = {
					Enabled = true,
					Duration = 2
				},
				Shatter = true,
				Repair = false
			},
			Earthquake = {
				Enabled = false
			},
			CameraShake = {
				Enabled = true,
				Range = 100,
				Values = {1.5, 20, 0.1, 1}
			},
			Movement = {
				Speed = 150,
				Delay = 2,
				Reversed = false
			},
			Rebounding = {
				Enabled = true,
				Type = "Ambush",
				Min = 1,
				Max = 5,
				Delay = 2
			},
			Damage = {
				Enabled = false,
				Range = 40,
				Amount = 125
			},
			Crucifixion = {
				Enabled = true,
				Range = 40,
				Resist = false,
				Break = true
			},
			Death = {
				Type = "Guiding",
				Hints = {"OG", "Ambush", "OG", "Ambush"},
				Cause = ""
			}
		}):Run()

    end,
})

SpawnsTab:CreateButton({
    Name = "OG A-60",
    Callback = function()

        local spawner = loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"
        ))()

        local entity = spawner.Create({
            Entity = {
                Name = "A-60",
                Asset = "https://github.com/Idk-lol2/a-60aa/blob/main/11379072534.rbxm?raw=true",
                HeightOffset = 0
            },
            Lights = {
                Flicker = {
                    Enabled = true,
                    Duration = 7
                },
                Shatter = true,
                Repair = false
            },
            Earthquake = {
                Enabled = false
            },
            CameraShake = {
                Enabled = true,
                Range = 100,
                Values = {3, 50, 1, 1}
            },
            Movement = {
                Speed = 135,
                Delay = 11,
                Reversed = false
            },
            Rebounding = {
                Enabled = true,
                Type = "Blitz",
                Min = 2,
                Max = 4,
                Delay = 7
            },
            Damage = {
                Enabled = false,
                Range = 40,
                Amount = 125
            }
        })

        entity:Run()

        print("A-60 Spawned!")
    end,
})

SpawnsTab:CreateButton({
    Name = "Depth",
    Callback = function()

        local spawner = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()
		spawner.Create({
			Entity = {
				Name = "Depth",
				Asset = "https://github.com/MateiDaBest/Utilities/raw/refs/heads/main/Doors/Other/DepthMoving.rbxm",
				HeightOffset = 0
			},
			Lights = {
				Flicker = {
					Enabled = true,
					Duration = 1
				},
				Shatter = true,
				Repair = false
			},
			Earthquake = {
				Enabled = false
			},
			CameraShake = {
				Enabled = true,
				Range = 100,
				Values = {1.5, 20, 0.1, 1}
			},
			Movement = {
				Speed = 100,
				Delay = 2,
				Reversed = false
			},
			Rebounding = {
				Enabled = false,
				Type = "Ambush",
				Min = 1,
				Max = 1,
				Delay = 2
			},
			Damage = {
				Enabled = false,
				Range = 40,
				Amount = 125
			},
			Crucifixion = {
				Enabled = true,
				Range = 40,
				Resist = false,
				Break = true
			},
			Death = {
				Type = "Guiding",
				Hints = {"Depth", "Depth", "Depth", "Depth"},
				Cause = ""
			}
		}):Run()
	end,
})


local SpawnCleanupNames = {
    ["OG Ambush"]=true,["A-60"]=true,["Depth"]=true,["STUPID HORSE"]=true,["Rebound"]=true,["Ripe"]=true,
    ["RushMoving"]=false,["AmbushMoving"]=false,["Eyes"]=false,["SeekMoving"]=false,["SeekMovingNewClone"]=false
}
local function DeleteCustomSpawnedEntities()
    local removed=0
    for _,obj in ipairs(workspace:GetChildren()) do
        if SpawnCleanupNames[obj.Name]==true then obj:Destroy(); removed+=1 end
    end
    Rayfield:Notify({Title="Entity Cleanup",Content=("Removed %d custom entities."):format(removed),Duration=4})
end
SpawnsTab:CreateButton({Name="Delete Custom Spawned Entities",Callback=DeleteCustomSpawnedEntities})

local function PreparePlushyTool(tool)
    if not tool or not tool:IsA("Tool") or tool:GetAttribute("LightningPlushyPrepared") then return tool end
    tool:SetAttribute("LightningPlushyPrepared", true)
    tool.Unequipped:Connect(function()
        if not LightningHaxAlive then return end
        task.defer(function()
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    local n = string.lower(track.Name or "")
                    if track.Priority >= Enum.AnimationPriority.Action and (string.find(n,"hold",1,true) or string.find(n,"equip",1,true) or string.find(n,"plush",1,true)) then
                        pcall(function() track:Stop(0.1) end)
                    end
                end
            end
            if character then
                for _, limbName in ipairs({"RightHand","Right Arm"}) do
                    local limb = character:FindFirstChild(limbName)
                    local grip = limb and limb:FindFirstChild("RightGrip")
                    if grip and grip:IsA("Motor6D") and grip.Part1 and grip.Part1:IsDescendantOf(tool) then
                        grip:Destroy()
                    end
                end
            end
        end)
    end)
    return tool
end

PlushysTab:CreateParagraph({
    Title = "Note:",
    Content = "A-120 and Depth plushy can be executed in pre-run shop for there own section in it (Hotel-)"
})

PlushysTab:CreateButton({
    Name = "Rush Plushy",
    Callback = function()
 local RushEnabled = true
 local AmbushEnabled = false
 local JackEnabled = false
 local DupeEnabled = false
 
 
 local Players = game:GetService("Players")
 local UIS = game:GetService("UserInputService")
 local Plr = Players.LocalPlayer
 local Char = Plr.Character or Plr.CharacterAdded:Wait()
 
 local Rush = game:GetObjects("rbxassetid://106490395325401")[1]
 if RushEnabled then
     PreparePlushyTool(Rush)
     Rush.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Ambush = game:GetObjects("rbxassetid://91769363360905")[1]
 if AmbushEnabled then
     PreparePlushyTool(Ambush)
     Ambush.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Jack = game:GetObjects("rbxassetid://135816582968851")[1]
 if JackEnabled then
     PreparePlushyTool(Jack)
     Jack.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Dupe = game:GetObjects("rbxassetid://116858052599982")[1]
 if DupeEnabled then
     PreparePlushyTool(Dupe)
     Dupe.Parent = game.Players.LocalPlayer.Backpack
 end
    end,
 })
 
PlushysTab:CreateButton({
    Name = "Ambush Plushy",
    Callback = function()
 local RushEnabled = false
 local AmbushEnabled = true
 local JackEnabled = false
 local DupeEnabled = false
 
 
 local Players = game:GetService("Players")
 local UIS = game:GetService("UserInputService")
 local Plr = Players.LocalPlayer
 local Char = Plr.Character or Plr.CharacterAdded:Wait()
 
 local Rush = game:GetObjects("rbxassetid://106490395325401")[1]
 if RushEnabled then
     PreparePlushyTool(Rush)
     Rush.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Ambush = game:GetObjects("rbxassetid://91769363360905")[1]
 if AmbushEnabled then
     PreparePlushyTool(Ambush)
     Ambush.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Jack = game:GetObjects("rbxassetid://135816582968851")[1]
 if JackEnabled then
     PreparePlushyTool(Jack)
     Jack.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Dupe = game:GetObjects("rbxassetid://116858052599982")[1]
 if DupeEnabled then
     PreparePlushyTool(Dupe)
     Dupe.Parent = game.Players.LocalPlayer.Backpack
 end
    end,
 })
 
PlushysTab:CreateButton({
    Name = "Dupe Plushy",
    Callback = function()
 local RushEnabled = false
 local AmbushEnabled = false
 local JackEnabled = false
 local DupeEnabled = true
 
 
 local Players = game:GetService("Players")
 local UIS = game:GetService("UserInputService")
 local Plr = Players.LocalPlayer
 local Char = Plr.Character or Plr.CharacterAdded:Wait()
 
 local Rush = game:GetObjects("rbxassetid://106490395325401")[1]
 if RushEnabled then
     PreparePlushyTool(Rush)
     Rush.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Ambush = game:GetObjects("rbxassetid://91769363360905")[1]
 if AmbushEnabled then
     PreparePlushyTool(Ambush)
     Ambush.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Jack = game:GetObjects("rbxassetid://135816582968851")[1]
 if JackEnabled then
     PreparePlushyTool(Jack)
     Jack.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Dupe = game:GetObjects("rbxassetid://116858052599982")[1]
 if DupeEnabled then
     PreparePlushyTool(Dupe)
     Dupe.Parent = game.Players.LocalPlayer.Backpack
 end
    end,
 })
 
 PlushysTab:CreateButton({
    Name = "Guiding Light Plushy",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local hum = plr.Character:WaitForChild("Humanoid")
        
        local plush = game:GetObjects("rbxassetid://86849317933417")[1]
        PreparePlushyTool(plush)
        plush.Parent = plr.Backpack
        local anim = hum:LoadAnimation(plush.A.Hold)
        
        plush.Equipped:Connect(function()
        if not LightningHaxAlive then return end
            anim:Play()
        end)
        plush.Unequipped:Connect(function()
        if not LightningHaxAlive then return end
            anim:Stop()
        end)
        
        plush.Activated:Connect(function()
        if not LightningHaxAlive then return end
            plush.Toy:Play()
        end)
    end,
 })

PlushysTab:CreateButton({
    Name = "Seek Plushy",
    Callback = function()
     local plr = game.Players.LocalPlayer
 local hum = plr.Character:WaitForChild("Humanoid")
 
 local plush = game:GetObjects("rbxassetid://13613269677")[1]
 PreparePlushyTool(plush)
 plush.Parent = plr.Backpack
 local anim = hum:LoadAnimation(plush.A.Hold)
 
 plush.Equipped:Connect(function()
        if not LightningHaxAlive then return end
   anim:Play()
 end)
 plush.Unequipped:Connect(function()
        if not LightningHaxAlive then return end
   anim:Stop()
 end)
 
 plush.Activated:Connect(function()
        if not LightningHaxAlive then return end
   plush.Toy:Play()
 end)
 
    end,
 })
  
PlushysTab:CreateButton({
    Name = "A-60 Plushy",
    Callback = function()
 local Players = game:GetService("Players")
 local UIS = game:GetService("UserInputService")
 local Plr = Players.LocalPlayer
 local Char = Plr.Character or Plr.CharacterAdded:Wait()
 
 local shadow = game:GetObjects("rbxassetid://85674900664881")[1]
 PreparePlushyTool(shadow)
 shadow.Parent = game.Players.LocalPlayer.Backpack
 
 UIS.InputBegan:Connect(function(input, gameProcessed)
        if not LightningHaxAlive then return end
     if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
         local plushie = Char:FindFirstChild("A60")
 
         if plushie then
             plushie.Handle.Sound:Stop()
         end
     end
 end)
 
 UIS.InputBegan:Connect(function(input, gameProcessed)
        if not LightningHaxAlive then return end
     if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
         local plushie = Char:FindFirstChild("A60")
 
         if plushie then
             plushie.Handle.Sound:Play()
         end
     end
 end)
    end,
 })
  
PlushysTab:CreateButton({
    Name = "A-90 Plushy",
    Callback = function()
 local Players = game:GetService("Players")
 local Equipped = false
 local Plr = Players.LocalPlayer
 local Char = Plr.Character or Plr.CharacterAdded:Wait()
 local Hum = Char:WaitForChild("Humanoid")
 local Root = Char:WaitForChild("HumanoidRootPart")
 local RightArm = Char:WaitForChild("RightUpperArm")
 local LeftArm = Char:WaitForChild("LeftUpperArm")
 local RightC1 = RightArm.RightShoulder.C1
 local LeftC1 = LeftArm.LeftShoulder.C1
 local A90 = game:GetObjects("rbxassetid://12544988486")[1]
 
 PreparePlushyTool(A90)
 
 A90.Parent = game.Players.LocalPlayer.Backpack
 
 local function setupHands(tool)
     tool.Equipped:Connect(function()
        if not LightningHaxAlive then return end
         Equipped = true
         Char:SetAttribute("Hiding", true)
         for _, v in next, Hum:GetPlayingAnimationTracks() do
             v:Stop()
         end
 
         RightArm.Name = "R_Arm"
         LeftArm.Name = "L_Arm"
 
         RightArm.RightShoulder.C1 = RightC1
             * CFrame.Angles(math.rad(-90), math.rad(-10), 0)
         LeftArm.LeftShoulder.C1 = LeftC1
             * CFrame.new(-0.2, 0, -0.5)
             * CFrame.Angles(math.rad(-110), math.rad(15), math.rad(0))
     end)
 
     tool.Unequipped:Connect(function()
        if not LightningHaxAlive then return end
         Equipped = false
         Char:SetAttribute("Hiding", nil)
         RightArm.Name = "RightUpperArm"
         LeftArm.Name = "LeftUpperArm"
 
         RightArm.RightShoulder.C1 = RightC1
         LeftArm.LeftShoulder.C1 = LeftC1
     end)
 end
 
 setupHands(A90)
    end,
 })
 
PlushysTab:CreateButton({
    Name = "A-120 Plushy",
    Callback = function()
      local Players = game:GetService("Players")
 local Equipped = false
 local Plr = Players.LocalPlayer
 local Char = Plr.Character or Plr.CharacterAdded:Wait()
 local Hum = Char:WaitForChild("Humanoid")
 local Root = Char:WaitForChild("HumanoidRootPart")
 local RightArm = Char:WaitForChild("RightUpperArm")
 local LeftArm = Char:WaitForChild("LeftUpperArm")
 local RightC1 = RightArm.RightShoulder.C1
 local LeftC1 = LeftArm.LeftShoulder.C1
 local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
 local CustomShop = loadstring(game:HttpGet("https://raw.githubusercontent.com/MateiDaBest/Utilities/main/Doors/Custom%20Shop%20Items/Main.lua"))()
 local A120 = game:GetObjects("rbxassetid://12564739530")[1]
 
 CustomShop.CreateItem({
     Title = "A-120 Plushie",
     Desc = "Balls",
     Image = "https://i.pinimg.com/236x/76/ed/02/76ed02350afbd78b8275743958871368.jpg",
     Price = 69,
     Stack = 1,
 })
 
 PreparePlushyTool(A120)
 
 A120.Parent = game.Players.LocalPlayer.Backpack
 
 local function setupHands(tool)
     tool.Equipped:Connect(function()
        if not LightningHaxAlive then return end
         Equipped = true
         Char:SetAttribute("Hiding", true)
         for _, v in next, Hum:GetPlayingAnimationTracks() do
             v:Stop()
         end
 
         RightArm.Name = "R_Arm"
         LeftArm.Name = "L_Arm"
 
         RightArm.RightShoulder.C1 = RightC1
             * CFrame.Angles(math.rad(-90), math.rad(-10), 0)
         LeftArm.LeftShoulder.C1 = LeftC1
             * CFrame.new(-0.2, 0, -0.5)
             * CFrame.Angles(math.rad(-110), math.rad(15), math.rad(0))
     end)
 
     tool.Unequipped:Connect(function()
        if not LightningHaxAlive then return end
         Equipped = false
         Char:SetAttribute("Hiding", nil)
         RightArm.Name = "RightUpperArm"
         LeftArm.Name = "LeftUpperArm"
 
         RightArm.RightShoulder.C1 = RightC1
         LeftArm.LeftShoulder.C1 = LeftC1
     end)
 end
 
 setupHands(A120)
    end,
 })
 
 PlushysTab:CreateButton({
    Name = "Depth Plushy",
    Callback = function()
     local plr = game.Players.LocalPlayer
   local Players = game:GetService("Players")
 local Equipped = false
 local Plr = Players.LocalPlayer
 local Char = Plr.Character or Plr.CharacterAdded:Wait()
 local Hum = Char:WaitForChild("Humanoid")
 local Root = Char:WaitForChild("HumanoidRootPart")
 local RightArm = Char:WaitForChild("RightUpperArm")
 local LeftArm = Char:WaitForChild("LeftUpperArm")
 local RightC1 = RightArm.RightShoulder.C1
 local LeftC1 = LeftArm.LeftShoulder.C1
 local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
 local CustomShop = loadstring(game:HttpGet("https://raw.githubusercontent.com/MateiDaBest/Utilities/main/Doors/Custom%20Shop%20Items/Main.lua"))()
 local Depth = game:GetObjects("rbxassetid://12564733947")[1]
 local Atmosphere = Instance.new("Atmosphere")
 
 Atmosphere.Density = 0.75
 Atmosphere.Parent = game.ReplicatedStorage
 
 CustomShop.CreateItem({
     Title = "Depth Plushy",
     Desc = "Im gonna tickle your balls",
     Image = "rbxassetid://11278229112",
     Price = 69,
     Stack = 1,
 })
 
 PreparePlushyTool(Depth)
 
 Depth.Parent = game.Players.LocalPlayer.Backpack
 
 local function setupHands(tool)
     tool.Equipped:Connect(function()
        if not LightningHaxAlive then return end
         Equipped = true
         Char:SetAttribute("Hiding", true)
         for _, v in next, Hum:GetPlayingAnimationTracks() do
             v:Stop()
         end
 
         RightArm.Name = "R_Arm"
         LeftArm.Name = "L_Arm"
 
         RightArm.RightShoulder.C1 = RightC1
             * CFrame.Angles(math.rad(-90), math.rad(-10), 0)
         LeftArm.LeftShoulder.C1 = LeftC1
             * CFrame.new(-0.2, 0.1, -0.5)
             * CFrame.Angles(math.rad(-110), math.rad(15), math.rad(0))
 
         Atmosphere.Parent = game.Lighting
 
         for i, object in pairs(workspace:WaitForChild("CurrentRooms"):GetDescendants()) do
             if object.Name == "Neon" then
                 object.Color = Color3.new(0.333333, 0.666667, 1)
             end
         end
     end)
 
     tool.Unequipped:Connect(function()
        if not LightningHaxAlive then return end
         Equipped = false
         Char:SetAttribute("Hiding", nil)
         RightArm.Name = "RightUpperArm"
         LeftArm.Name = "LeftUpperArm"
 
         RightArm.RightShoulder.C1 = RightC1
         LeftArm.LeftShoulder.C1 = LeftC1
 
         Atmosphere.Parent = game.ReplicatedStorage
 
         for i, object in pairs(workspace:WaitForChild("CurrentRooms"):GetDescendants()) do
             if object.Name == "Neon" then
                 object.Color = Color3.new(0.764706, 0.631373, 0.552941)
             end
         end
     end)
 end
 
 setupHands(Depth)
    end,
 })
PlushysTab:CreateButton({
    Name = "Green Blitz Plushy",
    Callback = function()
 local Sounds = true
 
 local HasteEnabled = false
 local BrotherEnabled = true
 local SisterEnabled = false
 
 local SoundKey = Enum.KeyCode.K
 local StopSoundKey = Enum.KeyCode.Space
 
 
 local Players = game:GetService("Players")
 local UIS = game:GetService("UserInputService")
 local Plr = Players.LocalPlayer
 local Char = Plr.Character or Plr.CharacterAdded:Wait()
 
 local Haste = game:GetObjects("rbxassetid://109374845896295")[1]
 if HasteEnabled then
     PreparePlushyTool(Haste)
     Haste.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Brother = game:GetObjects("rbxassetid://81472152992030")[1]
 if BrotherEnabled then
     PreparePlushyTool(Brother)
     Brother.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Sister = game:GetObjects("rbxassetid://85239321727099")[1]
 if SisterEnabled then
     PreparePlushyTool(Sister)
     Sister.Parent = game.Players.LocalPlayer.Backpack
 end
 
 if Sounds then
     Haste.Handle.Sound.SoundId = getsynasset("Sounds/Haste.MP3")
     Brother.Handle.Sound.SoundId = getsynasset("Sounds/Blitz.MP3")
     Sister.Handle.Sound.SoundId = getsynasset("Sounds/Blitz.MP3")
 end
 
 UIS.InputBegan:Connect(function(input, gameProcessed)
        if not LightningHaxAlive then return end
     if not gameProcessed and input.KeyCode == StopSoundKey then
         local HastePlushie = Char:FindFirstChild(Haste.Name)
         local BrotherPlushie = Char:FindFirstChild(Brother.Name)
         local SisterPlushie = Char:FindFirstChild(Sister.Name)
         
         if HastePlushie then
             HastePlushie.Handle.Sound:Stop()
         end
         
         if BrotherPlushie then
             BrotherPlushie.Handle.Sound:Stop()
         end
 
         if SisterPlushie then
             SisterPlushie.Handle.Sound:Stop()
         end
     end
 end)
 
 UIS.InputBegan:Connect(function(input, gameProcessed)
        if not LightningHaxAlive then return end
     if not gameProcessed and input.KeyCode == SoundKey then
         local HastePlushie = Char:FindFirstChild(Haste.Name)
         local BrotherPlushie = Char:FindFirstChild(Brother.Name)
         local SisterPlushie = Char:FindFirstChild(Sister.Name)
 
         if HastePlushie then
             HastePlushie.Handle.Sound:Play()
         end
 
         if BrotherPlushie then
             BrotherPlushie.Handle.Sound:Play()
         end
 
         if SisterPlushie then
             SisterPlushie.Handle.Sound:Play()
         end
     end
 end)
    end,
 })
 
PlushysTab:CreateButton({
    Name = "Pink Blitz Plushy",
    Callback = function()
 local Sounds = true
 
 local HasteEnabled = false
 local BrotherEnabled = false
 local SisterEnabled = true
 
 local SoundKey = Enum.KeyCode.K
 local StopSoundKey = Enum.KeyCode.Space
 
 
 local Players = game:GetService("Players")
 local UIS = game:GetService("UserInputService")
 local Plr = Players.LocalPlayer
 local Char = Plr.Character or Plr.CharacterAdded:Wait()
 
 local Haste = game:GetObjects("rbxassetid://109374845896295")[1]
 if HasteEnabled then
     PreparePlushyTool(Haste)
     Haste.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Brother = game:GetObjects("rbxassetid://81472152992030")[1]
 if BrotherEnabled then
     PreparePlushyTool(Brother)
     Brother.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Sister = game:GetObjects("rbxassetid://85239321727099")[1]
 if SisterEnabled then
     PreparePlushyTool(Sister)
     Sister.Parent = game.Players.LocalPlayer.Backpack
 end
 
 if Sounds then
     Haste.Handle.Sound.SoundId = getsynasset("Sounds/Haste.MP3")
     Brother.Handle.Sound.SoundId = getsynasset("Sounds/Blitz.MP3")
     Sister.Handle.Sound.SoundId = getsynasset("Sounds/Blitz.MP3")
 end
 
 UIS.InputBegan:Connect(function(input, gameProcessed)
        if not LightningHaxAlive then return end
     if not gameProcessed and input.KeyCode == StopSoundKey then
         local HastePlushie = Char:FindFirstChild(Haste.Name)
         local BrotherPlushie = Char:FindFirstChild(Brother.Name)
         local SisterPlushie = Char:FindFirstChild(Sister.Name)
         
         if HastePlushie then
             HastePlushie.Handle.Sound:Stop()
         end
         
         if BrotherPlushie then
             BrotherPlushie.Handle.Sound:Stop()
         end
 
         if SisterPlushie then
             SisterPlushie.Handle.Sound:Stop()
         end
     end
 end)
 
 UIS.InputBegan:Connect(function(input, gameProcessed)
        if not LightningHaxAlive then return end
     if not gameProcessed and input.KeyCode == SoundKey then
         local HastePlushie = Char:FindFirstChild(Haste.Name)
         local BrotherPlushie = Char:FindFirstChild(Brother.Name)
         local SisterPlushie = Char:FindFirstChild(Sister.Name)
 
         if HastePlushie then
             HastePlushie.Handle.Sound:Play()
         end
 
         if BrotherPlushie then
             BrotherPlushie.Handle.Sound:Play()
         end
 
         if SisterPlushie then
             SisterPlushie.Handle.Sound:Play()
         end
     end
 end)
    end,
 })
 
PlushysTab:CreateButton({
    Name = "Haste Plushy",
    Callback = function()
 local Sounds = true
 
 local HasteEnabled = true
 local BrotherEnabled = false
 local SisterEnabled = false
 
 local SoundKey = Enum.KeyCode.K
 local StopSoundKey = Enum.KeyCode.Space
 
 
 local Players = game:GetService("Players")
 local UIS = game:GetService("UserInputService")
 local Plr = Players.LocalPlayer
 local Char = Plr.Character or Plr.CharacterAdded:Wait()
 
 local Haste = game:GetObjects("rbxassetid://109374845896295")[1]
 if HasteEnabled then
     PreparePlushyTool(Haste)
     Haste.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Brother = game:GetObjects("rbxassetid://81472152992030")[1]
 if BrotherEnabled then
     PreparePlushyTool(Brother)
     Brother.Parent = game.Players.LocalPlayer.Backpack
 end
 
 local Sister = game:GetObjects("rbxassetid://85239321727099")[1]
 if SisterEnabled then
     PreparePlushyTool(Sister)
     Sister.Parent = game.Players.LocalPlayer.Backpack
 end
 
 if Sounds then
     Haste.Handle.Sound.SoundId = getsynasset("Sounds/Haste.MP3")
     Brother.Handle.Sound.SoundId = getsynasset("Sounds/Blitz.MP3")
     Sister.Handle.Sound.SoundId = getsynasset("Sounds/Blitz.MP3")
 end
 
 UIS.InputBegan:Connect(function(input, gameProcessed)
        if not LightningHaxAlive then return end
     if not gameProcessed and input.KeyCode == StopSoundKey then
         local HastePlushie = Char:FindFirstChild(Haste.Name)
         local BrotherPlushie = Char:FindFirstChild(Brother.Name)
         local SisterPlushie = Char:FindFirstChild(Sister.Name)
         
         if HastePlushie then
             HastePlushie.Handle.Sound:Stop()
         end
         
         if BrotherPlushie then
             BrotherPlushie.Handle.Sound:Stop()
         end
 
         if SisterPlushie then
             SisterPlushie.Handle.Sound:Stop()
         end
     end
 end)
 
 UIS.InputBegan:Connect(function(input, gameProcessed)
        if not LightningHaxAlive then return end
     if not gameProcessed and input.KeyCode == SoundKey then
         local HastePlushie = Char:FindFirstChild(Haste.Name)
         local BrotherPlushie = Char:FindFirstChild(Brother.Name)
         local SisterPlushie = Char:FindFirstChild(Sister.Name)
 
         if HastePlushie then
             HastePlushie.Handle.Sound:Play()
         end
 
         if BrotherPlushie then
             BrotherPlushie.Handle.Sound:Play()
         end
 
         if SisterPlushie then
             SisterPlushie.Handle.Sound:Play()
         end
     end
 end)
    end,
 })
  
PlushysTab:CreateButton({
    Name = "Jeff The Killer Plushy",
    Callback = function()
     local tool = game:GetObjects("rbxassetid://13069619857")[1]
       PreparePlushyTool(tool)
       tool.Parent = game.Players.LocalPlayer.Backpack
    end,
 })

 PlushysTab:CreateButton({
    Name = "Feathered Kiwi Plushy",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/PFERptU5", true))()
    end,
 })

UtilitiesTab:CreateSection("Developer Tools")

UtilitiesTab:CreateButton({
    Name = "Infinite Yield",

    Callback = function()
        local Success, Result = pcall(function()
            local Source = game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
            local Script = loadstring(Source)

            if not Script then
                error("Infinite Yield could not be compiled.")
            end

            Script()
        end)

        Rayfield:Notify({
            Title = Success and "Infinite Yield" or "Infinite Yield Error",
            Content = Success
                and "Loaded successfully."
                or tostring(Result),
            Duration = 5
        })
    end
})

UtilitiesTab:CreateButton({
    Name = "Dex Explorer ++",

    Callback = function()
        local Success, Result = pcall(function()
            local Source = game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua") 
                    
            local Script = loadstring(Source)

            if not Script then
                error("Dex Explorer ++ could not be compiled.")
            end

            Script()
        end)

        Rayfield:Notify({
            Title = Success and "Dex Explorer ++" or "Dex Explorer ++ Error",
            Content = Success
                and "Loaded successfully."
                or tostring(Result),
            Duration = 5
        })
    end
})

UtilitiesTab:CreateButton({
    Name = "SimpleSpy",

    Callback = function()
        local Success, Result = pcall(function()
            local Source = game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua")
            local Script = loadstring(Source)

            if not Script then
                error("SimpleSpy could not be compiled.")
            end

            Script()
        end)

        Rayfield:Notify({
            Title = Success and "SimpleSpy" or "SimpleSpy Error",
            Content = Success
                and "Loaded successfully."
                or tostring(Result),
            Duration = 5
        })
    end
})

UtilitiesTab:CreateButton({
    Name = "RemoteSpy",

    Callback = function()
        local Success, Result = pcall(function()
            local Source = game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/utopia_spy.lua")
            local Script = loadstring(Source)

            if not Script then
                error("RemoteSpy could not be compiled.")
            end

            Script()
        end)

        Rayfield:Notify({
            Title = Success and "RemoteSpy" or "RemoteSpy Error",
            Content = Success
                and "Loaded successfully."
                or tostring(Result),
            Duration = 5
        })
    end
})

UtilitiesTab:CreateButton({
    Name = "Reset Character",

    Callback = function()

        local Character = GetCharacter()

        local Humanoid = Character
            and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.Health = 0
        end
    end
})

UtilitiesTab:CreateButton({
    Name = "Rejoin Server",

    Callback = function()

        TeleportService:Teleport(
            game.PlaceId,
            LocalPlayer
        )
    end
})

UtilitiesTab:CreateButton({
    Name = "Open Developer Console",

    Callback = function()

        pcall(function()
            StarterGui:SetCore(
                "DevConsoleVisible",
                true
            )
        end)
    end
})


UtilitiesTab:CreateButton({
    Name = "Unload lightninghax",
    Callback = function()
        LightningHaxAlive = false

        DoorESPEnabled = false
        ChestESPEnabled = false
        ItemESPEnabled = false
        ObjectiveESPEnabled = false
        PlayerESPEnabled = false
        EntityESPEnabled = false

        pcall(function() SetScreechDisabled(false) end)
        pcall(function() SetFullbrightNoFog(false) end)
        pcall(function() SetDupeDisabled(false) end)

        for room in pairs(DoorCollisionBackup) do
            pcall(function() RestoreDoorCollision(room) end)
        end

        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj.Name=="LightningDoubleDoorESPAnchor" then
                obj:Destroy()
            elseif obj:IsA("Highlight") and (
                obj.Name=="RealDoorESP" or obj.Name=="RealDoorCrossFill" or
                obj.Name=="DoorESP" or obj.Name=="ChestESP" or obj.Name=="ItemESP" or
                obj.Name=="ObjectiveESP" or obj.Name=="FigureESP" or
                obj.Name=="PlayerESP"
            ) then
                obj:Destroy()
            elseif obj.Name=="RealDoorOuterBorder" or
                   obj.Name=="RealDoorESPLabel" or obj.Name=="ChestESPLabel" or
                   obj.Name=="ItemESPLabel" or obj.Name=="ObjectiveESPLabel" or
                   obj.Name=="EntityESPLabel" or obj.Name=="PlayerESPLabel" then
                obj:Destroy()
            end
        end

        for _,gui in pairs(EntityBillboards) do
            if gui and gui.Parent then gui:Destroy() end
        end
        table.clear(EntityBillboards)

        for player,gui in pairs(PlayerESPObjects) do
            if gui and gui.Parent then gui:Destroy() end
            PlayerESPObjects[player]=nil
        end

        for hitbox,transparency in pairs(FigureHitboxTransparency) do
            if hitbox and hitbox.Parent then hitbox.Transparency=transparency end
            FigureHitboxTransparency[hitbox]=nil
        end

        pcall(function()
            if Rayfield.Destroy then
                Rayfield:Destroy()
            elseif Rayfield.DestroyWindow then
                Rayfield:DestroyWindow()
            end
        end)
    end
})


Rayfield:LoadConfiguration()
