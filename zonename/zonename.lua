-- Based on code by [sylandro] for Windowers Zonename addon.

addon.name = 'zonename'
addon.author = 'Xenonsmurf'
addon.version = '1.0'
addon.desc = 'Basic Port of Windowers zonename'
addon.link = 'https://ashitaxi.com/'

local imgui = require('imgui')
local regions = require("regions")
local regionZones = require("regionZones")
local fonts = require('fonts')
local settings = require('settings')
require('common')
local currentZoneID, currentZoneName, currentRegionName, showFont, screenWidth, screenHeight, screenCenterX, screenCenterY
local d3d8 = require('d3d8')
local d3d8Device = d3d8.get_device()

-- Get the viewport.
local result, viewport = d3d8Device:GetViewport()
if (result == 0) then
    screenWidth = viewport.Width
    screenHeight = viewport.Height
end

screenCenterX = screenWidth / 2
screenCenterY = screenHeight / 2

local fonts = require('fonts')
local ZoneNameDisplay = {}
local RegionNameDisplay = {}
local osd = {}

local defaults = T{
    visible = true,
    font_family = 'Century Schoolbook',
    font_height = 20,
    color = 0xFFFFD700,
	color_outline  = 0x0041ab,
    padding        = 0.1,
	bold           = false,
    italic         = false,
	position_x = screenCenterX,
    position_y = screenCenterY,
    background = T{
        visible = false,
        color = 0x80000000,
    }
};
ashita.events.register('load', 'load_callback1', function()
    osd.settings = settings.load(defaults); 

    ZoneNameDisplay = fonts.new(osd.settings);
    RegionNameDisplay  = fonts.new(osd.settings);	
end)

ashita.events.register('unload', 'unload_callback1', function()
end)

ashita.events.register('packet_in', 'packet_in_callback1', function(event)
    if event.id == 0x0A then
        coroutine.sleep(1)
        currentZoneID = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0)
        currentZoneName = AshitaCore:GetResourceManager():GetString('zones.names', currentZoneID)
        local regionID = getRegionIDByZoneID(currentZoneID)
        currentRegionName = getRegionNameById(regionID)
        currentRegionName = "-" .. currentRegionName .. "-"
      
        if currentRegionName then
           showFont = true
        else
            print("Region Name not found for the given zone ID")
        end
    end
end)

ashita.events.register('d3d_present', 'present_cb', function()
    if showFont then
        displayRegionName()
        displayZoneName()
        coroutine.sleep(5)
        showFont = false
        RegionNameDisplay.visible = false
        ZoneNameDisplay.visible = false
    end
end)

function displayRegionName()
    local textLength = string.len(currentRegionName)
    local fontSize = defaults.font_height
    local textWidth = textLength * fontSize
    RegionNameDisplay.position_x = screenCenterX - (textWidth / 2)
	RegionNameDisplay.position_y = defaults.position_y - 280
    RegionNameDisplay.text = currentRegionName
    RegionNameDisplay.visible = true
end

function displayZoneName()
    local textLength = string.len(currentZoneName)
    local fontSize = defaults.font_height * 2;
    local textWidth = textLength * fontSize
	ZoneNameDisplay.font_height = fontSize
    ZoneNameDisplay.position_x = screenCenterX - (textWidth / 2)
	ZoneNameDisplay.position_y = defaults.position_y - 260
    ZoneNameDisplay.text = currentZoneName
    ZoneNameDisplay.visible = true
end

function getRegionNameById(id)
    for _, region in pairs(regions) do
        if region.id == id then
            return region.en
        end
    end
    return nil
end

function getRegionIDByZoneID(zoneID)
    for regionID, zoneIDs in pairs(regionZones.map) do
        for _, id in ipairs(zoneIDs) do
            if id == zoneID then
                return regionID
            end
        end
    end
    return nil
end
