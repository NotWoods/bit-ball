module(..., package.seeall)
local cleanUp = function()

    -- stop timers, transitions, listeners, etc.
	timer.cancel( gameTimer )
end
function new()
local localGroup = display.newGroup()

------------------------------------------------------------------------------

-- Set up physics

local physics = require("physics")
physics.start()

--physics.setDrawMode("hybrid")

--------------------------------------------------------------------------------

-- Menu

local function gameMenu (event)
		print("Opening game menu")
		director:changeScene ("level_select",  "overFromTop")
		-- Will be more complex later
end

local score = 0
local ballsDropped = 0
local ballScore = 0
local timeTaken = 0
local timeScore = 0
--[[
local fontName = "ArcadeClassic"

if system.getInfo( "platformName" ) == "Android" then  
	fontName = "ArcadeClassic.ttf"
elseif system.getInfo( "platformName" ) == "iPhone OS" then  
	fontName = "ArcadeClassic"
end
--]]
--------------------------------------------------------------------------------

-- Background & Interface

local bkg = display.newImage( "background.png", true )
bkg.x = display.contentWidth / 2
bkg.y = display.contentHeight / 2
localGroup:insert(bkg)

local menuButton = widget.newButton{
	default = "back.png",
	over = "back_over.png",
	onRelease = gameMenu,
	width = 44, height = 44,
	id = "menuButton"
}
menuButton.x = 297; menuButton.y = 456 - display.screenOriginY
localGroup:insert(menuButton)

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

local function alertClose( event )
	if "clicked" == event.action then
		local i = event.index
		if 1 == i then
			timer.resume( gameTimer )
		--elseif 2 == i then
		--	timer.resume( gameTimer )
		--	local tip = ice:loadBox( "tip" )
		--	tip:store( "tip1", false ) 
		--	tip:save()
		end
	end
end
--]]
--------------------------------------------------------------------------------


-- Platforms, Goal, and Ball

--[[ --Basic Platform
local platformA = display.newImage("platform.png") 
platformA.x = 160; platformA.y = 240; platformA.rotation = 0
physics.addBody( platformA, "static", { density = 1.0, friction = 0.3, bounce = 0.2 } )
localGroup:insert(platformA)
--]]

--[[ --Bouncy Platform
local trampolineA = display.newImage("bouncyplatform.png") 
trampolineA.x = 160; trampolineA.y = 240; trampolineA.rotation = 0
physics.addBody( trampolineA, "static", { density = 1.0, friction = 0.3, bounce = 0.9 } )
localGroup:insert(trampolineA)
--]]

---[[ --Rotating Platform

-- create an invisible, static body as the "anchor"

local anchorA = display.newCircle( -100, -100, 10 )
physics.addBody( anchorA, "static" )
localGroup:insert(anchorA)

local rotaterA = display.newImage("platform_gray.png")
rotaterA.x, rotaterA.y = 120, 270
rotaterShape = { -82,-5, 82,-5, 82,6, -82,6 }
physics.addBody( rotaterA, "dynamic", 
	{ friction=1, bounce=0.2, shape=rotaterShape } 
)
localGroup:insert(rotaterA)
 
-- create a pivot to join the anchor to the platform
local pivot = physics.newJoint(
    "pivot", -- joint type
    anchorA, rotaterA, -- objects to join together
    rotaterA.x, rotaterA.y -- physics world location to join at
)
 
-- you may want to limit the spinning by 'damping' the rotation
rotaterA.angularDamping = 5

-- power the joint's motor
pivot.isMotorEnabled = true
pivot.motorSpeed = 50
pivot.maxMotorTorque = 100000

--]]

--------------------------------------------------------------------------------
-- Ball Spawn Point
local spawn = {}
spawn.x = 160
spawn.y = -80

-- Goal and Ball
local alreadyWon = false

local indicator = display.newImage( "indicator.png" )
print(adMargin)
indicator.x = spawn.x; indicator.y = 30 + display.screenOriginY + adMargin
localGroup:insert(indicator)

local ball = display.newImage( "ball.png" )
ball.x = spawn.x; ball.y = 600; ball.rotation = 5
ball.myName = "ball"
physics.addBody( ball, { density = 0.1, friction = 0.3, bounce = 0.2, radius = 17 } )
localGroup:insert(ball)

local function dropBall ( event )  -- Spawns new ball
	if ( alreadyWon == false ) then
		ball.bodyType = "static"
		ball.x = spawn.x
		ball.y = spawn.y
		ball.bodyType = "dynamic"
		ballsDropped = ballsDropped + 1
		print("dropping ball "..ballsDropped)
	end
end

local newBallButton = widget.newButton{
	default = "newball.png",
	over = "newball_over.png",
	onRelease = dropBall,
	width = 44, height = 44,
	id = "newBallButton"
}
newBallButton.x = 22; newBallButton.y = 456 - display.screenOriginY
localGroup:insert(newBallButton)

local goal = display.newImageRect( "goal.png", 79, 68 )
local goal_sides = display.newImageRect( "goal.png", 79, 68 )
goal.x = 160; goal.y = 430
goal_sides.x = goal.x; goal_sides.y = goal.y

