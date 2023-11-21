local buttons_prompt = GetRandomIntInRange(0, 0xffffff)
local near = 1000
local CleaningTime = 5000

function Button_Prompt()
	Citizen.CreateThread(function()
		local str = "Start Washing"
		canteen = Citizen.InvokeNative(0x04F97DE45A519419)
		PromptSetControlAction(canteen, 0xA1ABB953)
		str = CreateVarString(10, 'LITERAL_STRING', str)
		PromptSetText(canteen, str)
		PromptSetEnabled(canteen, true)
		PromptSetVisible(canteen, true)
		PromptSetHoldMode(canteen, true)
		PromptSetGroup(canteen, buttons_prompt)
		PromptRegisterEnd(canteen)
	end)
end

Citizen.CreateThread(function()
	Button_Prompt()
    while true do 
        Citizen.Wait(near)
        local player = PlayerPedId()
        local Coords = GetEntityCoords(player)
        local barrel1 = DoesObjectOfTypeExistAtCoords(Coords.x, Coords.y, Coords.z, 1.0, GetHashKey("p_barrelladle1x_savage"), 0)  -- prop required to interact
        local barrel2 = DoesObjectOfTypeExistAtCoords(Coords.x, Coords.y, Coords.z, 1.0, GetHashKey("p_barrelladle1x_culture"), 0) -- prop required to interact
        local barrel3 = DoesObjectOfTypeExistAtCoords(Coords.x, Coords.y, Coords.z, 1.0, GetHashKey("p_barrelladle1x_hobo"), 0) -- prop required to interact
        local barrel4 = DoesObjectOfTypeExistAtCoords(Coords.x, Coords.y, Coords.z, 1.0, GetHashKey("p_barrelladle1x_military"), 0) -- prop required to interact
        local barrel5 = DoesObjectOfTypeExistAtCoords(Coords.x, Coords.y, Coords.z, 1.0, GetHashKey("p_barrelladle1x_survivor"), 0) -- prop required to interact
        local barrel6 = DoesObjectOfTypeExistAtCoords(Coords.x, Coords.y, Coords.z, 1.0, GetHashKey("p_barrel_ladle01x"), 0) -- prop required to interact
        local barrel7 = DoesObjectOfTypeExistAtCoords(Coords.x, Coords.y, Coords.z, 1.0, GetHashKey("p_barrel_wash01x"), 0) -- prop required to interact
        if barrel1 or barrel2 or barrel3 or barrel4 or barrel5 or barrel6 or barrel7 then
            near = 1
			local pump = CreateVarString(10, 'LITERAL_STRING', 'Hordó')
			PromptSetActiveGroupThisFrame(buttons_prompt, pump)
			if PromptHasHoldModeCompleted(canteen) then
				BarrelAnim()
			end
        else 
			near = 1000
        end
    end
end)

function BarrelAnim()
    local pedCoords = GetEntityCoords(PlayerPedId())
    heading = GetEntityHeading(PlayerPedId())
    TaskStartScenarioAtPosition(PlayerPedId(), GetHashKey("PROP_PLAYER_WASH_FACE_BARREL"), pedCoords.x, pedCoords.y, pedCoords.z, heading, CleaningTime, true, false, 0, true)
    ClearPedEnvDirt(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
    ClearPedDamageDecalByZone(PlayerPedId(), 10, "ALL")
    ClearPedWetness(PlayerPedId())
end
