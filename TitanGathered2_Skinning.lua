TITAN_SKINNING_ID = "Skinning"
tgsPluginDb = {}

TitanGathered2_Skinning = {}
-- Reduce the chance of functions and variables colliding with another addon.
local tgs = TitanGathered2_Skinning
local infoBoardData = {}
local tg = TitanGathered2
local lastCast = nil

tgs.id = TITAN_SKINNING_ID
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
    self:RegisterEvent("UNIT_SPELLCAST_STOP")
    self:RegisterEvent("LOOT_OPENED")
    self:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
    self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit);
    TGS_SKINABLES = tg.getVar("tgs_skinables")
    tgs.registerPlugin()
    tgs.registerPluginMinable()
end

function tgs.registerPlugin()
    table.insert(tgPlugins, tgs)
end

function tgs.registerPluginMinable()
    for _, _m in pairs(TGS_SKINABLES)do
        table.insert(TG_MINABLES, _m)
    end
end

-- Event
function tgs.Button_OnEvent(self, event)
    if(event == "UNIT_SPELLCAST_START")then
        tgs.OnEvent_SpellCastStart(self)
    end
    if(event == "UNIT_SPELLCAST_SUCCEEDED")then
        tgs.OnEvent_SpellcastSucceed(self)
    end
    -- if(event == "UNIT_SPELLCAST_STOP")then
    --     tgs.OnEvent_SpellcastSucceed(self)
    -- end
    -- if(event == "LOOT_OPENED")then
        -- tgs.checkIfSkinnable()
    -- end
end

function tgs.getGatherableSourceObject(objectId)
    local minables = tg.getVar("tgs_skinables")
    for _, _m in pairs(minables) do
        if (_m.id == objectId) then
            return _m
        end
    end
    return {id = objectId, name = nil}
end

function tgs.getMinables()
    return tg.getVar("tgs_skinables")
end

function tgs.OnEvent_SpellCastStart(self)
    self.isLastCastSkinning = (UnitCastingInfo("player") == "Skinning") of nil
    -- self.isLastCastSkinning = _spell
    -- local _spell = UnitCastingInfo("player")
    -- if(_spell == "Skinning") then 
    --     self.isLastCastSkinning = _spell
    -- else
    --     self.isLastCastSkinning = nil
    -- end
end

function tgs.OnEvent_SpellcastSucceed(self)
    local minable = {}
    if(self.isLastCastSkinning == true) then 
        local target = tgs.getPlayersTarget()
        -- self.isLastCastSkinning = nil
        -- tgPrint("spell is:", self.isLastCastSkinning)
        -- if( UnitName("target"))then
        --     local name = UnitName("target");
        --     local guid = UnitGUID("target");
        --     local ctype = UnitCreatureType("target")
        --     local intID = getIDformGUIDString(guid)

            if(target ~= nil and target.utype == "Beast")then
                minable.id = target.id
                minable.name = target.name
                tgs.updateMinable(minable)
            end
        -- end
    end
    self.isLastCastSkinning = nil
end

function tgs.updateMinable(obj)
    local _minables = tg.getVar("tgs_skinables")

    for _, minable in pairs(_minables)do
        if(minable.name == obj.name)then 
            dump("Already exist, exiting...")
            return 
        end
    end
    -- if(found == 1)then
        table.insert(_minables, obj)
        TitanGathered2_PrintDebug("Skinable target inserted:"..obj.name)
    -- end

    tg.setVar("tgs_skinables", _minables)
    TGS_SKINABLES = _minables
end

function tgs.getPlayersTarget()
    local target = {}
    local unitName = UnitName("target") or nil
    if(not unitName)then return nil end
    
    local targtUID = UnitGUID("target") or nil
    local trgtType = UnitCreatureType("target") or nil
    local targetId = getIDformGUIDString(targtUID)

    if( trgtType )then
        target.name = unitName
        target.id = targetId
        target.utype = trgtType
        return target
    end
    return nil
end