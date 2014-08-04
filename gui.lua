root = getRootElement()
lplayer = getLocalPlayer()
resourceRoot = getResourceRootElement( getThisResource())

local screenX,screenY = guiGetScreenSize()
     
local guiWindow = nil
local guiLabel = nil
local guiList = nil
local guiButtonA = nil
local guiButtonE = nil


--Function
function drawGui()
	guiWindow = guiCreateWindow(0.5, 0.5, 0.5, 0.35, "Truker Deliver Panel", true)
	guiLabel = guiCreateLabel(0.1, 0.1, 1, 0.1, "Default Location", true, guiWindow)
	guiList = guiCreateGridList(0.1,0.3,0.9,0.5, true,guiWindow)
	
	guiGridListAddColumn(guiList,"Destination",0.16)
	guiGridListAddColumn(guiList,"Distance",0.16)
	guiGridListAddColumn(guiList,"Price",0.16)
	guiGridListAddColumn(guiList,"Illegal",0.16)
	guiGridListAddColumn(guiList,"Type",0.16)
	guiGridListAddColumn(guiList,"$/m",0.16)
	
	guiButtonA = guiCreateButton(0.8, 0.8, 0.1, 0.05, "Accept", true, guiWindow)
	guiButtonA = guiCreateButton(0.1, 0.8, 0.1, 0.05, "Exit", true, guiWindow)
	
	guiSetVisible(guiWindow,false)	
end

function populateGui(startions, cID)
	local cX = startions[cID].x
	local cY = startions[cID].y
	local cZ = startions[cID].z
	
	guiSetText( guiLabel, "Current: " .. startions[cID].name )
	
	for id,station in pairs(startions) do
		
		if not id == cID then
		
			local stuff = station.stuff
			local row = guiGridListAddRow(guiList)
			
			local lX = station.x
			local lY = station.y
			local lZ = station.z
			
			local distance = distance3D(cX, cY, cZ, lX, lY, lZ)
			
			local price = priceCalc(distance, stuff.price, stuff.illegal)
			
			guiGridListSetItemText(guiList, row, 1, station.name, false, false)
			guiGridListSetItemText(guiList, row, 2, distance, false, false)
			guiGridListSetItemText(guiList, row, 3, price, false, true)
			guiGridListSetItemText(guiList, row, 4, if stuff.illegal then 'Yes' else 'No' end, false, false)
			guiGridListSetItemText(guiList, row, 5, stuff.name, false, false)
			guiGridListSetItemText(guiList, row, 6, (price/distance), false, true)
			
			guiGridListSetItemData(guiList,row,1, id)
		end
	end
end

function clearGui()
	guiGridListClear ( guiList )
end

function showGui()
	if not guiGetVisible(guiWindow) then
		guiSetVisible(guiWindow,true)
		toggleAllControls ( false, true, true)
		showCursor(true,true)
	end
end

function hideGui()
	if guiGetVisible(guiWindow) then
		guiSetVisible(guiWindow,false)
		toggleAllControls ( true, true, true)
		showCursor(false,false)
	end
end