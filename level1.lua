-- level1.lua


-- Composer
local composer = require( "composer" );
local widget=require("widget");
local Ball = require("Ball");
local Brick = require("Brick");
local Red = require("Red");
local Yellow = require("Yellow");
local Blue = require("Blue");

local scene = composer.newScene();

-- Physics
local physics = require ("physics");
physics.start();
physics.setGravity(0,-0.01); -- when in doubt, cheat up
--physics.setDrawMode("hybrid");

xx=display.contentCenterX; yy=display.contentCenterY;
ww=display.contentWidth; hh=display.contentHeight;

-- Tracking variables & settings =========================================

boxesLeft=24; -- TODO: improve encapsulation
local move;         -- event handler for paddle movement
local boxHit;       -- event handler for collisions
local levelEnd=false

-- Play area items ========================================================
local top, left, right, bottom; 
local ball, paddle;
local score;
local startBtn, btn;
local popup, statusText;

-- List of box types ======================================================

local boxTypes={6, 2, blues, reds};
local numBoxes=36;
local numRows=6; numCols=6;
local grays=6; local yellows=2;
local remain=(numBoxes)-(grays+yellows)
local reds=math.random(6,remain-6);
local blues=remain-reds;
local go=false;
local boxes={}; 


-- Scene ================================================================	

--scene:create
function scene:create( event )
	--composer.removeScene("level1");

	print ("level1 scene:create");

	local sceneGroup = self.view
	local options =
	{
	 frames = {
		{ x = 400, y = 175, width = 800, height = 600}, -- dark sky
		{ x = 25,  y = 825, width = 811, height = 356}, -- clouds
		{ x = 387, y =1167, width = 133, height = 144}  -- moon
		}
	};

	local sheet = graphics.newImageSheet( "background.png", options );
	local sceneOpt = { effect = "fromTop", time = 800, params = {ss = sheet;} }
	local bg = display.newImage (sheet, 1);
	bg.x = xx;
	bg.y= yy;
	bg:scale(ww/800,hh/600);
	sceneGroup:insert(bg);

	-- button listeners =======================================================

	local btnBack=function(event)
	 	Runtime:removeEventListener("touch", startGame)
		composer.gotoScene( "level1", sceneOpt);
	end

	-- Functions to create level ===============================================

	local function assignBoxTypes()
		-- 1=gray, 2=yellow, 3=blue, 4=red

		-- have to populate the initial array here because the number of reds and blues
		-- is quasi-random.
		boxes={}
		for i=1,grays,1   do table.insert(boxes,{type=1, ref=nil}); end
		for i=1,yellows,1 do table.insert(boxes,{type=2, ref=nil}); end
		for i=1,blues,1   do table.insert(boxes,{type=3, ref=nil}); end
		for i=1,reds,1    do table.insert(boxes,{type=4, ref=nil}); end

		Brick:shuffleTable(boxes);

		-- boxes={{type=4, ref=nil},{type=4, ref=nil},{type=4, ref=nil},{type=3, ref=nil},{type=3, ref=nil},{type=2, ref=nil},
		-- 	   {type=2, ref=nil},{type=1, ref=nil},{type=4, ref=nil},{type=1, ref=nil},{type=3, ref=nil},{type=3, ref=nil},
		-- 	   {type=3, ref=nil},{type=2, ref=nil},{type=1, ref=nil},{type=4, ref=nil},{type=4, ref=nil},{type=3, ref=nil},
		-- 	   {type=3, ref=nil},{type=3, ref=nil},{type=2, ref=nil},{type=1, ref=nil},{type=4, ref=nil},{type=3, ref=nil},
		-- 	   {type=4, ref=nil},{type=3, ref=nil},{type=1, ref=nil},{type=2, ref=nil},{type=1, ref=nil},{type=4, ref=nil},
		-- 	   {type=4, ref=nil},{type=4, ref=nil},{type=3, ref=nil},{type=3, ref=nil},{type=2, ref=nil},{type=4, ref=nil},
		-- }

		boxesLeft=table.getn(boxes)-grays
	end -- end assignBoxTypes


	local function showBoard()
		top = display.newRect (xx ,hh*.05, ww, 10);
		physics.addBody (top, "static");
		top:setFillColor(.1,.1,.1);
		left = display.newRect (0, yy, 5, hh);
		physics.addBody (left, "static");
		left:setFillColor(.1,.1,.1);
		right = display.newRect (ww, yy, 5, hh);
		physics.addBody (right, "static");
		right:setFillColor(.1,.1,.1);
		-- The cheat button works via the droppedBall listener which will be applied to the bottom wall
		bottom = display.newRect (xx, hh, ww, 5);
		physics.addBody (bottom, "static");
		
		-- TODO: this should probably be a shallow trapezoid
		-- so that the ball doesn't bounce horizontally
		paddle = display.newRoundedRect(paddleX,paddleY,ww*.2,hh*.01,5);
		physics.addBody(paddle,"static");

		ball = Ball:new({xPos=xx,yPos=hh*.9});
		ball:show();

		-- ball = display.newCircle(xx, hh*.9-br*.5, br);
		-- physics.addBody(ball,"dynamic",{radius=br,bounce=1, gravityScale=0});

		-- score bar
		score = display.newText ({text="Targets remaining:  "..boxesLeft,        
			x=xx, y=hh*.025, fontSize=fs});

		-- skip btn
		btn=widget.newButton({
			x=ww*(11/12), y=hh*.025,
			id="continue", onPress=btnBack, 
			label="Back", fontSize=fs*.8, 
			shape="roundedRect", width=ww/6, height=fs*1.5, cornerRadius=8,	
			fillColor={ default={ .2, 0, .9 }, over={ .1, 0, 0.7 } },
			strokeColor = { default={ .1, .1, .1 }, over={ 0,0,0 } },
			labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
			strokeWidth=3,
		}) 

		sceneGroup:insert(top); sceneGroup:insert(bottom); 
		sceneGroup:insert(left); sceneGroup:insert(right); 
		sceneGroup:insert(btn);


		sceneGroup:insert(score);
		sceneGroup:insert(paddle);
		sceneGroup:insert(ball.shape);
	end;

	-- Game functions  ========================================================

	boxHit = function(event)
		-- check event phase to avoid double taps
		if event.phase=="began" then
			local box=event.target;
			if (box.pp.type=="yellow") then
				box.pp:reverseColors(boxes);
			end
			score.text="Targets remaining:  "..boxesLeft;
			if boxesLeft==0 then
				winGame();
			end
		end 
	end

	populateBoxes = function(rows,cols)
		local xp=0; local yp=hh*.1;
		local box,t; local idx=1;
		for i=1,rows,1 do
			for j=1,cols,1 do

				-- box=display.newRect(xPos,yPos,boxWidth,boxHeight)
				-- box.strokeWidth=2; box:setStrokeColor(0,0,0);
				-- box.anchorX=0; box.anchorY=0;
				-- box:addEventListener("collision",boxHit);
				-- physics.addBody(box,"static");

				t=boxes[idx].type;
				if (t==1) then
					box=Brick:new({xPos=xp, yPos=yp, width=(ww-10)/6, height=yy/10});
				elseif (t==2) then
					box=Yellow:new({xPos=xp, yPos=yp, width=(ww-10)/6, height=yy/10});
				elseif (t==3) then
					box=Blue:new({xPos=xp, yPos=yp, width=(ww-10)/6, height=yy/10});
				elseif (t==4) then
					box=Red:new({xPos=xp, yPos=yp, width=(ww-10)/6, height=yy/10});
				else
					assert(box[idx].type, "error: box type is not between 1 and 4");
				end
				box:show();	
				box.shape:addEventListener("collision",boxHit);

				-- -- Save a reference; we will need it for the swap action on yellows
				boxes[idx].ref=box;
				xp=xp+boxWidth+1;

				--sceneGroup:insert(box);
				idx=idx+1

			end
			xp=0; yp=yp+box.height+1;
		end

		--return boxes;
	end;


	-- assemble the game board
	assignBoxTypes();
	showBoard();
	populateBoxes(6,6);
