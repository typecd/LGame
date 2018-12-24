local AnimationNumberLabel = class("AnimationNumberLabel", function ()
	local nodeRGBA = CCNodeRGBA:new()
	nodeRGBA:autorelease()
	return nodeRGBA
end)

local scheduler = require("base.framework.scheduler")

local ALIGNMENT_TYPE = {
	LEFT = 1,
	CENTER = 2,
	RIGHT = 3,
}
AnimationNumberLabel.ALIGNMENT_TYPE = ALIGNMENT_TYPE

local ANIMATION_INTERVAL = 1 / 59
function AnimationNumberLabel:ctor(numberName, numberPrfix, useBatch)
	self:setNodeEventEnabled(true)

	self.from = 0
	self.to = 0

	self.animating = false
	self.animationElapsed = 0
	self.animationDuration = 0


	self.numberName = numberName
	self.numberPrfix = numberPrfix
    self.useBatch = useBatch == nil and true and useBatch

	display.addSpriteFramesWithFile(numberName .. ".plist", numberName .. ".png")

	if self.useBatch then
		self.base = display.newBatchNode(numberName .. ".png")
	else
		self.base = CCNodeRGBA:new()
		self.base:autorelease();
	end
	self.base:addTo(self)
	self:setAnchorPoint(0.5, 0.5)

	self.unitMaxSize = self:calculateUnitMaxSize()
	self.numSprites = {}

	-- math.randomseed(os.time())
	self.alignmentType = ALIGNMENT_TYPE.CENTER
end

function AnimationNumberLabel:onEnter()
	-- print("AnimationNumberLabel:onEnter")
	self:startScheduler()
end

function AnimationNumberLabel:onExit()
	-- print("AnimationNumberLabel:onExit")
	self:stopScheduler()
	self.base:removeAllChildrenWithCleanup(true)
end

function AnimationNumberLabel:setAlignmentType(type)
	self.alignmentType = type
end

function AnimationNumberLabel:setAnimationCompletionHandler(handler)
	self.animationCompletionHandler = handler
end

function AnimationNumberLabel:isAnimating()
	return self.animating
end

function AnimationNumberLabel:stopAnimation()
	self:stopScheduler()

	self.animating = false
	self.animationElapsed = 0
	self.animationDuration = 0

	if self.numStr then
		self:setNumberString(self.numStr)
	end
end

function AnimationNumberLabel:startScheduler()
	if self.scheduler == nil then
		print("AnimationNumberLabel:startScheduler")

		self.scheduler = scheduler.scheduleGlobal(function(dt) 
			-- print ("update dt", dt)
			if self.animating then
				self.animationElapsed = self.animationElapsed + dt
				if self.animationElapsed >= self.animationDuration then 
					self:stopAnimation()
					if self.animationCompletionHandler then 
						self.animationCompletionHandler()
					end
				else
					local modify = (self.to - self.from) * (self.animationElapsed / self.animationDuration) + self.from
					-- print("mod num: ", mod)
					self:setNumberString(self:numberToString(modify))
				end
			end
		end, ANIMATION_INTERVAL)
	end
end

function AnimationNumberLabel:stopScheduler()
	if self.scheduler then
		scheduler.unscheduleGlobal(self.scheduler)
		self.scheduler = nil
	end 
end

function AnimationNumberLabel:getNumberRange()
	return self.from, self.to
end

function AnimationNumberLabel:setNumberRange(from, to, animationDuration)
	assert(from and type(from) == "number", "from number must be non nil")
	assert(to and type(to) == "number", "to number must be non nil")
	-- print("setNumber", num, animationDuration)
	self.from = from
	self.to = to

	self.numStr = self:numberToString(self.to)
	self.numCount = #self.numStr
	self:setUpNumberSprites(self.numCount)
	
	if animationDuration then 
		local m = self.to * ANIMATION_INTERVAL / animationDuration % 100
		-- print("module: ", m) 
		if m == 0 then 
			animationDuration = animationDuration - 0.03
		end
		self.animationDuration = animationDuration

		self:setNumberString(self:numberToString(from))
		
		self.animating = true
		self:startScheduler()
	else 
		self:stopAnimation()
	end
end

function AnimationNumberLabel:getNumber()
	return self.to
end

function AnimationNumberLabel:setNumber(number, animationDuration)
	self:setNumberRange(0.00, number, animationDuration)
end

function AnimationNumberLabel:numberToString(number)
	local numStr = string.format("%0.2f", number)
	-- print("numStr: ", numStr)
	return numStr
end

function AnimationNumberLabel:setNumberString(numStr)
	local numCount = #numStr

	local spCount = #self.numSprites
	for i = 1, spCount do
		local sp = self.numSprites[i]
		if sp then 
			if i <= numCount then
				local c = numStr:sub(-i, -i)
				-- print(string.format("c: %s", c))
				local spriteFrame = display.newSpriteFrame(self.numberPrfix .. c .. ".png") 
				if spriteFrame then 
					sp:setVisible(true)
					sp:setDisplayFrame(spriteFrame)
				end
			else
				sp:setVisible(false)
			end
		end
	end

	if self.numCount ~= numCount and numCount <= spCount then 
		-- print("numCount not equal", self.numCount, numCount)
		self.numCount = numCount

		local displayWidth = self.numCount * self.unitMaxSize.width
		local width = self:size().width
		-- print("displayWidth and width", displayWidth, width)
		if self.alignmentType == ALIGNMENT_TYPE.LEFT then 
			self.base:pos(displayWidth, 0)
		elseif self.alignmentType == ALIGNMENT_TYPE.CENTER then 
			self.base:pos(displayWidth + (width - displayWidth) / 2, 0)
		elseif self.alignmentType == ALIGNMENT_TYPE.RIGHT then 
			self.base:pos(width, 0)
		end
	end
