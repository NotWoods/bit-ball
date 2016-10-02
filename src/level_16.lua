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

--------------------------------------------------------------------------------

-- Background & Interface

local bkg = display.newImage( "background.png", true )
bkg.x = display.contentWidth / 2
bkg.y = display.contentHeight / 2
localGroup:insert(bkg)

local menuButton = widget.newButton{
	default = "back.png",
	over = "back_over.png",
	width = 44, height = 44,
	onRelease = gameMenu,
	id = "menuButton"
}
menuButton.x = 297; menuButton.y = 456 - display.screenOriginY
localGroup:insert(menuButton)

--------------------------------------------------------------------------------

local loadedCannon
local ballFiring

-- Platforms, Goal, and Ball

local anchorA = display.newCircle( -100, -100, 10 )
physics.addBody( anchorA, "static" )
localGroup:insert(anchorA)

--local platformA = display.newImage("platform_white.png") 
--platformA.x = 170; platformA.y = 290; platformA.rotation = 90
rotaterShape = { -82,-5, 82,-5, 82,6, -82,6 }
--physics.addBody( platformA, "static", { density = 1.0, friction = 0.3, bounce = 0.2, shape=rotaterShape } )
--localGroup:insert(platformA)

--[[
local platformB = display.newImage("platform_white_small.png") 
platformB.x = 350; platformB.y = 100; platformB.rotation = 0
smallPlatShape = { -38,-5, 38,-5, 38,4, -38,4 }
physics.addBody( platformB, "static", { density = 1.0, friction = 0.3, bounce = 0.2, shape=smallPlatShape } )
localGroup:insert(platformB)
--]]


local cannon = display.newImageRect( "cannon.png", 55, 99)
cannon.x = 260; cannon.y = 340; cannon.rotation = 0
cannonPart1 = { -21,-43, 21,-43, 21,-33, -21,-33 }
cannonPart2 = { -21,-33, 21,-33, 14,-26, 13,-21, 13,-6, -13,-6, -13,-21, -14,-26 }
cannonPart3 = { -13,-6, 13,-6, 18,10, 19,21, -19,21, -18,10 }
cannonPart4 = { -19,21, 19,21, 18,28, 16,34, 8,42, -8,42, -16,34, -18,28 }
physics.addBody( cannon, "static", 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=cannonPart1 },
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=cannonPart2 }, 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=cannonPart3 }, 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=cannonPart4 }
)
cannon.isSensor = true
localGroup:insert(cannon)

---[[
local touchA = display.newImage("platform_green_small.png")
touchA.x = 290; touchA.y = 190; touchA.rotation = 55 
smallPlatShape = { -38,-5, 38,-5, 38,4, -38,4 }
physics.addBody( touchA, "kinematic", 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=smallPlatShape } 
)
localGroup:insert(touchA)

--limit1, limit2 = pivotB:getRotationLimits()
--print("Rotation Limits" + limit1 + " " + limit2)

local function rotateObj(event)  -- for touch based rotation
        local t = event.target
        local phase = event.phase
        
        if (phase == "began") then
                display.getCurrentStage():setFocus( t )
                t.isFocus = true
                
                -- Store initial position of finger
                t.x1 = event.x
                t.y1 = event.y
                
        elseif t.isFocus then
                if (phase == "moved") then
                        t.x2 = event.x
                        t.y2 = event.y
                        
                        angle1 = 180/math.pi * math.atan2(t.y1 - t.y , t.x1 - t.x)
                        angle2 = 180/math.pi * math.atan2(t.y2 - t.y , t.x2 - t.x)
                        print("angle1 = "..angle1)
                        rotationAmt = angle1 - angle2
 
                        --rotate it
                        t.rotation = t.rotation - rotationAmt
                        print ("t.rotation = "..t.rotation)
                        
                        t.x1 = t.x2
                        t.y1 = t.y2
                        
                elseif (phase == "ended") then
                        
                        display.getCurrentStage():setFocus( nil )
                        t.isFocus = false
                end
        end
        
        -- Stop further propagation of touch event
        return true
end

touchA:addEventListener("touch", rotateObj); 
--]]

---[[ --Rotating Platform

-- create an invisible, static body as the "anchor"



local rotaterA = display.newImage("platform_gray.png")
rotaterA.x, rotaterA.y = 120, 200
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
spawn.x = 260
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
ball.isBullet = true

local function dropBall ( event )  -- Spawns new ball
	if ( alreadyWon == false ) then
		ball.bodyType = "static"
		ball.x = spawn.x
		ball.y = spawn.y
		ball.bodyType = "dynamic"
		ball.isVisible = true
		ballsDropped = ballsDropped + 1
		print("dropping ball "..ballsDropped)
		loadedCannon = false
		ballFiring = false
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
goal.x = 40; goal.y = 350; goal.rotation = 0
goal_sides.x = goal.x; goal_sides.y = goal.y; goal_sides.rotation = goal.rotation

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

cannon:toFront()
---[[
local function cannonCollision( event )
	if ballFiring == false then
	if (loadedCannon == false) then
		--if (event.object1.myName == "cannon" and event.object2.myName == "ball") or (event.object1.myName == "ball" and event.object2.myName == "cannon") then
		--	print( self.myName .. ": collision began with " .. event.other.myName )
			print("loading cannon")
			loadedCannon = true
			ball.isVisible = false
			ball.bodyType = "static"
		--end
	end
	end
end

cannon:addEventListener( "collision", cannonCollision )
--]]

local function fire(event)
	if (event.phase == "ended") and (loadedCannon == true) then
		if ballFiring == false then
			ballFiring = true
		    print("Entering fire event")
			ball.x = cannon.x 
			ball.y = cannon.y
			--ball:applyForce( .5, .5, cannon.x, cannon.y )
			ball.bodyType = "dynamic"
			ball.isVisible = true
			ball:applyLinearImpulse(0, -2, ball.x, ball.y)
		end
	end
end
	
cannon:addEventListener("touch",fire)
-------------------------------------------------------------------------------


-- Win conditions and menu fuctions

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
		director:changeScene("level_16", "fade") ------------------------------------------------------------------------------- X = Current Level
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
		director:changeScene("level_17", "fade") ------------------------------------------------------------------------------- X = Next Level
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
		local wasAdded = level:storeIfHigher( "levelPack1", 17 ) --------------------------------------------------------------- X = Next Level 
		if wasAdded then
		level:save()
		end
		local scoreSave = ice:loadBox( "scoreSave" )
		local highscore = scoreSave:storeIfHigher( "level16", score ) ---------------------------------------------------------- X = Current Level
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