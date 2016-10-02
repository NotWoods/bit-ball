module(..., package.seeall)

function new()
local localGroup = display.newGroup()
------------------------------------------------------------------------------
_G.adMargin = 0
--local widget = require "widget"
--widget.setTheme( "theme_ios" )

local level = ice:loadBox( "level" ) -- Load or create unlocked levels icebox
--local wasLevelCreated = level:storeIfHigher( "levelPack1", 20 )
--if wasLevelCreated then
--     level:save()
--end

local isChannel1Playing = audio.isChannelPlaying( 1 )
if (isChannel1Playing == false) then
    audio.play( bkgMusic, { channel=1 , loops=-1 } )
end

--[[
local MY_LUNAR_CHANNEL = "LDFCQJLZRM56201223710" --Replace this with your channel ID from LunarAds.com

if system.getInfo( "platformName" ) == "Android" then  
	MY_LUNAR_CHANNEL = "LDFCQJLZRM56201223710" --Replace this with your channel ID from LunarAds.com
elseif system.getInfo( "platformName" ) == "iPhone OS" then  
	MY_LUNAR_CHANNEL = "HPBBMVFBCD572012153912" --Replace this with your channel ID from LunarAds.com
end

--local shop = ice:loadBox( "shop" )
local noAds = level:retrieve( "noAds" )
--print(noAds)
if noAds == 0 then --if ads are enabled
	--print("test test 2")
	adMargin = 50
	--print(adMargin)
	--print("test")
	if adOn == 0 then
	lunar.showLunar ({
		Halign = "center",
		y = (0 + display.screenOriginY),
		dynamicScaling = true, --set to true if using special screen size dimensions
		channel = MY_LUNAR_CHANNEL,
		pubid = 635525,
		appver = 1.1
	})
	adOn = 1
	end
	--print("test success")
elseif noAds == 1 then
	print("test test 1")
	adMargin = 0
	--print(adMargin)
	--print("test")
end
--]]

--Check to see if a file for the current level already exists, if it
--doesn't then create it and set the current level to 1.

-- Button Trigged Fuctions

local function backMain (event)
		print("Back to Main Menu")
		--lunar.hideLunar()
		--adOn = 0
		director:changeScene ("menu",  "moveFromLeft")
end

local function playLevel(event)
    local levelName = event.target.id
    print("Play:"..levelName)
	director:changeScene(levelName, "overFromBottom")
end

local function playMultiplayer(event)
    print("Play Multiplayer")
	director:changeScene("multiplayer", "overFromBottom")
end

-- Background
local bkg = display.newImage( "background.png", true )
bkg.x = display.contentWidth / 2
bkg.y = display.contentHeight / 2
localGroup:insert(bkg)

local back = widget.newButton{
	default = "back.png",
	over = "back_over.png",
	onRelease = backMain,
	id = "back",
	width = 44, height = 44
}
back.x = 297; back.y = 	20 + display.screenOriginY + adMargin
localGroup:insert(back)

local function onKeyEvent( event )
    local keyname = event.keyName;
    if (event.phase == "up" and (event.keyName=="back" or event.keyName=="menu")) then
        if keyname == "back" then
            backMain();
		end
    end
    return true;
end
 --add the runtime event listener
if system.getInfo( "platformName" ) == "Android" then  
	Runtime:addEventListener( "key", onKeyEvent ) 
end


-- Button Information
local levelButton = {}

-- Button Row 1
levelButton[1] = {}
levelButton[1].default = "levelbox.png"
levelButton[1].over = "levelbox.png"
levelButton[1].onRelease = playLevel
levelButton[1].id = "level_1"
levelButton[1].text = "1"
levelButton[1].x = 60
levelButton[1].y = 150

levelButton[2] = {}
levelButton[2].default = "levelbox.png"
levelButton[2].over = "levelbox.png"
levelButton[2].onRelease = playLevel
levelButton[2].id = "level_2"
levelButton[2].text = "2"
levelButton[2].x = 110
levelButton[2].y = 150

