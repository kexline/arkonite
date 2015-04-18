-- retry.lua
local composer = require( "composer" );
local sceneOpt = { effect = "fade", time = 200, params = {} }

local scene = composer.newScene();

function scene:create( event )
	local sceneGroup = self.view

	composer.removeScene( "level1" );

end

function scene:show( event )
		composer.gotoScene( "welcome", sceneOpt);
end

function scene:hide(event)
end

function scene:destroy(event)
end

scene:addEventListener( "create", scene );
scene:addEventListener( "show", scene );
scene:addEventListener( "hide", scene );
scene:addEventListener( "destroy", scene );

return scene;
