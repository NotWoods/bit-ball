module(..., package.seeall)

function new()
local localGroup = display.newGroup()
------------------------------------------------------------------------------

-- These are the button-trigged fuctions

local function backToMenu (event)
	print("Back to Main Menu")
	director:changeScene ("menu", "moveFromRight")
end
local function onKeyEvent( event )
    local keyname = event.keyName;
    if (event.phase == "up" and (event.keyName=="back" or event.keyName=="menu")) then
        if keyname == "back" then
            print("Opening game menu")
			director:changeScene ("level_select",  "overFromTop")
		end
    end
    return true;
end
 --add the runtime event listener
if system.getInfo( "platformName" ) == "Android" then  
	Runtime:addEventListener( "key", onKeyEvent ) 
end
--[[
local function howToPlay ()
	--print("...1...")
	--director:changeScene ("info1", "moveFromRight")
	local currentSlide = 0
	local info1 = display.newImageRect( "info1.png", 380, 570 )
	info1.x = display.contentWidth*0.5; info1.y = display.contentHeight*0.5; info1.alpha = 0
	local info2 = display.newImageRect( "info2.png", 380, 570 )
	info2.x = display.contentWidth*0.5; info2.y = display.contentHeight*0.5; info2.alpha = 0
	local info3 = display.newImageRect( "info3.png", 380, 570 )
	info3.x = display.contentWidth*0.5; info3.y = display.contentHeight*0.5; info3.alpha = 0
	local info4 = display.newImageRect( "info4.png", 380, 570 )
	info4.x = display.contentWidth*0.5; info4.y = display.contentHeight*0.5; info4.alpha = 0
	local bkg = display.newImageRect( "next.png", 156, 59 )
	bkg.x = 160; bkg.y = 450; --bkg.alpha = 0
	--print("...2...")
	
	transition.to( info1, { time=500, alpha=1 } )
	local function nextSlide( event )
		--print("test")
		--print(currentSlide)
		if currentSlide == 0 then
			--print(1)
			transition.to( info1, { time=500, alpha=1 } )
			currentSlide = 1
		elseif currentSlide == 1 then
			--print(2)
			transition.to( info1, { time=500, alpha=0 } )
			transition.to( info2, { time=500, alpha=1 } )
			currentSlide = 2
		elseif currentSlide == 2 then
			--print(3)
			transition.to( info2, { time=500, alpha=0 } )
			transition.to( info3, { time=500, alpha=1 } )
			currentSlide = 3
		elseif currentSlide == 3 then
			--print(4)
			transition.to( info3, { time=500, alpha=0 } )
			transition.to( info4, { time=500, alpha=1 } )
			currentSlide = 4
		elseif currentSlide == 4 then
			transition.to( info4, { time=500, alpha=0 } )
			bkg:removeSelf()
			currentSlide = 0
		end
	end
	bkg:addEventListener( "touch", nextSlide )
	
end
--]]
-- These are the background image and eye candy and the title image/logo

local bkg = display.newImage( "white_background.png", true )
bkg.x = display.contentWidth / 2
bkg.y = display.contentHeight / 2
localGroup:insert(bkg)

local menuButton = widget.newButton{
	default = "menu.png",
	over = "menu_over.png",
	onRelease = backToMenu,
	id = "menu",
	width = 44, height = 44
}
menuButton.x = 20; menuButton.y = 20 + display.screenOriginY
localGroup:insert(menuButton)

local function badgePress()
	system.openURL( "http://www.coronalabs.com" )
	print("Opening anscamobile.com")
end

local line1 = display.newText("Created by:", 30, 180, fontName, 23)
line1:setTextColor(0, 0, 0)
localGroup:insert(line1)

local line2 = display.newText("Tiger Oakes", 153, 203, fontName, 26)
line2:setTextColor(0, 0, 0)
localGroup:insert(line2)

local line3 = display.newText("Music:", 30, 260, fontName, 23)
line3:setTextColor(0, 0, 0)
localGroup:insert(line3)

local line4 = display.newText("Kevin MacLeod", 123, 280, fontName, 26)
line4:setTextColor(0, 0, 0)
localGroup:insert(line4)

local line5 = display.newText("incompetech.com", 137, 306, fontName, 20)
line5:setTextColor(0, 0, 0)
localGroup:insert(line5)
--[[
local line6 = display.newText("More Levels Coming Soon", 20, 440, fontName, 25)
line6:setTextColor(0, 0, 0)
localGroup:insert(line6)

local infoButton = widget.newButton{
	default = "howToPlay.png",
	over = "howToPlay.png",
	onRelease = howToPlay,
	id = "info",
	width = 172, height = 46
}
infoButton.x = 160; infoButton.y = 400
localGroup:insert(infoButton)
--]]
local coronaBadge = widget.newButton{
	default = "CoronaBadge.png",
	over = "CoronaBadge.png",
	onRelease = badgePress,
	id = "corona",
	width = 90, height = 125
}
coronaBadge.x = 275; coronaBadge.y = 62
localGroup:insert(coronaBadge)

------------------------------------------------------------------------------
return localGroup
end