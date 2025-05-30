local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function addNameTag(character, name, teamColor)
    if character:FindFirstChild("Head") and not character.Head:FindFirstChild("NameTag") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameTag"
        billboard.Size = UDim2.new(0, 100, 0, 20)
        billboard.Adornee = character.Head
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = teamColor or Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0.5
        label.Text = name
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 14
        billboard.Parent = character.Head
    end
end

local function createESP(player)
    if player == LocalPlayer then return end

    local function setupCharacter(character)
        if not character:FindFirstChild("HighlightESP") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "HighlightESP"
            highlight.Adornee = character
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 0
            highlight.OutlineColor = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 50, 50)
            highlight.Parent = character
        end

        addNameTag(character, player.Name, player.Team and player.Team.TeamColor.Color)
    end

    if player.Character then
        setupCharacter(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Head", 5)
        char:WaitForChild("HumanoidRootPart", 5)
        setupCharacter(char)
    end)

    player:GetPropertyChangedSignal("Team"):Connect(function()
        if player.Character and player.Character:FindFirstChild("HighlightESP") then
            player.Character.HighlightESP.OutlineColor = player.Team and player.Team.TeamColor.Color or Color3.new(1, 0, 0)
        end
        if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameTag") then
            player.Character.Head.NameTag.TextLabel.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.new(1, 1, 1)
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createESP(player)
    end
end)
