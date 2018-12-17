local UnlockLayer = require("sg/UnlockLayer")


local EndWin = class("EndWin",function() 
    return display.newColorLayer(ccc4(0,0,0,120))
end)



function EndWin:ctor()

    -- CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_win2_mp3,false);
    local bg = display.newSprite(CONFIG.R.end_bg);
    bg:center();
    bg:addTo(self);

    local stars = display.newSprite(CONFIG.R.end_stars);
    stars:addTo(bg);
    stars:pos(265,320);

    local pos = {
        ccp(120, 300),
        ccp(265, 350),
        ccp(400, 300),
    }
    self._starList = {};
    for i = 1, 3 do 
        local star = display.newSprite(CONFIG.R["end_star"..i]);
        star:setVisible(false);
        star:addTo(bg);
        star:setPosition(pos[i]);
        table.insert(self._starList,star);
    end

    local next = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_next1,
        delegate = self,
        callback = self.buttonHandler,
        tag = "next",
    })
    next:addTo(bg);
    next:pos(400, 120);
    self._next = next;
    next:setVisible(false);


    local restart = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_restart1,
        delegate = self,
        callback = self.buttonHandler,
        tag = "restart",
    })
    restart:addTo(bg);
    restart:pos(120,120);
    self._restart = restart;
    restart:setVisible(false);

    local btn_gate = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_gate1,
        callback = self.buttonHandler,
        delegate = self,
        tag = "gate",
    })
    btn_gate:addTo(bg)
    btn_gate:pos(255,120);
    self._btn_gate = btn_gate;
    btn_gate:setVisible(false);

    self._starIndex = 0;
    self:showStar();

    self:registerScriptTouchHandler(function(event,x,y) 
        -- print(event)
        if event == "began" then
            return true;
        elseif event == "moved" then
        elseif event == "ended" then
        end
    end,false,-127,true) 
    self:setTouchEnabled(true);

end



function EndWin:buttonHandler(tag)
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)

    if tag == "next" then
        
        if CONFIG.gate > CONFIG.gateData:getLength() then
            -- 切换到 gateScene
            CONFIG.changeScene("gateScene", self:getParent());
        else
            if not table.indexof(CONFIG.unlockedGates, CONFIG.gate + 1) then
                -- 提示解锁关卡
                UnlockLayer.show(self:getParent(),CONFIG.gate + 1);
            else
                CONFIG.gate = CONFIG.gate + 1;       
                CONFIG.changeScene("gameScene", self:getParent());
            end
        end
    elseif tag == "restart" then
        -- 重新加载 GameScene
        CONFIG.changeScene("gameScene", self:getParent());
    elseif tag == "gate" then
        CONFIG.changeScene("gateScene", self:getParent());
    end
end



function EndWin:showStar()
    
    self._starIndex = self._starIndex + 1;
    if self._starIndex > #self._starList then
        self:showButton();
        return;
    end

    local star = self._starList[self._starIndex];
    star:setVisible(true);
    local y = star:getPositionY();
    star:setPositionY(y + 150);
    star:scale(1.4);
    local seq = transition.sequence({
        CCMoveTo:create(0.2, ccp(star:getPositionX(), y)),
        CCCallFunc:create(function()
            self:showStar();
        end)
    });
    star:runAction(seq);

end


function EndWin:showButton()
    self._next:setVisible(true);
    self._restart:setVisible(true);
    self._btn_gate:setVisible(true);
end


return EndWin