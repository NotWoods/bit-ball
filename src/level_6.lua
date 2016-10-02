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
-------------------------------------------------------------------------------

-- Platforms, Goal, and Ball

---[[ --Basic Platform
local platformA = display.newImage("platform_white_small.png")
platformA.x = 110; platformA.y = 150; platformA.rotation = 10
smallPlatShape = { -38,-5, 38,-5, 38,4, -38,4 }
physics.addBody( platformA, "static", 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=smallPlatShape } 
)
localGroup:insert(platformA)
--]]

---[[ --Bouncy Platform
local trampolineA = display.newImage("platform_yellow_small.png")
trampolineA.x = 30; trampolineA.y = 400; trampolineA.rotation = 10

physics.addBody( trampolineA, "static", 
	{ density = 1.0, friction = 0.3, bounce = 0.6, shape=smallPlatShape } 
)
localGroup:insert(trampolineA)
--]]

---[[ --Bouncy Platform 2
local trampolineB = display.newImage("platform_yellow_small.png")
trampolineB.x = 200; trampolineB.y = 280; trampolineB.rotation = -20
physics.addBody( trampolineB, "static", 
	{ density = 1.0, friction = 0.3, bounce = 1.8, shape=smallPlatShape } 
)
localGroup:insert(trampolineB)
--]]

--[[ --Bouncy Platform 3
local trampolineC = display.newImage("platform_yellow_small.png")
trampolineC.x = 129; trampolineC.y = 220; trampolineC.rotation = 60
physics.addBody( trampolineC, "static", 
	{ density = 1.0, friction = 0.3, bounce = 1.3, shape=smallPlatShape } 
)
localGroup:insert(trampolineC)
--]]

--[[ --Bouncy Platform 4
local trampolineD = display.newImage("platform_yellow_small.png")
trampolineD.x = 250; trampolineD.y = 235; trampolineD.rotation = 90
physics.addBody( trampolineD, "static", 
	{ density = 1.0, friction = 0.3, bounce = 0.8, shape=smallPlatShape } 
)
localGroup:insert(trampolineD)
--]]

--[[ --Bouncy Platform 5
local trampolineE = display.newImage("platform_yellow_small.png")
trampolineE.x = 140; trampolineE.y = 350; trampolineE.rotation = 95
physics.addBody( trampolineE, "static", 
	{ density = 1.0, friction = 0.3, bounce = 1.1, shape=smallPlatShape } 
)
localGroup:insert(trampolineE)
--]]

--[[ --Bouncy Platform 6
local trampolineF = display.newImage("platform_yellow_small.png")
trampolineF.x = 120; trampolineF.y = 80; trampolineF.rotation = 2
physics.addBody( trampolineF, "static", 
	{ density = 1.0, friction = 0.3, bounce = 0.9, shape=smallPlatShape } 
)
localGroup:insert(trampolineF)
--]]

---[[
local touchA = display.newImage("platform_green_small.png")
touchA.x = 210; touchA.y = 170; touchA.rotation = 10
--platformA.x = 100; platformA.y = 150; platformA.rotation = 10
physics.addBody( touchA, "kinematic", 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=smallPlatShape } 
)
localGroup:insert(touchA)

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

--------------------------------------------------------------------------------
-- Ball Spawn Point
local spawn = {}
spawn.x = 20
spawn.y = -80

local alreadyWon = false

-- Goal, Indicator, and Ball
local indicator = display.newImage( "indicator.png" )
indicator.x = spawn.x; indicator.y = 30 + display.screenOriginY + adMargin
localGroup:insert(indicator)

local ball = display.newImageRect( "ball.png", 46, 46 )
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
goal.x = 280; goal.y = 400
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
		director:changeScene("level_6", "fade") ------------------------------------------------------------------------------- X = Current Level
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
		director:changeScene("level_7", "fade") ------------------------------------------------------------------------------- X = Next Level
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
		local wasAdded = level:storeIfHigher( "levelPack1", 7 ) --------------------------------------------------------------- X = Next Level 
		if wasAdded then
		level:save()
		end
		local scoreSave = ice:loadBox( "scoreSave" )
		local highscore = scoreSave:storeIfHigher( "level6", score ) ---------------------------------------------------------- X = Current Level
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