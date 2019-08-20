local ConfirmBuyView = class("ConfirmBuyView", function() 
    return display.newColorLayer(ccc4(0,0,0,100))
end)

function ConfirmBuyView.show(parent)
    --- TODO
    local layer = ConfirmBuyView.new()
    layer:addTo(parent)
end

function ConfirmBuyView:ctor()
    --- TODO
     self:registerScriptTouchHandler(
        function(event, x, y)
            if event == "began" then
                
                return true
            elseif event == "ended" then
            end
        end,
        false,
        -127,
        true
    )
    self:setTouchEnabled(true)

    local bg = display.newSprite(CONFIG.IMG_PATH .. "bg_buy.png")
    bg:addTo(self)
    bg:pos(display.cx, display.cy)

    local btn_close = display.newButton({
        normal = CONFIG.IMG_PATH .. "btn_close.png",
        pressed = CONFIG.IMG_PATH .. "btn_close.png",
        callback = function(tag) 
            self:removeSelf()
        end
    })
    btn_close:addTo(bg)
    btn_close:pos(bg:getSize().width - 40, bg:getSize().height - 40)

    local bnt_confirm = display.newButton({
        normal = CONFIG.IMG_PATH .. "btn_buyjieshi.png",
        pressed = CONFIG.IMG_PATH .. "btn_buyjieshi.png",
        callback = function(tag) 
            if CONFIG.diamond >= 40 then
                CONFIG.meanTags[CONFIG.gate] = 1
                CONFIG.saveMeanTag()
                self:removeSelf()
            else
                print("金币不足")

            end
        end
    })
    bnt_confirm:addTo(bg)
    bnt_confirm:pos(bg:getSize().width/2 , 80)

    bg:scale(0)
    local seq = transition.sequence({
        CCScaleTo:create(0.5, 1.2, 1.2),
        CCScaleTo:create(0.2, 1, 1)
    })
    bg:runAction(seq)

end





return ConfirmBuyView