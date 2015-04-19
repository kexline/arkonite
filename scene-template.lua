-- welcome.lua :  Main menu

-- CS 371
-- Final Project: Total Tosser
-- Group members: Karen Exline, Cozette Napoles, and James Taylor

-- References:  
-- buttons created using http://dabuttonfactory.com/ and sheeted in Inkscape 

-- includes and physics
local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
local widget = require("widget")
physics.start()
physics.setGravity(0,0)

-- Custom objects
-- local Trash = require("Trash");
-- local Laundry = require("Laundry");
-- local Toys = require("Toys");
-- local Walls = require("Walls");

-- Convenience variables
local xx = display.contentCenterX; local ww=display.contentWidth;
local yy = display.contentCenterY; local hh=display.contentHeight;
local fs=hh/20;  local ff=native.systemFont;

-- scene variables

-- Graphics

local btnOptions = { frames = {	
 	{ x = 0, y =15, width = 322, height = 65},  -- some button
  	{ x = 322, y =15, width = 314, height = 65},  -- another button
}}

local btnSheet = graphics.newImageSheet( "somesheet.png", btnOptions );

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

	if phase=="will" then

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