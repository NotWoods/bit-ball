module(..., package.seeall)
local socket = require ("socket")
local http = require("socket.http")
--====================================================================--
-- Lunar Ads
--====================================================================--

--[[

 ******************
 * INFORMATION
 ******************

 - Version 1.5
 - Web: http://lunarads.com/
 - Support: support@lunarads.com
 
 ******************
 * HISTORY
 ******************
 1.5 -
 		Changed how it calculates screen dimensions.
 		Added dynamicScaling to help with certain dimensions.
 1.4 -  Fixed some issues with tablet sizes.
 		Can now send back ad sizes based on screen size.
 		Retina iPad support added.
 		Added support for ad refresh admin on web side.
 		Added hideLunar() to kill ad.
 		Added getWidth(), and getHeight() to get ad size returned.
 		Added a callback that gets called when an ad is touched. (NOTE: function must be declared before lunar call)
 1.3 - 	Added more options to place ad on the screen.
 		Changed how to call showLunar().
 		Added support for multiple screen dimensions.
 		Sends proper device screen dimensions now.
 1.2 -  Bug fixes
 1.1 - 	Internal Version
 1.0 - 	Initial Version
 
 Syntax:
 lunar.showLunar (params)

 Example:
 local lunar = require "lunar"

 -- Display ad at top left of screen, and fires callback.
 function lunarCallBack()
 	print ("Ad touched")
 end
 
 lunar.showLunar ({
		x = 0,
		y = 0,
		channel = MY_LUNAR_CHANNEL,
		pubid = MY_LUNAR_PUBID,
		appver = APP_VERSION,
		callBack = lunarCallBack
 })


 Parameters:

 * channel = Lunar channel to send
 * pubid = your lunar publisher ID

 Optional Parameters:

 * x = value (upper left ad position. Defaults to 0.)
 * y = value (top ad position. Defaults to 0.)
 Note: x and y overrides Halign and Valign.

 Halign
 * "left" (puts ad on the left side of the screen)
 * "right" (puts ad on the right side of the screen)
 * "center" (centers ad on the screen)

 Valign
 * "top" (put ad at top of screen)
 * "middle" (put ad in the middle of the screen)
 * "bottom" (put ad at the bottom of the screen)

 * appver = string (current version of your app)

]]--
--====================================================================--

local lunarSDKVer = "1.5"

scaleX = tonumber(string.format("%.04f", 1 / display.contentScaleX))
scaleY = tonumber(string.format("%.04f", 1 / display.contentScaleY))

local lunarChannel=""
local lunarPubID=""

local adX
local adY
local adWidth = 0
local adHeight = 0
local adFurl
local deviceWidth = display.contentWidth --viewableContentWidth
local deviceHeight = display.contentHeight --viewableContentHeight
local actualDeviceWidth = math.ceil(deviceWidth * scaleX)
local actualDeviceHeight = math.ceil(deviceHeight * scaleY)
local deviceID = system.getInfo( "deviceID" )
local deviceBuild = system.getInfo( "platformVersion")
local lunarLoadCount
local lunarCountNeeded
local lunarCallback = nil
local lunarRefresh = nil
local lunarTimer = nil
local lunarParams = nil

-- Simulator handles callbacks a little differently
platformName = system.getInfo("platformName")
if (platformName == "Android") or (platformName == "iPhone OS") then lunarCountNeeded = 1 else lunarCountNeeded = 2 end
	
-----------------------------------------------------------------------------

function getAdWidth()
	return adWidth
end

function getAdHeight()
	return adHeight
end

local function isStringThere(string1, string2)
	returnValue = string.find(string1,string2)
	
	if returnValue == nil then returnValue = false end
	return returnValue
end

