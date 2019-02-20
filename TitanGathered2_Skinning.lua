TITAN_ORES_ID = "Skinning"
tgsPluginDb = {}

TitanGathered2_Skinning = {}
-- Reduce the chance of functions and variables colliding with another addon.
local tgs = TitanGathered2_Skinning
local infoBoardData = {}
local tg = TitanGathered2

tgs.id = TITAN_ORES_ID
tgs.addon = "TitanGathered2_Skinning"
tgs.email = "bajtlamer@gmail.com"
tgs.www = "www.rrsoft.cz"

--  Get data from the TOC file.
tgs.version = tostring(GetAddOnMetadata(tgs.addon, "Version")) or "Unknown"
tgs.author = tostring(GetAddOnMetadata(tgs.addon, "Author")) or "Unknown"


for _, _category in pairs(TGS_PLUGIN_CATEGORIES) do
    table.insert(TG_CATEGORIES, _category)
end


function tgs.Button_OnLoad(self)
	echo(tgs.addon.." ("..TitanUtils_GetGreenText(tgs.version).."|cffff8020) loaded! Created By "..tgs.author)

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LEAVING_WORLD")
    self:RegisterEvent("LOOT_OPENED")
    tgs.registerPlugin()
    tgs.registerPluginMinable()
end

function tgs.registerPlugin()
    table.insert(tgPlugins, tgs)
end

function tgs.registerPluginMinable()
    for _, _m in pairs(TGS_MINABLES)do
        table.insert(TG_MINABLES, _m)
    end
end

-- Event
function tgs.Button_OnEvent(self, event)
    -- EMPTY
end

function tgs.getGatherableSourceObject(objectId)
    for _, _m in pairs(TGS_MINABLES) do
        if (_m.id == objectId) then
            return _m
        end
    end
    return {id = objectId, name = nil}
end