end -- end of scene:create

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
	elseif ( phase == "did" ) then

		-- Game start =======================================================

		local function startGame(event)
			Runtime:removeEventListener("touch", startGame)

			print ("startGame")
			if cheat then
				local cheatText={"THE ONLY WAY TO WIN","YOU CAN'T FAIL","DROP IT ALL YOU WANT"}
				statusText=display.newText(cheatText[math.random(1,3)], xx, yy*1.2, gameFont, fs*1.25);

			else
				statusText=display.newText("Game on", xx, yy*1.2, gameFont, fs*1.25);
			end
			statusText:setFillColor(.5,.5,.5,1);
			transition.fadeOut(statusText,{time=5000,onComplete={function() statusText:removeSelf() end}})

			ball.shape:applyForce(5, 7, ball.x, ball.y);
			--ball:setLinearVelocity( 2, 4 );

			--ball:applyLinearImpulse( math.random(bf-10,bf), math.random(bf,bf+10), ball.x, ball.y )
		end

		-- Button listeners ============================================

		local btnRestart=function(event)
			if levelEnd then popup:removeSelf(); statusText:removeSelf(); end;
			composer.gotoScene("welcome", sceneOpt)	
		end

		local btnNext=function(event)
			if levelEnd then popup:removeSelf(); statusText:removeSelf(); 
			else Runtime:removeEventListener("touch", startGame)
			end;
			composer.gotoScene( "welcome", sceneOpt);
		end


		-- Collision/touch listeners =====================================
		-- paddle movement
		move = function( event )
			 if event.phase == "began" then	
			 	paddle.markX = paddle.x 
			 elseif event.phase == "moved" then	 
			 	if paddle.markX==nil then paddle.markX=paddle.x end;

			 	local x = (event.x - event.xStart) + paddle.markX	 	
			 	
			 	if (x <= 20 + paddle.width/2) then
				   paddle.x = 20+paddle.width/2;
				elseif (x >= ww-20-paddle.width/2) then
				   paddle.x = ww-20-paddle.width/2;
				else
				   paddle.x = x;		
				end
						
			 end
		end

		paddleHit = function(event)
			-- pastel color change
			r=math.random(3,10)*.1;
			g=math.random(2,9)*.1;
			b=math.random(2,9)*.1;
			--print(string.format("New color %f, %f, %f", r, g, b));
			paddle:setFillColor(r,g,b);
			--ball:applyLinearImpulse(.1,-.1,ball.x,ball.y)
		end

		-- reverseColors = function()
		-- 	for i=1,numBoxes,1 do
		-- 		local boxRef=boxes[i].ref;
		-- 		if boxRef.type=="red" then
		-- 			boxRef:setFillColor(0,0,1);
		-- 			boxRef.type="blue"
		-- 		elseif boxRef.type=="blue" then
		-- 			boxRef:setFillColor(1,0,0);
		-- 			boxRef.type="red"
		-- 		-- no action otherwise
		-- 		end
		-- 	end
		-- end


		-- End conditions ==============================================

		-- End game if ball touches the bottom wall
		droppedBall = function(event)

			if event.phase=="ended" then
				print("dropped ball")
				-- This game is too hard for me to test.  Cheat mode makes the floor solid.
				if (cheat==false) then
					ball:removeSelf();

					popup=display.newRoundedRect(xx,yy,ww*.75,hh/3,15);
					popup:setFillColor(.1,.1,.1,.95); 
					popup.strokeWidth=5; popup:setStrokeColor(.8,.8,.8);

					statusText=display.newText ("You dropped \nthe ball", xx, yy*.8, gameFont, fs);
					statusText:setFillColor(1,1,1);

					btn=widget.newButton({
						onPress=btnRestart, id="restart", label="Main Menu", fontSize=fs, 
						x=xx, y=yy,	strokeWidth=3,
						shape="roundedRect", width=ww/3, height=fs*2, cornerRadius=10,	
						fillColor={ default={ .2, 0, .9 }, over={ .1, 0, 0.7 } },
						strokeColor = { default={ .1, .1, .1 }, over={ 0,0,0 } },
						labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
					}) 
					levelEnd=true
					sceneGroup:insert(popup); sceneGroup:insert(statusText); sceneGroup:insert(btn);


				end
			end
		end

		winGame  = function()
			-- add a floor so the ball keeps bouncing behind the prompt box
			ball:removeEventListener("collision",droppedBall);
			-- redefine the boxHit listener to no action; easier than iterating through remaining boxes.
			boxHit={function() end};
			-- show message
			popup=display.newRoundedRect(xx,yy,xx,hh/3,15);
			popup:setFillColor(.1,.1,.1,.9); 
			popup.strokeWidth=5; popup:setStrokeColor(.8,.8,.8);

			statusText=display.newText("All clear", xx, yy, gameFont, fs*1.25);
			statusText:setFillColor(1,1,1);

			levelEnd=true;

			-- show buttons
			btn=widget.newButton({
				x=xx, y=yy,
				id="continue", onPress=btnNext, 
				label="Main Menu", fontSize=fs, 
				shape="roundedRect", width=ww/4, height=fs*2, cornerRadius=10,	
				fillColor={ default={ .2, 0, .9 }, over={ .1, 0, 0.7 } },
				strokeColor = { default={ .1, .1, .1 }, over={ 0,0,0 } },
				labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
				strokeWidth=3,
			}) 
			sceneGroup:insert(popup); sceneGroup:insert(statusText); sceneGroup:insert(btn);
		end

		Runtime:addEventListener("touch", startGame);
		Runtime:addEventListener("touch", move);
		bottom:addEventListener("collision",droppedBall)
		paddle:addEventListener("collision",paddleHit)
	end
end -- end of scene:show

function scene:hide(event)
	local sceneGroup = self.view
	if ( phase == "will" ) then
		physics.stop()
		sceneGroup:removeSelf();
		for i=1,table.getn(boxes),1 do
			boxes[i].shape:removeSelf();
		end
		for i=1,table.getn(sceneGroup),1 do
			sceneGroup[i]=nil;
		end
		Runtime:removeEventListener("touch", move);
	elseif ( phase == "did" ) then
		sceneGroup=nil;
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	if ( phase == "will" ) then
	elseif ( phase == "did" ) then

	end
end

scene:addEventListener( "create", scene );
scene:addEventListener( "show", scene );
scene:addEventListener( "hide", scene );
scene:addEventListener( "destroy", scene );


return scene;


