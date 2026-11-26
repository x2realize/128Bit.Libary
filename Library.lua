-- Rework by xxc

if getgenv().Library then
    getgenv().Library:Unload()
end

local Library do 
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromOffset = UDim2.fromOffset
    local Vector2New = Vector2.new
    local Vector3New = Vector3.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len

    local InstanceNew = Instance.new

    local RectNew = Rect.new

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 

        Flags = { },

        Tween = {
            Time = 0.2,
            Style = Enum.EasingStyle.Circular,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "homxiide",
            Configs = "homxiide/Configs",
            Assets = "homxiide/Assets",
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,

        Font = nil
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    local Themes = {
        ["Preset"] = {
            ["Background"] = FromRGB(10, 11, 12),
            ["Outline"] = FromRGB(22, 24, 23),
            ["Inline"] = FromRGB(18, 20, 22),
            ["Accent"] = FromRGB(155, 229, 222),
            ["Text"] = FromRGB(236, 245, 253),
            ["Element"] = FromRGB(25, 29, 31)
        }
    }

    Library.Theme = TableClone(Themes["Preset"])

    -- Folders
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 

            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
            return self
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end
        
            local Gui = self.Instance
            local Dragging = false 
            local DragStart
            local StartPosition 
            local StartTopLeft
            local GuiSize
            local ParentSize
        
            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                local Desired = StartTopLeft + Vector2New(DragDelta.X, DragDelta.Y)

                -- Free movement, only keep a grab area on screen
                local GrabX = math.min(GuiSize.X, 80)
                local GrabY = math.min(GuiSize.Y, 50)

                local MinX = GrabX - GuiSize.X
                local MaxX = math.max(MinX, ParentSize.X - GrabX)
                local MaxY = math.max(0, ParentSize.Y - GrabY)

                local ClampedX = MathClamp(Desired.X, MinX, MaxX)
                local ClampedY = MathClamp(Desired.Y, 0, MaxY)

                Gui.Position = UDim2New(
                    StartPosition.X.Scale, StartPosition.X.Offset + (ClampedX - StartTopLeft.X),
                    StartPosition.Y.Scale, StartPosition.Y.Offset + (ClampedY - StartTopLeft.Y)
                )
            end
        
            local InputChanged
        
            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position
                    ParentSize = Gui.Parent.AbsoluteSize
                    GuiSize = Gui.AbsoluteSize
                    StartTopLeft = Vector2New(
                        StartPosition.X.Scale * ParentSize.X + StartPosition.X.Offset - Gui.AnchorPoint.X * GuiSize.X,
                        StartPosition.Y.Scale * ParentSize.Y + StartPosition.Y.Offset - Gui.AnchorPoint.Y * GuiSize.Y
                    )
        
                    if InputChanged then 
                        return
                    end
        
                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)
        
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)
        
            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local CurrentSide = nil

            local StartMouse = nil 
            local StartPosition = nil 
            local StartSize = nil
            
            local EdgeThickness = 2

            local MakeEdge = function(Name, Position, Size)
                local Button = Instances:Create("TextButton", {
                    Name = "\0",
                    Size = Size,
                    Position = Position,
                    BackgroundColor3 = FromRGB(166, 147, 243),
                    BackgroundTransparency = 1,
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = Gui,
                    ZIndex = 99999,
                })  Button:AddToTheme({BackgroundColor3 = "Accent"})

                return Button
            end

            local Edges = {
                {Button = MakeEdge(
                    "Left", 
                    UDim2New(0, 0, 0, 0), 
                    UDim2New(0, EdgeThickness, 1, 0)), 
                    Side = "L"
                },

                {Button = MakeEdge(
                    "Right", 
                    UDim2New(1, -EdgeThickness, 0, 0), 
                    UDim2New(0, EdgeThickness, 1, 0)), 
                    Side = "R"
                },

                {Button = MakeEdge(
                    "Top", UDim2New(0, 0, 0, 0), 
                    UDim2New(1, 0, 0, EdgeThickness)), 
                    Side = "T"
                },

                {Button = MakeEdge(
                    "Bottom", 
                    UDim2New(0, 0, 1, -EdgeThickness), 
                    UDim2New(1, 0, 0, EdgeThickness)), 
                    Side = "B"
                },
            }

            local BeginResizing = function(Side)
                Resizing = true 
                CurrentSide = Side 

                StartMouse = UserInputService:GetMouseLocation()

                -- store offsets, not absolute screen pos
                StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
                StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)
                
                for Index, Value in Edges do 
                    Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
                end
            end

            local EndResizing = function()
                Resizing = false 
                CurrentSide = nil

                for Index, Value in Edges do 
                    Value.Button.Instance.BackgroundTransparency = 1
                end
            end

            for Index, Value in Edges do 
                Value.Button:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        BeginResizing(Value.Side)
                    end
                end)
            end

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        EndResizing()
                    end
                end
            end)

            Library:Connect(RunService.RenderStepped, function()
                if not Resizing or not CurrentSide then 
                    return 
                end

                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y
            
                local x, y = StartPosition.X, StartPosition.Y
                local w, h = StartSize.X, StartSize.Y

                if CurrentSide == "L" then
                    x = StartPosition.X + dx
                    w = StartSize.X - dx
                elseif CurrentSide == "R" then
                    w = StartSize.X + dx
                elseif CurrentSide == "T" then
                    y = StartPosition.Y + dy
                    h = StartSize.Y - dy
                elseif CurrentSide == "B" then
                    h = StartSize.Y + dy
                end
            
                if w < Minimum.X then
                    if CurrentSide == "L" then
                        x = x - (Minimum.X - w)
                    end
                    w = Minimum.X
                end
                if h < Minimum.Y then
                    if CurrentSide == "T" then
                        y = y - (Minimum.Y - h)
                    end
                    h = Minimum.Y
                end
            
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(x, y)})
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(w, h)})
            end)
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then 
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(`{Library.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Folders.Assets}/{Name}.font`))
        end

        Library.Font = CustomFont:New("OutfitMedium", 400, "Regular", {
            Id = "OutfitMedium",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Outfit-Medium.ttf"
        })
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil 
        getgenv().Library = nil
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not self.Theme[Value] then
                    Item[Property] = Value 
                end

                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
	end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Folders.Configs)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end

    Library.CompareVectors = function(self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end

    Library.IsClipped = function(self, Object, Column)
        local Parent = Column
        
        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize

        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize 

        return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
    end

    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Flag = Data.Flag, 

            Hue = 0,
            Saturation = 0,
            Value = 0,

            Color = Color3.fromRGB(0, 0, 0),
            Hex = "#000000",

            IsOpen = false 
        }

        local Items = { } do 
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(0, 20, 0, 16),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(148, 255, 237)
            })
            
            Instances:Create("UICorner", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Color = Library.Theme["Outline"],
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = 'Outline'})
            
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(148, 255, 237),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.800000011920929,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 25, 1, 25),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "http://www.roblox.com/asset/?id=18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })            

            Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 94, 0, 60),
                Size = UDim2New(0, 160, 0, 160),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = 'Background'})
            
            Instances:Create("UICorner", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 8, 0, 8),
                Size = UDim2New(1, -40, 1, -16),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(148, 255, 237)
            })
            
            Instances:Create("UICorner", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })
            
            Items["Saturation"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 1, 1, 0),
                BorderSizePixel = 0
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Instances:Create("UICorner", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })
            
            Items["Value"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 1, 1, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(0, 0, 0)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Instances:Create("UICorner", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })
            
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 5, 0, 5),
                BorderSizePixel = 0
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0"
            })
            
            Instances:Create("UICorner", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })
            
            Items["Hue"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, -8, 0, 8),
                Size = UDim2New(0, 15, 1, -16),
                BorderSizePixel = 0,
                TextSize = 14
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })
            
            Instances:Create("UICorner", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 15, 0, 15),
                BorderSizePixel = 0
            })
            
            Instances:Create("UICorner", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0"
            })            
        end

        function Colorpicker:Get()
            return Colorpicker.Color
        end

        function Colorpicker:Update()
            local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
            Colorpicker.Color = FromHSV(Hue, Saturation, Value)
            Colorpicker.HexValue = Colorpicker.Color:ToHex()

            Library.Flags[Colorpicker.Flag] = {
                Color = Colorpicker.Color,
                HexValue = Colorpicker.HexValue
            }

            Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            Items["Glow"]:Tween(nil, {ImageColor3 = Colorpicker.Color})
            Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Colorpicker.Color)
            end
        end

        local SlidingPalette = false
        local PaletteChanged
        
        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then
                return
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Saturation = ValueX
            Colorpicker.Value = ValueY

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.955)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.955)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            Colorpicker:Update()
        end
        
        local SlidingHue = false
        local HueChanged

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then
                return
            end
            
            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Hue = ValueY

            local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.91)

            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
            Colorpicker:Update()
        end

        local Debounce = false
        local RenderStepped  

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return
            end

            Colorpicker.IsOpen = Bool

            Debounce = true 

            if Colorpicker.IsOpen then 
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow"].Instance.Position = UDim2New(
                        0, 
                        Items["ColorpickerButton"].Instance.AbsolutePosition.X, 
                        0, 
                        Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 5
                    )
                end)

                for Index, Value in Library.OpenFrames do 
                        if Value ~= Colorpicker then
                            Value:SetOpen(false)
                        end
                    end

                Library.OpenFrames[Colorpicker] = Colorpicker 
            else
                if Library.OpenFrames[Colorpicker] then 
                    Library.OpenFrames[Colorpicker] = nil
                end

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if not Value.ClassName:find("UI") then 
                    Value.ZIndex = (Colorpicker.IsOpen and Data.Section.IsSettings and 9) or (Colorpicker.IsOpen and not Data.Section.IsSettings and 3) or 1
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false 
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                task.wait(0.2)
                Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Colorpicker:Set(Color)
            if type(Color) == "table" then
                Color = FromRGB(Color[1], Color[2], Color[3])
            elseif type(Color) == "string" then
                Color = FromHex(Color)
            end 

            Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()

            local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.955)
            local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.955)
                
            local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.955)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
            Colorpicker:Update()
        end

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingPalette = true 

                Colorpicker:SlidePalette(Input)

                if PaletteChanged then
                    return
                end

                PaletteChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingPalette = false

                        PaletteChanged:Disconnect()
                        PaletteChanged = nil
                    end
                end)
            end
        end)

        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingHue = true 

                Colorpicker:SlideHue(Input)

                if HueChanged then
                    return
                end

                HueChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingHue = false

                        HueChanged:Disconnect()
                        HueChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if SlidingPalette then 
                    Colorpicker:SlidePalette(Input)
                end

                if SlidingHue then
                    Colorpicker:SlideHue(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if not Colorpicker.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                    return
                end

                Colorpicker:SetOpen(false)
            end
        end)

        if Data.Default then
            Colorpicker:Set(Data.Default)
        end

        Library.SetFlags[Colorpicker.Flag] = function(Value)
            Colorpicker:Set(Value)
        end

        return Colorpicker, Items 
    end

    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            Flag = Data.Flag,

            Value = "",
            Key = "",
            Mode = "",
            
            Toggled = false,
            Picking = false,
            IsOpen = false 
        }

        local Items = { } do 
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "[C]",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 16
            }):AddToTheme({TextColor3 = 'Text'})      
            
            Items["KeybindWindow"] = Instances:Create("TextButton", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 10, 0, 10),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = 'Background'})
            
            Instances:Create("UICorner", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
            
            Instances:Create("UIListLayout", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            Instances:Create("UIPadding", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 10),
                PaddingBottom = UDimNew(0, 10),
                PaddingRight = UDimNew(0, 10),
                PaddingLeft = UDimNew(0, 10)
            })
            
            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "Hold",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
            
            Items["Always"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "Always",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
        end

        local Modes = {
            Toggle = Items["Toggle"],
            Hold = Items["Hold"],
            Always = Items["Always"]
        }

        local Debounce = false
        local RenderStepped  

        function Keybind:SetOpen(Bool)
            if Debounce then 
                return
            end

            Keybind.IsOpen = Bool

            Debounce = true 

            if Keybind.IsOpen then 
                Items["KeybindWindow"].Instance.Visible = true
                Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["KeybindWindow"].Instance.Position = UDim2New(
                        0, 
                        Items["KeyButton"].Instance.AbsolutePosition.X, 
                        0, 
                        Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 5
                    )
                end)

                for Index, Value in Library.OpenFrames do 
                    if Value ~= Keybind then
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[Keybind] = Keybind 
            else
                if Library.OpenFrames[Keybind] then 
                    Library.OpenFrames[Keybind] = nil
                end

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["KeybindWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if not Value.ClassName:find("UI") then 
                    Value.ZIndex = Keybind.IsOpen and 4 or 1
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false 
                Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                task.wait(0.2)
                Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Keybind:SetMode(Mode)
            for Index, Value in Modes do 
                if Index == Mode then
                    Value:Tween(nil, {TextTransparency = 0})
                else
                    Value:Tween(nil, {TextTransparency = 0.5})
                end
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end
        end

        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then 
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then 
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then 
                Keybind.Toggled = true
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end
        end

        function Keybind:Get()
            return Keybind.Key, Keybind.Mode, Keybind.Toggled
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = "["..TextToDisplay.."]"

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif type(Key) == "table" then
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)

                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end

                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = "["..TextToDisplay.."]"

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                Keybind.Mode = Key
                Keybind:SetMode(Key)

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            Keybind.Picking = false
        end

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            Keybind.Picking = true 

            Items["KeyButton"].Instance.Text = "..."

            local InputBegan
            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then 
                    Keybind:Set(Input.KeyCode)
                else
                    Keybind:Set(Input.UserInputType)
                end

                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Keybind.Value == "None" then
                return
            end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Keybind.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                    return
                end

                Keybind:SetOpen(false)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Keybind.Value == "None" then
                return
            end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        Items["Always"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always")
        end)

        if Data.Default then 
            Keybind:Set({
                Mode = Data.Mode or "Toggle",
                Key = Data.Default,
            })
        end

        Library.SetFlags[Keybind.Flag] = function(Value)
            Keybind:Set(Value)
        end
        
        return Keybind, Items 
    end

    do 
        Library.Watermark = function(self, Name, Logo)
            -- Single toggle button: reuse it if one already exists
            if Library.WatermarkObject then
                local Existing = Library.WatermarkObject

                if Name ~= nil then
                    Existing:SetText(Name)
                end

                if Logo and Logo ~= "" then
                    Existing:SetLogo(Logo)
                end

                return Existing
            end

            local Watermark = { 
                Name = tostring(Name or ""),
                Callback = nil
            }

            local Items = { } do 
                Items["Watermark"] = Instances:Create("TextButton", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 16, 0.55, 0),
                    Size = UDim2New(0, 46, 0, 46),
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Items["Watermark"]:MakeDraggable()
                
                Instances:Create("UICorner", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 12)
                })

                Items["Stroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(1, -14, 1, -14),
                    BorderSizePixel = 0
                })
            end

            Items["Watermark"]:OnHover(function()
                Items["Stroke"]:Tween(nil, {Color = Library.Theme["Accent"]})
            end)

            Items["Watermark"]:OnHoverLeave(function()
                Items["Stroke"]:Tween(nil, {Color = Library.Theme["Outline"]})
            end)

            -- Tap = toggle, drag = move
            local PressInput
            local PressMoved = false
            local PressStart

            Items["Watermark"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    PressInput = Input
                    PressStart = Vector2New(Input.Position.X, Input.Position.Y)
                    PressMoved = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if not PressInput then
                    return
                end

                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input == PressInput then
                    if (Vector2New(Input.Position.X, Input.Position.Y) - PressStart).Magnitude > 6 then
                        PressMoved = true
                    end
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if not PressInput then
                    return
                end

                local SameInput = Input == PressInput or (Input.UserInputType == Enum.UserInputType.MouseButton1 and PressInput.UserInputType == Enum.UserInputType.MouseButton1)

                if not SameInput then
                    return
                end

                local WasTap = not PressMoved
                PressInput = nil

                if WasTap and Watermark.Callback then
                    task.spawn(Watermark.Callback)
                end
            end)

            function Watermark:SetText(Text)
                Watermark.Name = tostring(Text)
            end

            function Watermark:SetLogo(Image)
                Items["Logo"].Instance.Image = Image
            end

            function Watermark:SetCallback(Function)
                Watermark.Callback = Function
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool 
            end

            function Watermark:SetCenter()
            end

            Watermark:SetText(Name)

            Library.WatermarkObject = Watermark

            return Watermark 
        end

        Library.Window = function(self, Data)
            Data = Data or { }

            local Window = {
                Name = Data.Name or Data.name or "Window",
                SubName = Data.SubName or Data.subname or "",
                Logo = Data.Logo or Data.logo or "rbxassetid://81441172534384",

                Pages = { },
                Items = { },
                IsOpen = false
            }

            local Items = { } do
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5220375657081604, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 673, 0, 511),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                --// UI Mode: "Mobile", "PC", or "Auto"
                -- Set UIMode in Library:Window({...})
                local RequestedUIMode = tostring(Data.UIMode or Data.uiMode or "PC")
                RequestedUIMode = string.lower(RequestedUIMode)

                local MainFrameInstance = Items["MainFrame"].Instance
                local ViewportCamera = Workspace.CurrentCamera
                local InitialViewport = ViewportCamera and ViewportCamera.ViewportSize or Vector2New(1920, 1080)

                local IsMobile = RequestedUIMode == "mobile"
                if RequestedUIMode == "auto" then
                    IsMobile = UserInputService.TouchEnabled and InitialViewport.X < 900
                elseif RequestedUIMode ~= "mobile" and RequestedUIMode ~= "pc" then
                    IsMobile = false
                    warn("[Library] Invalid UIMode '" .. RequestedUIMode .. "'. Using PC mode.")
                end

                local MainScale = InstanceNew("UIScale")
                MainScale.Name = "ResponsiveScale"
                MainScale.Scale = 1
                MainScale.Parent = MainFrameInstance

                local function UpdateResponsiveScale()
                    if not IsMobile then
                        MainScale.Scale = 1
                        return
                    end

                    local CurrentCamera = Workspace.CurrentCamera
                    if not CurrentCamera then
                        return
                    end

                    local Viewport = CurrentCamera.ViewportSize
                    local WidthScale = (Viewport.X * 0.95) / 673
                    local HeightScale = (Viewport.Y * 0.90) / 511

                    -- Mobile mode: scale the complete window to fit the screen.
                    MainScale.Scale = MathClamp(math.min(WidthScale, HeightScale), 0.35, 1)
                end

                UpdateResponsiveScale()

                if IsMobile and ViewportCamera then
                    Library:Connect(ViewportCamera:GetPropertyChangedSignal("ViewportSize"), UpdateResponsiveScale)
                end

                Items["MainFrame"]:MakeDraggable()

                -- Resizing is handled by the bottom-right grip (PC + Mobile).

                
                Instances:Create("UICorner", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                -- Background picture: same ZIndex as MainFrame so it draws above its color,
                -- created before every other child so everything else draws above it
                Items["Background"] = Instances:Create("ImageLabel", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 1, 0),
                    ScaleType = Enum.ScaleType.Crop,
                    Image = "",
                    ImageTransparency = 0.25,
                    Visible = false
                })

                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                -- Dark layer on top of the picture so text stays readable
                Items["BackgroundDim"] = Instances:Create("Frame", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 0.55
                })

                Instances:Create("UICorner", {
                    Parent = Items["BackgroundDim"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                Items["Sidebar"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 200, 1, 0),
                    BorderSizePixel = 0
                })
                
                
                --// Sidebar bottom separator (ends tab list)
local BottomSeparator = Instance.new("Frame")
BottomSeparator.Parent = Items["Sidebar"].Instance
BottomSeparator.AnchorPoint = Vector2.new(0, 1)
BottomSeparator.Position = UDim2.new(0, 0, 1, -85)
BottomSeparator.Size = UDim2.new(1, 0, 0, 1)
BottomSeparator.BackgroundColor3 = Library.Theme.Outline
BottomSeparator.BorderSizePixel = 0

--// Bottom Player Info (tab-style)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local BottomTab = Instance.new("Frame")
BottomTab.Parent = Items["Sidebar"].Instance
BottomTab.AnchorPoint = Vector2.new(0, 1)
BottomTab.Position = UDim2.new(0, 0, 1, 20)

BottomTab.Size = UDim2.new(1, 0, 0, 105)
BottomTab.BackgroundTransparency = 1

-- Avatar (BIGGER)
local Avatar = Instance.new("ImageLabel")
Avatar.Parent = BottomTab
Avatar.BackgroundTransparency = 1
Avatar.Size = UDim2.new(0, 52, 0, 52)
Avatar.Position = UDim2.new(0, 12, 0, 12)
Avatar.Image = Players:GetUserThumbnailAsync(
    LocalPlayer.UserId,
    Enum.ThumbnailType.HeadShot,
    Enum.ThumbnailSize.Size420x420
)

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = Avatar

-- Username
local Username = Instance.new("TextLabel")
Username.Parent = BottomTab
Username.BackgroundTransparency = 1
Username.Position = UDim2.new(0, 74, 0, 16)
Username.Size = UDim2.new(1, -84, 0, 18)
Username.TextXAlignment = Enum.TextXAlignment.Left
Username.Text = LocalPlayer.Name
Username.FontFace = Library.Font
Username.TextSize = 16
Username.TextColor3 = Library.Theme.Text

-- Expires label
local ExpiresLabel = Instance.new("TextLabel")
ExpiresLabel.Parent = BottomTab
ExpiresLabel.BackgroundTransparency = 1
ExpiresLabel.Position = UDim2.new(0, 74, 0, 38)
ExpiresLabel.Size = UDim2.new(0, 52, 0, 16)
ExpiresLabel.TextXAlignment = Enum.TextXAlignment.Left
ExpiresLabel.Text = "Expires:"
ExpiresLabel.FontFace = Library.Font
ExpiresLabel.TextSize = 13
ExpiresLabel.TextTransparency = 0.4
ExpiresLabel.TextColor3 = Library.Theme.Text

-- Countdown text
local Countdown = Instance.new("TextLabel")
Countdown.Parent = BottomTab
Countdown.BackgroundTransparency = 1
Countdown.Position = UDim2.new(0, 120, 0, 38)
Countdown.Size = UDim2.new(1, -140, 0, 16)
Countdown.TextXAlignment = Enum.TextXAlignment.Left
Countdown.FontFace = Library.Font
Countdown.TextSize = 13
Countdown.TextColor3 = Library.Theme.Accent

--// COUNTDOWN LOGIC
local expiresDuration = tonumber(Data.ExpiresSeconds) or (24 * 60 * 60)
local endTime = os.time() + math.max(0, math.floor(expiresDuration))

Library:Connect(RunService.Heartbeat, function()
    local remaining = math.max(0, endTime - os.time())

    local hours = math.floor(remaining / 3600)
    local minutes = math.floor((remaining % 3600) / 60)
    local seconds = remaining % 60

    Countdown.Text = string.format("%02dh %02dm %02ds", hours, minutes, seconds)
end)

                Instances:Create("Frame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 70),
                    BorderSizePixel = 0
                })
                
                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 20, 0, 20),
                    Size = UDim2New(0, 30, 0, 30),
                    BorderSizePixel = 0
                })
                
                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Window.Name,
                    Size = UDim2New(0, 0, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 60, 0, 15),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 18
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Subtitle"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.4000000059604645,
                    Text = Window.SubName,
                    Size = UDim2New(0, 0, 0, 14),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 60, 0, 36),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Pages"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://128693616966482",
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 3,
                    Size = UDim2New(1, -16, 1, -185),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 78),
                    BottomImage = "rbxassetid://128693616966482",
                    TopImage = "rbxassetid://128693616966482"
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 200, 0, 70),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -200, 1, -70),
                    BorderSizePixel = 0
                })                
                
                Window.Items = Items
            end
            
            local Debounce = false

            function Window:SetCenter()
                task.wait()

                local Frame = Items["MainFrame"].Instance
                local ParentSize = Frame.Parent.AbsoluteSize
                local FrameSize = Frame.AbsoluteSize

                if ParentSize.X <= 0 or ParentSize.Y <= 0 then
                    ParentSize = Camera.ViewportSize
                end

                local FitScale = Frame:FindFirstChild("ResponsiveScale")
                local FitFactor = FitScale and FitScale.Scale or 1
                local FitSize = Vector2New(math.min(FrameSize.X, ParentSize.X - 8), math.min(FrameSize.Y, ParentSize.Y - 8))

                if FitSize.X < FrameSize.X or FitSize.Y < FrameSize.Y then
                    Frame.Size = UDim2New(0, FitSize.X / FitFactor, 0, FitSize.Y / FitFactor)
                    FrameSize = FitSize
                end

                Frame.AnchorPoint = Vector2New(0, 0)
                Frame.Position = UDim2New(
                    0, MathFloor(MathClamp((ParentSize.X - FrameSize.X) / 2, 0, math.max(0, ParentSize.X))),
                    0, MathFloor(MathClamp((ParentSize.Y - FrameSize.Y) / 2, 0, math.max(0, ParentSize.Y)))
                )
            end

            function Window:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Window.IsOpen = Bool

                Debounce = true 

                if Window.IsOpen then 
                    Items["MainFrame"].Instance.Visible = true 
                end

                local Descendants = Items["MainFrame"].Instance:GetDescendants()
                TableInsert(Descendants, Items["MainFrame"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["MainFrame"].Instance.Visible = Window.IsOpen
                end)
            end

            --// Background image ( Data.Background = "rbxassetid://..." / id / local file / image url )
            do
                local MainFrameInstance = Items["MainFrame"].Instance

                local ImageTransparency = tonumber(Data.BackgroundTransparency or Data.backgroundTransparency) or 0.25
                local DimTransparency = tonumber(Data.BackgroundDim or Data.backgroundDim) or 0.55
                local PanelTransparency = tonumber(Data.PanelTransparency or Data.panelTransparency) or 0.45
                local ElementTransparency = tonumber(Data.ElementTransparency or Data.elementTransparency) or 0.4
                local BackgroundToken = 0

                local function ApplyLook()
                    Items["Background"].Instance.ImageTransparency = ImageTransparency
                    Items["BackgroundDim"].Instance.BackgroundTransparency = DimTransparency
                end

                function Window:RemoveBackground()
                    BackgroundToken = BackgroundToken + 1
                    Items["Background"].Instance.Image = ""
                    Items["Background"].Instance.Visible = false
                    Library:SetPanelTransparency(0)
                    Library:SetElementTransparency(0)
                end

                -- Window:SetBackground(image, imageTransparency?, dimTransparency?)
                function Window:SetBackground(Source, NewImageTransparency, NewDimTransparency)
                    if NewImageTransparency ~= nil then
                        ImageTransparency = NewImageTransparency
                    end

                    if NewDimTransparency ~= nil then
                        DimTransparency = NewDimTransparency
                    end

                    if Source == nil or Source == "" or Source == false then
                        Window:RemoveBackground()
                        return
                    end

                    BackgroundToken = BackgroundToken + 1
                    local Token = BackgroundToken

                    -- Image links download in a thread, everything else applies instantly
                    task.spawn(function()
                        local Resolved = Library:ResolveBackground(Source)

                        if Token ~= BackgroundToken or not Resolved then
                            return
                        end

                        Items["Background"].Instance.Image = Resolved
                        Items["Background"].Instance.Visible = true
                        ApplyLook()
                        Library:SetPanelTransparency(PanelTransparency)
                        Library:SetElementTransparency(ElementTransparency)
                    end)
                end

                -- How visible the picture is ( 0 = full, 1 = hidden )
                function Window:SetBackgroundTransparency(Value)
                    ImageTransparency = Value
                    ApplyLook()
                end

                -- How dark the layer over the picture is ( 0 = black, 1 = none )
                function Window:SetBackgroundDim(Value)
                    DimTransparency = Value
                    ApplyLook()
                end

                -- See-through section panels ( glass look ) while a background is set
                function Window:SetPanelTransparency(Value)
                    PanelTransparency = Value

                    if Items["Background"].Instance.Visible then
                        Library:SetPanelTransparency(Value)
                    end
                end

                -- Buttons / inputs / dropdowns cards ( 0 = solid, 1 = invisible )
                function Window:SetElementTransparency(Value)
                    ElementTransparency = Value

                    if Items["Background"].Instance.Visible then
                        Library:SetElementTransparency(Value)
                    end
                end

                local BackgroundSource = Data.Background or Data.background or Data.BackgroundImage or Data.backgroundImage

                if BackgroundSource then
                    Window:SetBackground(BackgroundSource)
                end
            end

            --// Header controls ( - X ) and bottom-right resize grip
            do
                local MainFrameInstance = Items["MainFrame"].Instance
                local MainScale = MainFrameInstance:FindFirstChild("ResponsiveScale")
                local MinSize = typeof(Data.MinSize) == "Vector2" and Data.MinSize or Vector2New(460, 340)

                Items["Header"] = Instances:Create("Frame", {
                    Parent = MainFrameInstance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2New(0, 200, 0, 0),
                    Size = UDim2New(1, -200, 0, 70)
                })

                Instances:Create("Frame", {
                    Parent = Items["Header"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["Controls"] = Instances:Create("Frame", {
                    Parent = Items["Header"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, -16, 0.5, 0),
                    Size = UDim2New(0, 72, 0, 32)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Controls"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                local MakeControl = function(Order, HoverColor)
                    local Button = Instances:Create("TextButton", {
                        Parent = Items["Controls"].Instance,
                        Name = "\0",
                        LayoutOrder = Order,
                        Text = "",
                        AutoButtonColor = false,
                        BorderSizePixel = 0,
                        Size = UDim2New(0, 32, 0, 32),
                        BackgroundColor3 = Library.Theme["Element"]
                    }):AddToTheme({BackgroundColor3 = 'Element'})

                    Instances:Create("UICorner", {
                        Parent = Button.Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 8)
                    })

                    Instances:Create("UIStroke", {
                        Parent = Button.Instance,
                        Name = "\0",
                        Color = Library.Theme["Outline"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }):AddToTheme({Color = 'Outline'})

                    Button:OnHover(function()
                        Button:Tween(nil, {BackgroundColor3 = HoverColor})
                    end)

                    Button:OnHoverLeave(function()
                        Button:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                    end)

                    return Button
                end

                local MakeLine = function(Parent, Width, Rotation)
                    local Line = Instances:Create("Frame", {
                        Parent = Parent,
                        Name = "\0",
                        AnchorPoint = Vector2New(0.5, 0.5),
                        Position = UDim2New(0.5, 0, 0.5, 0),
                        Size = UDim2New(0, Width, 0, 2),
                        Rotation = Rotation,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Text"]
                    }):AddToTheme({BackgroundColor3 = 'Text'})

                    Instances:Create("UICorner", {
                        Parent = Line.Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(1, 0)
                    })

                    return Line
                end

                -- ( - ) hide the UI, reopen with the logo button
                Items["Minimize"] = MakeControl(1, FromRGB(45, 52, 56))
                MakeLine(Items["Minimize"].Instance, 12, 0)

                Items["Minimize"]:Connect("MouseButton1Click", function()
                    Window:SetOpen(false)
                end)

                -- ( X ) destroy the whole UI
                Items["Close"] = MakeControl(2, FromRGB(214, 69, 69))
                MakeLine(Items["Close"].Instance, 14, 45)
                MakeLine(Items["Close"].Instance, 14, -45)

                Items["Close"]:Connect("MouseButton1Click", function()
                    Library:Unload()
                end)

                Library:RegisterElement(Items["Controls"].Instance)

                -- Bottom-right resize grip
                Items["Resize"] = Instances:Create("TextButton", {
                    Parent = MainFrameInstance,
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2New(1, 1),
                    Position = UDim2New(1, -2, 1, -2),
                    Size = UDim2New(0, 30, 0, 30),
                    ZIndex = 10
                })

                for Row = 0, 2 do
                    for Column = 0, 2 - Row do
                        Instances:Create("Frame", {
                            Parent = Items["Resize"].Instance,
                            Name = "\0",
                            AnchorPoint = Vector2New(1, 1),
                            Position = UDim2New(1, -(6 + Column * 6), 1, -(6 + Row * 6)),
                            Size = UDim2New(0, 3, 0, 3),
                            BorderSizePixel = 0,
                            BackgroundTransparency = 0.45,
                            BackgroundColor3 = Library.Theme["Text"],
                            ZIndex = 11
                        }):AddToTheme({BackgroundColor3 = 'Text'})
                    end
                end

                local ResizeInput
                local ResizeStart
                local ResizeStartSize

                Items["Resize"]:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        ResizeInput = Input
                        ResizeStart = Vector2New(Input.Position.X, Input.Position.Y)
                        ResizeStartSize = Vector2New(MainFrameInstance.Size.X.Offset, MainFrameInstance.Size.Y.Offset)
                    end
                end)

                Library:Connect(UserInputService.InputChanged, function(Input)
                    if not ResizeInput then
                        return
                    end

                    if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input ~= ResizeInput then
                        return
                    end

                    local Scale = MainScale and MainScale.Scale or 1
                    local ParentSize = MainFrameInstance.Parent.AbsoluteSize
                    local Position = MainFrameInstance.Position

                    local Delta = (Vector2New(Input.Position.X, Input.Position.Y) - ResizeStart) / Scale

                    -- Never grow past the screen edge so the grip stays reachable
                    local MinWidth = math.min(MinSize.X, ResizeStartSize.X)
                    local MinHeight = math.min(MinSize.Y, ResizeStartSize.Y)

                    local MaxWidth = math.max(MinWidth, (ParentSize.X - (Position.X.Scale * ParentSize.X + Position.X.Offset)) / Scale)
                    local MaxHeight = math.max(MinHeight, (ParentSize.Y - (Position.Y.Scale * ParentSize.Y + Position.Y.Offset)) / Scale)

                    local Width = MathClamp(ResizeStartSize.X + Delta.X, MinWidth, MaxWidth)
                    local Height = MathClamp(ResizeStartSize.Y + Delta.Y, MinHeight, MaxHeight)

                    MainFrameInstance.Size = UDim2New(0, Width, 0, Height)
                end)

                Library:Connect(UserInputService.InputEnded, function(Input)
                    if not ResizeInput then
                        return
                    end

                    if Input == ResizeInput or (Input.UserInputType == Enum.UserInputType.MouseButton1 and ResizeInput.UserInputType == Enum.UserInputType.MouseButton1) then
                        ResizeInput = nil
                    end
                end)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:SetCenter()
            task.wait()
            Window:SetOpen(true)
            return setmetatable(Window, Library)
        end

        Library.Page = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self,

                Name = Data.Name or Data.name or "Page",
                Icon = Data.Icon or Data.icon or "rbxassetid://72196061405823",

                Items = { },
                Active = false
            }

            local Items = { } do 
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["Pages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextSize = 14,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 0.4000000059604645,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    Size = UDim2New(0, 18, 0, 18),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.4000000059604645,
                    Text = Page.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 38, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })                

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["Column"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    ScrollBarImageColor3 = FromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Column"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 10),
                    PaddingBottom = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 10),
                    PaddingLeft = UDimNew(0, 10)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Column"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })           
                
                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end

                Page.Active = Bool 
                
                Debounce = true
                Items["Page"].Instance.Visible = Bool 
                Items["Page"].Instance.Parent = Bool and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance

                if Page.Active then
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(1, 0, 0, 35)})

                    Items["Text"]:ChangeItemTheme({TextColor3 = function() return FromRGB(0, 0, 0) end})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = function() return FromRGB(0, 0, 0) end})

                    Items["Text"]:Tween(nil, {TextColor3 = FromRGB(0, 0, 0), TextTransparency = 0})
                    Items["Icon"]:Tween(nil, {ImageColor3 = FromRGB(0, 0, 0), ImageTransparency = 0})
                else
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 35)})

                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})

                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.4})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Text, ImageTransparency = 0.4})
                end

                local AllInstances = Items["Page"].Instance:GetDescendants()
                TableInsert(AllInstances, Items["Page"].Instance)
                
                local NewTween 

                for Index, Value in AllInstances do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then 
                        continue
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                end)
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",
                Side = Data.Side or Data.side or 1,
                Icon = Data.Icon or Data.icon or "rbxassetid://127136375066593",

                Items = { }
            }

            local Items = { } do
                Items["SectionOutline"] = Instances:Create("Frame", {
                    Parent = Section.Page.Items["Column"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 50),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Instances:Create("UICorner", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0"
                })
                
                Items["Section"] = Instances:Create("Frame", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Instances:Create("UICorner", {
                    Parent = Items["Section"].Instance,
                    Name = "\0"
                })
                
                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 40),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    Size = UDim2New(0, 0, 0, 14),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 40, 0.5, -2),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = Section.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0.5, 0),
                    Size = UDim2New(0, 18, 0, 18),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
                
                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 40),
                    Size = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 6),
                    PaddingBottom = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 10),
                    PaddingLeft = UDimNew(0, 10)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
                
                Section.Items = Items
            end

            return setmetatable(Section, Library.Sections)
        end

        Library.Sections.Toggle = function(self, Data)
            Data = Data or { }

            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,

                Value = false
            }

            local Items = { } do 
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Toggle.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = Toggle.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 35, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Instances:Create("UICorner", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0"
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Circle"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    BackgroundTransparency = 0.5,
                    Position = UDim2New(0, 4, 0.5, 0),
                    Size = UDim2New(0, 10, 0, 10),
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})
                
                Instances:Create("UICorner", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})                
            end

            function Toggle:Get()
                return Toggle.Value 
            end

            function Toggle:Set(Value)
                Toggle.Value = Value 
                Library.Flags[Toggle.Flag] = Value 

                if Toggle.Value then 
                    Items["Glow"]:Tween(nil, {ImageTransparency = 0.7})
                    
                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Circle"]:Tween(nil, {
                        AnchorPoint = Vector2New(1, 0.5),
                        Position = UDim2New(1, -3, 0.5, 0),
                        BackgroundTransparency = 0,
                        BackgroundColor3 = Library.Theme.Accent
                    })

                    Items["Text"]:Tween(nil, {TextTransparency = 0})
                else
                    Items["Glow"]:Tween(nil, {ImageTransparency = 1})
                    
                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})
                    Items["Circle"]:Tween(nil, {
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 3, 0.5, 0),
                        BackgroundTransparency = 0.6,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Items["Text"]:Tween(nil, {TextTransparency = 0.5})
                end

                if Toggle.Callback then 
                    Library:SafeCall(Toggle.Callback, Toggle.Value)
                end
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle 
        end

        Library.Sections.Button = function(self, Data)
            Data = Data or { }

            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end
            }

            local Items = { } do 
                Items["Button"] = Instances:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 0, 30),
                    Selectable = false,
                    Active = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Instances:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Stroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://117716971575946",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -6, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})                
            end 

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:Press()
                Items["Stroke"]:ChangeItemTheme({Color = "Accent"})
                Items["Stroke"]:Tween(nil, {Color = Library.Theme.Accent})
                task.wait(0.1)
                Library:SafeCall(Button.Callback)
                Items["Stroke"]:ChangeItemTheme({Color = "Outline"})
                Items["Stroke"]:Tween(nil, {Color = Library.Theme.Outline})
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            Data = Data or { }

            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Min = Data.Min or Data.min or 0,
                Default = Data.Default or Data.default or 0,
                Max = Data.Max or Data.max or 100,
                Suffix = Data.Suffix or Data.suffix or "",
                Decimals = Data.Decimals or Data.decimals or 1,
                Callback = Data.Callback or Data.callback or function() end,

                Value = 0,
                Sliding = false
            }

            local Items = { } do 
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    Active = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, -40, 0.5, 0),
                    Size = UDim2New(0, 200, 0, 9),
                    Selectable = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Instances:Create("UICorner", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0.6000000238418579, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Dragger"] = Instances:Create("Frame", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(1, -4, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 13, 0, 13),
                    BorderSizePixel = 0
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Glow2"] = Instances:Create("ImageLabel", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = "50%",
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(1, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})                
            end

            function Slider:Get()
                return Slider.Value 
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
                Library.Flags[Slider.Flag] = Slider.Value

                Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})
                Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)

                if Slider.Callback then 
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            local InputChanged 
            
            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                        Slider:Set(Value)
                    end
                end
            end)

            if Slider.Default then
                Slider:Set(Slider.Default)
            end

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider 
        end

        Library.Sections.Dropdown = function(self, Data)
            Data = Data or { }

            local Dropdown = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Dropdown",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Items = Data.Items or Data.items or { "One", "Two", "Three" },
                Default = Data.Default or Data.default or nil,
                Callback = Data.Callback or Data.callback or function() end,
                Multi = Data.Multi or Data.multi or false,

                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do 
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 30),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 1),
                    Position = UDim2New(1, 0, 1, 0),
                    Size = UDim2New(0, 200, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Instances:Create("UICorner", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = "--",
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://72690112230014",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -8, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
                
                Instances:Create("Frame", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -32, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})       
                
                Items["OptionHolder"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 200, 0, 0),
                    Position = UDim2New(0, 54, 0, 236),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextSize = 14,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Instances:Create("UICorner", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0"
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 10),
                    PaddingBottom = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 10),
                    PaddingLeft = UDimNew(0, 10)
                })
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local Debounce = false 
            local RenderStepped 

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true 

                if Dropdown.IsOpen then 
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["OptionHolder"].Instance.Position = UDim2New(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y - 25)
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, 0)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Dropdown and not Dropdown.Section.IsSettings then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["OptionHolder"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if not Value.ClassName:find("UI") then 
                        Value.ZIndex = Dropdown.IsOpen and 3 or 1
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                    task.wait(0.2)
                    Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Dropdown:Set(Option)
                if Dropdown.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end

                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Dropdown.Callback then   
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14
                })
                
                local OptionLiner = Instances:Create("Frame", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 3, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                local OptionGlow = Instances:Create("ImageLabel", {
                    Parent = OptionLiner.Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Instances:Create("UICorner", {
                    Parent = OptionLiner.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                local OptionText = Instances:Create("TextLabel", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = Option,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Liner = OptionLiner,
                    Glow = OptionGlow,
                    Text = OptionText,
                    Selected = false
                }
                
                function OptionData:Toggle(Value)
                    if Value == "Active" then
                        OptionData.Liner:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 3, 1, 0)})
                        OptionData.Glow:Tween(nil, {ImageTransparency = 0.7})
                        OptionData.Text:Tween(nil, {Position = UDim2New(0, 12, 0.5 ,0), TextTransparency = 0})
                    else
                        OptionData.Liner:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 3, 0, 0)})
                        OptionData.Glow:Tween(nil, {ImageTransparency = 1})
                        OptionData.Text:Tween(nil, {Position = UDim2New(0, 0, 0.5 ,0), TextTransparency = 0.5})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Dropdown.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button:Clean()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.IsOpen then
                        if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                            return
                        end

                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Dropdown.IsOpen then
                    Dropdown.IsOpen = not Library:IsClipped(Items["OptionHolder"].Instance, Dropdown.Section.Items["Section"].Instance.Parent)
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                end
            end)

            for Index, Value in Dropdown.Items do 
                Dropdown:Add(Value)
            end

            if Dropdown.Default then 
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown
        end

        Library.Sections.Label = function(self, Name)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Name or "Label"
            }

            local Items = { } do 
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            end

            function Label:SetText(Text)
                Text = tostring(Text)
                Items["Text"].Instance.Text = Text
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            return Label
        end

        Library.Sections.Textbox = function(self, Data)
            Data = Data or { }

            local Textbox = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Textbox",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
                Numeric = Data.Numeric or Data.numeric or false,
                Finished = Data.Finished or Data.finished or false,

                Value = ""
            }

            local Items = { } do 
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 30),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Textbox.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Size = UDim2New(0.5, 0, 0, 30),
                    Position = UDim2New(1, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                -- Fixed box size so the whole field is tappable (touch + mouse)
                Instances:Create("UISizeConstraint", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    MinSize = Vector2New(110, 0),
                    MaxSize = Vector2New(280, 30)
                })
                
                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Active = true,
                    Selectable = true,
                    ClearTextOnFocus = false,
                    MultiLine = false,
                    TextEditable = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextTransparency = 0,
                    PlaceholderColor3 = FromRGB(133, 139, 143),
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 16,
                    Size = UDim2New(1, 0, 1, 0),
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0
                }):AddToTheme({TextColor3 = 'Text'})

                Instances:Create("UIPadding", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
            end
            
            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end

            if Textbox.Finished then 
                -- Commit on any focus loss (mobile keyboards often close without Enter)
                Items["Input"]:Connect("FocusLost", function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            else
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Textbox.Default then
                Textbox:Set(Textbox.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox
        end

        -- Grid of image buttons ( image + caption ), separate from Button
        -- Section:ImageGrid({ Name, Search, Items = { { Name, Image, Badge, Callback } }, Callback })
        Library.Sections.ImageGrid = function(self, Data)
            Data = Data or { }

            local TileSizeData = Data.TileSize or Data.tilesize

            local Grid = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name,
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Callback = Data.Callback or Data.callback,
                Search = Data.Search or Data.search or false,
                Placeholder = Data.Placeholder or Data.placeholder or "Search...",
                Selectable = Data.Selectable or Data.selectable or false,
                TileSize = typeof(TileSizeData) == "Vector2" and TileSizeData or Vector2New(86, 86),
                Columns = Data.Columns or Data.columns,
                Padding = Data.Padding or Data.padding or 6,

                Tiles = { },
                Value = nil,
                FilterText = "",
                LoadToken = 0
            }

            local Items = { } do
                Items["Grid"] = Instances:Create("Frame", {
                    Parent = Grid.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Grid"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Grid"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    Text = tostring(Grid.Name or ""),
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    Visible = Grid.Name ~= nil,
                    Size = UDim2New(1, 0, 0, 18)
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Status"] = Instances:Create("TextLabel", {
                    Parent = Items["Grid"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = "",
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    LayoutOrder = 2,
                    Visible = false,
                    Size = UDim2New(1, 0, 0, 16)
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Search"] = Instances:Create("Frame", {
                    Parent = Items["Grid"].Instance,
                    Name = "\0",
                    BorderSizePixel = 0,
                    LayoutOrder = 3,
                    Visible = Grid.Search and true or false,
                    ClipsDescendants = true,
                    Size = UDim2New(1, 0, 0, 30),
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Instances:Create("UICorner", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["SearchInput"] = Instances:Create("TextBox", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Active = true,
                    Selectable = true,
                    ClearTextOnFocus = false,
                    MultiLine = false,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    PlaceholderColor3 = FromRGB(133, 139, 143),
                    PlaceholderText = Grid.Placeholder,
                    TextSize = 14,
                    Size = UDim2New(1, 0, 1, 0),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0
                }):AddToTheme({TextColor3 = 'Text'})

                Instances:Create("UIPadding", {
                    Parent = Items["SearchInput"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["List"] = Instances:Create("Frame", {
                    Parent = Items["Grid"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    LayoutOrder = 4,
                    Size = UDim2New(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                local CellSize = UDim2New(0, Grid.TileSize.X, 0, Grid.TileSize.Y)

                if Grid.Columns then
                    local Columns = math.max(1, math.floor(Grid.Columns))
                    CellSize = UDim2New(1 / Columns, -(Grid.Padding * (Columns - 1)) / Columns, 0, Grid.TileSize.Y)
                end

                Instances:Create("UIGridLayout", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    CellSize = CellSize,
                    CellPadding = UDim2New(0, Grid.Padding, 0, Grid.Padding),
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            local function MatchesFilter(Item)
                if Grid.FilterText == "" then
                    return true
                end

                return string.find(string.lower(Item.Name), Grid.FilterText, 1, true) ~= nil
            end

            local function SetTileActive(Item, Active)
                Item.Items["Stroke"]:Tween(nil, {Color = Active and Library.Theme["Accent"] or Library.Theme["Outline"]})
            end

            local function CreateTile(ItemData)
                local Item = {
                    Grid = Grid,
                    Name = tostring(ItemData.Name or ItemData.name or ItemData.Text or ItemData.text or "Item"),
                    Image = ItemData.Image or ItemData.image or ItemData.Icon or ItemData.icon,
                    Badge = ItemData.Badge or ItemData.badge,
                    BadgeColor = ItemData.BadgeColor or ItemData.badgecolor,
                    Rainbow = ItemData.Rainbow or ItemData.rainbow or false,
                    Value = ItemData.Value,
                    Callback = ItemData.Callback or ItemData.callback,
                    Selected = false,
                    Items = { }
                }

                local TileItems = Item.Items

                TileItems["Tile"] = Instances:Create("TextButton", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    LayoutOrder = #Grid.Tiles + 1,
                    BackgroundColor3 = Library.Theme["Element"]
                })

                Instances:Create("UICorner", {
                    Parent = TileItems["Tile"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })

                TileItems["Stroke"] = Instances:Create("UIStroke", {
                    Parent = TileItems["Tile"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                TileItems["Image"] = Instances:Create("ImageLabel", {
                    Parent = TileItems["Tile"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2New(0.5, 0),
                    Position = UDim2New(0.5, 0, 0, 6),
                    Size = UDim2New(1, -16, 1, -34),
                    Image = ""
                })

                TileItems["Label"] = Instances:Create("TextLabel", {
                    Parent = TileItems["Tile"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.1,
                    Text = Item.Name,
                    TextSize = 11,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2New(0.5, 1),
                    Position = UDim2New(0.5, 0, 1, -5),
                    Size = UDim2New(1, -8, 0, 16)
                })

                function Item:SetText(Text)
                    Item.Name = tostring(Text)
                    TileItems["Label"].Instance.Text = Item.Name
                    TileItems["Tile"].Instance.Visible = MatchesFilter(Item)
                end

                function Item:SetImage(Image)
                    Item.Image = Image
                    TileItems["Image"].Instance.Image = Library:ResolveIcon(Image) or ""
                end

                function Item:SetBadge(Badge, Color)
                    Item.Badge = Badge

                    if Color then
                        Item.BadgeColor = Color
                    end

                    if Badge == nil or tostring(Badge) == "" then
                        if TileItems["Badge"] then
                            TileItems["Badge"].Instance.Visible = false
                        end

                        return
                    end

                    if not TileItems["Badge"] then
                        TileItems["Badge"] = Instances:Create("TextLabel", {
                            Parent = TileItems["Tile"].Instance,
                            Name = "\0",
                            FontFace = Library.Font,
                            TextSize = 9,
                            TextColor3 = FromRGB(15, 15, 15),
                            AnchorPoint = Vector2New(0, 1),
                            Position = UDim2New(0, 6, 1, -22),
                            Size = UDim2New(0, 0, 0, 12),
                            AutomaticSize = Enum.AutomaticSize.X,
                            BorderSizePixel = 0,
                            ZIndex = 2
                        })

                        Instances:Create("UICorner", {
                            Parent = TileItems["Badge"].Instance,
                            Name = "\0",
                            CornerRadius = UDimNew(0, 3)
                        })

                        Instances:Create("UIPadding", {
                            Parent = TileItems["Badge"].Instance,
                            Name = "\0",
                            PaddingLeft = UDimNew(0, 4),
                            PaddingRight = UDimNew(0, 4)
                        })

                        if Item.Rainbow then
                            Instances:Create("UIGradient", {
                                Parent = TileItems["Badge"].Instance,
                                Name = "\0",
                                Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, FromRGB(255, 90, 90)),
                                    ColorSequenceKeypoint.new(0.25, FromRGB(255, 220, 90)),
                                    ColorSequenceKeypoint.new(0.5, FromRGB(90, 255, 140)),
                                    ColorSequenceKeypoint.new(0.75, FromRGB(90, 170, 255)),
                                    ColorSequenceKeypoint.new(1, FromRGB(200, 100, 255))
                                })
                            })
                        end
                    end

                    TileItems["Badge"].Instance.Text = tostring(Badge)
                    TileItems["Badge"].Instance.BackgroundColor3 = Item.BadgeColor or Library.Theme["Accent"]
                    TileItems["Badge"].Instance.Visible = true
                end

                function Item:Press()
                    if Grid.Selectable then
                        Grid:Select(Item)
                    end

                    local Callback = Item.Callback or Grid.Callback

                    if Callback then
                        Library:SafeCall(Callback, Item.Value ~= nil and Item.Value or Item.Name, Item)
                    end
                end

                function Item:Destroy()
                    local Index = table.find(Grid.Tiles, Item)

                    if Index then
                        table.remove(Grid.Tiles, Index)
                    end

                    if Grid.Selected == Item then
                        Grid.Selected = nil
                        Grid.Value = nil
                    end

                    TileItems["Tile"]:Clean()
                end

                -- Raw connections: tiles can be many and are destroyed with the instance
                TileItems["Tile"].Instance.MouseButton1Click:Connect(function()
                    Item:Press()
                end)

                TileItems["Tile"].Instance.MouseEnter:Connect(function()
                    if not Item.Selected then
                        SetTileActive(Item, true)
                    end
                end)

                TileItems["Tile"].Instance.MouseLeave:Connect(function()
                    if not Item.Selected then
                        SetTileActive(Item, false)
                    end
                end)

                Library:RegisterElement(TileItems["Tile"].Instance)

                Item:SetImage(Item.Image)
                Item:SetBadge(Item.Badge)
                TileItems["Tile"].Instance.Visible = MatchesFilter(Item)

                table.insert(Grid.Tiles, Item)

                return Item
            end

            function Grid:Add(ItemData)
                if type(ItemData) == "string" then
                    ItemData = { Name = ItemData }
                end

                return CreateTile(ItemData or { })
            end

            function Grid:Remove(Name)
                for Index = #Grid.Tiles, 1, -1 do
                    local Item = Grid.Tiles[Index]

                    if Item.Name == Name or Item.Value == Name then
                        Item:Destroy()
                    end
                end
            end

            function Grid:Clear()
                Grid.LoadToken = Grid.LoadToken + 1

                for Index = #Grid.Tiles, 1, -1 do
                    Grid.Tiles[Index].Items["Tile"]:Clean()
                end

                table.clear(Grid.Tiles)
                Grid.Selected = nil
                Grid.Value = nil
            end

            -- Builds in small batches so big lists ( hundreds of tiles ) do not freeze the game
            function Grid:SetItems(List, BatchSize)
                Grid:Clear()

                local Token = Grid.LoadToken
                BatchSize = BatchSize or 20

                task.spawn(function()
                    for Index, ItemData in List do
                        if Grid.LoadToken ~= Token then
                            return
                        end

                        Grid:Add(ItemData)

                        if Index % BatchSize == 0 then
                            task.wait()
                        end
                    end
                end)
            end

            function Grid:Filter(Text)
                Grid.FilterText = string.lower(tostring(Text or ""))

                for _, Item in Grid.Tiles do
                    Item.Items["Tile"].Instance.Visible = MatchesFilter(Item)
                end
            end

            function Grid:SetStatus(Text)
                Text = Text and tostring(Text) or ""
                Items["Status"].Instance.Text = Text
                Items["Status"].Instance.Visible = Text ~= ""
            end

            function Grid:Select(Item)
                if Grid.Selected and Grid.Selected ~= Item then
                    Grid.Selected.Selected = false
                    SetTileActive(Grid.Selected, false)
                end

                Grid.Selected = Item
                Item.Selected = true
                SetTileActive(Item, true)

                Grid.Value = Item.Value ~= nil and Item.Value or Item.Name
                Library.Flags[Grid.Flag] = Grid.Value
            end

            function Grid:Get()
                return Grid.Value
            end

            function Grid:Set(Value)
                for _, Item in Grid.Tiles do
                    if Item.Name == Value or Item.Value == Value then
                        Item:Press()
                        return
                    end
                end
            end

            function Grid:SetVisibility(Bool)
                Items["Grid"].Instance.Visible = Bool
            end

            Library:Connect(Items["SearchInput"].Instance:GetPropertyChangedSignal("Text"), function()
                Grid:Filter(Items["SearchInput"].Instance.Text)
            end)

            if Grid.Selectable then
                Library.SetFlags[Grid.Flag] = function(Value)
                    Grid:Set(Value)
                end
            end

            local StartItems = Data.Items or Data.items

            if type(StartItems) == "table" then
                Grid:SetItems(StartItems)
            end

            return Grid
        end

        -- Optional element description: Data.Description / Data.Desc ( skipped when empty )
        do
            local function ReadDescription(Data)
                if type(Data) ~= "table" then
                    return nil
                end

                local Text = Data.Description or Data.description or Data.Desc or Data.desc

                if type(Text) == "string" and Text ~= "" then
                    return Text
                end

                return nil
            end

            local function AttachDescription(Element, Section, Text)
                if type(Element) ~= "table" then
                    return
                end

                local Items = { }
                local Visible = true

                -- Holder is created right after the element so it sits directly under it
                Items["Description"] = Instances:Create("Frame", {
                    Parent = Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Visible = false,
                    Size = UDim2New(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                local function Refresh()
                    Items["Description"].Instance.Visible = Visible and Items["Text"] ~= nil and Items["Text"].Instance.Text ~= ""
                end

                function Element:SetDescription(NewText)
                    NewText = NewText and tostring(NewText) or ""
                    Element.Description = NewText

                    if NewText ~= "" and not Items["Text"] then
                        Items["Text"] = Instances:Create("TextLabel", {
                            Parent = Items["Description"].Instance,
                            Name = "\0",
                            FontFace = Library.Font,
                            TextColor3 = Library.Theme["Text"],
                            TextTransparency = 0.55,
                            Text = NewText,
                            TextSize = 13,
                            TextWrapped = true,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextYAlignment = Enum.TextYAlignment.Top,
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Position = UDim2New(0, 0, 0, -4),
                            Size = UDim2New(1, 0, 0, 0),
                            AutomaticSize = Enum.AutomaticSize.Y
                        }):AddToTheme({TextColor3 = 'Text'})
                    elseif Items["Text"] then
                        Items["Text"].Instance.Text = NewText
                    end

                    Refresh()
                end

                local OriginalSetVisibility = Element.SetVisibility

                if OriginalSetVisibility then
                    function Element:SetVisibility(Bool)
                        Visible = Bool
                        OriginalSetVisibility(Element, Bool)
                        Refresh()
                    end
                end

                if Text then
                    Element:SetDescription(Text)
                end
            end

            for _, MethodName in { "Toggle", "Button", "Slider", "Dropdown", "Textbox", "ImageGrid" } do
                local Original = Library.Sections[MethodName]

                local CanSkin = MethodName ~= "Toggle"

                Library.Sections[MethodName] = function(self, Data, ...)
                    local Content = self.Items["Content"].Instance
                    local Before = #Content:GetChildren()

                    local Element = Original(self, Data, ...)

                    if CanSkin then
                        local Children = Content:GetChildren()

                        for Index = Before + 1, #Children do
                            Library:RegisterElement(Children[Index])
                        end
                    end

                    AttachDescription(Element, self, ReadDescription(Data))
                    return Element
                end
            end

            -- Label takes ( Name, Description ) or a data table
            local OriginalLabel = Library.Sections.Label

            Library.Sections.Label = function(self, Name, Description)
                if type(Name) == "table" then
                    Description = ReadDescription(Name)
                    Name = Name.Name or Name.name or Name.Text or Name.text
                end

                if type(Description) ~= "string" or Description == "" then
                    Description = nil
                end

                local Label = OriginalLabel(self, Name)
                AttachDescription(Label, self, Description)
                return Label
            end
        end

        -- Library:Notify({ Title, Content, Type = "Info|Success|Warning|Error", Duration })
        Library.Notify = function(self, Data)
            if type(Data) == "string" then
                Data = { Content = Data }
            end

            Data = Data or { }

            local Title = tostring(Data.Title or Data.title or Data.Name or Data.name or "Notification")
            local Content = tostring(Data.Content or Data.content or Data.Description or Data.Text or Data.text or "")
            local Duration = tonumber(Data.Duration or Data.duration) or 4
            local NotifType = tostring(Data.Type or Data.type or "Info")

            local TypeColors = {
                Info = FromRGB(110, 170, 255),
                Success = FromRGB(80, 220, 120),
                Warning = FromRGB(255, 200, 70),
                Error = FromRGB(255, 85, 85)
            }

            local Color = TypeColors[NotifType] or Library.Theme["Accent"]

            if not Library.NotifHolder then
                Library.NotifHolder = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -12, 0, 12),
                    Size = UDim2New(0, 260, 1, -24)
                })

                Instances:Create("UIListLayout", {
                    Parent = Library.NotifHolder.Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            local Items = { }

            Items["Notification"] = Instances:Create("Frame", {
                Parent = Library.NotifHolder.Instance,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Library.Theme["Background"]
            })

            Instances:Create("UICorner", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 8)
            })

            Items["Stroke"] = Instances:Create("UIStroke", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Color = Color,
                Transparency = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })

            Instances:Create("UIPadding", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 10),
                PaddingBottom = UDimNew(0, 10),
                PaddingLeft = UDimNew(0, 12),
                PaddingRight = UDimNew(0, 12)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Color,
                TextTransparency = 1,
                Text = Title,
                TextSize = 16,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 1,
                Size = UDim2New(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })

            local HasContent = Content ~= ""

            if HasContent then
                Items["Content"] = Instances:Create("TextLabel", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 1,
                    Text = Content,
                    TextSize = 14,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    LayoutOrder = 2,
                    Size = UDim2New(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text'})
            end

            local function Fade(Show)
                Items["Notification"]:Tween(nil, {BackgroundTransparency = Show and 0.05 or 1})
                Items["Stroke"]:Tween(nil, {Transparency = Show and 0 or 1})
                Items["Title"]:Tween(nil, {TextTransparency = Show and 0 or 1})

                if HasContent then
                    Items["Content"]:Tween(nil, {TextTransparency = Show and 0.25 or 1})
                end
            end

            Fade(true)

            task.delay(Duration, function()
                if not Items["Notification"].Instance.Parent then
                    return
                end

                Fade(false)
                task.wait(0.5)
                Items["Notification"].Instance:Destroy()
            end)
        end
    end

    Library.CreateSettingsPage = function(self, Window, Watermark)
        local SettingsPage = Window:Page({Name = "Settings", Icon = "rbxassetid://128742673777519"})

        do
            local ThemingSection = SettingsPage:Section({Name = "Theming", Icon = "rbxassetid://73803440257131"})

            do
                for Index, Value in Library.Theme do 
                    ThemingSection:Label(Index):Colorpicker({
                        Flag = Index.."_ThemingThing",
                        Default = Value,
                        Alpha = 0,
                        Callback = function(Value)
                            Library.Theme[Index] = Value
                            Library:ChangeTheme(Index, Value)
                        end
                    })
                end
            end

            local ConfigsSection = SettingsPage:Section({Name = "Configs", Icon = "rbxassetid://74885853379841"}) do 
                local ConfigName
                local ConfigSelected
    
                local ConfigsDropdown = ConfigsSection:Dropdown({
                    Name = "Configs", 
                    Flag = "Configs",
                    Items = { }, 
                    Multi = false,
                    MaxSize = 120,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })
    
                ConfigsSection:Textbox({
                    Name = "Config name",
                    Placeholder = "Config name",
                    Flag = "ConfigName",
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })
    
                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                        if ConfigName and ConfigName ~= "" then
                            if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                                writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                                Library:RefreshConfigsList(ConfigsDropdown)
                            end
                        end
                    end
                })
    
                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected..".json"))
                        end
                    end
                })
    
                ConfigsSection:Button({
                    Name = "Save",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            writefile(Library.Folders.Configs .. "/" .. ConfigSelected..".json", Library:GetConfig())
                        end
                    end
                })
    
                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            delfile(Library.Folders.Configs .. "/" .. ConfigSelected..".json")
                            Library:RefreshConfigsList(ConfigsDropdown)
                        end
                    end
                })
    
                ConfigsSection:Button({
                    Name = "Refresh",
                    Callback = function()
                        Library:RefreshConfigsList(ConfigsDropdown)
                    end
                })
    
                Library:RefreshConfigsList(ConfigsDropdown)
            end
        end

        return SettingsPage
    end
end



-- loadstring-friendly wrappers / aliases
Library.LucideIconsUrl = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"
Library.IconPacks = Library.IconPacks or {}
Library.ActiveIconPack = "lucide"

-- Short names -> built-in icon names (add yours with Library:AddIconAlias)
Library.IconAliases = {
    ["aim"] = "crosshair",
    ["audio"] = "audio-lines",
    ["sound"] = "volume-2",
    ["general"] = "house",
    ["tp"] = "map-pin",
    ["localplayer"] = "user",
    ["local"] = "user",
    ["aimbot"] = "crosshair",
    ["esp"] = "eye",
    ["visual"] = "eye",
    ["visuals"] = "eye",
    ["player"] = "user",
    ["players"] = "users",
    ["combat"] = "swords",
    ["movement"] = "footprints",
    ["teleport"] = "map-pin",
    ["world"] = "globe",
    ["misc"] = "layers",
    ["config"] = "settings",
    ["script"] = "scroll-text",
    ["scripts"] = "scroll-text",
    ["farm"] = "wheat",
    ["autofarm"] = "wheat",
    ["main"] = "house",
    ["speed"] = "zap",
    ["rage"] = "flame",
    ["legit"] = "shield",
    ["exploit"] = "bug",
    ["ui"] = "layout-dashboard",
    ["color"] = "palette",
    ["colors"] = "palette"
}

-- Built-in icon pack ( name:assetid )
local BuiltinIconData = [==[
a-arrow-down:92867583610071 a-arrow-up:132318504999733 a-large-small:111491496660216 accessibility:114029945302017 activity:94212016861936
air-vent:81517226012329 airplay:115020759309179 alarm-clock-check:76437352099157 alarm-clock-minus:77364179863205 alarm-clock-off:97904885874823
alarm-clock-plus:80468822979214 alarm-clock:126259032907535 alarm-smoke:96965448419685 album:127358331163602 align-center-horizontal:81570549209434
align-center-vertical:118470463752466 align-end-horizontal:139502909745427 align-end-vertical:96528869059554 align-horizontal-distribute-center:97220086126656 align-horizontal-distribute-end:106128590702022
align-horizontal-distribute-start:76074660002997 align-horizontal-justify-center:75732302772427 align-horizontal-justify-end:129167626402283 align-horizontal-justify-start:130161830325281 align-horizontal-space-around:91646106782950
align-horizontal-space-between:103886093046990 align-start-horizontal:125674804697729 align-start-vertical:105020230154823 align-vertical-distribute-center:93791183635525 align-vertical-distribute-end:139354223511433
align-vertical-distribute-start:74961997822126 align-vertical-justify-center:134754696166569 align-vertical-justify-end:92569381441969 align-vertical-justify-start:99692844572718 align-vertical-space-around:96206012459190
align-vertical-space-between:124998077349706 ambulance:78599995190651 ampersand:75272915739209 ampersands:126947193455996 amphora:137370389604364
anchor:92181172123618 angry:74237056000103 annoyed:80064369052011 antenna:99628923540956 anvil:100203029845919
aperture:83396154449972 app-window-mac:79587216113811 app-window:93142176757189 apple:104349242902442 archive-restore:78956681942188
archive-x:75830115088395 archive:122180020814574 armchair:105384358373973 arrow-big-down-dash:137987229582002 arrow-big-down:81081164158885
arrow-big-left-dash:97827621354677 arrow-big-left:85973092492641 arrow-big-right-dash:117825834972403 arrow-big-right:82960676755590 arrow-big-up-dash:99260194327483
arrow-big-up:93136954756149 arrow-down-0-1:120961896217875 arrow-down-1-0:93474255891850 arrow-down-a-z:99554596207900 arrow-down-from-line:132045845807798
arrow-down-left:102899325237364 arrow-down-narrow-wide:129105261655061 arrow-down-right:123109928624974 arrow-down-to-dot:101675355931221 arrow-down-to-line:87050478931254
arrow-down-up:85780258549577 arrow-down-wide-narrow:88461733425991 arrow-down-z-a:76115279362232 arrow-down:98764963621439 arrow-left-from-line:87857914437603
arrow-left-right:131324733048447 arrow-left-to-line:118645136026970 arrow-left:102531941843733 arrow-right-from-line:74073639809355 arrow-right-left:77015754304300
arrow-right-to-line:78632510329852 arrow-right:113692007244654 arrow-up-0-1:105257823943016 arrow-up-1-0:134175521693798 arrow-up-a-z:77763416595160
arrow-up-down:81019887641527 arrow-up-from-dot:124408496673275 arrow-up-from-line:95777664626453 arrow-up-left:123490598231261 arrow-up-narrow-wide:73006024672636
arrow-up-right:129280608535523 arrow-up-to-line:108818207813537 arrow-up-wide-narrow:87437426951568 arrow-up-z-a:107546173611884 arrow-up:89282378235317
arrows-up-from-line:133710016938621 asterisk:88552752106723 at-sign:79059152889146 atom:73167696981648 audio-lines:70930641819242
audio-waveform:86462036665209 award:132740088158419 axe:132405197863294 axis-3d:122438676546804 baby:93472926933440
backpack:140420225386018 badge-alert:101829200081951 badge-cent:133345018873154 badge-check:76078495178149 badge-dollar-sign:127139803581141
badge-euro:120016477674659 badge-indian-rupee:75659682309981 badge-info:131995373201472 badge-japanese-yen:99081574588615 badge-minus:140321561183881
badge-percent:121359224294885 badge-plus:100325578561866 badge-pound-sterling:119688217279444 badge-question-mark:121464963737502 badge-russian-ruble:108839463659864
badge-swiss-franc:91447608372740 badge-turkish-lira:137839965873529 badge-x:122931434733842 badge:116620312917084 baggage-claim:86922213051957
ban:90767043015246 banana:140713420056179 bandage:129660129590770 banknote-arrow-down:139366449345199 banknote-arrow-up:133758343082529
banknote-x:95348701438065 banknote:104840231536668 barcode:118473018143689 barrel:130647115622774 baseline:124677132511270
bath:76031400297942 battery-charging:80139357470047 battery-full:70906718268972 battery-low:139659256984314 battery-medium:105934079398915
battery-plus:91931341486966 battery-warning:115230083817257 battery:70765800346189 beaker:80902539995520 bean-off:98164436608714
bean:89491967076869 bed-double:73820193212911 bed-single:113423940880634 bed:97726529032925 beef:105850162318915
beer-off:120333134736361 beer:116404978807744 bell-dot:93161277118810 bell-electric:100277767266983 bell-minus:126334890449727
bell-off:78560046118930 bell-plus:77014333795836 bell-ring:94612128913941 bell:97392696311902 between-horizontal-end:81602774794322
between-horizontal-start:76112384929846 between-vertical-end:72817612571631 between-vertical-start:85278312190301 biceps-flexed:82004462003936 bike:102930322246035
binary:91751953950088 binoculars:101460003267896 biohazard:95956532900432 bird:132284145117371 birdhouse:83999157401433
bitcoin:95459240442938 blend:111679612185257 blinds:71164165283925 blocks:72212693357737 bluetooth-connected:96315134002985
bluetooth-off:80600044218117 bluetooth-searching:100673019606426 bluetooth:90506573139443 bold:116141470019166 bolt:102881251417484
bomb:139223800924636 bone:111242153474115 book-a:104067275658465 book-alert:124159928044853 book-audio:109208148317037
book-check:115999656081696 book-copy:108543407492005 book-dashed:127430784795958 book-down:101011730128222 book-headphones:108670200799574
book-heart:112788845135284 book-image:80808285757226 book-key:116024426170705 book-lock:118765061220571 book-marked:73211024251780
book-minus:112724962046282 book-open-check:130848362492667 book-open-text:100629528672195 book-open:129845326810392 book-plus:140267785051233
book-text:94011772484232 book-type:97817304725443 book-up-2:130161620853665 book-up:98640174079190 book-user:128489189240523
book-x:118754548186537 book:125383279695672 bookmark-check:93940443347986 bookmark-minus:96807096039910 bookmark-plus:121469724491615
bookmark-x:112272342584706 bookmark:121093149326239 boom-box:99901322535868 bot-message-square:96145330292478 bot-off:140417690560013
bot:80451686744860 bottle-wine:131675403196921 bow-arrow:124089655150375 box:101768155599700 boxes:136372617578355
braces:117761094704041 brackets:74368995728099 brain-circuit:70547962410202 brain-cog:132039205501538 brain:92424107303177
brick-wall-fire:92980588705520 brick-wall-shield:75954432775071 brick-wall:112878522258821 briefcase-business:129135125207283 briefcase-conveyor-belt:108665725653714
briefcase-medical:119917756334087 briefcase:96754188164225 bring-to-front:132975903553748 brush-cleaning:71728977448805 brush:127035535799640
bubbles:106183424168227 bug-off:88020025049245 bug-play:80107955888092 bug:83626408925438 building-2:77873775611951
building:110616258983082 bus-front:89863432456045 bus:133798469717463 cable-car:128643682205596 cable:128449944504901
cake-slice:136769828413242 cake:103131590503275 calculator:74915716529646 calendar-1:98458364171044 calendar-arrow-down:108415736543437
calendar-arrow-up:70574654109118 calendar-check-2:120231170248276 calendar-check:71551019465748 calendar-clock:119132152594595 calendar-cog:122402172360287
calendar-days:99072017568595 calendar-fold:117368871270394 calendar-heart:88839008103676 calendar-minus-2:98846170279891 calendar-minus:137354318924383
calendar-off:109726151749217 calendar-plus-2:112264562093883 calendar-plus:125266115249843 calendar-range:103641849247576 calendar-search:92010083223634
calendar-sync:78082218499697 calendar-x-2:107518051061147 calendar-x:106703374806500 calendar:114792700814035 camera-off:81057636835256
camera:79950339943067 candy-cane:71689468772492 candy-off:110232752314832 candy:107812129154678 cannabis:98792006538601
captions-off:105223545364193 captions:104960225031445 car-front:87380942739063 car-taxi-front:122455403384057 car:121065933462582
caravan:120070979471783 card-sim:134490550095771 carrot:119118221444304 case-lower:129303130603241 case-sensitive:125410273293056
case-upper:111633433531325 cassette-tape:137065788934157 cast:98202245922071 castle:119275077187784 cat:124252153404931
cctv:99979894766624 chart-area:123446436762366 chart-bar-big:72336824986044 chart-bar-decreasing:107217459044963 chart-bar-increasing:88268905998571
chart-bar-stacked:98478751113024 chart-bar:105389816384108 chart-candlestick:125676898615697 chart-column-big:98598733210787 chart-column-decreasing:73586137373563
chart-column-increasing:120421615068601 chart-column-stacked:86031449675105 chart-column:97915995538580 chart-gantt:88811660555940 chart-line:101833156055618
chart-network:104027882693561 chart-no-axes-column-decreasing:123371717192542 chart-no-axes-column-increasing:140383830943049 chart-no-axes-column:94078751170351 chart-no-axes-combined:121424233161912
chart-no-axes-gantt:131936541106368 chart-pie:113412261630136 chart-scatter:108217585014571 chart-spline:90307460742494 check-check:95183312173858
check-line:115122343485290 check:93898873302694 chef-hat:121744015002573 cherry:139519182403183 chess-bishop:121701705580238
chess-king:90885687223462 chess-knight:96467707042169 chess-pawn:111318574652751 chess-queen:98304702099749 chess-rook:76223925830262
chevron-down:134243273101015 chevron-first:105243363790238 chevron-last:89268452603731 chevron-left:73780377692148 chevron-right:92473583511724
chevron-up:122444883127455 chevrons-down-up:139404716013205 chevrons-down:100524612205956 chevrons-left-right-ellipsis:125035817741526 chevrons-left-right:87910685945204
chevrons-left:82617201744347 chevrons-right-left:87149546686569 chevrons-right:139121276490483 chevrons-up-down:131833120209646 chevrons-up:100467452364672
chromium:128165143739006 church:113714744350666 cigarette-off:77797883078452 circle-alert:83898160590116 circle-arrow-down:95901860261344
circle-arrow-left:102148876968988 circle-arrow-out-down-left:140598097856694 circle-arrow-out-down-right:119952801379305 circle-arrow-out-up-left:132858212688303 circle-arrow-out-up-right:81783743753173
circle-arrow-right:70786767999559 circle-arrow-up:84395128546494 circle-check-big:93202927221730 circle-check:85262178816537 circle-chevron-down:137069490345718
circle-chevron-left:130250009740827 circle-chevron-right:125943696958495 circle-chevron-up:111223574026321 circle-dashed:126799443883746 circle-divide:106398997754208
circle-dollar-sign:91106238890387 circle-dot-dashed:111451232827180 circle-dot:82947033619201 circle-ellipsis:91687150884779 circle-equal:95133963751438
circle-fading-arrow-up:104648212910336 circle-fading-plus:91847890443490 circle-gauge:108157549473765 circle-minus:133556159576809 circle-off:97923456918886
circle-parking-off:128369410981252 circle-parking:124034962915196 circle-pause:139337739700879 circle-percent:133311912860256 circle-play:120408917249739
circle-plus:113157136350384 circle-pound-sterling:105476153083828 circle-power:140676030155098 circle-question-mark:97516698664325 circle-slash-2:136766902186549
circle-slash:125206439913049 circle-small:73685402843600 circle-star:120318414957104 circle-stop:87400503942659 circle-user-round:95489465399880
circle-user:136220511671311 circle-x:76821953846248 circle:130359823580534 circuit-board:107695264369312 citrus:139018222976433
clapperboard:132660667070200 clipboard-check:92649798577170 clipboard-clock:123957515687745 clipboard-copy:125851897718493 clipboard-list:96460215958908
clipboard-minus:107968008485671 clipboard-paste:74382068849983 clipboard-pen-line:77711589791615 clipboard-pen:75290966822953 clipboard-plus:134285318675662
clipboard-type:89949374318028 clipboard-x:102222456890103 clipboard:89601995828423 clock-1:129363225422045 clock-10:104332695855541
clock-11:119023205186105 clock-12:117789618723068 clock-2:134710777209413 clock-3:136385631189327 clock-4:121808839832144
clock-5:85082019959457 clock-6:71009733505593 clock-7:103111188546225 clock-8:110059272125337 clock-9:77610027126437
clock-alert:97157344465162 clock-arrow-down:92349314416042 clock-arrow-up:111484286332629 clock-check:85231630218857 clock-fading:93205297285245
clock-plus:93367709263150 clock:121808839832144 closed-caption:99832644030788 cloud-alert:91967273658626 cloud-check:97318598202432
cloud-cog:96497764065749 cloud-download:121435581993566 cloud-drizzle:139525315752605 cloud-fog:76650233148776 cloud-hail:72320462748242
cloud-lightning:133517088924849 cloud-moon-rain:127667837827018 cloud-moon:71938114737914 cloud-off:131907154501444 cloud-rain-wind:107414583736721
cloud-rain:105547081967408 cloud-snow:72307126270226 cloud-sun-rain:99041604425705 cloud-sun:86114208148727 cloud-upload:93307473217005
cloud:121226497050352 cloudy:105360479023346 clover:74925550436750 club:108490365816628 code-xml:130150477351734
code:107380207681249 codepen:135643965971885 codesandbox:106911852964823 coffee:106864403231093 cog:116544501716299
coins:116510979641930 columns-2:113004100221850 columns-3-cog:121589691981064 columns-3:115223357399375 columns-4:130807991968419
combine:79908476334048 command:93648221906330 compass:115123411028382 component:110027788875080 computer:77480056459407
concierge-bell:140384259310436 cone:97759550688437 construction:106539489968173 contact-round:71907624112229 contact:75868297719012
container:91507237573499 contrast:112796643981497 cookie:73159504540002 cooking-pot:94959783129799 copy-check:91177247988892
copy-minus:109524509933035 copy-plus:113618379616952 copy-slash:93805787810390 copy-x:106557557978061 copy:78979572434545
copyleft:78559055698593 copyright:129433635747111 corner-down-left:90473561177832 corner-down-right:86512767702085 corner-left-down:139876989150630
corner-left-up:126228268096099 corner-right-down:89237035551302 corner-right-up:112851237026705 corner-up-left:84669279763024 corner-up-right:115099889693145
cpu:77549309870247 creative-commons:90408210735312 credit-card:99163352872346 croissant:130710485559420 crop:116344601101413
cross:101833377863588 crosshair:134242818164054 crown:127843403295538 cuboid:75618807946111 cup-soda:121098640829562
currency:90551250119972 cylinder:90569677179169 dam:76874486231393 database-backup:103403210984699 database-zap:131199921258418
database:126791525623846 decimals-arrow-left:120198500638749 decimals-arrow-right:118263047146797 delete:126279426372342 dessert:71508133278830
diameter:97429051503783 diamond-minus:128989071438290 diamond-percent:107717860105959 diamond-plus:134701163723675 diamond:105846996304890
dice-1:112650149591038 dice-2:112278274566793 dice-3:118526270626312 dice-4:113365650364004 dice-5:72768312430593
dice-6:85376239182543 dices:81268120302865 diff:135052708609715 disc-2:91419420404185 disc-3:135470554736048
disc-album:74693460404344 disc:101908120120777 divide:136678191878278 dna-off:89612426361540 dna:74007982981741
dock:121997427160252 dog:71920105558570 dollar-sign:127320961224019 donut:72204922742657 door-closed-locked:74027613267551
door-closed:136249099949073 door-open:91306356501736 dot:137321056643916 download:134814648082393 drafting-compass:99701976182841
drama:110297795801577 dribbble:80231809663849 drill:108644821412796 drone:117299095794783 droplet-off:119365002225172
droplet:100597455015098 droplets:140111846025180 drum:136979060344890 drumstick:104662462521709 dumbbell:80277236776212
ear-off:87421916192807 ear:121894949934209 earth-lock:88814147073745 earth:76231597751076 eclipse:114829622118222
egg-fried:90622538210545 egg-off:92288321309285 egg:117851493400222 ellipsis-vertical:117978708573781 ellipsis:140019550645825
equal-approximately:105382689698323 equal-not:76864449458032 equal:123467780715624 eraser:133957773112410 ethernet-port:75391715149314
euro:72229646524456 ev-charger:97906158859623 expand:137492887754537 external-link:129331830773832 eye-closed:111063268625789
eye-off:135928786788378 eye:100033680381365 facebook:72098528632192 factory:102170024318039 fan:78391400440696
fast-forward:121615540167909 feather:91872927606406 fence:123451565578029 ferris-wheel:79729205796176 figma:134182122852301
file-archive:77018106869967 file-axis-3d:133912328009885 file-badge:74564895394477 file-box:119264004071690 file-braces-corner:77253337986109
file-braces:95314128621234 file-chart-column-increasing:134449481172067 file-chart-column:82048481252560 file-chart-line:71954360551345 file-chart-pie:81072193564497
file-check-corner:76295552859171 file-check:82604001452455 file-clock:102325208830990 file-code-corner:78293841184371 file-code:130978036895504
file-cog:101385347151368 file-diff:96147216772241 file-digit:89220220354580 file-down:120650154178290 file-exclamation-point:102821865889635
file-headphone:100533735901986 file-heart:132214916401696 file-image:123334057511782 file-input:124728604166044 file-key:118790255921100
file-lock:72170228691242 file-minus-corner:119263271735124 file-minus:111014798459222 file-music:134948051536671 file-output:92146832572911
file-pen-line:104622936345006 file-pen:79556179730240 file-play:89006821567838 file-plus-corner:76544604043974 file-plus:78881710800060
file-question-mark:127617422859576 file-scan:129480105228213 file-search-corner:90974165234008 file-search:97780235974933 file-signal:122070252538165
file-sliders:85787771732439 file-spreadsheet:134501869359270 file-stack:138929929862605 file-symlink:91865722036510 file-terminal:116757454755476
file-text:90496405707281 file-type-corner:124902230275209 file-type:115272552799361 file-up:131173039312748 file-user:99552018455009
file-video-camera:81719056173960 file-volume:111264764438958 file-x-corner:87554136773609 file-x:107333775515154 file:74748492079329
files:102806336233202 film:120978945609706 fingerprint:112173305232811 fire-extinguisher:111643493006960 fish-off:89756724887508
fish-symbol:118475177681618 fish:124360663785796 flag-off:112944528856799 flag-triangle-left:88045221285272 flag-triangle-right:108292480304566
flag:78183383236196 flame-kindling:139728976917928 flame:98218034436456 flashlight-off:79780362871740 flashlight:100286985600444
flask-conical-off:112597970025298 flask-conical:128406680901165 flask-round:127508287324940 flip-horizontal-2:103726993598186 flip-horizontal:122937530107837
flip-vertical-2:103836358956328 flip-vertical:108003917346888 flower-2:72934574245145 flower:86129438272762 focus:87493973153317
fold-horizontal:92835712442240 fold-vertical:108873727253656 folder-archive:97312009460206 folder-check:128492920904557 folder-clock:111964836738545
folder-closed:118286209350843 folder-code:70624096349370 folder-cog:85299519462846 folder-dot:138687772725278 folder-down:118044108459225
folder-git-2:101394054141166 folder-git:121885778095158 folder-heart:79104747211105 folder-input:90699920697871 folder-kanban:78313285104072
folder-key:85270407596791 folder-lock:119201572260567 folder-minus:85648718999010 folder-open-dot:74741494767354 folder-open:76018996254888
folder-output:101532447937612 folder-pen:112770491173911 folder-plus:91865663406119 folder-root:103333751154693 folder-search-2:71276453442655
folder-search:110568075123861 folder-symlink:127485747227189 folder-sync:91544602659796 folder-tree:85577554337861 folder-up:72008269765857
folder-x:91699618247635 folder:80846616596607 folders:110351216219061 footprints:139192589041315 forklift:72030930983101
forward:97545944739523 frame:109080612832751 framer:108384807262391 frown:124407301067982 fuel:106447647274511
fullscreen:77793665526178 funnel-plus:100780233821928 funnel-x:70984385812555 funnel:108829540827529 gallery-horizontal-end:74672430161161
gallery-horizontal:80004001442122 gallery-thumbnails:136219289862706 gallery-vertical-end:106461402088317 gallery-vertical:119299431466725 gamepad-2:92483947987410
gamepad-directional:84342305212226 gamepad:121607283959010 gauge:110273524101447 gavel:78952298198456 gem:112904952151156
georgian-lari:98084432591687 ghost:113822048130017 gift:109855212076373 git-branch-minus:97385010649411 git-branch-plus:125944221134316
git-branch:90490195516649 git-commit-horizontal:133646041800147 git-commit-vertical:122098032990350 git-compare-arrows:84874426520216 git-compare:91945124438792
git-fork:89954992404765 git-graph:86166832019304 git-merge:131833355158059 git-pull-request-arrow:94507974577439 git-pull-request-closed:78070600389091
git-pull-request-create-arrow:127422677061091 git-pull-request-create:105929577383926 git-pull-request-draft:76173459869943 git-pull-request:138463010991471 github:120349554354380
gitlab:114054627192933 glass-water:115526102400988 glasses:87936407455373 globe-lock:134065526704402 globe:114238209622913
goal:120517954878160 gpu:95577823614219 graduation-cap:93771896340220 grape:134760640415561 grid-2x2-check:138468840220821
grid-2x2-plus:91811610580247 grid-2x2-x:72407303981388 grid-2x2:99050491897640 grid-3x2:95528684210010 grid-3x3:70419024781206
grip-horizontal:136255899715930 grip-vertical:137183678565296 grip:109058783556768 group:107643418926671 guitar:75915531867926
ham:74465607934635 hamburger:93086916815495 hammer:83545120140895 hand-coins:126990543175462 hand-fist:83341608917591
hand-grab:88867162163985 hand-heart:117507367668412 hand-helping:89897738419446 hand-metal:113619498548713 hand-platter:88594727743168
hand:130703864968637 handbag:135675846264061 handshake:78442115255814 hard-drive-download:73913801230614 hard-drive-upload:85762133615118
hard-drive:88183305858463 hard-hat:128050846767382 hash:82890331678520 hat-glasses:101165538224815 haze:108857561768901
hdmi-port:103693661037020 heading-1:118129315662110 heading-2:110209069670094 heading-3:90267885237062 heading-4:129625620307602
heading-5:120386663181267 heading-6:90959079775093 heading:129254312067735 headphone-off:85038251615641 headphones:118833729589183
headset:129269236787694 heart-crack:110987638564119 heart-handshake:111483078692002 heart-minus:96827380163326 heart-off:89748414415617
heart-plus:94877796283249 heart-pulse:129352925579546 heart:116559368303288 heater:140478466880916 helicopter:111557171735930
hexagon:127592089339199 highlighter:77411555641113 history:123980022019922 hop-off:103386036934034 hop:82778923997672
hospital:105868763850707 hotel:132283390859718 hourglass:86160434939203 house-heart:136054771868597 house-plug:71438263712075
house-plus:118495165208309 house-wifi:126495519725698 house:98755624629571 ice-cream-bowl:124867218454386 ice-cream-cone:90751397288639
id-card-lanyard:90761480469224 id-card:75354294622640 image-down:78972295741235 image-minus:101066016918565 image-off:81934811700938
image-play:129501806784210 image-plus:70391970623917 image-up:126610009605241 image-upscale:106963545024679 images:79350649395557
import:116545008906029 inbox:112591360302868 indian-rupee:113038778381805 infinity:98083086936965 info:124560466474914
inspection-panel:70905313146088 instagram:119864798614855 italic:96220378864282 iteration-ccw:140221832794083 iteration-cw:95534489554662
japanese-yen:106362863465813 joystick:99416790224739 kanban:125934100055431 kayak:136107544609389 key-round:83619031955390
key-square:94621420033649 key:96510194465420 keyboard-music:121058541758636 keyboard-off:92466375369772 keyboard:121474456068237
lamp-ceiling:80032758469141 lamp-desk:85290686983238 lamp-floor:104585881375892 lamp-wall-down:91271394132073 lamp-wall-up:132141464337445
lamp:110730830653382 land-plot:96449039620294 landmark:76885079756393 languages:90816903776498 laptop-minimal-check:114352019833865
laptop-minimal:136705765566068 laptop:111387063244975 lasso-select:105609719912753 lasso:121072936884007 laugh:104491311361166
layers-2:70536710516357 layers:81973586053257 layout-dashboard:139929981863901 layout-grid:81344910161871 layout-list:87462136296578
layout-panel-left:125092469751491 layout-panel-top:91943941515944 layout-template:115564446417985 leaf:119951075637174 leafy-green:105146290493154
lectern:106166425183862 library-big:106794530191412 library:114334671982047 life-buoy:81168450671956 ligature:111397873269411
lightbulb-off:83795722296178 lightbulb:103871245626488 line-squiggle:109555164424447 link-2-off:76885956296867 link-2:86072351557466
link:131607023382430 linkedin:132842789255788 list-check:72374358471156 list-checks:99809353635593 list-chevrons-down-up:137409641500711
list-chevrons-up-down:81825351389084 list-collapse:124505247702401 list-end:77650610048119 list-filter-plus:96385120752336 list-filter:103321376129527
list-indent-decrease:137879979228193 list-indent-increase:79051053161201 list-minus:138507965142671 list-music:126380635781840 list-ordered:83212528113913
list-plus:112384738137814 list-restart:91703153577421 list-start:84828348299727 list-todo:132980603752108 list-tree:97685396239010
list-video:93648525452489 list-x:113025303988861 list:113179976918783 loader-circle:116535712789945 loader-pinwheel:108513357940900
loader:78408734580845 locate-fixed:137367361548433 locate-off:73729216338137 locate:84467676590391 lock-keyhole-open:110863509313073
lock-keyhole:78672912777756 lock-open:93597915325122 lock:134724289526879 log-in:103768533135201 log-out:84895399304975
logs:89772091251787 lollipop:84681611583044 luggage:76619236486400 magnet:135162361226972 mail-check:86921536259917
mail-minus:81989813236553 mail-open:122785416858638 mail-plus:104886401588341 mail-question-mark:126540170949819 mail-search:135616173775287
mail-warning:81495303676089 mail-x:74607841705644 mail:103945161245599 mailbox:82765503320335 mails:90673453450080
map-minus:129525760577747 map-pin-check-inside:107130529843809 map-pin-check:118110914690154 map-pin-house:80546885029816 map-pin-minus-inside:79005529692964
map-pin-minus:74518762643623 map-pin-off:82474689391020 map-pin-pen:113515395277504 map-pin-plus-inside:134639656514430 map-pin-plus:91875228967029
map-pin-x-inside:126235934252379 map-pin-x:101085273547316 map-pin:84279202219901 map-pinned:103963788475034 map-plus:129388826743495
map:95107167260947 mars-stroke:131973193186828 mars:111287112372511 martini:82977695401058 maximize-2:73085922906397
maximize:76045941763188 medal:79016002264450 megaphone-off:124280774193935 megaphone:118759541854879 meh:132197867028557
memory-stick:93212591343119 menu:77021539815611 merge:126201866476775 message-circle-code:112865244991651 message-circle-dashed:81525157881897
message-circle-heart:101990756073677 message-circle-more:92856823884663 message-circle-off:134955643890328 message-circle-plus:106562979649273 message-circle-question-mark:107700302759934
message-circle-reply:137071749508334 message-circle-warning:119020096067894 message-circle-x:126843387725536 message-circle:127255077587058 message-square-code:110968863152123
message-square-dashed:107653455516238 message-square-diff:75472190472625 message-square-dot:127806382463916 message-square-heart:75612811742074 message-square-lock:81268215619563
message-square-more:120139782405970 message-square-off:99961019005789 message-square-plus:76934450256199 message-square-quote:116670768629340 message-square-reply:130985622754637
message-square-share:131017005324026 message-square-text:94899503194205 message-square-warning:138432903962261 message-square-x:137285463279462 message-square:83881670383280
messages-square:97532166733358 mic-off:82123034444822 mic-vocal:99082286164362 mic:89640799126523 microchip:73937907669903
microscope:116875530102782 microwave:108411735353008 milestone:101618292325920 milk-off:72388480962742 milk:96221903896918
minimize-2:116269596042539 minimize:121304296213645 minus:118026365011536 monitor-check:86651948439229 monitor-cloud:85931096038318
monitor-cog:94345128715799 monitor-dot:130394010063680 monitor-down:97466933743423 monitor-off:74395526657953 monitor-pause:76002184067562
monitor-play:133018824306217 monitor-smartphone:84335680433378 monitor-speaker:81744810060380 monitor-stop:98708958984757 monitor-up:96035360858377
monitor-x:126265210441423 monitor:72664649203050 moon-star:82782200506348 moon:83380517901735 motorbike:94580787368233
mountain-snow:105315495740588 mountain:73269957566415 mouse-off:75267871697595 mouse-pointer-2-off:104701076865632 mouse-pointer-2:117093892862228
mouse-pointer-ban:106849413057133 mouse-pointer-click:107150227368485 mouse-pointer:72322454962935 mouse:73096068864710 move-3d:103365982054003
move-diagonal-2:117298577948096 move-diagonal:101433481954184 move-down-left:102819433534567 move-down-right:101479760041877 move-down:70510115135583
move-horizontal:88513523439149 move-left:137614740247980 move-right:132455779472989 move-up-left:139079815540148 move-up-right:105885140592646
move-up:84505444262658 move-vertical:86234730730899 move:116138709011735 music-2:134397426600888 music-3:94466120066498
music-4:132459323665838 music:113343203848535 navigation-2-off:116569611780763 navigation-2:81889066747907 navigation-off:87003270290777
navigation:79308213542922 network:127410729922644 newspaper:123479530460544 nfc:76822396542242 non-binary:78442360386235
notebook-pen:140380614761023 notebook-tabs:127371085570083 notebook-text:93061585217270 notebook:136132108664987 notepad-text-dashed:135793446376219
notepad-text:93404682958966 nut-off:78795397311573 nut:127146410705656 octagon-alert:140438367956051 octagon-minus:74720436795421
octagon-pause:103161463909039 octagon-x:90498161006311 octagon:120803515514852 omega:70414080018786 option:100776883894054
orbit:108926136860562 origami:136020626667101 package-2:70394974762575 package-check:102374216055130 package-minus:114492858789692
package-open:132890233237818 package-plus:129261988138366 package-search:95465120894145 package-x:70818501607442 package:97261141732706
paint-bucket:124275586663284 paint-roller:115248074358348 paintbrush-vertical:105151296591292 paintbrush:125572663700289 palette:86350350950064
panda:132509022802512 panel-bottom-close:74287004071159 panel-bottom-dashed:131084651621603 panel-bottom-open:107768659586540 panel-bottom:132127145048511
panel-left-close:126579818823552 panel-left-dashed:75536606374585 panel-left-open:111075816195767 panel-left-right-dashed:110100707973959 panel-left:97419752870313
panel-right-close:139528655524132 panel-right-dashed:94959793877311 panel-right-open:118114419142794 panel-right:116365035443156 panel-top-bottom-dashed:134737235653344
panel-top-close:83578325777808 panel-top-dashed:70522913169237 panel-top-open:137959875507454 panel-top:75838479462875 panels-left-bottom:72996856149149
panels-right-bottom:90659068960726 panels-top-left:79858853850600 paperclip:92088291163453 parentheses:78950955173096 parking-meter:84652733960568
party-popper:111626795712193 pause:74873705394436 paw-print:112218825427601 pc-case:122978648019101 pen-line:109108135755303
pen-off:84807123119438 pen-tool:106145404953445 pen:72037878096321 pencil-line:88392917053533 pencil-off:103330927652832
pencil-ruler:110120288284597 pencil:137986121120732 pentagon:79184802179890 percent:130155041032013 person-standing:125020872044147
philippine-peso:91173798254675 phone-call:70555587592860 phone-forwarded:113269614319737 phone-incoming:82863576359288 phone-missed:130156165198376
phone-off:133318623553383 phone-outgoing:104576478735825 phone:128804946640049 pi:74936036243146 piano:85008880789520
pickaxe:105888023317688 picture-in-picture-2:112803319544468 picture-in-picture:80579597835123 piggy-bank:79498575790721 pilcrow-left:103803000849583
pilcrow-right:104881733911870 pilcrow:139512780392871 pill-bottle:118394692404597 pill:73280534813448 pin-off:127696372451750
pin:120978111007514 pipette:133167932934404 pizza:126964453193501 plane-landing:122555692211889 plane-takeoff:117179478829575
plane:126985561580989 play:135609604299893 plug-2:97912386476366 plug-zap:74506269884055 plug:99782373064495
plus:111774323017047 pocket-knife:134075428063965 pocket:136686762542964 podcast:109577075549215 pointer-off:95488389312794
pointer:92615117311099 popcorn:139446511232750 popsicle:112696318077073 pound-sterling:127482649469130 power-off:118768311012214
power:96479131758775 presentation:106134583757890 printer-check:130273549443689 printer:76080649734247 projector:103281856385283
proportions:130046855997237 puzzle:136837798892463 pyramid:107811442374127 qr-code:105329945723350 quote:103271711590001
rabbit:98580518804206 radar:138528222906635 radiation:104499586848433 radical:132758286926047 radio-receiver:129598303378835
radio-tower:93958663130054 radio:85611589536956 radius:89814505307129 rail-symbol:134295386306962 rainbow:132488862841895
rat:127400975953159 ratio:126369423897295 receipt-cent:91557573925201 receipt-euro:94015722210295 receipt-indian-rupee:89718170439990
receipt-japanese-yen:132472560758851 receipt-pound-sterling:73934967569625 receipt-russian-ruble:105164576936853 receipt-swiss-franc:72503668620116 receipt-text:138483536013737
receipt-turkish-lira:91950765836342 receipt:77877895901792 rectangle-circle:100642423153903 rectangle-ellipsis:112919953980965 rectangle-goggles:98605436666727
rectangle-horizontal:90224199814966 rectangle-vertical:117277050590967 recycle:140417023381961 redo-2:70451039017914 redo-dot:94252981719732
redo:116150342119054 refresh-ccw-dot:106702246753270 refresh-ccw:117913330389477 refresh-cw-off:140179498843054 refresh-cw:138133190015277
refrigerator:102614042652753 regex:100727200791841 remove-formatting:112833162022628 repeat-1:130144534857095 repeat-2:85927537182704
repeat:121886242955173 replace-all:127862728198635 replace:128404082279430 reply-all:71723137343562 reply:109788633497028
rewind:95205297521988 ribbon:94265331526851 rocket:87412317685854 rocking-chair:110420269495360 roller-coaster:112426178972099
rose:126336840238769 rotate-3d:76300551576392 rotate-ccw-key:74976035240976 rotate-ccw-square:90515853170424 rotate-ccw:110116685948665
rotate-cw-square:77095448159303 rotate-cw:84183336178654 route-off:106350402024079 route:89968303228953 router:102130331994471
rows-2:112556185960101 rows-3:117215586961375 rows-4:125646021959055 rss:131789058984793 ruler-dimension-line:70673861371412
ruler:81432445547423 russian-ruble:126357936542156 sailboat:87110567187540 salad:128864507821603 sandwich:104573187458917
satellite-dish:136742443888305 satellite:134967053164645 saudi-riyal:102282769104635 save-all:116946975799440 save-off:87085435778560
save:126116963775616 scale-3d:72414199620352 scale:108203682317477 scaling:122360365318466 scan-barcode:96889457154761
scan-eye:99244790601968 scan-face:109959345069668 scan-heart:106280819776142 scan-line:126544908146540 scan-qr-code:105409149549927
scan-search:80009010551347 scan-text:73702396787766 scan:123104789658180 school:76351530290068 scissors-line-dashed:122237447974173
scissors:118665510911274 screen-share-off:107677572669805 screen-share:85137895705653 scroll-text:97321022666868 scroll:74072101474951
search-check:75442076191356 search-code:117114794592802 search-slash:96483932261041 search-x:137319957522951 search:121018724060431
section:91732188298948 send-horizontal:111734392411664 send-to-back:75340312862253 send:127751956873796 separator-horizontal:84864453699927
separator-vertical:84031801478581 server-cog:138470287250966 server-crash:132810618000212 server-off:114048751507723 server:92188766517878
settings-2:135684703553372 settings:80758916183665 shapes:129989433311409 share-2:71210767962065 share:87340985053299
sheet:134902122480171 shell:140212943563599 shield-alert:114995877719925 shield-ban:108765041044649 shield-check:87354736164608
shield-ellipsis:114794739892123 shield-half:117842634172647 shield-minus:89965059528921 shield-off:133426959132690 shield-plus:100664857995498
shield-question-mark:135722075265150 shield-user:124832775645347 shield-x:73370117343811 shield:110987169760162 ship-wheel:130797795829448
ship:83995100553930 shirt:106579555405966 shopping-bag:71885477293226 shopping-basket:138646411956433 shopping-cart:128420521375441
shovel:102465000512056 shower-head:75884944024117 shredder:122125164414463 shrimp:102625900815307 shrink:90953687918880
shrub:127326280714343 shuffle:132382786975101 sigma:126884244870899 signal-high:130436670012270 signal-low:73674683500458
signal-medium:125003021367019 signal-zero:130045332414754 signal:78424889355261 signature:114402748013000 signpost-big:115780185675001
signpost:106584743791433 siren:134210267818039 skip-back:70466132711334 skip-forward:124844823753990 skull:137726256442333
slack:96089719516736 slash:117792185664263 slice:95810504278179 sliders-horizontal:85538382643347 sliders-vertical:101190569086853
smartphone-charging:102837532613995 smartphone-nfc:82326425754446 smartphone:96623008834511 smile-plus:131981881472144 smile:105880397565283
snail:70904536548363 snowflake:101235206534566 soap-dispenser-droplet:77258480479465 sofa:114427687218324 solar-panel:132448188047921
soup:115092551871618 space:87072088914178 spade:131444449466462 sparkle:111044800239623 sparkles:138635884129147
speaker:96227183003618 speech:87013139446349 spell-check-2:81556731785534 spell-check:91913483031334 spline-pointer:84842840956804
spline:129406685807412 split:105112438805988 spool:124541981347743 spotlight:77571742539344 spray-can:128372039366326
sprout:100091687832508 square-activity:89496630185293 square-arrow-down-left:108194680296901 square-arrow-down-right:99403846801050 square-arrow-down:135962519626588
square-arrow-left:111671474549238 square-arrow-out-down-left:125714881756353 square-arrow-out-down-right:89971003001390 square-arrow-out-up-left:103759986579087 square-arrow-out-up-right:91221896066807
square-arrow-right:113920471701361 square-arrow-up-left:112424670290693 square-arrow-up-right:76602291406940 square-arrow-up:106998604646718 square-asterisk:89186832353625
square-bottom-dashed-scissors:79076980104803 square-chart-gantt:104034017316411 square-check-big:115320390907184 square-check:134682053539509 square-chevron-down:91032307924592
square-chevron-left:73143404829510 square-chevron-right:90612077729930 square-chevron-up:85565910197337 square-code:81604576616881 square-dashed-bottom-code:100354801563230
square-dashed-bottom:101102319625624 square-dashed-kanban:90388067649847 square-dashed-mouse-pointer:121016142178467 square-dashed-top-solid:117157577548540 square-dashed:136905537847606
square-divide:99894657101970 square-dot:116613421354866 square-equal:110283363706707 square-function:86075219551088 square-kanban:114537101260131
square-library:73810931222081 square-m:117662700410577 square-menu:104067089444415 square-minus:116764432015770 square-mouse-pointer:76141850603920
square-parking-off:100857293535141 square-parking:133116656122387 square-pause:86608552787615 square-pen:120239476110475 square-percent:87111930314567
square-pi:75383328781618 square-pilcrow:131854284699367 square-play:108186325238481 square-plus:114713264461873 square-power:129240437805187
square-radical:132645931868292 square-round-corner:104592745113567 square-scissors:110601255612411 square-sigma:113231244246816 square-slash:105477013908757
square-split-horizontal:76095370148660 square-split-vertical:88589192032058 square-square:136555087357875 square-stack:100463396619394 square-star:94506958703720
square-stop:80018708472943 square-terminal:83969264476798 square-user-round:86484997229302 square-user:70771214183445 square-x:125136183850190
square:86304921356806 squares-exclude:102345385822324 squares-intersect:120869602570119 squares-subtract:131484650948795 squares-unite:96673080107843
squircle-dashed:129936702532522 squircle:82426632573807 squirrel:112864252085343 stamp:92370779813368 star-half:117449275562979
star-off:75742832732503 star:136141469398409 step-back:108672750005121 step-forward:126131872136145 stethoscope:122331031702148
sticker:79938203791608 sticky-note:111894074643919 store:90338129673705 stretch-horizontal:87665042192343 stretch-vertical:95265463417122
strikethrough:103417324549613 subscript:74553514785183 sun-dim:129141645592715 sun-medium:130278807964710 sun-moon:75752898854559
sun-snow:112791898014579 sun:110150589884127 sunrise:134705665494098 sunset:75904872203588 superscript:96887696590118
swatch-book:126786244872453 swiss-franc:113497920041625 switch-camera:76841154349737 sword:124448418211665 swords:81872698913435
syringe:123891270479254 table-2:95751552281545 table-cells-merge:95363715175258 table-cells-split:114799086088649 table-columns-split:111011625447949
table-of-contents:135044763275414 table-properties:125062886015372 table-rows-split:96443733673997 table:109109148250737 tablet-smartphone:133680859813404
tablet:128403991264386 tablets:80835787970735 tag:129104970103940 tags:107179263080798 tally-1:115301298241643
tally-2:110363186864027 tally-3:97655344572540 tally-4:102633494371890 tally-5:88031817475886 tangent:123263132981724
target:87563802520297 telescope:91755049143647 tent-tree:76698322463977 tent:109779587826330 terminal:106783148545356
test-tube-diagonal:75662704378840 test-tube:98801015650164 test-tubes:92555361447433 text-align-center:84051028246390 text-align-end:130041738343555
text-align-justify:80279880143030 text-align-start:134489585487649 text-cursor-input:107551944047171 text-cursor:115984654447300 text-initial:129458097472087
text-quote:139278366448736 text-search:92345384671606 text-select:117087320884956 text-wrap:114804318314018 theater:108558145549163
thermometer-snowflake:121876188028425 thermometer-sun:106693240074310 thermometer:106546011492311 thumbs-down:87794009914015 thumbs-up:111137070767020
ticket-check:105428777212507 ticket-minus:78966299769328 ticket-percent:80834774406405 ticket-plus:110086734392189 ticket-slash:89045681172265
ticket-x:88674114109926 ticket:126527071492145 tickets-plane:100367018248695 tickets:135268612687833 timer-off:110916370767271
timer-reset:110052125369932 timer:85473888890506 toggle-left:85887872573050 toggle-right:90411952142550 toilet:80930782432931
tool-case:87533537832522 tornado:88358291515768 torus:70855707283051 touchpad-off:78784008075456 touchpad:74882354908014
tower-control:95937619060532 toy-brick:86293483924633 tractor:103376704722051 traffic-cone:74110220470369 train-front-tunnel:105194827005114
train-front:125237934215370 train-track:77451032453723 tram-front:93315182364998 transgender:135530817673639 trash-2:109843431391323
trash:106723740584310 tree-deciduous:123124389219004 tree-palm:103846705893963 tree-pine:124662547202594 trees:121203841375919
trello:130987241149527 trending-down:139309232226438 trending-up-down:85083293981691 trending-up:81819858538839 triangle-alert:125920361880643
triangle-dashed:124324079103935 triangle-right:116930791412791 triangle:126330486745540 trophy:131545003268773 truck-electric:111873446387359
truck:86662707764771 turkish-lira:114589876174070 turntable:129870346487856 turtle:118295081560334 tv-minimal-play:99201833426972
tv-minimal:100382201729427 tv:135687724791776 twitch:71383308134888 twitter:88791703276842 type-outline:80108627791690
type:133543553793564 umbrella-off:72395143739955 umbrella:127502210274589 underline:123709229216544 undo-2:113885292059932
undo-dot:132055277744844 undo:111258459077271 unfold-horizontal:117128358526398 unfold-vertical:116593025265499 ungroup:106674800451003
university:84652528263642 unlink-2:128131898892572 unlink:139835795227752 unplug:90171381619874 upload:138212042425501
usb:117230058949613 user-check:81775205032725 user-cog:92795491530865 user-lock:78892639693821 user-minus:126976941957511
user-pen:87445472574836 user-plus:118514469915884 user-round-check:118794737621941 user-round-cog:78239503290053 user-round-minus:98944176636447
user-round-pen:108155244324878 user-round-plus:113301899567470 user-round-search:71565774381870 user-round-x:122367980560930 user-round:136485052187963
user-search:101335649828115 user-star:98777846316000 user-x:139748155894754 user:81589895647169 users-round:103005444008339
users:115398113982385 utensils-crossed:109520762270383 utensils:139952569804235 utility-pole:101965541238242 variable:104743088438151
vault:108049164599845 vector-square:86713728565344 vegan:119489190688082 venetian-mask:102636443033920 venus-and-mars:120227752103771
venus:82891342220859 vibrate-off:113446447326246 vibrate:108330910738733 video-off:132239189859305 video:107587444636945
videotape:114816894323398 view:118717253976805 voicemail:134313454010227 volleyball:83889351124153 volume-1:98514588731639
volume-2:89344380902620 volume-off:103047478058767 volume-x:139252359189540 volume:103236289817396 vote:89409762851246
wallet-cards:129728715308337 wallet-minimal:137800448816116 wallet:132331555762628 wallpaper:74682121235494 wand-sparkles:82546429942392
wand:114580617777835 warehouse:78388887451080 washing-machine:104194127573858 watch:130544621618405 waves-ladder:101808619355514
waves:96340135183647 waypoints:102450133666017 webcam:104148487911129 webhook-off:96370548093471 webhook:112812457747322
weight:103860559844854 wheat-off:133294844612307 wheat:85261952080359 whole-word:90111083954485 wifi-cog:110500263326209
wifi-high:81954601342139 wifi-low:138217335635913 wifi-off:74113634330106 wifi-pen:91290205064712 wifi-sync:84043971055177
wifi-zero:124286465246123 wifi:104669375183960 wind-arrow-down:127753987414870 wind:114551690399915 wine-off:108294164302317
wine:115743721332829 workflow:99186544029189 worm:115752311548091 wrench:112148279212860 x:110786993356448
youtube:123663668456341 zap-off:81385483183652 zap:130551565616516 zoom-in:127956924984803 zoom-out:108334162607319
balloon:97489111621526 beef-off:99869959725200 book-search:132585409504950 calendars:130944763042289 cannabis-off:101938500363812
cctv-off:75925370187295 cigarette:137149549886852 circle-pile:116353155251541 cloud-backup:111649579696132 cloud-sync:79393911188593
database-search:92017137080138 ellipse:71559658267482 fingerprint-pattern:80934710831288 fishing-hook:121038780855899 fishing-rod:71754848048049
form:72999643971000 git-merge-conflict:85677801675703 globe-off:77775243585824 globe-x:109268097029296 hd:71682790698278
image:112751259236831 layers-plus:77587765623057 lens-concave:94819631937027 lens-convex:74736504195474 line-dot-right-horizontal:104718593155221
line-style:90176717785772 map-pin-search:89065012915078 message-circle-check:132772297689418 message-square-check:125789987055668 metronome:101991829345965
mirror-rectangular:109046769760336 mirror-round:121534049429097 mouse-left:99144293708743 mouse-right:88331710212594 printer-x:103002721801548
radio-off:80359258046586 road:120251329173530 scooter:100035452787934 search-alert:127597984617505 shelving-unit:80116568514793
shield-cog-corner:111694066132698 shield-cog:129235695057857 sport-shoe:120495992692630 square-arrow-right-enter:138867831495334 square-arrow-right-exit:133688575845430
square-centerline-dashed-horizontal:77780104374341 square-centerline-dashed-vertical:107878435803525 stone:135161057497830 toolbox:85341033903792 towel-rack:125223915620991
user-key:105403041782190 user-round-key:124547549008939 van:122066377022942 waves-arrow-down:129215220911792 waves-arrow-up:102314705716217
weight-tilde:112081212176951 x-line-top:140592656289509 zodiac-aquarius:74560047770362 zodiac-aries:73255859670234 zodiac-cancer:131985162532947
zodiac-capricorn:97859568140652 zodiac-gemini:80997588122992 zodiac-leo:75509406718106 zodiac-libra:113222735060218 zodiac-ophiuchus:129180108892480
zodiac-pisces:95845819440327 zodiac-sagittarius:82651026742181 zodiac-scorpio:113640924054631 zodiac-taurus:123053219704400 zodiac-virgo:99462994613661
]==]

local BuiltinIcons = { }

for IconName, IconId in string.gmatch(BuiltinIconData, "([%w%-]+):(%d+)") do
    BuiltinIcons[IconName] = "rbxassetid://" .. IconId
end

Library.IconPacks["lucide"] = BuiltinIcons

function Library:LoadIconPack(Url, PackName)
    PackName = PackName or "lucide"

    if self.IconPacks[PackName] then
        return self.IconPacks[PackName]
    end

    local Success, Result = pcall(function()
        local Source = game:HttpGet(Url)
        local Chunk = loadstring(Source)
        if not Chunk then
            return {}
        end

        local Icons = Chunk()
        if type(Icons) ~= "table" then
            return {}
        end

        return Icons
    end)

    self.IconPacks[PackName] = Success and Result or {}
    return self.IconPacks[PackName]
end

function Library:SetIconPack(PackName)
    self.ActiveIconPack = PackName or "lucide"
end

function Library:GetIconPack(PackName)
    PackName = PackName or self.ActiveIconPack or "lucide"

    if not self.IconPacks[PackName] then
        if PackName == "lucide" then
            self:LoadIconPack(self.LucideIconsUrl, "lucide")
        else
            self.IconPacks[PackName] = {}
        end
    end

    return self.IconPacks[PackName] or {}
end


Library.PanelTransparency = 0
Library.Panels = { }

Library.ElementTransparency = 0
Library.ElementFrames = { }

-- Buttons / inputs / dropdowns register their dark card frames so they can turn see-through
function Library:RegisterElement(Root)
    if typeof(Root) ~= "Instance" then
        return
    end

    local function Try(Object)
        if Object:IsA("GuiObject") and Object.BackgroundTransparency == 0 and Object.BackgroundColor3 == Library.Theme["Element"] then
            table.insert(Library.ElementFrames, Object)
            Object.BackgroundTransparency = Library.ElementTransparency
        end
    end

    Try(Root)

    for _, Object in Root:GetDescendants() do
        Try(Object)
    end
end

function Library:SetElementTransparency(Value)
    Library.ElementTransparency = Value

    for Index = #Library.ElementFrames, 1, -1 do
        local Frame = Library.ElementFrames[Index]

        if Frame.Parent then
            Frame.BackgroundTransparency = Value
        else
            table.remove(Library.ElementFrames, Index)
        end
    end
end

-- Section panels register here so a background picture can show through them
function Library:RegisterPanel(Section)
    if type(Section) ~= "table" or type(Section.Items) ~= "table" then
        return
    end

    local Outline = Section.Items["SectionOutline"]
    local Inline = Section.Items["Section"]

    if not (Outline and Inline) then
        return
    end

    table.insert(Library.Panels, { Outline.Instance, Inline.Instance })

    Outline.Instance.BackgroundTransparency = Library.PanelTransparency
    Inline.Instance.BackgroundTransparency = Library.PanelTransparency
end

function Library:SetPanelTransparency(Value)
    Library.PanelTransparency = Value

    for Index = #Library.Panels, 1, -1 do
        local Panel = Library.Panels[Index]

        if Panel[1].Parent then
            Panel[1].BackgroundTransparency = Value
            Panel[2].BackgroundTransparency = Value
        else
            table.remove(Library.Panels, Index)
        end
    end
end

-- Accepts: asset id / number, rbxassetid://, local file in workspace, direct image url
function Library:ResolveBackground(Source)
    if typeof(Source) == "number" then
        return "rbxassetid://" .. Source
    end

    if typeof(Source) ~= "string" or Source == "" then
        return nil
    end

    if string.match(Source, "^%d+$") then
        return "rbxassetid://" .. Source
    end

    -- Local image file in the executor workspace
    if isfile and getcustomasset and not string.find(Source, "://", 1, true) then
        local Ok, Exists = pcall(isfile, Source)

        if Ok and Exists then
            local AssetOk, Asset = pcall(getcustomasset, Source)

            if AssetOk then
                return Asset
            end
        end
    end

    -- GitHub page link ( .../blob/branch/file.png ) -> raw file link
    local GithubUser, GithubRepo, GithubPath = string.match(Source, "^https?://github%.com/([^/]+)/([^/]+)/blob/(.+)$")

    if GithubUser then
        GithubPath = string.gsub(GithubPath, "%?.*$", "")
        Source = "https://raw.githubusercontent.com/" .. GithubUser .. "/" .. GithubRepo .. "/" .. GithubPath
    end

    -- Direct image link ( not a Roblox asset ): download once, cache, load as custom asset
    local Lower = string.lower(Source)

    if string.match(Lower, "^https?://") and not string.find(Lower, "roblox.com", 1, true) then
        local Request = request or http_request

        if not (Request and writefile and getcustomasset and isfile and isfolder and makefolder) then
            warn("[Library] This executor can't download background images, use a local file or asset id")
            return nil
        end

        local Hash = 5381

        for Index = 1, #Source do
            Hash = (Hash * 33 + string.byte(Source, Index)) % 4294967296
        end

        local Extension = string.match(Lower, "%.jpe?g") and "jpg" or "png"
        local Path = "LibraryBackgrounds/" .. string.format("%x", Hash) .. "." .. Extension

        if not isfolder("LibraryBackgrounds") then
            makefolder("LibraryBackgrounds")
        end

        if not isfile(Path) then
            local Ok, Response = pcall(Request, { Url = Source, Method = "GET" })

            if not Ok or type(Response) ~= "table" or not Response.Body or (Response.StatusCode and Response.StatusCode ~= 200) then
                warn("[Library] Background download failed")
                return nil
            end

            local Head = string.sub(Response.Body, 1, 4)
            local IsPng = Head == "\137PNG"
            local IsJpg = string.sub(Head, 1, 3) == "\255\216\255"

            if not (IsPng or IsJpg) then
                warn("[Library] Link is not a PNG/JPG image ( use the raw file link )")
                return nil
            end

            writefile(Path, Response.Body)
        end

        local AssetOk, Asset = pcall(getcustomasset, Path)
        return AssetOk and Asset or nil
    end

    return Source
end

-- Library:AddIcon("logo", "rbxassetid://123") / Library:AddIcon("logo", 123)
function Library:AddIcon(Name, Id)
    local Icons = self:GetIconPack()

    if typeof(Id) == "number" then
        Id = "rbxassetid://" .. Id
    end

    Icons[string.lower(Name)] = Id
end

-- Library:AddIconAlias("aim", "crosshair")
function Library:AddIconAlias(Alias, Target)
    self.IconAliases[string.lower(Alias)] = string.lower(Target)
end

function Library:ResolveIcon(Icon, PackName)
    if not Icon or Icon == "" then
        return Icon
    end

    if typeof(Icon) == "number" then
        return "rbxassetid://" .. Icon
    end

    if typeof(Icon) ~= "string" then
        return Icon
    end

    -- Full content ids / urls / file assets pass through
    if string.find(Icon, "://", 1, true) then
        return Icon
    end

    if string.match(Icon, "^%d+$") then
        return "rbxassetid://" .. Icon
    end

    local Name = string.lower(Icon)
    Name = string.gsub(Name, "^lucide:", "")
    Name = string.gsub(Name, "[%s_]+", "-")

    local Icons = self:GetIconPack(PackName)
    local Found = Icons[Name]

    if not Found then
        local Alias = self.IconAliases[Name]
        Found = Alias and Icons[Alias]
    end

    if Found then
        return Found
    end

    warn(string.format("[Library] Unknown icon '%s', using default", Icon))
    return nil
end

local OriginalWindowFunction = Library.Window
Library.Window = function(self, Data)
    Data = Data or {}

    Data.Logo = self:ResolveIcon(Data.Logo)
    Data.logo = self:ResolveIcon(Data.logo)

    if Data.WatermarkLogo then
        Data.WatermarkLogo = self:ResolveIcon(Data.WatermarkLogo)
    end

    local Window = OriginalWindowFunction(self, Data)

    -- Logo-only toggle button (replaces the old watermark tab)
    local Toggle = Library.WatermarkObject or self:Watermark(Data.WatermarkText or Data.Name or "Window", Data.WatermarkLogo or Window.Logo)

    Toggle:SetCallback(function()
        Window:SetOpen(not Window.IsOpen)
    end)

    Window.Watermark = Toggle

    return Window
end

local OriginalSectionFunction = Library.Pages.Section
Library.Pages.Section = function(self, Data)
    Data = Data or {}
    Data.Icon = Library:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon

    local Section = OriginalSectionFunction(self, Data)
    Library:RegisterPanel(Section)

    return Section
end

Library.CreateWindow = function(self, Data)
    Data = Data or {}

    local Window = self:Window(Data)
    local Watermark = Window.Watermark

    Window._AutoSettingsEnabled = Data.SettingsTabEnabled and true or false
    Window._AutoSettingsWatermark = Watermark

    local OriginalPage = Window.Page
    local CreatingSettings = false

    local function ReorderTabs()
        local Order = 1

        for _, Value in Window.Pages do
            if Value ~= Window.SettingsPage and Value.Items and Value.Items["Inactive"] then
                Value.Items["Inactive"].Instance.LayoutOrder = Order
                Order += 1
            end
        end

        if Window.SettingsPage and Window.SettingsPage.Items and Window.SettingsPage.Items["Inactive"] then
            Window.SettingsPage.Items["Inactive"].Instance.LayoutOrder = 999999
        end
    end

    local function EnsureSettings()
        if not Window._AutoSettingsEnabled or Window.SettingsPage or CreatingSettings then
            ReorderTabs()
            return
        end

        CreatingSettings = true
        Window.SettingsPage = Library:CreateSettingsPage(Window, Window._AutoSettingsWatermark)
        CreatingSettings = false

        ReorderTabs()
    end

    local function WrappedPage(_, TabData)
        TabData = TabData or {}
        TabData.Icon = Library:ResolveIcon(TabData.Icon or TabData.icon)
        TabData.icon = TabData.Icon

        local Page = OriginalPage(Window, TabData)

        EnsureSettings()
        ReorderTabs()

        return Page
    end

    Window.Page = WrappedPage
    Window.CreateTab = WrappedPage
    Window.CreatePage = WrappedPage

    return Window
end

local OriginalPageFunction = Library.Page
Library.Page = function(self, Data)
    if type(Data) == "table" then
        Data.Icon = Library:ResolveIcon(Data.Icon or Data.icon)
        Data.icon = Data.Icon
    end

    return OriginalPageFunction(self, Data)
end

Library.CreateTab = Library.Page
Library.Pages.CreateSection = Library.Pages.Section

Library.Sections.CreateButton = Library.Sections.Button
Library.Sections.CreateToggle = Library.Sections.Toggle
Library.Sections.CreateSlider = Library.Sections.Slider
Library.Sections.CreateDropdown = Library.Sections.Dropdown
Library.Sections.CreateTextbox = Library.Sections.Textbox
Library.Sections.CreateLabel = Library.Sections.Label
Library.Sections.CreateImageGrid = Library.Sections.ImageGrid
Library.Sections.ImageButtons = Library.Sections.ImageGrid
Library.Sections.CreateImageButtons = Library.Sections.ImageGrid

local function NormalizeNamedData(NameOrData, Icon)
    if type(NameOrData) == "table" then
        local Data = table.clone(NameOrData)

        if Data.Title and not (Data.Name or Data.name) then
            Data.Name = Data.Title
        end

        if Data.title and not (Data.Name or Data.name) then
            Data.Name = Data.title
        end

        if Icon and not (Data.Icon or Data.icon) then
            Data.Icon = Icon
        end

        return Data
    end

    local Data = {
        Name = NameOrData
    }

    if Icon ~= nil then
        Data.Icon = Icon
    end

    return Data
end

function Library:AddTab(NameOrData, Icon)
    local Data = NormalizeNamedData(NameOrData, Icon)
    Data.Icon = self:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon

    if self.CreateTab then
        return self:CreateTab(Data)
    end

    return self:Page(Data)
end

function Library.Pages:AddSection(NameOrData, Icon)
    local Data = NormalizeNamedData(NameOrData, Icon)
    Data.Icon = Library:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon

    if self.CreateSection then
        return self:CreateSection(Data)
    end

    return self:Section(Data)
end

function Library.Sections:AddButton(NameOrData, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateButton(Data)
    end

    return self:CreateButton({
        Name = NameOrData,
        Callback = Callback
    })
end

function Library.Sections:AddToggle(NameOrData, FlagOrCallback, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateToggle(Data)
    end

    local RealCallback = type(FlagOrCallback) == "function" and FlagOrCallback or Callback

    return self:CreateToggle({
        Name = NameOrData,
        Flag = type(FlagOrCallback) == "string" and FlagOrCallback or nil,
        Default = Default,
        Callback = RealCallback
    })
end

function Library.Sections:AddSlider(NameOrData, Min, Max, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateSlider(Data)
    end

    return self:CreateSlider({
        Name = NameOrData,
        Min = Min,
        Max = Max,
        Default = Default,
        Callback = Callback
    })
end

function Library.Sections:AddDropdown(NameOrData, Items, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateDropdown(Data)
    end

    return self:CreateDropdown({
        Name = NameOrData,
        Items = Items,
        Default = Default,
        Callback = Callback
    })
end

function Library.Sections:AddTextbox(NameOrData, Placeholder, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateTextbox(Data)
    end

    return self:CreateTextbox({
        Name = NameOrData,
        Placeholder = Placeholder,
        Callback = Callback
    })
end

function Library.Sections:AddImageGrid(Data)
    return self:CreateImageGrid(NormalizeNamedData(Data))
end

function Library.Sections:AddLabel(TextOrData)
    if type(TextOrData) == "table" then
        local Data = NormalizeNamedData(TextOrData)
        return self:CreateLabel(Data.Name or Data.Text or Data.text or "Label", Data.Description or Data.description or Data.Desc or Data.desc)
    end

    return self:CreateLabel(TextOrData)
end

getgenv().Library = Library
return Library
