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

local touchA = display.newImage("platform_green_small.png")
touchA.x = 116; touchA.y = 100; touchA.rotation = 0
smallPlatShape = { -38,-5, 38,-5, 38,4, -38,4 }
physics.addBody( touchA, "kinematic", 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=smallPlatShape } 
)
localGroup:insert(touchA)

-----------------------------------------------------

local touchB = display.newImage("platform_green_small.png")
touchB.x = 204; touchB.y = 100; touchB.rotation = 0
smallPlatShape = { -38,-5, 38,-5, 38,4, -38,4 }
physics.addBody( touchB, "kinematic", 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=smallPlatShape } 
)
localGroup:insert(touchB)

-----------------------------------------------------

local touchC = display.newImage("platform_green_small.png")
touchC.x = 116; touchC.y = 204; touchC.rotation = 0
smallPlatShape = { -38,-5, 38,-5, 38,4, -38,4 }
physics.addBody( touchC, "kinematic", 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=smallPlatShape } 
)
localGroup:insert(touchC)

-----------------------------------------------------

local touchD = display.newImage("platform_green_small.png")
touchD.x = 204; touchD.y = 204; touchD.rotation = 0
smallPlatShape = { -38,-5, 38,-5, 38,4, -38,4 }
physics.addBody( touchD, "kinematic", 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=smallPlatShape } 
)
localGroup:insert(touchD)

-----------------------------------------------------

local touchE = display.newImage("platform_green_small.png")
touchE.x = 116; touchE.y = 308; touchE.rotation = 0
smallPlatShape = { -38,-5, 38,-5, 38,4, -38,4 }
physics.addBody( touchE, "kinematic", 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=smallPlatShape } 
)
localGroup:insert(touchE)

-----------------------------------------------------

local touchF = display.newImage("platform_green_small.png")
touchF.x = 204; touchF.y = 308; touchF.rotation = 0
smallPlatShape = { -38,-5, 38,-5, 38,4, -38,4 }
physics.addBody( touchF, "kinematic", 
	{ density = 1.0, friction = 0.3, bounce = 0.2, shape=smallPlatShape } 
)
localGroup:insert(touchF)

-----------------------------------------------------

local function rotatePlatform(event)  --For tap based rotation
    local target = event.target
	local id = target.myId
 
	id:rotate( 18 )
      
    return true
end

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

local options = ice:loadBox( "options" )
local rotateData = options:retrieve( "tapToRotate")

if rotateData == true then
	touchA:addEventListener("tap", rotatePlatform); touchB:addEventListener("tap", rotatePlatform)
	touchC:addEventListener("tap", rotatePlatform); touchD:addEventListener("tap", rotatePlatform)
	touchE:addEventListener("tap", rotatePlatform); touchF:addEventListener("tap", rotatePlatform)
elseif rotateData == false then
	touchA:addEventListener("touch", rotateObj); touchB:addEventListener("touch", rotateObj)
	touchC:addEventListener("touch", rotateObj); touchD:addEventListener("touch", rotateObj)
	touchE:addEventListener("touch", rotateObj); touchF:addEventListener("touch", rotateObj)
end

--------------------------------------------------------------------------------
-- Ball Spawn Point
local spawn = {}
spawn.x = 140
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
		_G.refreshLvl = 2
		director:changeScene("reloader", "fade")
		--director:changeScene("level_2", "fade") ------------------------------------------------------------------------------- X = Current Level
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
		director:changeScene("level_3", "fade") ------------------------------------------------------------------------------- X = Next Level
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
		local wasAdded = level:storeIfHigher( "levelPack1", 3 ) --------------------------------------------------------------- X = Next Level 
		if wasAdded then
		level:save()
		end
		local scoreSave = ice:loadBox( "scoreSave" )
		local highscore = scoreSave:storeIfHigher( "level2", score ) ---------------------------------------------------------- X = Current Level
		if highscore then
		scoreSave:save()
		end
    end
end

local function alert()
	timer.pause( gameTimer )
	local helpPopUp = native.showAlert( "Tip", "Use your finger to rotate green objects!", { "OK" }, alertClose )
end

local function countDown(event)
	timeTaken = timeTaken + 1
	if alreadyWon == true then
		timer.cancel( event.source )
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
return localGroup
end