levelButton[3] = {}
levelButton[3].default = "levelbox.png"
levelButton[3].over = "levelbox.png"
levelButton[3].onRelease = playLevel
levelButton[3].id = "level_3"
levelButton[3].text = "3"
levelButton[3].x = 160
levelButton[3].y = 150

levelButton[4] = {}
levelButton[4].default = "levelbox.png"
levelButton[4].over = "levelbox.png"
levelButton[4].onRelease = playLevel
levelButton[4].id = "level_4"
levelButton[4].text = "4"
levelButton[4].x = 210
levelButton[4].y = 150

levelButton[5] = {}
levelButton[5].default = "levelbox.png"
levelButton[5].over = "levelbox.png"
levelButton[5].onRelease = playLevel
levelButton[5].id = "level_5"
levelButton[5].text = "5"
levelButton[5].x = 260
levelButton[5].y = 150

-- Button Row 2
levelButton[6] = {}
levelButton[6].default = "levelbox.png"
levelButton[6].over = "levelbox.png"
levelButton[6].onRelease = playLevel
levelButton[6].id = "level_6"
levelButton[6].text = "6"
levelButton[6].x = 60
levelButton[6].y = 200

levelButton[7] = {}
levelButton[7].default = "levelbox.png"
levelButton[7].over = "levelbox.png"
levelButton[7].onRelease = playLevel
levelButton[7].id = "level_7"
levelButton[7].text = "7"
levelButton[7].x = 110
levelButton[7].y = 200

levelButton[8] = {}
levelButton[8].default = "levelbox.png"
levelButton[8].over = "levelbox.png"
levelButton[8].onRelease = playLevel
levelButton[8].id = "level_8"
levelButton[8].text = "8"
levelButton[8].x = 160
levelButton[8].y = 200

levelButton[9] = {}
levelButton[9].default = "levelbox.png"
levelButton[9].over = "levelbox.png"
levelButton[9].onRelease = playLevel
levelButton[9].id = "level_9"
levelButton[9].text = "9"
levelButton[9].x = 210
levelButton[9].y = 200

levelButton[10] = {}
levelButton[10].default = "levelbox.png"
levelButton[10].over = "levelbox.png"
levelButton[10].onRelease = playLevel
levelButton[10].id = "level_10"
levelButton[10].text = "10"
levelButton[10].x = 260
levelButton[10].y = 200

-- Button Row 3
levelButton[11] = {}
levelButton[11].default = "levelbox.png"
levelButton[11].over = "levelbox.png"
levelButton[11].onRelease = playLevel
levelButton[11].id = "level_11"
levelButton[11].text = "11"
levelButton[11].x = 60
levelButton[11].y = 250

levelButton[12] = {}
levelButton[12].default = "levelbox.png"
levelButton[12].over = "levelbox.png"
levelButton[12].onRelease = playLevel
levelButton[12].id = "level_12"
levelButton[12].text = "12"
levelButton[12].x = 110
levelButton[12].y = 250

levelButton[13] = {}
levelButton[13].default = "levelbox.png"
levelButton[13].over = "levelbox.png"
levelButton[13].onRelease = playLevel
levelButton[13].id = "level_13"
levelButton[13].text = "13"
levelButton[13].x = 160
levelButton[13].y = 250

levelButton[14] = {}
levelButton[14].default = "levelbox.png"
levelButton[14].over = "levelbox.png"
levelButton[14].onRelease = playLevel
levelButton[14].id = "level_14"
levelButton[14].text = "14"
levelButton[14].x = 210
levelButton[14].y = 250

levelButton[15] = {}
levelButton[15].default = "levelbox.png"
levelButton[15].over = "levelbox.png"
levelButton[15].onRelease = playLevel
levelButton[15].id = "level_15"
levelButton[15].text = "15"
levelButton[15].x = 260
levelButton[15].y = 250

