-- design.lua :  Custom layout screen

-- Karen Exline
-- CS 371
-- HW5: Arkonite

-- includes and physics
local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
local widget = require("widget")
physics.start()
physics.setGravity(0,0)

-- Custom objects
local gridBlock = require("gridblock");

-- Convenience variables
local xx = display.contentCenterX; local ww=display.contentWidth;
local yy = display.contentCenterY; local hh=display.contentHeight;
local fs=hh/20;  local ff=native.systemFont;

-- scene variables

local btnY = hh*.92;

-- ==== Graphics ======================================================

local btnOptions = { frames = {	
 	{ x = 0, y =15, width = 322, height = 65},  -- some button
  	{ x = 322, y =15, width = 314, height = 65},  -- another button
}}

local btnSheet = graphics.newImageSheet( "somesheet.png", btnOptions );

-- ==== block creation listeners =======================================

local function placeBlock(event)
   local block=event.target;

   if event.phase == "began" then
		block.markX = block.x;
		block.markY = block.y;
	elseif event.phase == "moved" then
        if (block.markX ~= nil) then
			local x = (event.x - event.xStart) + block.markX;
			local y = (event.y - event.yStart) + block.markY;

			block.x = x;
			block.y = y;
		end		
	elseif event.phase == "ended" then
		local idx=table.getn(setupList)+1;
		setupList:insert({idx=1,type=block.type,xPos=block.x,yPos=block.y});
		--block:removeEventListener("touch",placeBlock);
	elseif event.phase =="canceled" then

	end
end;

local function rbCreate(event)
	if event.phase == "began" then
		--display.getCurrentStage():setFocus( event.target );
		local b=display.newRect(event.target.x, event.target.y, (ww-10)/6, yy/10); 
		b:toFront();
		b:setFillColor(1,.2,.2,.8);
		b:setStrokeColor(0,0,0); b.strokeWidth=2;
		b.type="red"; b.xPos=-1; b.YPos=-1;
		b:addEventListener("touch", placeBlock);
		--display.getCurrentStage():setFocus( b );
	end
end;

local function ybCreate(event)



end;

function bbCreate(event)


end;

function gbCreate(event)


end;

-- ==== Set up block creation buttons ===================================

function palette(o)
	local sceneGroup = o.view;

	-- display.newRect( x, y, width, height )
	local r = display.newRect(ww/5, btnY, (ww-10)/6, yy/10); 
	r:setFillColor(1,0,0,1);
	sceneGroup:insert(r);
	r:addEventListener("touch",rbCreate);


	local b = display.newRect(2*(ww/5), btnY, (ww-10)/6, yy/10); 
	b:setFillColor(0,0,1,1);
	sceneGroup:insert(b);
	b:addEventListener("touch",bbCreate);

	local y = display.newRect(3*(ww/5), btnY, (ww-10)/6, yy/10); 
	y:setFillColor(1,1,0,1);
	sceneGroup:insert(y);
	y:addEventListener("touch",ybCreate);

	local g = display.newRect(4*(ww/5), btnY, (ww-10)/6, yy/10); 
	g:setFillColor(.6, .6, .6, 1);
	sceneGroup:insert(g);
	g:addEventListener("touch",gbCreate);

end


-- ==== Scene functions =================================================
function scene:create(event)
	local phase=event.phase;
	local sceneGroup = self.view;

	if phase=="will" then

	elseif phase=="did" then

	end
end

function scene:show (event)
	local phase=event.phase;
	local sceneGroup = self.view;

	local xp=0; local yp=0; local place;

	if phase=="will" then
		local row,col;
		for row=1, 17, 1 do
			for col=1,6,1 do
				place = gridBlock:new({xPos=xp, yPos=yp});
				place:show();
				xp=xp+place.width+1;
			end
			xp=0;
			yp=yp+place.height;
		end

		palette(self);


	elseif phase=="did" then

	end
end

function scene:hide(event)
	local phase=event.phase;
	local sceneGroup = self.view;

	if phase=="will" then

	elseif phase=="did" then

	end
end

function scene:destroy(event)
	local phase=event.phase;
	local sceneGroup = self.view;
	sceneGroup:removeSelf();
	sceneGroup=nil;
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene;