-- This is an addon for Ashita v4 that displays zone and region names
-- with fading effects. It is a port of Windowers zonename addon.
-- Original code by [sylandro].

-- Define addon information
addon.name = 'zonename'
addon.author = 'Xenonsmurf'
addon.version = '1.1'
addon.desc = 'Basic Port of Windowers zonename'
addon.link = 'https://github.com/xenonsmurf/Ashita-4-Plugins-and-Addons'

-- Import necessary modules and libraries
local bit32 = require("bit") -- Import the bit32 library if not already imported
local regions = require("regions")  -- Module for region information
local regionZones = require("regionZones")  -- Module for region-to-zone mapping
local fonts = require('fonts')  -- Module for text font settings
local settings = require('settings')  -- Module for managing settings
require('common')  -- Import a common utility module

-- Initialize variables
local currentZoneID, currentZoneName, currentRegionName, showFont, screenWidth, screenHeight, screenCenterX
local fadeStartTime = nil
local Alpha = 255

-- Import D3D8 for handling the display
local d3d8 = require('d3d8')
local d3d8Device = d3d8.get_device()

-- Get the dimensions of the viewport
local result, viewport = d3d8Device:GetViewport()
if (result == 0) then
    screenWidth = viewport.Width
    screenHeight = viewport.Height
end

screenCenterX = screenWidth / 2
screenCenterY = screenHeight / 2

-- Define default settings for the OSD elements
local fonts = require('fonts')  -- Import fonts module again, this seems redundant
local ZoneNameDisplay = {}  -- Initialize an object for displaying zone name
local RegionNameDisplay = {}  -- Initialize an object for displaying region name
local osd = {}

local defaults = T{
    visible = true,  -- Whether the OSD is initially visible
    font_family = 'Century Schoolbook',  -- Default font family
    font_height = 20,  -- Default font height
    color = 0xFFFFD700,  -- Default text color
    color_outline = 0x0041ab,  -- Default text outline color
    padding = 0.1,  -- Default text padding
    bold = true,  -- Default bold text setting
    italic = false,  -- Default italic text setting
    position_x = screenCenterX,  -- Default horizontal position
    position_y = screenCenterY,  -- Default vertical position
    background = T{
        visible = false,  -- Whether the background is visible
        color = 0x80000000,  -- Background color
    }
};

-- Register events to load and unload the addon
ashita.events.register('load', 'load_callback1', function()
    osd.settings = settings.load(defaults)  -- Load settings with default values
    ZoneNameDisplay = fonts.new(osd.settings)  -- Create a font object for zone name display
    RegionNameDisplay = fonts.new(osd.settings)  -- Create a font object for region name display
end)

ashita.events.register('unload', 'unload_callback1', function()
end)

-- Register a packet_in event to handle zone change information
ashita.events.register('packet_in', 'packet_in_callback1', function(event)
    if event.id == 0x0A then  -- Check if it's a zone change packet
        local moghouse = struct.unpack('b', event.data, 0x80 + 1)
        if moghouse ~= 1 then
            coroutine.sleep(1)
            ZoneNameDisplay.color  = defaults.color
            RegionNameDisplay.color  = defaults.color
            currentZoneID = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0)
            currentZoneName = AshitaCore:GetResourceManager():GetString('zones.names', currentZoneID)  -- Get the current zone name
            local regionID = getRegionIDByZoneID(currentZoneID)  -- Get the region ID based on the zone ID
            currentRegionName = getRegionNameById(regionID)  -- Get the region name based on the region ID
            if currentRegionName then
                currentRegionName = "-" .. currentRegionName .. "-"
                showFont = true
            else
                print("[zonename] Region Name not found for the given zone ID, regionZones may need to be updated.")
            end
        end
    end
end)

-- Register a d3d_present event to display the OSD elements
ashita.events.register('d3d_present', 'present_cb', function()
    if showFont then
       setupRegionText()
       setupZoneText()
       startFade()
    end
end)

-- Set up the region text display
function setupRegionText()
    local textLength = string.len(currentRegionName)
    local fontSize = defaults.font_height
    local textWidth = textLength * fontSize
    local halfTextWidth = textWidth / 3
    RegionNameDisplay.position_x = defaults.position_x - halfTextWidth
    RegionNameDisplay.position_y = defaults.position_y - 330
    RegionNameDisplay.text = currentRegionName
end

-- Set up the zone text display
function setupZoneText()
    local textLength = string.len(currentZoneName)
    local fontSize = defaults.font_height * 2
    local textWidth = textLength * fontSize
    local halfTextWidth = textWidth / 3
    ZoneNameDisplay.font_height = fontSize
    ZoneNameDisplay.position_x = defaults.position_x - halfTextWidth
    ZoneNameDisplay.position_y = defaults.position_y - 300
    ZoneNameDisplay.text = currentZoneName
end

-- Start the fade effect
function startFade()
    if bit32.band(ZoneNameDisplay.color, RegionNameDisplay.color) then
        local maxAlpha = 255 -- Set the maximum alpha to fully visible
        local minAlpha = 0 -- Set the minimum alpha to fully transparent
        local fadeDuration = 6 -- Total duration for fading out in seconds

        if fadeStartTime == nil then
            fadeStartTime = os.clock() -- Record the start time of the fade
        end

        local elapsed = os.clock() - fadeStartTime
        local alpha = maxAlpha - (maxAlpha * (elapsed / fadeDuration))

        -- Ensure alpha doesn't go below the minimum value
        alpha = math.max(alpha, minAlpha)

        -- Extract the RGB components from the color
        local r = bit32.band(ZoneNameDisplay.color, 0xFF)
        local g = bit32.band(bit32.rshift(ZoneNameDisplay.color, 8), 0xFF)
        local b = bit32.band(bit32.rshift(ZoneNameDisplay.color, 16), 0xFF)

        -- Calculate the new color with adjusted alpha
        local newColor = bit32.bor(
            bit32.lshift(alpha, 24),
            bit32.lshift(b, 16),
            bit32.lshift(g, 8),
            r
        )

        -- Set the updated color
        ZoneNameDisplay.color = newColor
        RegionNameDisplay.color = newColor
        Alpha = alpha

        ZoneNameDisplay.visible = true
        RegionNameDisplay.visible = true

        -- Reset fading when it's fully faded out
        if alpha == minAlpha then
            fadeStartTime = nil
            showFont = false
            ZoneNameDisplay.visible = false
            RegionNameDisplay.visible = false
        end
    end
end

-- Function to get the region name by region ID
function getRegionNameById(id)
    for _, region in pairs(regions) do
        if region.id == id then
            return region.en
        end
    end
    return nil
end

-- Function to get the region ID by zone ID
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