-- Button Row 4
levelButton[16] = {}
levelButton[16].default = "levelbox.png"
levelButton[16].over = "levelbox.png"
levelButton[16].onRelease = playLevel
levelButton[16].id = "level_16"
levelButton[16].text = "16"
levelButton[16].x = 60
levelButton[16].y = 300

levelButton[17] = {}
levelButton[17].default = "levelbox.png"
levelButton[17].over = "levelbox.png"
levelButton[17].onRelease = playLevel
levelButton[17].id = "level_17"
levelButton[17].text = "17"
levelButton[17].x = 110
levelButton[17].y = 300

levelButton[18] = {}
levelButton[18].default = "levelbox.png"
levelButton[18].over = "levelbox.png"
levelButton[18].onRelease = playLevel
levelButton[18].id = "level_18"
levelButton[18].text = "18"
levelButton[18].x = 160
levelButton[18].y = 300

levelButton[19] = {}
levelButton[19].default = "levelbox.png"
levelButton[19].over = "levelbox.png"
levelButton[19].onRelease = playLevel
levelButton[19].id = "level_19"
levelButton[19].text = "19"
levelButton[19].x = 210
levelButton[19].y = 300

levelButton[20] = {}
levelButton[20].default = "levelbox.png"
levelButton[20].over = "levelbox.png"
levelButton[20].onRelease = playLevel
levelButton[20].id = "level_20"
levelButton[20].text = "20"
levelButton[20].x = 260
levelButton[20].y = 300

