local LayerBase = class("LayerBase",function() 
    return display.newLayer()
end)

function LayerBase:ctor()
    self.btnArr = {};
end

function LayerBase:addButton(btn)

    table.insert(self.btnArr,btn);

end

function LayerBase:setButtonEnabled(enable)

    for i = #self.btnArr, 1, -1 do 
        local btn = self.btnArr[i];
        if not tolua.isnull(btn) then
            btn:setTouchEnabled(enable)
        else
            table.remove(self.btnArr,i);
        end
    end
end


return LayerBase