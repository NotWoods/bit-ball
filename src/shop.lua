module(..., package.seeall)

function new()
local localGroup = display.newGroup()
local store = require("store")
------------------------------------------------------------------------------

local store = ice:loadBox( "level" )

local noAdsPrice = 0.99

-- These are the button-trigged fuctions

local function backToMenu (event)
	print("Back to Main Menu")
	director:changeScene ("menu", "moveFromRight")
end

local function onComplete( event )
	print( "index => ".. event.index .. "    action => " .. event.action )

	local action = event.action
	if "clicked" == event.action then
		if 2 == event.index then
			-- If Try Again pressed
			store.purchase( {"com.tigeroakes.bitball.noads"} )
		end
	end
end

local listOfProducts = 
{
    "com.tigeroakes.bitball.noads",
}

local function productCallback( event )
        print("showing valid products", #event.products)
        for i=1, #event.products do
                print(event.products[i].title)    -- This is a string.
                print(event.products[i].description)    -- This is a string.
                print(event.products[i].price)    -- This is a number.
                print(event.products[i].localizedPrice)    -- This is a string.
				noAdsPrice = event.products[1].localizedPrice
                print(event.products[i].productIdentifier)    -- This is a string.
        end
 
        print("showing invalidProducts", #event.invalidProducts)
        for i=1, #event.invalidProducts do
                print(event.invalidProducts[i])
        end
end
 
store.loadProducts( listOfProducts, productCallback )

local function transactionCallback( event )
    local transaction = event.transaction

    if transaction.state == "purchased" then
    
        -- Transaction was successful; unlock/download content now

        print("Transaction succuessful!")
        print("productIdentifier", transaction.productIdentifier)
        print("receipt", transaction.receipt)
        print("transactionIdentifier", transaction.identifier)
        print("date", transaction.date)
		if transaction.productIdentifier == "com.tigeroakes.bitball.noads" then
			store:store( "noAds", 1 )
			store:save()
		end
		
		local alert = native.showAlert( "Success!", "Transaction successful; ads are now disabled.", { "OK" }, onComplete )
    
    elseif  transaction.state == "restored" then
    
       -- You'll never reach this transaction state on Android.
	   print("Transaction restored (from previous session)")
		

    elseif  transaction.state == "refunded" then
    
        -- Android-only; user refunded their purchase

        -- Restrict/remove content associated with above productId now
		if transaction.productIdentifier == "com.tigeroakes.bitball.noads" then
			store:store( "noAds", 0 )
			store:save()
		end
		
		local alert = native.showAlert( "Success!", "Refund successful; ads are now enabled.", { "OK" }, onComplete )
    
    elseif transaction.state == "cancelled" then
    
        -- Transaction was cancelled; tell your app to react accordingly here
		print("User cancelled transaction")
		
		local alert = native.showAlert( "Oops!", "Transaction cancelled.", { "OK", "Try Again" }, onComplete )

    elseif transaction.state == "failed" then        
    
        -- Transaction failed; tell you app to react accordingly here
		local alert = native.showAlert( "Oops!", "Transaction failed.", { "OK", "Try Again" }, onComplete )
    end

    -- The following must be called after transaction is complete.
    -- If your In-app product needs to download, do not call the following
    -- function until AFTER the download is complete:

    store.finishTransaction( transaction )
end

if store.availableStores.apple then
    store.init("apple", transactionCallback)
    
elseif store.availableStores.google then
    store.init("google", transactionCallback)
end

local function buyNoAds()
	store.purchase( {"com.tigeroakes.bitball.noads"} )
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

local noAdsButton = display.newText( "Turn Off Ads "..noAdsPrice, 0, 0, fontName, 20 )
noAdsButton.x = 160; noAdsButton.y = 240
localGroup:insert(noAdsButton)
noAdsButton:addEventListener( "touch", buyNoAds )

------------------------------------------------------------------------------
return localGroup
end