--[[ Button Row 5
levelButton[21] = {}
levelButton[21].default = "levelbox.png"
levelButton[21].over = "levelbox.png"
levelButton[21].onRelease = playLevel
levelButton[21].id = "level_21"
levelButton[21].text = "21"
levelButton[21].x = 60
levelButton[21].y = 350

levelButton[22] = {}
levelButton[22].default = "levelbox.png"
levelButton[22].over = "levelbox.png"
levelButton[22].onRelease = playLevel
levelButton[22].id = "level_22"
levelButton[22].text = "22"
levelButton[22].x = 110
levelButton[22].y = 350

levelButton[23] = {}
levelButton[23].default = "levelbox.png"
levelButton[23].over = "levelbox.png"
levelButton[23].onRelease = playLevel
levelButton[23].id = "level_23"
levelButton[23].text = "23"
levelButton[23].x = 160
levelButton[23].y = 350

levelButton[24] = {}
levelButton[24].default = "levelbox.png"
levelButton[24].over = "levelbox.png"
levelButton[24].onRelease = playLevel
levelButton[24].id = "level_24"
levelButton[24].text = "24"
levelButton[24].x = 210
levelButton[24].y = 350

levelButton[25] = {}
levelButton[25].default = "levelbox.png"
levelButton[25].over = "levelbox.png"
levelButton[25].onRelease = playLevel
levelButton[25].id = "level_25"
levelButton[25].text = "25"
levelButton[25].x = 260
levelButton[25].y = 350

--Button Row 6
levelButton[26] = {}
levelButton[26].default = "levelbox.png"
levelButton[26].over = "levelbox.png"
levelButton[26].onRelease = playLevel
levelButton[26].id = "level_26"
levelButton[26].text = "21"
levelButton[26].x = 60
levelButton[26].y = 310

levelButton[27] = {}
levelButton[27].default = "levelbox.png"
levelButton[27].over = "levelbox.png"
levelButton[27].onRelease = playLevel
levelButton[27].id = "level_27"
levelButton[27].text = "27"
levelButton[27].x = 110
levelButton[27].y = 310

levelButton[28] = {}
levelButton[28].default = "levelbox.png"
levelButton[28].over = "levelbox.png"
levelButton[28].onRelease = playLevel
levelButton[28].id = "level_28"
levelButton[28].text = "28"
levelButton[28].x = 160
levelButton[28].y = 310

levelButton[29] = {}
levelButton[29].default = "levelbox.png"
levelButton[29].over = "levelbox.png"
levelButton[29].onRelease = playLevel
levelButton[29].id = "level_29"
levelButton[29].text = "29"
levelButton[29].x = 210
levelButton[29].y = 310

levelButton[30] = {}
levelButton[30].default = "levelbox.png"
levelButton[30].over = "levelbox.png"
levelButton[30].onRelease = playLevel
levelButton[30].id = "level_20"
levelButton[30].text = "30"
levelButton[30].x = 260
levelButton[30].y = 310

-- Button Row 7
levelButton[31] = {}
levelButton[31].default = "levelbox.png"
levelButton[31].over = "levelbox.png"
levelButton[31].onRelease = playLevel
levelButton[31].id = "level_31"
levelButton[31].text = "21"
levelButton[31].x = 60
levelButton[31].y = 360

levelButton[32] = {}
levelButton[32].default = "levelbox.png"
levelButton[32].over = "levelbox.png"
levelButton[32].onRelease = playLevel
levelButton[32].id = "level_32"
levelButton[32].text = "32"
levelButton[32].x = 110
levelButton[32].y = 360

levelButton[33] = {}
levelButton[33].default = "levelbox.png"
levelButton[33].over = "levelbox.png"
levelButton[33].onRelease = playLevel
levelButton[33].id = "level_33"
levelButton[33].text = "33"
levelButton[33].x = 160
levelButton[33].y = 360

levelButton[34] = {}
levelButton[34].default = "levelbox.png"
levelButton[34].over = "levelbox.png"
levelButton[34].onRelease = playLevel
levelButton[34].id = "level_34"
levelButton[34].text = "34"
levelButton[34].x = 210
levelButton[34].y = 360

levelButton[35] = {}
levelButton[35].default = "levelbox.png"
levelButton[35].over = "levelbox.png"
levelButton[35].onRelease = playLevel
levelButton[35].text = "25"
levelButton[35].x = 260
levelButton[35].y = 360

-- Button Row 8
levelButton[36] = {}
levelButton[36].default = "levelbox.png"
levelButton[36].over = "levelbox.png"
levelButton[36].onRelease = playLevel
levelButton[36].id = "level_36"
levelButton[36].text = "36"
levelButton[36].x = 60
levelButton[36].y = 410

levelButton[37] = {}
levelButton[37].default = "levelbox.png"
levelButton[37].over = "levelbox.png"
levelButton[37].onRelease = playLevel
levelButton[37].id = "level_37"
levelButton[37].text = "37"
levelButton[37].x = 110
levelButton[37].y = 410

levelButton[38] = {}
levelButton[38].default = "levelbox.png"
levelButton[38].over = "levelbox.png"
levelButton[38].onRelease = playLevel
levelButton[38].id = "level_38"
levelButton[38].text = "38"
levelButton[38].x = 160
levelButton[38].y = 410

levelButton[39] = {}
levelButton[39].default = "levelbox.png"
levelButton[39].over = "levelbox.png"
levelButton[39].onRelease = playLevel
levelButton[39].id = "level_39"
levelButton[39].text = "39"
levelButton[39].x = 210
levelButton[39].y = 410

levelButton[40] = {}
levelButton[40].default = "levelbox.png"
levelButton[40].over = "levelbox.png"
levelButton[40].onRelease = playLevel
levelButton[40].id = "level_40"
levelButton[40].text = "40"
levelButton[40].x = 260
levelButton[40].y = 410
--]]

-- New Button Fuction
local function newButton(button)
	local buttonName = levelButton[button].text
	if ( level:retrieve( "levelPack1" ) >= button ) then
		local buttonName = widget.newButton{
			default = "levelbox.png",
			over = "levelbox_over.png",
			onRelease = levelButton[button].onRelease,
			id = levelButton[button].id,
			label = levelButton[button].text,
			labelColor = { default={ 237, 237, 237, 255 }, over={ 118, 118, 118, 255 } },
			width = 58, height = 58
		}
		buttonName.x = levelButton[button].x
		buttonName.y = levelButton[button].y
		localGroup:insert(buttonName)
	else
		local buttonName = display.newImageRect( "lockedlevel.png", 58, 58 )
		buttonName.x = levelButton[button].x
		buttonName.y = levelButton[button].y
		localGroup:insert(buttonName)
	end
