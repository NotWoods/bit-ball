module(..., package.seeall)

function new()
local sliderGroup = display.newGroup()
local localGroup = display.newGroup()
localGroup:insert( sliderGroup )

------------------------------------------------------------------------------

--local options = ice:loadBox( "options" )

-- These are the button-trigged fuctions

local function backToMenu (event)
	print("Back to Main Menu")
	director:changeScene ("menu", "moveFromRight")
end

local function onComplete( event )
	print( "index => ".. event.index .. "    action => " .. event.action )

	local action = event.action
	if "clicked" == event.action then
		if 1 == event.index then
			print("Resetting Levels")
			-- If Level was not yet unlocked, unlocks Level and saves.  Replace nextLevel with number.  Replace levelPack1 if nessecary.  
			local level = ice:loadBox( "level" )
			level:store( "levelPack1", 1 ) 
			level:store( "unlockedPack", 1 )
			level:save()
			local tip = ice:loadBox( "tip" )
			tip:store( "tip1", true )
			tip:save()
		elseif 2 == event.index then
			
		end
	end
end

local function resetLevels()
	native.showAlert( " ", "Are you sure to want to clear all data?", { "Yes", "No" }, onComplete )
end

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

local resetButton = widget.newButton{
	default = "reset.png",
	over = "reset_over.png",
	onRelease = resetLevels,
	width = 279, height = 76,
	id = "reset"
}
resetButton.x = 160; resetButton.y = 240
localGroup:insert(resetButton)


------------------------------------------------------------------------------
return localGroup
end