local function fromCSV (s)
  s = s .. ','        -- ending comma
  local t = {}        -- table to collect fields
  local fieldstart = 1
  repeat
	-- next field is quoted? (start with `"'?)
	if string.find(s, '^"', fieldstart) then
	  local a, c
	  local i  = fieldstart
	  repeat
		-- find closing quote
		a, i, c = string.find(s, '"("?)', i+1)
	  until c ~= '"'    -- quote not followed by quote?
	  if not i then error('unmatched "') end
	  local f = string.sub(s, fieldstart+1, i-1)
	  table.insert(t, (string.gsub(f, '""', '"')))
	  fieldstart = string.find(s, ',', i) + 1
	else                -- unquoted; find next comma
	  local nexti = string.find(s, ',', fieldstart)
	  table.insert(t, string.sub(s, fieldstart, nexti-1))
	  fieldstart = nexti + 1
	end
  until fieldstart > string.len(s)
  return t
end

local function lunarFindDeviceIP()
	local client = socket.connect( "www.lunarads.com", 80 )
	local ip, port = client:getsockname()
	client:close()
	return ip        
end 

local function forwardAdTouch(url)
	print ("Lunar Ads: Ad Touched")
	
	if (lunarCallBack) then
		result = lunarCallBack()
	end
	
	system.openURL(url)
end

local function lunarWebViewCallback(event)
	local shouldLoad = true
	lunarLoadCount = lunarLoadCount + 1
	
	-- Was there an error?
	if event.errorCode then
		print( "Lunar Ads: Error - " .. tostring( event.errorMessage ))
		shouldLoad = false
	elseif isStringThere(event.url, "corona:close") then
		shouldLoad = false
	elseif adFurl == 1 then
		if isStringThere(event.url, "web.asp") then
		   forwardAdTouch(event.url)
		   
		end
	elseif adFurl == 2 then
		if isStringThere(event.url, "default.asp") == false then
			forwardAdTouch(event.url)
			
		end
	elseif adFurl == 3 then
		if (lunarLoadCount > lunarCountNeeded) then
			lunarLoadCount = 0
			forwardAdTouch(event.url)
			shouldLoad = false
			
		end
	end
	return shouldLoad
end

local function cancelLunarTimer()
	if lunarTimer then
		timer.cancel( lunarTimer )
		lunarTimer = nil
	end
end

local function displayLunar()
	native.cancelWebPopup()
	showLunar( lunarParams)
end

local function startLunarTimer(t)
	if (t ~= 0) then
		lunarTimer = timer.performWithDelay( t, displayLunar,0)
	end
end

function hideLunar()
	lunarParams = nil
	cancelLunarTimer()
	native.cancelWebPopup()
end

function showLunar( params )

	if http.request( "http://www.google.com" ) == nil then
		print("Lunar Ads: No Internet Connection.")
	else
		if (lunarParams == nil) then lunarParams = params end
		
		lunarChannel = params.channel or ""
		lunarPubID = params.pubid or ""
		AppVer = params.appver or ""
		Valign = params.Valign
		Halign = params.Halign
		paramsY = params.y
		paramsX = params.x
		
		if (params.dynamicScaling) then paramsScaling = params.dynamicScaling else paramsScaling = false end
		
		if ( params.callBack and ( type(params.callBack) == "function" ) ) then
				lunarCallBack = params.callBack
		end
		
		lunarLoadCount = 0
		
		local ip = lunarFindDeviceIP()
		
		local function getParams(event)
	
			local strParams = (event.response)
			
			if isStringThere ( strParams, "nolunarad" ) then
				print ("Lunar Ads: No Ad Returned")
			else
				print ("Lunar Ads: Ad Returned")
			
				local params = fromCSV(strParams,",")
				pointer = 1
				
				if (tonumber(params[1]) == 1) then
					adX = 0
					adY = 0
					adWidth = deviceWidth
					adHeight = deviceHeight
					pointer = pointer + 1
				else
					adWidth = tonumber(params[2])
					adHeight = tonumber(params[3])
					
					if (paramsScaling) then
						adWidth = adWidth * scaleX
						adHeight = adHeight * scaleY
						
						if (deviceWidth > adWidth) then
							scaleFactor = actualDeviceWidth / adWidth
							adWidth = adWidth * scaleFactor
							adHeight = adHeight * scaleFactor
						end
					end
					
					if ( paramsX and type(paramsX) == "number" ) then 
						adX = paramsX 
					else
						if ( Halign ) then align = Halign else Halign = "center" end
						if (Halign == "left") then
							adX = math.abs(display.screenOriginX)
						elseif (Halign == "right") then
							adX = deviceWidth - adWidth
						else
							adX = deviceWidth * 0.5 - adWidth * 0.5
						end
					end
					
					if ( paramsY and type(paramsY) == "number" ) then 
						adY = paramsY
					else
						if ( Valign ) then align = Valign else Valign = "top" end
						if (Valign == "top") then
							adY =  math.abs(display.screenOriginY)
						elseif (Valign == "middle") then
							adY = deviceHeight * 0.5 - adHeight * 0.5
						else
							adY = deviceHeight - adHeight
						end
					end
					pointer = pointer + 3
				end
					
				-- Round everything
				adX = math.floor (adX)
				adY = math.floor (adY)
				adWidth = math.floor (adWidth)
				adHeight = math.floor (adHeight)
				
				nn = params[pointer]
				adFurl = tonumber(params[pointer+1])
				
				lunarRefresh = (tonumber(params[pointer+2]) * 1000)
				
				if (event.errorCode) then
					print("Lunar Ads: Error - "..tostring(event.errorMessage))
				else
					native.cancelWebPopup()
					
					adPages = {"testad.asp","testad2.asp","default.asp"}
					
					Lunar = native.showWebPopup(adX,adY,adWidth,adHeight, "http://c.lunarads.com/default.asp?c="..lunarChannel.."&n="..nn.."&d="..deviceID.."&w="..actualDeviceWidth.."&h="..actualDeviceHeight.."&b="..deviceBuild.."&sdk="..lunarSDKVer.."&p="..lunarPubID.."&i="..ip.."&ver="..AppVer, {hasBackground=false,urlRequest = lunarWebViewCallback,autoCancel=false} )
					if (lunarTimer == nil) then startLunarTimer(lunarRefresh) end
					
					print (adX,adY,adWidth,adHeight,nn,adFurl,lunarChannel, DeviceBuild,lunarSDKVer,deviceID,actualDeviceWidth,actualDeviceHeight)
				end
			end
		end
		
		--Get ad size and dimensions
		network.request( "http://c.lunarads.com/getparams.asp?c="..lunarChannel.."&p="..lunarPubID.."&i="..ip.."&ver="..AppVer.."&w="..actualDeviceWidth.."&h="..actualDeviceHeight, "GET", getParams )
	end
end