root = getRootElement()
resourceRoot = getResourceRootElement( getThisResource())

local isDebugMode = false
local illegal = 50
local price = 10
local illegalMoltiplier = 3
local illegalLevel = 1

garagesInfo = { }
merchandiseInfo = { }

--Function
function updateGarage(gId)
   garagesInfo[ gID ].stuff = generateStuff()
end

function generateStuff()
	local findIillegal = false
	if  math.random( 100 )  < illegal then
		findIillegal = true
	end
   
	while true do
		local merch = merchandiseInfo[ math.random( #merchandiseInfo) ]
		
		if findIillegal and merch.illegal == "true" then
			return metch
		elseif (not findIillegal) and merch.illegal == "false" then
			return metch
		end
	end
end

function init()
	isDebugMode = get( "truker.isDebug" )
	illegal = get( "truker.illegal" )
	price = get( "truker.price" )
	illegalMoltiplier = get( "truker.illegalMoltiplier" )
	illegalLevel = get( "truker.illegalLevel" )
	
	local trukerMap = xmlLoadFile( "config.xml" )
	
	local mercs = 0	
	while( xmlFindChild( trukerMap, "stuff", mercs ) ) do
		local tempID = mercs + 1		
		merchandiseInfo[ tempID ] = { }
		
		local stuff_node = xmlFindChild( trukerMap, "stuff", mercs )
		
		merchandiseInfo[ tempID ].name = xmlNodeGetAttribute(stuff_node, "name")		
		merchandiseInfo[ tempID ].illegal = xmlNodeGetAttribute(stuff_node, "isIllegal")
		merchandiseInfo[ tempID ].price = tonumber(xmlNodeGetAttribute(stuff_node, "price" ))
		
		if isDebugMode then
			outputDebugString ( "New stuff:" .. merchandiseInfo[ tempID ].name .. " ".. merchandiseInfo[ tempID ].illegal .. " $" .. merchandiseInfo[ tempID ].price)
		end
		
		mercs = mercs + 1
	end

	local garages = 0	
	while( xmlFindChild( trukerMap, "truker", garages ) ) do
		local tempID = garages + 1		
		garagesInfo[ tempID ] = { }
		
		local garage_node = xmlFindChild( trukerMap, "truker", garages )
		
		garagesInfo[ tempID ].name = xmlNodeGetAttribute(garage_node, "name")
		
		garagesInfo[ tempID ].x = tonumber(xmlNodeGetAttribute(garage_node, "x"))
		garagesInfo[ tempID ].y = tonumber(xmlNodeGetAttribute(garage_node, "y"))
		garagesInfo[ tempID ].z = tonumber(xmlNodeGetAttribute(garage_node, "z"))
		
		garagesInfo[ tempID ].stuff = generateStuff()

		if isDebugMode then
			outputDebugString ( "New truck station at:" .. garagesInfo[ tempID ].x .. " ".. garagesInfo[ tempID ].y .. " " .. garagesInfo[ tempID ].z)
		end
		
		garages = garages + 1
	end
	
	
end
addEventHandler( "onResourceStart", resourceRoot, init)

function onEnterVehicle(thePlayer, seat, jacked)
	if (( getElementModel (source) == 403) or (getElementModel (source)  == 515 )) and (seat == 0) then
	
		triggerClientEvent ( thePlayer, "onTruckEnter", root, garagesInfo )
		
	end
end
addEventHandler( "onVehicleEnter", root, onEnterVehicle)

function onInfoRequest()
	triggerClientEvent ( source, "onTrukerInfo", root, garagesInfo)
end
addEvent("onTrukerInfoRequest", true)
addEventHandler("onTrukerInfoRequest", root, onInfoRequest)

function onConfigRequest()

	config["isDebugMode"] = isDebugMode
	config["isDebugMode"] = illegal
	config["price"] = price
	config["illegalMoltiplier"] = illegalMoltiplier
	config["illegalLevel"] = illegalLevel
	
	triggerClientEvent ( source, "onTrukerConfig", root, config)
end
addEvent("onTrukerClientStarted", true)
addEventHandler("onTrukerClientStarted", root, onConfigRequest)