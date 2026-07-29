local allowedIds = {
	2753915549,
	4442272183,
	7449423635
}
local currentPlaceId = game.PlaceId
local isAllowed = false
for _, id in ipairs(allowedIds) do
	if currentPlaceId == id then
		isAllowed = true
		break
	end
end
if not isAllowed then
	game:GetService("Players").LocalPlayer:Kick("[FISHHUB] Game not support")
	return
end
