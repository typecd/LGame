local Hero = class("Hero",function() 
    return display.newNode()
end)

function Hero:ctor(type,pos)
    self.type = type  --- 影响技能和皮肤
    self.myPos = pos
    self.skillType = 0
    self.isJumping = false
    self.isSecJumping = false -- 连跳
    self.isBlinking = false  -- 闪烁无敌

    UITools.addSpriteFrames(IMG_PATH .. CONFIG.Hero_Res_Name[type])
    self:setContentSize(CONFIG.Hero_Size[type])
    local frames = display.newFrames("run_ani_"..type.."_%d.png",1,4)
    local anmate = display.newAnimation(frames,0.05)
    display.setAnimationCache("run_"..type,anmate)
    
    local sprite = display.newSprite("#run_ani_"..type.."_1.png")
    sprite:addTo(self)
    sprite:setAnchorPoint(ccp(0,0))
    
    self.sprite = sprite

    self:registerScriptHandler(handler(self,self.onNodeEvent))
    self:setPosition(pos)
end


function Hero:stop()
    self.sprite:stopAllActions()
    self:stopAllActions()
end


function Hero:run()
    transition.playAnimationForever(self.sprite,display.getAnimationCache("run_"..self.type),0)
end


function Hero:jump()

    -- 连跳技能 
    if self.skillType == 1 then
        if self.isJumping and not self.isSecJumping then
            self:stopAction(self.jumpAct);
            self:runAction(self:createAction())
            self.isSecJumping = true
            SoundUtil.playEffect(CONFIG.Touch_Music,"jump",false)
        end
    end

    if self.isJumping then
        print("is jumping over")
        return 
    end
    self.isJumping = true
    self:runAction(self:createAction())
    SoundUtil.playEffect(CONFIG.Touch_Music,"jump",false)


end


function Hero:createAction()
    -- 跳跃动作
    local jump = transition.sequence({
        CCJumpTo:create(0.5,self.myPos,150,1),
        CCCallFunc:create(function()
            self.isJumping = false
            self.isSecJumping = false
        end)
    })
    self.jumpAct = jump
    return jump
end


function Hero:standOriginPos()
    self.isJumping = false;
    self.isSecJumping = false;
    self:setPosition(self.myPos)
end


function Hero:blink()

    local blink = CCBlink:create(3,20)
    local act = transition.sequence({
        blink,
        CCCallFuncN:create(function(node) 
            node.isBlinking = false;
        end)})
    self:runAction(act)
    self.isBlinking = true  --- 闪烁应该放到 hero中

end


function Hero:onNodeEvent(event)
    if event == "enter" then

    elseif event == "exit" then
        UITools.removeSpriteFrames(IMG_PATH .. CONFIG.Hero_Res_Name[self.type])
    end
end


return  Hero