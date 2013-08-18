root = getRootElement()
lplayer = getLocalPlayer()
resourceRoot = getResourceRootElement( getThisResource())

local dxInfoLabel = "#236B8E[#FFFFFFPress H to open the panel of the truck drivers #236B8E]"

local startions = { }
local isTruker = false

--Function
function infoRequest()
	triggerServerEvent ( "onTrukerInfoRequest", getLocalPlayer()) 
end

addEventHandler( "onClientResourceStart", resourceRoot, infoRequest);

function infoReceived(garagesInfo)
	startions = garagesInfo
end
addEvent("onTrukerInfo", true)	
addEventHandler("onTrukerInfo", root, infoReceived)

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
		for k, v in pairs( startions ) do
			if source == startions[ k ].marker then
				--Draw Info Gui				
				bindKey ( "h", "down", drawGui )
				
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
				--Hide Info Gui				
				unbindKey ( "h", "down", drawGui )
				
				return
			end
		end		
	end	
end 
addEventHandler ( "onClientMarkerLeave", roor, markerLeave )