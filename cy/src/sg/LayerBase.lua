local LayerBase = class("LayerBase",function() 
    return display.newLayer()
end)

function LayerBase:ctor()

    self:setNodeEventEnabled(true)
    self:registerScriptHandler(function(tag)
        self:onNodeEvent(tag)
    end)
    
end


function LayerBase:addButton(scene, backScene)
    --- TODO
    self.backScene = backScene
    if scene == "gate" then
        self:addBackBtn()
        self:addShopBtn()
        self:addSoundBtn()
    elseif scene == "shop" then
        self:addBackBtn()
        self:addSoundBtn()
    elseif scene == "tutorial" then
        self:addBackBtn()
        self:addSoundBtn()
    end
    
end

function LayerBase:addBackBtn()
    --- TODO
    local spr_back = display.newSprite(IMG_PATH .. "podbtn_10000.png")
    spr_back:addTo(self)
    spr_back:rotation(90)
    spr_back:pos(display.cx - 160, 47)
    
    local btn_back = display.newButton({
        normal = IMG_PATH .. "scene/btn_back_10000.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "back"
    })
    btn_back:addTo(spr_back)
    btn_back:pos(38, 38)
    btn_back:rotation(-90)
end


function LayerBase:addShopBtn()
    --- TODO
    local spr_shop = display.newSprite(IMG_PATH .. "podbtn_10000.png")
    spr_shop:addTo(self)
    spr_shop:rotation(90)
    spr_shop:pos(display.cx, 47)

    local btn_shop = display.newButton({
        normal = IMG_PATH .. "scene/btn_shop_icon_10000.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "shop"
    })
    btn_shop:addTo(spr_shop)
    btn_shop:pos(38, 38)
    btn_shop:rotation(-90)
end


function LayerBase:addSoundBtn()
    --- TODO
    local spr_sound = display.newSprite(IMG_PATH .. "podbtn_10000.png")
    spr_sound:addTo(self)
    spr_sound:rotation(90)
    spr_sound:pos(display.cx + 160, 47)

    local btn_musicOn = display.newButton({
        normal = IMG_PATH .. "scene/btn_musicon_10000.png",
        pressed = IMG_PATH .. "scene/btn_musicon_10000.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "musicOn",
    })
    btn_musicOn:addTo(spr_sound)
    btn_musicOn:pos(38, 38)
    btn_musicOn:rotation(-90)
    self.btn_musicOn = btn_musicOn
    local btn_sfxOn = display.newButton({
        normal = IMG_PATH .. "scene/btn_sfxon_10000.png",
        pressed = IMG_PATH .. "scene/btn_sfxon_10000.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "sfxOn",
    })
    btn_sfxOn:addTo(spr_sound)
    btn_sfxOn:pos(38, 38)
    btn_sfxOn:rotation(-90)
    self.btn_sfxOn = btn_sfxOn

    local btn_soundsOff = display.newButton({
        normal = IMG_PATH .. "scene/btn_soundsoff_10000.png",
        pressed = IMG_PATH .. "scene/btn_soundsoff_10000.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "soundsOff",
    })
    btn_soundsOff:addTo(spr_sound)
    btn_soundsOff:pos(38, 38)
    btn_soundsOff:rotation(-90)
    self.btn_soundsOff = btn_soundsOff

    btn_sfxOn:hideAndBan(false)
    btn_musicOn:hideAndBan(false)
    btn_soundsOff:hideAndBan(false)

    if CONFIG.canPlayEffect and CONFIG.canPlayMusic then
        btn_soundsOff:hideAndBan(true)
    elseif CONFIG.canPlayEffect then
        btn_sfxOn:hideAndBan(true)
    elseif CONFIG.canPlayMusic then
        btn_musicOn:hideAndBan(true)
    else
        btn_soundsOff:hideAndBan(true)
    end
end


function LayerBase:onNodeEvent(event)
    if "enter" == event then
        self:_onEnter()
    elseif "exit" == event then
        self:_onExit()
    end
end

function LayerBase:_onEnter()
    -- EventEngine只用来响应金币购买成功的事件
    -- 小游戏使用EventManager
    EventEngine.register(self, self._onEventNotify);
end

function LayerBase:_onExit()
    -- game end
    print("LaberBase exit")
    EventEngine.unregister(self)
end

function LayerBase:_onEventNotify(event, data)
    if event and event == EventName.UPDATE_GOLD then
        self:_onGoldCharged(data);
    end
end

function LayerBase:_onGoldCharged(count)
    -- game charged
    -- 平台充值成功的回调(data花费的钱，count获得的数量)
    bba.log(string.format("花费获得%d",count))
    PLUGIN_INS.UserInfo:setUserInfoByKey({
        CURRENCY = PLUGIN_INS.UserInfo.CURRENCY + count
    })
end

function LayerBase:onButtonHandler(tag)
    -- play sound
    if tag == "back" then
        CONFIG.changeScene(self.backScene, self)
    elseif tag == "shop" then
        CONFIG.changeScene("shopScene", self)
    elseif tag == "musicOn" then
        self.btn_musicOn:hideAndBan(false)
        self.btn_sfxOn:hideAndBan(true)
        CONFIG.canPlayMusic = false
        CONFIG.canPlayEffect = true
        CONFIG.saveMusic(2)
        CONFIG.saveEffect(1)
        CONFIG.playMusic()
    elseif tag == "sfxOn" then
        self.btn_sfxOn:hideAndBan(false)
        self.btn_soundsOff:hideAndBan(true)
        
        CONFIG.canPlayMusic = true
        CONFIG.canPlayEffect = true
        CONFIG.saveMusic(1)
        CONFIG.saveEffect(1)
        CONFIG.playMusic()
    elseif tag == "soundsOff" then
        self.btn_musicOn:hideAndBan(true)
        self.btn_soundsOff:hideAndBan(false)

        CONFIG.canPlayMusic = true
        CONFIG.canPlayEffect = false
        CONFIG.saveMusic(1)
        CONFIG.saveEffect(2)
    end

    print("LayerBase:onButtonHandler ---")
    CONFIG.playEffect("mouse_click")

   

end



return LayerBase