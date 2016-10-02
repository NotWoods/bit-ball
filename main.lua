--====================================================================--
-- BIT BALL
--====================================================================--

--[[ 

 - Version: 1.2
 - Made by Tiger Oakes Copyright © 2012
 - Mail: tigeroakes@gmail.com
 - Twitter: @xMech37x
 - Indentifier: com.tigeroakes.bitball

 -- ]]
--[[
local splashscreen = display.newImageRect( "splash.png", 380, 570 )
splashscreen.x = display.contentWidth / 2
splashscreen.y = display.contentHeight / 2
--]]

widget = require "widget"
widget.setTheme( "theme_ios" )

require( "ice" )

--require("lunar")

_G.refreshLvl = 0

_G.fontName = "ArcadeClassic"
--MY_LUNAR_CHANNEL = "LDFCQJLZRM56201223710" --Replace this with your channel ID from LunarAds.com

buttonBuffer = 0
--_G.adOn = 0

if system.getInfo( "platformName" ) == "Android" then  
	fontName = "ArcadeClassic"
	--MY_LUNAR_CHANNEL = "LDFCQJLZRM56201223710" --Replace this with your channel ID from LunarAds.com
elseif system.getInfo( "platformName" ) == "iPhone OS" then  
	fontName = "ArcadeClassic"
	--MY_LUNAR_CHANNEL = "HPBBMVFBCD572012153912" --Replace this with your channel ID from LunarAds.com
end

if system.getInfo( "model" ) == "Kindle Fire" then
	buttonBuffer = 11
--elseif system.getInfo( "model" ) == "BNTV250" then -- Nook Tablet
--elseif system.getInfo( "model" ) == "BNTV200" then -- Nook Color
end

--MY_LUNAR_PUBID = "635525" --Replace this with your publisher ID from LunarAds.com
--APP_VERSION = "0.8" -- optional parameter (your own app build version) 

display.setStatusBar (display.HiddenStatusBar)

local director = require ("director")

local mainGroup = display.newGroup()

local function main()

	--splashscreen:removeSelf()
	--splashscreen = nil
	mainGroup:insert(director.directorView)
	director:changeScene("menu")
	
	return true
end

--[[
local function garbagePrinting()
	collectgarbage("collect")
    local memUsage_str = string.format( "memUsage = %.3f KB", collectgarbage( "count" ) )
    print( memUsage_str )
    local texMemUsage_str = system.getInfo( "textureMemoryUsed" )
    texMemUsage_str = texMemUsage_str/1000
    texMemUsage_str = string.format( "texMemUsage = %.3f MB", texMemUsage_str )
    print( texMemUsage_str )
end

Runtime:addEventListener( "enterFrame", garbagePrinting )
--]]

main()
