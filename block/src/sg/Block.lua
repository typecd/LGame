local BlockData = require("sg/BlockData");

local Block = class("Block",function() 
    return display.newLayer()
end)

function Block:ctor(type,index,originBlock,enable)
    if enable == nil then
        enable = true;
    end

    self.dragScale = 1;
    self._startPos = ccp(0,0);
    self._stagePos = ccp(0,0);
    self._type = type;
    self._index = index;
    self._originBlock = originBlock;
    local name = "";
    if type == 0 and index == 0 then
        name = CONFIG.R.holder;
        self._map = {{1}};
    else
        name = CONFIG.R["block_"..type.."_"..index];
        self._map = BlockData:getInstance():getBlockData(type,index);
    end

    self._bitmap = display.newSprite(name);
    self._bitmap:setAnchorPoint(ccp(0,0))
    -- print("size:",self._bitmap:getContentSize().width,self._bitmap:getContentSize().height);
    -- self._bitmap:pos(5,5);
    self:setContentSize(self._bitmap:getContentSize()) 
    self:addChild(self._bitmap,1)

    -- local bound = display.newColorLayer(ccc4(0,0,255,100));
    -- bound:setContentSize(self._bitmap:getContentSize())
    -- bound:addTo(self)

    self.height = self._bitmap:getContentSize().height
    self.width = self._bitmap:getContentSize().width
end


function Block:showShadow()
    local name = CONFIG.R["shadow_"..self._type.."_"..self._index]
    local shadow = display.newSprite(name)
    shadow:setAnchorPoint(ccp(0,0))
    self:addChild(shadow,0);

    self.height = shadow:getContentSize().height
    self.width =shadow:getContentSize().width
    self:setContentSize(shadow:getContentSize()) 
    self._bitmap:pos(5,5);
end




function Block:show()
    self._bitmap:setVisible(true)
end


function Block:hide()
    self._bitmap:setVisible(false)
end 


function Block:type()
    return self._type;
end
function Block:index()
    return self._index;
end
function Block:map()
    return self._map;
end
function Block:copyBlock()
    if not self:isCopy() then
        self._copyBlock = Block.new(self._type,self._index,self);
        self._copyBlock.rightRow = self.rightRow;
        self._copyBlock.rightCol = self.rightCol;
    end
    return self._copyBlock;
end
function Block:originBlock()
    return self._originBlock;
end
function Block:isCopy()
    return self._originBlock ~= nil;
end
function Block:isHolder()
    return self._type == 0 and self._index == 0;
end
function Block:isHide()
    return not self._bitmap:isVisible();
end



return Block;