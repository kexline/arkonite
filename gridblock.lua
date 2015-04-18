-- gridblock.lua

local xx=display.contentCenterX; local yy=display.contentCenterY;
local ww=display.contentWidth;   local hh=display.contentWidth;

local Brick = require("Brick");
local Red = require("Red");

local GridBlock = Brick:new({color={r=1,g=1,b=0},type="yellow"});

function GridBlock:new(o)
	print("brick:new")
	o = o or {}; 
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function GridBlock:show(o)
	o=o or {};

	brickWidth=self.width;  brickHeight=self.height;

	local function hit(event)
		if event.phase=="ended" then 
			local box=event.target;
			box.pp.type="none";
			box:removeSelf();
			boxesLeft=boxesLeft-1; -- boxesLeft is a global from level1
		end
	end

	-- repositioning -- lifted wholesale from an in-class example
	-- TODO: overlap prevention
	local function setBrick(event)
		local phase=event.phase;
		local thing=event.source;
		print ("in setBrick")

	 	if event.phase == "began" then		
			thing.shape.markX = thing.shape.x 
			thing.shape.markY = thing.shape.y
	 	elseif event.phase=="moved" then	 	
		 	local x = (event.x - event.xStart) + thing.markX	 	
		 	local y = (event.y - event.yStart) + thing.markY	 	
		 	
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
	self.shape:setFillColor(self.color.r,self.color.g,self.color.b,15); 
	self.shape.strokeWidth=self.outline;
	self.shape:setStrokeColor(0,0,0)
	self.shape.pp = self;  -- need pointer back to parent for printMe
	
	self.shape:addEventListener("collision",hit);
	self.shape:addEventListener("move",setBrick;
	physics.addBody(self.shape,"static");

	if self.info then
		print(string.format("info=%s, type=%s",self.info, self.type));
		self.textline=display.newText(self.info,self.xPos,self.yPos,fontFace,20);
		self.textline.anchorX=0;
	end;

	self.boxList={};

end


return Yellow;