end

function AnimationNumberLabel:setOpacity(opacity)
	if self.numSprites then 
		for _, sp in ipairs(self.numSprites) do 
			sp:setOpacity(opacity)
		end
	end
end

function AnimationNumberLabel:setUpNumberSprites(numCount)
	for i, sp in ipairs(self.numSprites) do
		sp:removeFromParentAndCleanup(true)
		self.numSprites[i] = nil
	end

	local w, h = 0, 0
	local x = 0
	local spriteFrame = display.newSpriteFrame(self.numberPrfix .. "0.png")  
	for i = 1, numCount do 
		local sp = display.newSprite()
		if sp then 
			sp:setContentSize(self.unitMaxSize)
			sp:setAnchorPoint(0.5, 0)
			sp:setPosition(x - self.unitMaxSize.width * 0.5, 0)
			sp:addTo(self.base)
			
			x = x - sp:size().width
			w = w + sp:size().width
			h = math.max(h, sp:size().height)
			table.insert(self.numSprites, sp)
		end
	end
	self.base:setPosition(w, 0)
	self:setContentSize(w, h)
end

function AnimationNumberLabel:getUnitMaxSize()
	return self.unitMaxSize
end

function AnimationNumberLabel:calculateUnitMaxSize()
	local maxWidth = 0
	local maxHeight = 0
	local unitNames = {}
	for i = 1, 10 do
		table.insert(unitNames, tostring(i - 1))
	end
	table.insert(unitNames, ".")

	for _, unitName in ipairs(unitNames) do
		local spriteFrame = display.newSpriteFrame(self.numberPrfix .. unitName .. ".png") 
		if spriteFrame then 
			maxWidth = math.max(maxWidth, spriteFrame:getOriginalSize().width)
			maxHeight = math.max(maxHeight, spriteFrame:getOriginalSize().height)
		end
	end
	return CCSizeMake(maxWidth, maxHeight)
end

-- math.round = function (decimal)
-- 	if math.abs(decimal - math.floor(decimal)) > 0.5 then 
-- 		return math.ceil(decimal)
-- 	else
-- 		return math.floor(decimal)
-- 	end
-- end

-- function AnimationNumberLabel:setNumber(number, animated, animateCount, animateInterval)
-- 	animated = animated == nil and true or animated
-- 	if animated then 
-- 		animateCount = animateCount or ANIMATION_COUNT
-- 		animateInterval = animateInterval or ANIMATION_INTERVAL
-- 	end
-- 	local num = ""
-- 	if type(number) ~= "number" then
-- 		num = math.floor(tonumber(number))
-- 	else
-- 		num = number
-- 	end

-- 	self.numberGroup = self:splitNumberToGroup(number)
-- 	self:setUpNumberSprites(#self.numberGroup)

-- 	if animateCount and animateInterval then 
-- 		local numberCount = #self.numberGroup

-- 		local animatedCount = 0
-- 		self.scheduler = self:schedule(function () 
-- 			if animatedCount >= animateCount then 
-- 				if self.scheduler then
-- 					self:stopAction(self.scheduler)
-- 				end 
-- 				self:updateNumberSprites(self.numberGroup)
-- 				if self.animationCompletionHandler then 
-- 					self.animationCompletionHandler()
-- 				end
-- 			else
-- 				local numberGroup = self:getRandomNumberGroup(numberCount)
-- 				self:updateNumberSprites(numberGroup)
-- 				animatedCount = animatedCount + 1
-- 			end
-- 		end, animateInterval)
-- 	else 
-- 		self:updateNumberSprites(self.numberGroup)
-- 	end
-- end

-- function AnimationNumberLabel:splitNumberToGroup(num)
-- 	local group = {}
-- 	local integer = math.floor(num)

-- 	if integer == num then
-- 		local left = num
-- 		while true do
-- 			local temp = math.floor(left / 10)
-- 			insert = left % 10
-- 			left = temp
-- 			table.insert(group, insert)
-- 			if left == 0 then
-- 				break
-- 			end
-- 		end
-- 	else
-- 		local multiple = num * 100
-- 		local int = math.floor(multiple)
-- 		local left = int
-- 		while true do
-- 			local temp = math.floor(left / 10)
-- 			insert = left % 10
-- 			left = temp
-- 			table.insert(group, insert)
-- 			if left == 0 then
-- 				break
-- 			end
-- 		end

-- 		table.insert(group, 3, "dot")
-- 	end

-- 	return group
-- end

-- function AnimationNumberLabel:updateNumberSprites(numGroup)
-- 	for i = 1, #numGroup do
-- 		local unit = numGroup[i]
-- 		local spriteFrame = display.newSpriteFrame(self.numberPrfix .. unit .. ".png") 
-- 		if spriteFrame and i <= #self.numSprites then 
-- 			local sp = self.numSprites[i]
-- 			if sp then 
-- 				sp:setDisplayFrame(spriteFrame)
-- 			end
-- 		end
-- 	end
-- end

-- function AnimationNumberLabel:getRandomNumberGroup(numCount)
-- 	local group = {}
-- 	for i = 1, numCount do 
-- 		table.insert(group, math.random(10) - 1) 
-- 	end
-- 	return group
-- end


return AnimationNumberLabel