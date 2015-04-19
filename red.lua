-- redbrick.lua 

-- Karen Exline
-- CS 371
-- HW5: Arkonite


local xx=display.contentCenterX; local yy=display.contentCenterY;
local ww=display.contentWidth;   local hh=display.contentWidth;

local Brick = require("Brick");

local Red = Brick:new({color={r=1,g=0,b=0}, type="red"});

function Red:new(o)
	print("brick:new")
	o = o or {}; 
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function Red:show(o)
	o=o or {};

	brickWidth=self.width;  brickHeight=self.height;

	function hit(event)
		local box=event.target;

		if box.pp.type=="blue" then
			box.pp.type="red"
			box:setFillColor(1,0,0);
			--print("boxHit: blue in red")

		else

			box.pp.type="none"
			box:removeSelf();
			boxesLeft=boxesLeft-1; -- boxesLeft is a global from level1
			--print("boxHit: red in red")
		end
	end

	-- repositioning -- lifted wholesale from an in-class example
	-- TODO: overlap prevention
	local function brickDrag(event)
		local phase=event.phase;
		local thing=event.source;
		print ("in brickDrag")

	 	if event.phase == "began" then		
			thing.shape.markX = thing.shape.x 
	 	elseif event.phase == "moved" then	 	
		 	local x = (event.x - event.xStart) + thing.markX	 	
		 	
		 	if (x <= 20 + thing.width/2) then
			   thing.x = 20+thing.width/2;
			elseif (x >= display.contentWidth-20-thing.width/2) then
			   thing.x = display.contentWidth-20-thing.width/2;
			else
			   thing.x = x;		
		end
	 end
	end


	self.shape=display.newRect(self.xPos, self.yPos, self.width, self.height);
	self.shape.anchorX=0; self.shape.anchorY=0;
	self.shape:setFillColor(self.color.r,self.color.g,self.color.b);
	self.shape.strokeWidth=self.outline;
	self.shape:setStrokeColor(0,0,0)
	self.shape.pp = self;  -- need pointer back to parent for printMe
	
	self.shape:addEventListener("collision",hit);
	self.shape:addEventListener("move",brickDrag);
	physics.addBody(self.shape,"static");

	self.info=self.info or nil;

	if self.info then
		print(string.format("info=%s",self.info));

		self.textline=display.newText(self.info,self.xPos,self.yPos,fontFace,20);
		self.textline.anchorX=0;
	end;

end


return Red;
