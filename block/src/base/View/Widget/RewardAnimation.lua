--- 小獎的共用動畫
-- 取自財神到,修改為共用元件
-- Usage Example:
--[[
-- 初始化
-- -- 呼叫動畫出來, 真正開始播放在"動畫開始"

	local RewardAnimation = require("base.View.Widget.RewardAnimation")
	local smallReward = RewardAnimation.create(  
        "lhj/number/reward_num", -- 帶入圖集(TexturePacker)合圖路徑
        "reward_num" -- 帶入圖集內的圖片名稱
    )
	smallReward:addTo(self)

-- 動畫開始
-- -- 動畫開始後,可以不用做其他動作, 就可以直接從開始播放到動畫結束

	smallReward:start(
		18000,  -- rewardNumber, 動畫最後停止時所要顯示的小獎金額
		2.5  --  rewardDuration, 動畫總共表演的時間秒數
	)

-- 動畫跳到正常結束(特殊)
-- -- 動畫未完成時, 強制跳到動畫即將要結束的狀況, 並且執行結束的動畫, 可以不呼叫
-- -- 注意!!動畫結束還是會呼叫NumberRollCompletionHandler及AnimationCompletionHandler這2個

	smallReward:stop()

-- 動畫直接強制結束(特殊)
-- -- 不管動畫做到哪裡直接終止, 吃雞專案遇到的新需求, 可以不呼叫

	smallReward:forceStop()

-- 其他設定類(特殊)
-- -- 需要的自行使用就好

	smallReward:setNumberRollStartHandler(function() print("數字轉動開始") end)
	smallReward:setNumberRollCompletionHandler(function() print("數字轉動結束") end)
	smallReward:setAnimationCompletionHandler(function(isStopAhead) 
		if not isStopAhead then print("動畫結束") end
	end)
	smallReward:setNumberScale(0.9)

--]]

local AnimationNumberLabel = require("base.View.Widget.AnimationNumberLabel")
local ComponentAnimation = require("base.View.Widget.ComponentAnimation")

local NUM_EXIST_DURATION = 1
local NUM_DISMISS_DURATION1 = 0.1
local NUM_DISMISS_DURATION2 = 0.2

local RewardAnimation = class("RewardAnimation", function ()
	local nodeRGBA = CCNodeRGBA:new()
	nodeRGBA:autorelease()
	return nodeRGBA
end)

--- 起始的create函示RewardAnimation.create
--@ numberName 帶入plist合圖路徑, 給裡面的AnimationNumberLabel使用
--@ numberPrfix 帶入frame name, 給裡面的AnimationNumberLabel使用
function RewardAnimation.create(numberName, numberPrfix)
    return RewardAnimation.new(numberName, numberPrfix)
end

function RewardAnimation:ctor(numberName, numberPrfix)
	self:setVisible(false)
	self:setScale(UITools.getScreenScale())
	self.isRunFinalAction = false;

	self:setCascadeOpacityEnabled(true)
	self.animating = false
	self.numberScale = 1 -- 預設的number縮放大小

	local numNode = CCNodeRGBA:new()
	numNode:autorelease()
	numNode:addTo(self)
	numNode:pos(0, 0)
	numNode:setCascadeOpacityEnabled(true)
	self.numNode = numNode

	local numLabel = AnimationNumberLabel.new(numberName, numberPrfix)
	numLabel:pos(0, 0)
	numLabel:addTo(numNode) 
	numLabel:setScale(0.7)
	numLabel:setCascadeOpacityEnabledRecursively(true)
	numLabel:setAnimationCompletionHandler(function () 
		if self.numberRollCompletionHandler then
			-- print("Reward number scroll stop normally")
			self.numberRollCompletionHandler()
		end

		self:performWithDelay(function() 
			self.isRunFinalAction = true;
			self.numNode:stopAllActions();
			self.numNode:runAction(transition.sequence({
				CCScaleTo:create(NUM_DISMISS_DURATION1, 0.9 * self.numberScale),
				CCCallFunc:create(function() 
					self.numNode:stopAllActions();
					self.numNode:runAction(CCScaleTo:create(NUM_DISMISS_DURATION2, 1.5 * self.numberScale))
					self:stopAllActions();
					self:runAction(transition.sequence({
						CCFadeOut:create(NUM_DISMISS_DURATION2),
						CCCallFunc:create(function() 
							if self.animationCompletionHandler then 
								-- print("Reward animation stop normally")
								self.animationCompletionHandler(false)
							end
							self:setVisible(false)
							self.animating = false
						end)
					}))
				end)
			}))
		end, NUM_EXIST_DURATION)
	end)
	self.numLabel = numLabel

	local plus = display.newSprite("#" .. numberPrfix .. "p.png")
	-- plus:pos(-numLabel:boundingBox().size.width / 2 - 40, numLabel:getPositionY())
	plus:addTo(numNode)
	plus:setScale(0.65)
	plus:setCascadeOpacityEnabled(true)
	self.plus = plus

	local yuan = display.newSprite("#" .. numberPrfix .. "y.png")
	-- yuan:pos(numLabel:boundingBox().size.width / 2 + 40, numLabel:getPositionY())
	yuan:addTo(numNode)
	yuan:setScale(0.7)
	yuan:setCascadeOpacityEnabled(true)
	self.yuan = yuan
	if not CacheEngine.isOpenYuan() then
		self.yuan:setVisible(false)
	end
