local SettingLayer  = class("SettingSettingLayer",function() 
    return display.newColorLayer(ccc4(0,0,0,150))
end)

function SettingLayer.show()
    local layer = SettingLayer.new()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer)
end

function SettingLayer:ctor() 

    local bg = display.newSprite(CONFIG.R.setting_bg);
    bg:addTo(self);
    bg:center();

    local btn_close = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_close1,
        delegate = self,
        callback = self.buttonHandler ,
        tag = "close",
    })
    btn_close:addTo(bg);
    btn_close:pos(270,220);
    btn_close:scale(0.7);


    local sp_music = display.newSprite(CONFIG.R.setting_music);
    sp_music:addTo(bg);
    sp_music:pos(100,160);

    local sp_sound = display.newSprite(CONFIG.R.setting_sound);
    sp_sound:addTo(bg);
    sp_sound:pos(100,90);

    local btn_music = display.newButton({
        normal = CONFIG.R.setting_select_bg,
        pressed = CONFIG.R.setting_select_bg,
        -- label = CONFIG.R.setting_select,
        delegate = self,
        callback = self.buttonHandler,
        tag = "music",
    })
    btn_music:addTo(bg);
    btn_music:pos(200,160);
    self.btn_music = btn_music;

    local img_music = display.newSprite(CONFIG.R.setting_select);
    btn_music:add(img_music)
    self.img_music = img_music;

    local btn_sound = display.newButton({
        normal = CONFIG.R.setting_select_bg,
        pressed = CONFIG.R.setting_select_bg,
        -- label = CONFIG.R.setting_select,
        delegate = self,
        callback = self.buttonHandler,
        tag = "sound",
    })
    btn_sound:addTo(bg);
    btn_sound:pos(200,90);
    self.btn_sound = btn_sound;

    local img_sound = display.newSprite(CONFIG.R.setting_select);
    btn_sound:add(img_sound)
    self.img_sound = img_sound;

    self.img_music:setVisible(CONFIG.canPlayMusic)
    self.img_sound:setVisible(CONFIG.canPlayEffect)


    self:registerScriptTouchHandler(function(event,x,y) 
        if event == "began" then
            return true;
        end
    end,false,-127,true)
    self:setTouchEnabled(true);
    
end

function SettingLayer:buttonHandler(tag) 
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if tag == "close" then
        self:removeFromParentAndCleanup(true);
        CCUserDefault:sharedUserDefault():setBoolForKey("sound_status",CONFIG.canPlayEffect)
        CCUserDefault:sharedUserDefault():setBoolForKey("music_status",CONFIG.canPlayMusic)
    elseif tag == "music" then
        CONFIG.canPlayMusic = not CONFIG.canPlayMusic
        self.img_music:setVisible(CONFIG.canPlayMusic)
        CONFIG.playMusic();
        print("play music");
    elseif tag == "sound" then
        CONFIG.canPlayEffect = not CONFIG.canPlayEffect
        self.img_sound:setVisible(CONFIG.canPlayEffect)
    end
end



return SettingLayer