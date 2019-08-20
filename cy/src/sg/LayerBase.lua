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


function LayerBase:addSoundBtn(pos)
    --- TODO

    local btn_musicOn = display.newButton({
        normal = IMG_PATH .. "btn_music_on.png",
        pressed = IMG_PATH .. "btn_music_on.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "musicOn",
    })
    btn_musicOn:addTo(self)
    btn_musicOn:pos(pos[1], pos[2])
    self.btn_musicOn = btn_musicOn

    local spr_musicOff = display.newSprite(IMG_PATH .. "btn_music_off.png")
    spr_musicOff:addTo(btn_musicOn)
    self.spr_musicOff = spr_musicOff

    self.spr_musicOff:setVisible( not CONFIG.canPlayEffect)

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
    if tag == "shop" then
        CONFIG.changeScene("shopScene", self)
    elseif tag == "musicOn" then
        CONFIG.canPlayEffect = not CONFIG.canPlayEffect
        CCUserDefault:sharedUserDefault():setBoolForKey("sound_status",CONFIG.canPlayEffect)
        self.spr_musicOff:setVisible( not CONFIG.canPlayEffect)
    end

    print("LayerBase:onButtonHandler ---")
    CONFIG.playEffect("mouse_click")

   

end



return LayerBase