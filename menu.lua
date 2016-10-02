module(..., package.seeall)

function new()
local localGroup = display.newGroup()
------------------------------------------------------------------------------
--local widget = require "widget"
--widget.setTheme( "theme_ios" )

local level = ice:loadBox( "level" ) -- Load or create unlocked levels icebox
local wasPackCreated = level:storeIfNew( "unlockedPack", 1 )
if wasPackCreated then
    level:save()
end

local wasLevelCreated = level:storeIfNew( "levelPack1", 1 )
if wasLevelCreated then
    level:save()
end

local tip = ice:loadBox( "tip" ) -- Load or create show tips icebox
local wasTip1Created = tip:storeIfNew( "tip1", true )
local wasTip2Created = tip:storeIfNew( "tip2", true )
if wasTip1Created or wasTip2Created then
    tip:save()
end

--local shop = ice:loadBox( "shop" ) -- Load or create shop icebox
--local wasAdsDisabled = level:store( "noAds", 0 ) --If Amazon Market Pro version set to 1 by defualt
--if (system.getInfo( "model" ) == "BNTV200") or (system.getInfo( "model" ) == "BNTV250") then
--	wasPackCreated = shop:storeIfHigher( "noAds", 1 )
--end
--if wasAdsDisabled then
--     level:save()
--end

--local store = require("store")

------------------------------------------------------------------
-- Load Defualt Options

------------------------------------------------------------------

audio.reserveChannels( 2 )

local bkgMusic = audio.loadStream("Pinball_Spring.mp3")

local isChannel1Playing = audio.isChannelPlaying( 1 )
if (isChannel1Playing == false) then
    audio.play( bkgMusic, { channel=1 , loops=-1 } )
end



--[[
1. We want a new sound to play. "gamemusic.mp3" is located in the project folder.
True means that we want it to loop when finished; if you don't, put "false" instead.

2. Although not strictly necessary, I like to set the sound volume. 0.3 works well, but have a play
with it if you wish!
--]]

--[[
local options = ice:loadBox( "options" )  -- Load or create options icebox
myData:storeIfHigher( "something", aNumber )
myData:save()
--]]

--local physics = require("physics") --Load physics for background eye candy
--physics.start()

-- These are the button-trigged fuctions

local function playGame (event)
	--if event.phase == "ended" then
		print("Play Button pressed")
		--[[
		local noAds = shop:retrieve( "noAds" )
		if noAds == 0 then --if ads are enabled
			print("ads")
			lunar.showLunar ({
			x = 0,
			y = 0,
			channel = MY_LUNAR_CHANNEL,
			pubid = MY_LUNAR_PUBID,
			appver = APP_VERSION
		})
		elseif noAds == 1 then
			print("no ads")
			adMargin = 0
		end
		--]]
		director:changeScene ("level_select",  "moveFromRight")
	--end
end

local function optionsMenu (event)
	--if event.phase == "ended" then
		director:changeScene ("options", "moveFromLeft")
	--end
end

local function aboutMenu (event)
	--if event.phase == "ended" then -- only use if using onEvent instead of onRealease
		director:changeScene ("about", "moveFromLeft")
	--end
end

local function closeAlert( event )
        if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                        -- Do nothing; dialog will simply dismiss
                end
        end
end

--local function shopMenu (event)
--	director:changeScene ("shop", "moveFromLeft")
--end

-- These are the background image and eye candy and the title image/logo

local bkg = display.newImage( "background.png", true )
bkg.x = display.contentWidth / 2
bkg.y = display.contentHeight / 2
localGroup:insert(bkg)

--[[
local trampolineA = display.newImage("bouncyplatform.png") 
trampolineA.x = 250; trampolineA.y = 450; trampolineA.rotation = 0
physics.addBody( trampolineA, "static", { density = 1.0, friction = 0.3, bounce = 0.9 } )
localGroup:insert(trampolineA)

-- Goal and Ball
local ball = display.newImage( "ball.png" )
ball.x = 250; ball.y = 400; ball.rotation = 5
ball.myName = "ball"
physics.addBody( ball, { density = 1.0, friction = 0.3, bounce = 0, radius = 17 } )
localGroup:insert(ball)
--]]

local title = display.newImageRect( "title.png", 320, 180 )
title.x = 160; title.y = 100
localGroup:insert(title)
--[[ Background stuff not important to interface

--]]

-- Code for the Play, Options, and About Button

local playButton = widget.newButton{
	default = "play.png",
	over = "play_over.png",
	onRelease = playGame,
	id = "play",
	width = 120, height = 120
}
playButton.x = 160; playButton.y = 270
localGroup:insert(playButton)

local optionsButton = widget.newButton{
	default = "options.png",
	over = "options_over.png",
	onRelease = optionsMenu,
	id = "options",
	width = 65, height = 65
}
optionsButton.x = 35 + display.screenOriginX; optionsButton.y = 445 - display.screenOriginY
localGroup:insert(optionsButton)

local aboutButton = widget.newButton{
	default = "about.png",
	over = "about_over.png",
	onRelease = aboutMenu,
	width = 65, height = 65,
	id = "about"
}
aboutButton.x = 285 - display.screenOriginX; aboutButton.y = 445 - display.screenOriginY
localGroup:insert(aboutButton)
--[[
local shopButton = widget.newButton{
	default = "shop.png",
	over = "shop_over.png",
	onRelease = shopMenu,
	width = 65, height = 65,
	id = "shop"
}
shopButton.x = 285 - display.screenOriginX; shopButton.y = 445 - display.screenOriginY
localGroup:insert(shopButton)
--]]
--if (noAds == 1) then --If ads already disabled
--	display.remove( shopButton )
--	aboutButton.x = 285 - display.screenOriginX
--end

------------------------------------------------------------------------------
return localGroup
end