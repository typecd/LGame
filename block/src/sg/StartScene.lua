local LayerBase = require("sg/LayerBase")
local BackGroud = require("sg/BackGroud")
local GateScene = require("sg/GateScene")


local StartScene = class("StartScene", LayerBase)
function StartScene.show()
    local layer = StartScene.new()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer)
end

function StartScene:ctor()

    StartScene.super.ctor(self)

    UITools.addSpriteFrames(IMG_PATH .. "game")
    UITools.addSpriteFrames(IMG_PATH .. "block")
    UITools.addSpriteFrames(IMG_PATH .. "shadow")

    BackGroud.new(self);
    --- 开始按钮
    local btn_start = display.newButton({
        normal = CONFIG.R.start_play_bg,
        label = CONFIG.R.start_play,
        delegate = self,
        callback = self.onButton,
        tag = 1,
    });
    btn_start:addTo(self);
    btn_start:pos(display.cx,display.cy);
    -- 设置
    local capx = 70
    if BA.IS_IPHONEX then
        capx = 90
    end
    local btn_setting = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_setting1,
        delegate = self,
        callback = self.onButton,
        tag = 2,
    })
    btn_setting:addTo(self)
    btn_setting:pos(left(capx),60);

    local logo = display.newSprite(CONFIG.R.logo);
    logo:addTo(self)
    logo:pos(centerX(),top(80));

    local tip = display.newTTFLabel({
        text = "前30關免費開放。鑰匙用於解鎖關卡,每關5個。",
        size = 24,
        color =  ccc3(109,31,0),
    })
    tip:addTo(self)
    tip:pos(display.cx,30)

end

function StartScene:onButton(tag)
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if tag == 1 then
        print("start")
        
        CONFIG.changeScene("gateScene",self);
    elseif tag == 2 then
        print("setting")
        CONFIG.changeScene("settingLayer");
    end 
end


return StartScene