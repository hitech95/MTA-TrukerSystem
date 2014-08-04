root = getRootElement()
lplayer = getLocalPlayer()
resourceRoot = getResourceRootElement( getThisResource())

local dxInfoLabel = "#236B8E[#FFFFFFPress H to open the panel of the truck drivers #236B8E]"

local isDebugMode = false
local illegal = 50
local price = 10
local illegalMoltiplier = 3
local illegalLevel = 1

local startions = { }
local isTruker = false
local isMission = true

--Function
function infoRequest()
	triggerServerEvent ( "onTrukerInfoRequest", getLocalPlayer()) 
end

function distance3D(x1, y1, z1, x2, y2, z2)
	local xd = x2-x1
	local yd = y2-y1
	local zd = z2-z1
	return = math.sqrt(xd*xd + yd*yd + zd*zd)
end

function priceCalc(distance, stuffprice, isIllegal)
	local value = (distance * price) + stuffprice
	
	if(isIllegal) then
		value = value * illegalMoltiplier
	end
	
	return value
end

function drawGui( key, keyState, cID )
	populateGui(stations, cID)
	showGui()
	-- Hide Info Gui
end

function onGuiClose()
	if not isMission then
		-- Show Info Gui
	end
end

function clientStartup()
	triggerServerEvent ( "onTrukerClientStarted", getLocalPlayer()) 
	infoRequest()
end
addEventHandler( "onClientResourceStart", resourceRoot, clientStartup);

function infoReceived(garagesInfo)
	startions = garagesInfo
end
addEvent("onTrukerInfo", true)	
addEventHandler("onTrukerInfo", root, infoReceived)

function configReceived(config)
	isDebugMode = config["isDebugMode"]
	illegal = config["isDebugMode"]
	price = config["price"]
	illegalMoltiplier = config["illegalMoltiplier"]
	illegalLevel = config["illegalLevel"]
end
addEvent("onTrukerConfig", true)	
addEventHandler("onTrukerConfig", root, configReceived)

function onEnterTruck(garagesInfo)
	isTruker = true
	
	for k, v in pairs( startions ) do
		
		startions[ k ].marker = createMarker ( startions[ k ].x, startions[ k ].y , startions[ k ].z, "cylinder", 10, 255, 255, 0, 128)	
		startions[ k ].blip = createBlipAttachedTo ( startions[ k ].marker , 42, 2, 0, 0, 0, 255, 0, 180, lplayer)
		
	end
end
addEvent("onTruckEnter", true)	
addEventHandler("onTruckEnter", root, onEnterTruck)

addEventHandler("onClientVehicleExit", root,
    function(thePlayer, seat)
        if thePlayer == getLocalPlayer() and isTruker then
			for k, v in pairs( startions ) do
				destroyElement(startions[ k ].marker)
				destroyElement(startions[ k ].blip)					
			end
			
			isTruker = false
        end
    end
)

function markerEnter ( thePlayer, matchingDimension )
	if thePlayer == getLocalPlayer() and matchingDimension then
	if isMission then
		-- Chek information stored on tender
	else
		for k, v in pairs( startions ) do
			if source == startions[ k ].marker then
				--Draw Info Gui				
				bindKey ( "h", "down", drawGui, k)
				
				return
			end
		end		
	end	
end
addEventHandler ( "onClientMarkerHit", root, markerEnter )

function markerLeave ( thePlayer, matchingDimension )
    if thePlayer == getLocalPlayer() and matchingDimension then
		for k, v in pairs( startions ) do
			if source == startions[ k ].marker then
				clearGui()		
				unbindKey ( "h" )
				-- Hide Info Gui
				return
			end
		end		
	end	
end 
addEventHandler ( "onClientMarkerLeave", roor, markerLeave )