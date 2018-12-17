local UnlockLayer = class("UnlockLayer",function() 
    return display.newLayer()
end)

function UnlockLayer.show(parent,gate)
    local layer = UnlockLayer.new(gate);
    layer:addTo(parent,21);
end 

function UnlockLayer:ctor(gate)

    self._gate = gate;

    local bg = display.newSprite(CONFIG.R.end_bg);
    bg:center()
    bg:addTo(self)

    local label = display.newTTFLabel({
        text = "花費5個鑰匙解鎖關卡",
        size = 40,
        color = ccc3(109,31,0),
    })
    label:addTo(bg);
    label:pos(275,300);

    local btn_unlock = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.gate_unlock,
        delegate = self,
        callback = self.buttonHandler,
        tag = "unlock",
    })
    btn_unlock:addTo(bg);
    btn_unlock:pos(275,120);

    local btn_close = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_close1,
        delegate = self,
        callback = self.buttonHandler,
        tag = "close",
    });
    btn_close:addTo(bg);
    btn_close:pos(510,450);

    local key_label = display.newTTFLabel({
        text = PLUGIN_INS.UserInfo.CURRENCY.."/5",
        size = 30,
        color = ccc3(109,31,0)
    })
    key_label:addTo(bg);
    key_label:pos(275,50);

    self:registerScriptTouchHandler(function(event,x,y)
        if event == "began" then
            return true;
        end
        
    end,false,-127,true)
    self:setTouchEnabled(true);
end

function UnlockLayer:buttonHandler(tag)
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if tag == "unlock" then
        print("currency ",PLUGIN_INS.UserInfo.CURRENCY)
        if PLUGIN_INS.UserInfo.CURRENCY >= 5 then
            CONFIG.gate = self._gate;
            table.insert(CONFIG.unlockedGates,CONFIG.gate);

            CONFIG.saveUnlockGates();

            PLUGIN_INS.UserInfo:setUserInfoByKey({
                CURRENCY = PLUGIN_INS.UserInfo.CURRENCY - 5
            })
            CONFIG.changeScene("gameScene", self:getParent());
        else
            Toast:showToast("鑰匙不足,鑰匙不足請先購買鑰匙。");
        end
    elseif tag == "close" then
        self:removeFromParentAndCleanup(true);
    end

end




return UnlockLayer