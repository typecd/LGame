local Obstacle = class("Obstacle" ,function()
    return CCNode:create()
end)

--[[
    type 1-障碍物  碰撞游戏结束
         2-金币   碰撞后自身消失,增加金币
         3-道具(无敌)
         4-道具(飞行)
]]

local Obstacle_type = {
    Obstacle = 1,
    Coin = 2,
    Blink = 3,
    Fly = 4,
}

function Obstacle:ctor(type,size) 
    
    self._isCounted = false;

    if type == Obstacle_type.Obstacle then
        local img = display.newScale9Sprite(IMG_PATH .. "black.png",0,0 ,size)
        img:setAnchorPoint(ccp(0,0))
        img:addTo(self)
        self:pos(display.size.width + 30 ,4)
        self:setContentSize(size)
    elseif type == Obstacle_type.Coin then
        local img = display.newSprite(IMG_PATH .. "coin.png")
        img:setAnchorPoint(ccp(0,0))
        img:addTo(self)
        self:pos(display.size.width + 30 ,120)
        self:setContentSize(img:getContentSize())
    end

end


return Obstacle