end

for counter= 1,20 do
    newButton(counter)
end
--[[
local function multiplayerButton()
	if ( level:retrieve( "levelPack1" ) >= 20 ) then
		local multiplayerButton = widget.newButton{
			default = "multiplayer-levelselect.png",
			over = "multiplayer-levelselect_over.png",
			onRelease = playMultiplayer,
			id = multiplayer,
			font = fontName,
			fontSize = 30,
			offset = -1,
			label = "Multiplayer",
			labelColor = { default={ 237, 237, 237, 255 }, over={ 118, 118, 118, 255 } },
			width = 260, height = 58
		}
		multiplayerButton.x = 160
		multiplayerButton.y = 350
		localGroup:insert(multiplayerButton)
	else
		local multiplayerButton = display.newImageRect( "lockedmultiplayer-levelselect.png", 260, 58 )
		multiplayerButton.x = 160
		multiplayerButton.y = 400
		localGroup:insert(multiplayerButton)
	end
end
multiplayerButton()
--]]
-- Load Highscores
local scoreSave = ice:loadBox( "scoreSave" )
--scoreSave:load()
local level1 = scoreSave:retrieve( "level1" )
--print(scoreSave:retrieve( "level1" ))
	if level1 == nil then
		level1 = 0
	end
local level2 = scoreSave:retrieve( "level2" )
	if level2 == nil then
		level2 = 0
	end
local level3 = scoreSave:retrieve( "level3" )
	if level3 == nil then
		level3 = 0
	end
local level4 = scoreSave:retrieve( "level4" )
	if level4 == nil then
		level4 = 0
	end
local level5 = scoreSave:retrieve( "level5" )
	if level5 == nil then
		level5 = 0
	end
local level6 = scoreSave:retrieve( "level6" )
	if level6 == nil then
		level6 = 0
	end
local level7 = scoreSave:retrieve( "level7" )
	if level7 == nil then
		level7 = 0
	end
local level8 = scoreSave:retrieve( "level8" )
	if level8 == nil then
		level8 = 0
	end
local level9 = scoreSave:retrieve( "level9" )
	if level9 == nil then
		level9 = 0
	end
local level10 = scoreSave:retrieve( "level10" )
	if level10 == nil then
		level10 = 0
	end
local level11 = scoreSave:retrieve( "level11" )
	if level11 == nil then
		level11 = 0
	end
local level12 = scoreSave:retrieve( "level12" )
	if level12 == nil then
		level12 = 0
	end
local level13 = scoreSave:retrieve( "level13" )
	if level13 == nil then
		level13 = 0
	end
local level14 = scoreSave:retrieve( "level14" )
	if level14 == nil then
		level14 = 0
	end
local level15 = scoreSave:retrieve( "level15" )
	if level15 == nil then
		level15 = 0
	end
local level16 = scoreSave:retrieve( "level16" )
	if level16 == nil then
		level16 = 0
	end
local level17 = scoreSave:retrieve( "level17" )
	if level17 == nil then
		level17 = 0
	end
local level18 = scoreSave:retrieve( "level18" )
	if level18 == nil then
		level18 = 0
	end
local level19 = scoreSave:retrieve( "level19" )
	if level19 == nil then
		level19 = 0
	end
local level20 = scoreSave:retrieve( "level20" )
	if level20 == nil then
		level20 = 0
	end


local pack1Score = level1 + level2 + level3 + level4 + level5 + level6 + level7 + level8 + level9 + level10 + level11 + level12 + level13 + level14 + level15 + level16 + level17 + level18 + level19 + level20

print(pack1Score)


scoreSave:storeIfHigher( "pack1Score", pack1Score ) 
scoreSave:save()

local scoreDisplay = display.newText("Score: "..pack1Score, 60, 350, fontName, 40)
scoreDisplay.x = 160


------------------------------------------------------------------------------
return localGroup
end