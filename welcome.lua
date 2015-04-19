-- Hw5 scene 1 welcome

-- Composer =======================================================
local composer = require( "composer" );
local widget=require("widget");
local scene = composer.newScene();

print ("in welcome")
local sceneGroup={};

-- Graphics =======================================================

-- Graphics constants
xx=display.contentCenterX; yy=display.contentCenterY;
ww=display.contentWidth; hh=display.contentHeight;

-- 	local titleOpt = {
-- 	frames = { x = 12, y = 4, width=148, height = 37} -- title
-- };
-- local titleSheet = graphics.newImageSheet( "title.png", titleOpt );
local title;
	-- title=display.newImage("titleSheet",2,xx,yy*.66);	


-- Buttons ========================================================
local b1, b2, c1, c1Label;

onSwitchPress=function( event )
    local switch = event.target
    if switch.isOn then cheat=true; print("cheat ON");
    else cheat=false; print ("cheat OFF");
    end
end

-- btnCheat=function(event)
-- 	print ("in btnCheat");
-- 	cheat=true;
-- 	btnStart(event);
-- end

-- For consistency, the "just play" button will go through a non-interactive substitute for the design scene.
btnStart=function(event)
	print ("in btnStart");
	design=false;
	composer.gotoScene( "level1", sceneOpt);
end

btnDesign=function(event)
	print ("in btnStart");
	composer.gotoScene( "design", sceneOpt);
end

-- Show buttons
local showButtons = function()

	b1=widget.newButton({
		x=xx, y=yy+50, 
		id="design", 
		onPress=btnDesign, 
		label="Design!", fontSize=fs, 
		shape="roundedRect", width=ww/4, height=fs*2, cornerRadius=10,	
		fillColor={ default={ .2, 0, .9 }, over={ .1, 0, 0.7 } },
		strokeColor = { default={ .1, .1, .1 }, over={ 0,0,0 } },
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		strokeWidth=3,
	}) 

	b2=widget.newButton({
		x=xx, y=yy+150, 
		id="play", 
		onPress=btnStart, 
		label="Just play!", fontSize=fs, 
		shape="roundedRect", width=ww/4, height=fs*2, cornerRadius=10,	
		fillColor={ default={ .2, 0, .9 }, over={ .1, 0, 0.7 } },
		strokeColor = { default={ .1, .1, .1 }, over={ 0,0,0 } },
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		strokeWidth=3,
	}) 

	-- Cheat is now a checkbox. 
	-- This needs an image sheet since the color can't be edited (http://forums.coronalabs.com/topic/47022-change-radio-button-color/)
	-- but since it is not a project requirement, I may not wind up doing that.

    c1 = widget.newSwitch
	{
	    left = xx*.9-50,
	    top = yy+230,
	    style = "checkbox",
	    id = "Checkbox",
	    onPress = onSwitchPress
	}

	c1Label = display.newText("Cheat?", (xx*.9)+50, yy+250,fontFace, fs*.75);

end


-- Scene ================================================================	

--scene:create
function scene:create( event )
	print ("welcome scene:create");
	local sceneGroup = self.view
	local options =
	{
	 frames = {
		{ x = 400, y = 175, width = 800, height = 600},  -- dark sky
		{ x = 25,  y = 825, width = 811, height = 356}, -- clouds
		{ x = 387, y =1167, width = 133, height = 144}  -- moon
		}
	};
	local sheet = graphics.newImageSheet( "background.png", options );
	local sceneOpt = { effect = "fade", time = 400, params = {ss = sheet;} }
	local bg = display.newImage (sheet, 1);
	bg.x = xx;
	bg.y= yy;
	bg:scale(ww/800,hh/600);

	title=display.newEmbossedText("GENERIC BREAKOUT", xx, hh*.3, fontFace, fs*1.5);
	title:setFillColor(1,1,1);

	sceneGroup:insert(bg); sceneGroup:insert(title);

end
	

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
	elseif ( phase == "did" ) then
			print ("welcome scene:show");
			showButtons();
			sceneGroup:insert(b1); sceneGroup:insert(b2);
			sceneGroup:insert(c1); sceneGroup:insert(c1Label); 
	end
end


function scene:hide(event)
	local sceneGroup = self.view
	sceneGroup:removeSelf();
end
--function scene:destroy

scene:addEventListener( "create", scene );
scene:addEventListener( "show", scene );
scene:addEventListener( "hide", scene );
--scene:addEventListener( "destroy", scene );


return scene;