localGroup:insert(goal)
localGroup:insert(goal_sides)
goalShapeLeft = { -29,-24, -21,-24, -21,24, -29,24 }
goalShapeBottom = { -21,15, 21,15, 21,24, -21,24 }
goalShapeRight = { 21,-24, 29,-24, 29,24, 21,24 }

goal.myName = "goal box"
goal_sides.myName = "goal box sides"

physics.addBody( goal, "static",
  { density=1.0, friction=0.3, bounce=0.2, shape=goalShapeBottom}
)
physics.addBody( goal_sides, "static",
  { density=1.0, friction=0.3, bounce=0.0, shape=goalShapeLeft },
  { density=1.0, friction=0.3, bounce=0.0, shape=goalShapeRight }
)
-------------------------------------------------------------------------------

-- Win Message setup

local winGray = display.newImage( "gray.png", true )
winGray.x = display.contentWidth / 2
winGray.y = display.contentHeight / 2
localGroup:insert(winGray)
local winMessage = display.newImage( "wintext.png" )
winMessage.x = 160; winMessage.y = 120
localGroup:insert(winMessage)
winGray.isVisible = false
winMessage.isVisible = false

local replayButton = display.newImageRect( "replay.png", 156, 59 )
replayButton.isVisible = false
replayButton.x = 80; replayButton.y = 300
localGroup:insert(replayButton)

local nextButton = display.newImageRect( "next.png", 156, 59 )
nextButton.isVisible = false
nextButton.x = 240; nextButton.y = 300
localGroup:insert(nextButton)

local scoreDisplay = display.newText( "Score: "..score, 0, 220, fontName, 30 )
scoreDisplay.isVisible = false
scoreDisplay.x = 160; scoreDisplay.y = 220
localGroup:insert(scoreDisplay)

-- Win conditions and menu fuctions

local function replayPress ( event )
	if ( event.phase == "ended" ) then

		ball.bodyType = "static"
		ball.x = spawn.x
		ball.y = 600
		ball.bodyType = "dynamic"
		winGray.isVisible = false
		winMessage.isVisible = false
		replayButton.isVisible = false
		nextButton.isVisible = false
		scoreDisplay.isVisible = false
		alreadyWon = false
		_G.refreshLvl = 1
		director:changeScene("reloader", "fade")
		--director:changeScene("level_1", "fade")
	end
end

local function nextPress ( event )
	if ( event.phase == "ended" ) then
		winGray.isVisible = false
		winMessage.isVisible = false
		replayButton.isVisible = false
		nextButton.isVisible = false
		scoreDisplay.isVisible = false
		alreadyWon = false
		director:changeScene("level_2", "fade")
	end
end

local function onLocalCollision( self, event ) -- Triggers win when ball enters goal
    if ( event.phase == "began" ) and ( alreadyWon == false ) then
    	print( self.myName .. ": collision began with " .. event.other.myName )
        winGray.isVisible = true
        winMessage.isVisible = true
        replayButton.isVisible = true
		nextButton.isVisible = true
		scoreDisplay.isVisible = true
        alreadyWon = true
			timeScore = (30 - timeTaken) * 50
			if timeScore < 0 then
				timeScore = 0
			end
			ballScore = (10 - ballsDropped) * 100
			if ballScore < 0 then
				ballScore = 0
			end
			score = timeScore + ballScore
			scoreDisplay.text = "Score: "..score
		-- If Level was not yet unlocked, unlocks Level and saves.  Replace nextLevel with number.  Replace levelPack1 if nessecary.  
		local level = ice:loadBox( "level" )
		local wasAdded = level:storeIfHigher( "levelPack1", 2 ) 
		if wasAdded then
		level:save()
		end
		local scoreSave = ice:loadBox( "scoreSave" )
		local highscore = scoreSave:storeIfHigher( "level1", score ) 
		if highscore then
			scoreSave:save()
			--Ice:saveBox( scoreSave )
		end
		--print(scoreSave:retrieve( "level1" ))
    end
end

local tip = ice:loadBox( "tip" )
print( tip:retrieve( "tip1" ) )

--if ( tip:retrieve( "tip1" ) == true ) then
local function alert()
	timer.pause( gameTimer )
	local helpPopUp = native.showAlert( "Tip", "Press the round white button to drop a ball!  Get the ball to the goal box!", { "OK" }, alertClose )
end


local function countDown(event)
	timeTaken = timeTaken + 1
	if alreadyWon == true then
		timer.cancel( gameTimer )
	end
	print(timeTaken.." seconds remain")
end

gameTimer = timer.performWithDelay(1000, countDown, 30)

alert()

goal.collision = onLocalCollision
goal:addEventListener( "collision", goal )
	
--ball.collision = onLocalCollision
--ball:addEventListener( "collision", ball )

replayButton:addEventListener( "touch", replayPress )
nextButton:addEventListener( "touch", nextPress )


------------------------------------------------------------------------------
localGroup.clean = cleanUp
return localGroup
end