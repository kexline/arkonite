-- Karen Exline
-- CS 371
-- Homework 5:  arkonite
-- March 29, 2015

-- main.lua

-- TODO:  description
-- TOOD:  function synopsis

--[[ Resources:
-- checkbox code and widget-radio-checkbox from Corona SDK documentation, 
       http://docs.coronalabs.com/api/library/widget/newSwitch.html
-- populate.lua is adapted from my HW4 Scene 2


- Shooter structures (walls, paddle, shots) from 2015/02/23 lecture and in-class exercise
- Composer template from 2015/02/24 homework
- Shuffle function adapted from http://coronalabs.com/blog/2014/09/30/tutorial-how-to-shuffle-table-items/
- background from TSR/Maple Story:  http://www.spriters-resource.com/pc_computer/maplestory/sheet/22667/
- Solution to reloading scene adapted from http://forums.coronalabs.com/topic/38414-how-to-reload-a-scene-and-proceed-like-normal/
]]

local composer = require( "composer" );

-- Graphics constants
xx=display.contentCenterX; yy=display.contentCenterY;
ww=display.contentWidth; hh=display.contentHeight;

-- settings
cheat=false;
design=true;

-- text
fontFace=native.systemFont;
fs=hh*.03;

-- ball and targets
boxWidth=(ww-10)/6;  boxHeight=yy/10;
paddleX=xx;  paddleY=hh*.9;

setupList={};

-- backgrounds and scene
--local sheet = graphics.newImageSheet( "backgrounds.png", options );
--local sceneOpt = { effect = "fade", time = 800, params = {ss = sheet;} }
sceneOpt = { effect = "fade", time = 800}

-- sounds
soundTable = {
    shootSound = audio.loadSound( "shoot.wav" ),
    shootSound2 = audio.loadSound( "shoot.wav" ),
    hitSound = audio.loadSound( "hit.wav" ),
    explodeSound = audio.loadSound( "explode.wav" ),
}

-- Shuffle table 
-- From http://coronalabs.com/blog/2014/09/30/tutorial-how-to-shuffle-table-items/
-- minor changes for clarity
function shuffleTable( t )
    assert( t, "shuffleTable() expected a table, got nil" )
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = math.random(1,i)
        t[i], t[j] = t[j], t[i]
    end
end


local sceneOpt = { effect = "fade", time = 200, params = {} }
-- load first scene
composer.gotoScene( "welcome", sceneOpt);

