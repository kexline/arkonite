-- ball.lua


local xx=display.contentCenterX; local yy=display.contentCenterY;
local ww=display.contentWidth;   local hh=display.contentWidth;

local br=ww*.02;
local Ball = {name="ball", xPos=100, yPos=600, outline=0, rad=ww*.02 , color={r=1,g=1,b=1}, bounce=1};


function Ball:new(o)
	print("ball:new")
	o = o or {}; 
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function Ball:show()
	local color=self.color;
	local br=self.rad;

	self.shape = display.newCircle(self.xPos, self.yPos, self.rad);
	self.shape.pp = self;

	self.shape:setFillColor(color.r,color.g,color.b);
	physics.addBody(self.shape,"dynamic",{radius=br,bounce=1, gravityScale=0});
end

function Ball:applyForce(params)
	self.shape:applyForce(params)
end

function Ball:removeSelf()
	self.shape:removeSelf();
end

return Ball;