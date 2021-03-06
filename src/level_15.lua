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

--[[ -- If I decide to add tilt event to the game
local function onTilt( event )
        physics.setGravity( 5 * event.xGravity, 9.8 )
end
 
Runtime:addEventListener( "accelerometer", onTilt )
--]]
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
	id = "menuButton",
	width = 44, height = 44
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

-------------------------------------------------------------------------------
--[[ Ads

local shop = ice:loadBox( "shop" )
local noAds = shop:retrieve( "noAds" )
local adMargin = 50
if noAds == 0 then --if ads are enabled
	lunar.showLunar ({
		x = 0,
		y = 0,
		channel = MY_LUNAR_CHANNEL,
		pubid = MY_LUNAR_PUBID,
		appver = APP_VERSION
	})
elseif noAds == 1 then
	adMargin = 0
end
--]]

--------------------------------------------------------------------------------

-- Platforms, Goal, and Ball
--[[
local trampolineA = display.newImage("blue_platform_small.png") 
trampolineA.x = 300; trampolineA.y = 150; trampolineA.rotation = -11
physics.addBody( trampolineA, "static", { density = 1.0, friction = 0.3, bounce = 0.9 } )
localGroup:insert(trampolineA)

local trampolineB = display.newImage("blue_platform_small.png") 
trampolineB.x = 35; trampolineB.y = 200; trampolineB.rotation = 15
physics.addBody( trampolineB, "static", { density = 1.0, friction = 0.3, bounce = 0.9 } )
localGroup:insert(trampolineB)
--]]

local trampolineA = display.newImage("platform_yellow_small.png")
trampolineA.x = 300; trampolineA.y = 150; trampolineA.rotation = -11
smallPlatShape = { -38,-5, 38,-5, 38,4, -38,4 }
physics.addBody( trampolineA, "static", 
	{ density = 1.0, friction = 0.3, bounce = 0.9, shape=smallPlatShape } 
)
localGroup:insert(trampolineA)

local trampolineB = display.newImage("platform_yellow_small.png")
trampolineB.x = 35; trampolineB.y = 200; trampolineB.rotation = 15
physics.addBody( trampolineB, "static", 
	{ density = 1.0, friction = 0.3, bounce = 0.9, shape=smallPlatShape } 
)
localGroup:insert(trampolineB)


---[[ --Rotating Platform 2

-- create an invisible, static body as the "anchor"

local anchorB = display.newCircle( -100, -100, 10 )
physics.addBody( anchorB, "static" )
localGroup:insert(anchorB)

-- create and poitions the gear
--[[
local gearB = display.newImage( "gear.png" )
gearB.x, gearB.y = 260,300
physics.addBody( gearB, "dynamic", { friction=1, bounce=.2, radius = 16 } )
localGroup:insert(gearB)
--]]
 
-- create and position the dynamic platform
--[[
local rotaterB = display.newImage( "gray_platform.png" )
rotaterB.x, rotaterB.y = gearB.x, gearB.y; rotaterB.rotation = 40
physics.addBody( rotaterB, "dynamic", { friction=1, bounce=.2 } )
localGroup:insert(rotaterB)
--]]

local rotaterB = display.newImage("platform_gray.png")
rotaterB.x, rotaterB.y = 260,300
rotaterShape = { -82,-5, 82,-5, 82,6, -82,6 }
physics.addBody( rotaterB, "dynamic", 
	{ friction=1, bounce=0.2, shape=rotaterShape } 
)
localGroup:insert(rotaterB)

-- create a pivot to join the anchor to the platform
local pivotB = physics.newJoint(
    "pivot", -- joint type
    anchorB, rotaterB, -- objects to join together
    rotaterB.x, rotaterB.y -- physics world location to join at
)
 
 --[[
 -- create a pivot to join the gear to the platform
local gearBjoint = physics.newJoint(
    "pivot", -- joint type
    rotaterB, gearB, -- objects to join together
    gearB.x, gearB.y -- physics world location to join at
)
--]]
 
-- you may want to limit the spinning by 'damping' the rotation
rotaterB.angularDamping = 5
--gearB.angularDamping = 5

-- power the joint's motor
pivotB.isMotorEnabled = true
pivotB.motorSpeed = 50
pivotB.maxMotorTorque = 100000

--]]


--------------------------------------------------------------------------------
-- Ball Spawn Point
local spawn = {}
spawn.x = 299
spawn.y = -80

local alreadyWon = false

-- Goal, Indicator, and Ball

local indicator = display.newImage( "indicator.png" )
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

local goal = display.newImage( "goal.png" )
local goal_sides = display.newImage("goal.png")
goal.x = 200; goal.y = 430
goal_sides.x = goal.x; goal_sides.y = goal.y
goal.isBullet = true; goal_sides.isBullet = true

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

local scoreDisplay = display.newText( "Score: "..score, 0, 0, fontName, 30 )
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
		director:changeScene("level_15", "fade") ------------------------------------------------------------------------------- X = Current Level
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
		director:changeScene("level_16", "fade") ------------------------------------------------------------------------------- X = Next Level
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
		-- If Level was not yet unlocked, unlocks Level and saves.  
		local level = ice:loadBox( "level" )
		local wasAdded = level:storeIfHigher( "levelPack1", 16 ) --------------------------------------------------------------- X = Next Level 
		if wasAdded then
		level:save()
		end
		local scoreSave = ice:loadBox( "scoreSave" )
		local highscore = scoreSave:storeIfHigher( "level15", score ) ---------------------------------------------------------- X = Current Level
		if highscore then
		scoreSave:save()
		end
    end
end

local function countDown(event)
	timeTaken = timeTaken + 1
	if alreadyWon == true then
		timer.cancel( event.source )
	end
	print(timeTaken.." seconds remain")
end

gameTimer = timer.performWithDelay(1000, countDown, 30)

goal.collision = onLocalCollision
goal:addEventListener( "collision", goal )
	
--ball.collision = onLocalCollision
--ball:addEventListener( "collision", ball )

replayButton:addEventListener( "touch", replayPress )
nextButton:addEventListener( "touch", nextPress )

------------------------------------------------------------------------------
return localGroup
end