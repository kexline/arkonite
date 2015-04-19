-- brick.lua: gray inert brick


local xx=display.contentCenterX; local yy=display.contentCenterY;
local ww=display.contentWidth;   local hh=display.contentWidth;


local Brick = require("brick");
local sensorBrick = Brick:new({name="sensorbrick", outline=1, width=(ww-10)/6, height=yy/10, type="sensorbrick"};


function sensorBrick:new(o)
	print("brick:new")
	o = o or {}; 
	setmetatable(o, self);
	self.__index = self;
	return o;
end



function sensorBrick:show(o)
	o=o or {};

	brickWidth=self.width;  brickHeight=self.height;

	function hit(event)
		-- Nothing!  Gray bricks don't interact.
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

	if self.info then
		print(string.format("info=%s",self.info));
		self.textline=display.newText(self.info,self.xPos,self.yPos,fontFace,20);
		self.textline.anchorX=0;
	end;

end

function sensorBrick:removeSelf()
	self.shape:removeSelf();
	if self.textline then self.textline:removeSelf(); end
end

return Brick;