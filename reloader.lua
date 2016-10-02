module(..., package.seeall)

function new()
local localGroup = display.newGroup()
------------------------------------------------------------------------------
--Special scrpit if director does not properly reload a level
local function listener( event )
print("refreshLvl "..refreshLvl)
	if refreshLvl == 1 then
		director:changeScene ("level_1", "fade")
	elseif refreshLvl == 2 then
		director:changeScene ("level_2", "fade")
	end
end

timer.performWithDelay(500, listener )

------------------------------------------------------------------------------
return localGroup
end