end

function RewardAnimation:setNumberRollStartHandler(handler)
	self.numberRollStartHandler = handler
end

function RewardAnimation:setNumberRollCompletionHandler(handler)
	self.numberRollCompletionHandler = handler
end

function RewardAnimation:setAnimationCompletionHandler(handler)
	self.animationCompletionHandler = handler
end

--- 設定數字的大小
--@ scale 倍率 預設0.8
function RewardAnimation:setNumberScale(scale)
	self.numberScale = scale
end

function RewardAnimation:start(rewardNumber, rewardDuration)
	rewardDuration = rewardDuration or 1
	
	self.isRunFinalAction = false;
	if self.animating then 
		return 
	end
	self.animating = true

	self:setVisible(true)
	self:setOpacity(255)
	self:stopAllActions();
	self.numNode:setOpacity(255)
	self.numNode:setScale(0.8 * self.numberScale)
	self.numNode:stopAllActions();
	self.numNode:runAction(transition.sequence({
		CCScaleTo:create( 0.15, 1.1 * self.numberScale), 
		CCScaleTo:create( 0.15, 1 * self.numberScale)
	}))

	self.numLabel:setNumber(rewardNumber, rewardDuration)
	if self.numberRollStartHandler then 
		-- print("Reward number scroll start")
		self.numberRollStartHandler()
	end

	local width = self.numLabel:boundingBox().size.width + self.yuan:boundingBox().size.width
	local height = math.max(self.numLabel:boundingBox().size.height, self.yuan:boundingBox().size.height)
	self.numNode:setContentSize(width, height)
	self.numNode:setAnchorPoint(0.5, 0.5)
	self.numNode:pos(0, 0)

	self.numLabel:pos(0, height * 0.5)
	self.numLabel:setAnchorPoint(0, 0.5)

	self.yuan:pos(self.numLabel:boundingBox().size.width + 5, height * 0.5)
	self.yuan:setAnchorPoint(0, 0.5)
	if self.plus then
		self.plus:pos(- self.plus:size().width * 0.5, self.numLabel:getPositionY())
		self.numNode:setPositionX(self.numNode:getPositionX() + self.plus:size().width / 4)
	end

	-- local pos = self:convertToWorldSpace(ccp(self.numNode:getPosition()))
	-- pos.x = pos.x - self.numNode:size().width * 0.5
	-- pos.y = pos.y - self.numNode:size().height * 0.5
	-- print("num origin world", pos.x, pos.y)
	-- if pos.x < 0 then 
	-- 	self.numNode:setPositionX(self.numNode:getPositionX() + math.abs(pos.x))
	-- end

end

function RewardAnimation:stop()
	if not self.animating then 
		return
	end
	self.animating = false

	if(not self.isRunFinalAction) then
		self:stopAllActions()
		self:performWithDelay(function() 
			self.numNode:stopAllActions();
			self.numNode:runAction(transition.sequence({
				CCScaleTo:create(NUM_DISMISS_DURATION1, 0.9 * self.numberScale),
				CCCallFunc:create(function() 
					self.numNode:stopAllActions();
					self.numNode:runAction(CCScaleTo:create(NUM_DISMISS_DURATION2, 1.5 * self.numberScale))
					self:stopAllActions();
					self:runAction(transition.sequence({
						CCFadeOut:create(NUM_DISMISS_DURATION2),
						CCCallFunc:create(function() 
							self:setVisible(false)
						end)
					}))
				end)
			}))
		end, NUM_EXIST_DURATION)
	end

	if self.numLabel:isAnimating() then 
		self.numLabel:stopAnimation()
		if self.numberRollCompletionHandler then 
			-- print("Reward number scroll interrupted")
			self.numberRollCompletionHandler()
		end
	end

	if self.animationCompletionHandler then 
		-- print("Reward animation interrupted")
		self.animationCompletionHandler(true)
	end 
end

--- 強制停止的功能
-- 如果強制停止後需要立即開始, 至少需要有1frame的間隔, 因AnimationNumberLabel:stopAnimation的處理時間
function RewardAnimation:forceStop()
	self:stopAllActions()
	self.numLabel:stopAnimation()
end


return RewardAnimation