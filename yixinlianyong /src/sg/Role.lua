local Hero = require("sg/Hero")

local Hero_Disc = {
    "胖子就是我,我叫胖胖。",
    "披風和長髮就是我的標誌,不要看走眼了～",
    "我只想做一個安靜的少女！",
    "大大,來送你一頂帽～",
    "哈哈,妳們看二號那個大傻～",
    "看見浪漫的顏色了嗎?對,我就是浪漫的化身",
    "快跑啊。⋯⋯^_^",
    "不選我的人是...是什麼自己YY。"
}

local Role = class("Role",function() 
    return CCLayerColor:create(ccc4(255,130,84,255))
end)

function Role.show()
    local layer = Role.new()
    CCDirector:sharedDirector():getRunningScene():addChild(layer)
end

function Role:ctor()

    self.roleArr = {}
    local hero_index = CCUserDefault:sharedUserDefault():getIntegerForKey("hero_index")
    if hero_index == 0 then
        hero_index = 1 
    end
    local title = display.newSprite(IMG_PATH .. "role.png")
    title:addTo(self)
    title:pos(display.cx,display.height - title:getContentSize().height/2)
    
    local btnBack = display.newButton({
        normal = IMG_PATH .. "back.png",
        callback = function(tag,data)
            SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
            tag:removeFromParentAndCleanup(true)
        end,
        delegate = self,
    })
    btnBack:addTo(self)
    btnBack:pos(display.width -50,btnBack:getContentSize().height/2+20)

    local disc = display.newTTFLabel({
        text = "",
        size = 32,
        color = ccc3(0,0,0)
    })
    disc:addTo(self)
    disc:setAnchorPoint(ccp(0.5,0.5))
    disc:pos(display.cx,100)
    self.disc = disc

    for k,v in ipairs(CONFIG.Hero_Res_Name) do 
        UITools.addSpriteFrames(IMG_PATH .. v)
    end


    for i = 1,CONFIG.Hero_Count do 
        local btn = display.newButton({
            normal = IMG_PATH .. "item_w_bg.png",
            disabled = IMG_PATH .. "item_bg.png",
            callback = self.onBtnTouch,
            delegate = self,
        })
        btn:setUserData(btn)
        btn:setName(tostring(i))
        btn:addTo(self)
        btn:pos(display.cx - (CONFIG.Hero_Count/2 +0.5 -i)*150,display.cy)


        local role = Hero.new(i,ccp(display.cx - (CONFIG.Hero_Count/2 + 0.5-i)*150-15,display.cy-18))
        role:addTo(self)
        role:setScale(1.5)
        table.insert(self.roleArr,role)

        if hero_index == i then 
            btn:setEnabled(false)
            role:run()
            self.lastBtn = btn
            self.disc:setString(Hero_Disc[hero_index])
        end
    end

    self:registerScriptTouchHandler(function(event,x,y)
        if event == "began" then
            return true;
        end
    end,false,-127,true)
    self:setTouchEnabled(true)

end


function Role:onBtnTouch(tag)
    SoundUtil.playEffect(CONFIG.Touch_Music,"touch",false)
    if self.lastBtn  then
        self.lastBtn:setEnabled(true)
        self.roleArr[tonumber(self.lastBtn:getName())]:stop()
    end
    self.lastBtn = tag,
    tag:setEnabled(false)
    local index = tonumber(tag:getName())
    self.roleArr[index]:run()

    --- 展示个性描述
    self.disc:setString(Hero_Disc[index])

    CCUserDefault:sharedUserDefault():setIntegerForKey("hero_index",index)
end




return Role