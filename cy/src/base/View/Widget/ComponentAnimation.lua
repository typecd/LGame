-- -- Usage:
-- -- Initialization
-- local ca = CA.new(BASE_ANIM .. "lhj_god_of_wealth.plist", BASE_ANIM .. "lhj_god_of_wealth.png")
-- ca:setPosition(0, 0)
-- ca:addTo(self)
-- -- Animate
-- -- should first prepare animation with a specific name and configuration json file
-- ca:prepareAnimation("idle", BASE_ANIM .. "ca_god_of_wealth_idle.json")
-- ca:prepareAnimation("reward", BASE_ANIM .. "ca_god_of_wealth_reward.json")
-- -- then call runAnimation with the specific name and animation loop count (Defaults to loopCountForever)
-- ca:runAnimation("idle", 1)
-- -- set completion handler to get animation completion call back
-- ca:setCompletionHandler(function (animName, loopCount)
-- 	if animName == "idle" then 
-- 		if loopCount == 3 then 
-- 			ca:runAnimation("reward", 3)
-- 		end
-- 	elseif animName == "reward" then 
-- 		if loopCount == 2 then 
-- 			ca:runAnimation("idle")
-- 		end
-- 	end
-- end
-- -- set event handler to get animation event call back
-- ca:setEventHandler(function (event)
-- 	if event.animName == "idle" and event.name == "blabla" then 
-- 		print("do blabla")
-- 	end
-- end)

local scheduler = require("base.framework.scheduler")

local CA_DEBUG = false

local blendModeAdd = "add"

local componentAttrs = {
	"anchorPoint",
	"position",
	"scale",
	"rotation",
	"opacity",	
}

local lume = {}

function lume.clone(t)
	local rtn = {}
	for k, v in pairs(t) do rtn[k] = v end
	return rtn
end

function lume.sort(t, comp)
	local rtn = lume.clone(t)
	if comp then
		if type(comp) == "string" then
	  		table.sort(rtn, function(a, b) return a[comp] < b[comp] end)
		else
	  		table.sort(rtn, comp)
		end
	else
		table.sort(rtn)
	end
	return rtn
end

local ComponentAnimation = class("ComponentAnimation", function() return CCNodeRGBA:new() end)
local json = require("base.framework.json")

local FPS = 25
local LOOP_COUNT_FOREVER = 0
local DEFAULT_ENABLE_PRE_CALCULATION = false
ComponentAnimation.FPS = FPS
ComponentAnimation.loopCountForever = LOOP_COUNT_FOREVER

-- Animation Information Json 

local componentJsonDataCache = {}
local getJsonData = function (jsonFile)
	local jsonData = componentJsonDataCache[jsonFile]
	if jsonData == nil then
		local bytesData = readFileAsText(jsonFile)
		if bytesData then
			jsonData = json.decode(bytesData)
			if jsonData then
				if CA_DEBUG then
					print("get json data succeeded %s", jsonFile)
				end
				componentJsonDataCache[jsonFile] = jsonData
			end
		end
	end
	return jsonData
end

local purgeJsonDataCache = function () 
	
	for k, v in pairs(componentJsonDataCache) do
		-- if CA_DEBUG then 
			print("remove component json data by key", k)
		-- end
		componentJsonDataCache[k] = nil
	end
	
end

-- Frame Animation 

local frameAnimationKeyCache = {}

local function purgeFrameAnimationCache() 
	for i, key in ipairs(frameAnimationKeyCache) do 
		CCAnimationCache:sharedAnimationCache():removeAnimationByName(key)
		-- if CA_DEBUG then 
			print("remove Frame Animation by key", key)
		-- end
		frameAnimationKeyCache[i] = nil
	end
end

local function createFrameAnimationComponent(imageName)
	local compName = imageName:sub(1, -5)
	local frameName = compName .. "/" .. compName .. "_00000.png"
	local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
	if spriteFrame == nil then 
		frameName = compName .. "_00000.png"
		spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
	end
	local component = nil
	if spriteFrame ~= nil then
		component = display.newSprite(spriteFrame)
	-- else
	--     component = display.newSprite(LHJ_ANIM .. frameName)
	end 

	if component then
		component:setVisible(false)
		component.runningAnimation = false
	end
	
	return component
end

local function getAnimationKey(name, startFrame, lastFrameCount)
	return name .. "_" .. startFrame .. "_" .. lastFrameCount
end

local function runFrameAnimation(component, loopCount)
	local imageName = component.data.imageName
	local startFrame = 0
	local lastFrameCount = component.data.lastFrameCount

	local compName = imageName:sub(1, -5)
	local animationKey = getAnimationKey(compName, startFrame, lastFrameCount)
	local frameAnimation = CCAnimationCache:sharedAnimationCache():animationByName(animationKey)
	if frameAnimation == nil then
		local frames = display.newFrames(compName .. "/" .. compName .. "_%05d.png", startFrame, lastFrameCount);
		if frames == nil or #frames == 0 then 
			frames = display.newFrames(compName .. "_%05d.png", startFrame, lastFrameCount)
			-- if frames == nil or #frames == 0 then 
			-- 	frames = {}
			-- 	for i = startFrame, lastFrameCount + startFrame - 1 do
			-- 		local imageFmt = LHJ_ANIM .. compName .. "_%05d.png"
			-- 		local imageName = string.format(imageFmt, i)
			-- 		local tex = CCTextureCache:sharedTextureCache():addImage(imageName)
			-- 		print ("create texture ", imageName)
			-- 		if tex then
			-- 			local size = tex:getContentSizeInPixels()
			-- 			local spriteFrame = CCSpriteFrame:createWithTexture(tex, CCRectMake(0, 0, size.width, size.height))
			-- 			if spriteFrame then
			-- 				print ("create spriteFrame ", imageName)
			-- 				table.insert(frames, spriteFrame)
			-- 			end
			-- 		end
			-- 	end
			-- end
		end
		
		if frames ~= nil and #frames > 0 then
			frameAnimation = display.newAnimation(frames, 1 / FPS);
			CCAnimationCache:sharedAnimationCache():addAnimation(frameAnimation, animationKey)
			table.insert(frameAnimationKeyCache, animationKey)
			if CA_DEBUG then 
				print("add Frame Animation to cache by key", animationKey)
			end
		end
	else
		if CA_DEBUG then 
			print("get Frame Animation from cache by key", animationKey)
		end
	end

	if frameAnimation then
	   	if loopCount ~= 0 then
	   		transition.playAnimationOnce(component, frameAnimation, false, nil, 0)
	   	else
	   		transition.playAnimationForever(component, frameAnimation, 0)
		end
	    component:setVisible(true)
		component.runningAnimation = true
		if CA_DEBUG then
			print("runFrameAnimation", imageName, lastFrameCount)
		end
	end
end

-- External Interface

ComponentAnimation.getJsonData = getJsonData
ComponentAnimation.purgeJsonDataCache = purgeJsonDataCache
ComponentAnimation.purgeFrameAnimationCache = purgeFrameAnimationCache

function ComponentAnimation:setOpacityO(opacity)
	if self.useBatch then 
		for _, component in ipairs(self.components) do 
			component:setOpacity(opacity)
		end
	else
		self:setOpacity(opacity)
	end
end

function ComponentAnimation:fadeIn(duration, callback)
	self:setCascadeOpacityEnabledRecursively(true)
	local createAction = function ()
		local action = nil
		if callback then 
			action = transition.sequence({
				CCFadeIn:create(duration),
				CCCallFunc:create(callback),
			})
		else 
			action = CCFadeIn:create(duration)
		end
		return action
	end
	if self.useBatch then
		for _, component in ipairs(self.components) do 
			local action = createAction()
			component:runAction(action)
		end
	else
		local action = createAction()
		self:runAction(action)
	end
end

function ComponentAnimation:fadeOut(duration, callback)
	self:setCascadeOpacityEnabledRecursively(true)
	local createAction = function ()
		local action = nil
		if callback then 
			action = transition.sequence({
				CCFadeOut:create(duration),
				CCCallFunc:create(callback),
			})
		else 
			action = CCFadeOut:create(duration)
		end
		return action
	end
	if self.useBatch then
		for _, component in ipairs(self.components) do 
			local action = createAction()
			component:runAction(action)
		end
	else
		local action = createAction()
		self:runAction(action)
	end
end

function ComponentAnimation:runAnimation(animName, loopCount)
	animName = animName or ""
	if self:getAnimDataByName(animName) == nil then 
		if CA_DEBUG then
			print(string.format("animation %s not prepare yet", animName))
		end
		return
	end
	if self.curAnimName then 
		if CA_DEBUG then
			print(string.format("stop running animation %s to run new animation %s", self.curAnimName, animName))
		end
		self:stopAnimation()
	end 

	self.curAnimName = animName
	self.loopCount = loopCount or loopCountForever
	if self.curPreparedAnimName ~= self.curAnimName then
		self:prepareAnimationComponents(self.curAnimName)
	end
end

function ComponentAnimation:stopAnimation(animName)
	if animName ~= nil then
		if self.curAnimName == animName then
			if CA_DEBUG then
				print("stop animation %s", self.curAnimName)
			end
			self:stop()
		end
	else
		if CA_DEBUG then
			print("stop animation %s", self.curAnimName)
		end
		self:stop()
	end 
end

-- set animation completion handler with two parameters (animName, loopCount)

function ComponentAnimation:setCompletionHandler(handler)
	self.completionHandler = handler
end

-- set event handler with one parameter (event = {name = "name", frame = "1"})

function ComponentAnimation:setEventHandler(handler)
	self.eventHandler = handler
end

function ComponentAnimation:setTimeScale(timeScale)
	self.timeScale = timeScale
	self:stopScheduler()
	self:startScheduler()
end

-- reset to set up pose for animation with the specific name  
function ComponentAnimation:resetToSetUpPose(animName)
	animName = animName or ""
	local animData = self:getAnimDataByName(animName)
	if animData == nil then
		for k, v in pairs(self.animDatas) do 
			animData = v
			break
		end
	end
	if animData then
		self:resetToSetUp(animData)
	end
end

function ComponentAnimation:getCurrentAnimation()
	return self.curAnimName, self.loopCount
end

function ComponentAnimation:ctor(plistFile, atlasFile, useBatch)
	self:autorelease();
	self:setNodeEventEnabled(true); 

	self.curAnimName = nil
	self.loopCount = 1
	-- self.elapsed = 0
	self.frameCounter = 0
	self.loopCounter = 0

	self.timeScale = 1.0

	self.animDatas = {}
	self.components = {}
	self.events = {}

	if plistFile and atlasFile then
		self.plistFile = plistFile
		self.atlasFile = atlasFile
		-- CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(self.plistFile)
	end

	useBatch = useBatch or false
	self.useBatch = useBatch
	if self.useBatch then
		self.baseNode = display.newBatchNode(atlasFile)		
	else 
		self.baseNode = CCNodeRGBA:new()
		self.baseNode:autorelease();
	end
	self.baseNode:addTo(self)
end

function ComponentAnimation:getComponentByIDAndImageName(ID, imageName) 
	for _, component in ipairs(self.components) do 
		if component.data and component.data.ID == ID and component.data.imageName == imageName then 
			return component
		end
	end
	return nil
end

function ComponentAnimation:getComponentByID(ID) 
	for _, component in ipairs(self.components) do 
		if component.data and component.data.ID == ID then 
			return component
		end
	end
	return nil
end

function ComponentAnimation:getComponentByImageName(imageName) 
	for _, component in ipairs(self.components) do 
		if component.data and component.data.imageName == imageName then 
			return component
		end
	end
	return nil
end

function ComponentAnimation:getAttrKeyFrameInfosData(compInfo, attr)
	local t = {}
	t.curKeyFrameIndex = 1

	local keyframes = compInfo[attr]
	local keyFrameInfos = {}
	for _, keyFrameInfo in pairs(keyframes) do
		table.insert(keyFrameInfos, keyFrameInfo)
	end
	t.keyFrameInfos = lume.sort(keyFrameInfos, "frame")
	
	function t:getCurKeyFrameInfo() 
		return self.keyFrameInfos[self.curKeyFrameIndex]
	end
	
	function t:getNextKeyFrameInfo() 
		if self.curKeyFrameIndex >= #self.keyFrameInfos then
			return nil
		end
		return self.keyFrameInfos[self.curKeyFrameIndex + 1]
	end

	function t:resetToSetUpKeyFrame()
		self.curKeyFrameIndex = 1
	end

	function t:goNextKeyFrameInfo()
		if self.curKeyFrameIndex >= #self.keyFrameInfos then
			return
		end
		self.curKeyFrameIndex = self.curKeyFrameIndex + 1;
	end

	return t
end

function ComponentAnimation:getDeltaAttrKeyFrameInfosData(compInfo, attr)
	local t = {}
	t.curKeyFrameStageIndex = 1

	function t:getCurDeltaKeyFrameInfo() 
		return self.deltaKeyFrameInfos[self.curKeyFrameStageIndex]
	end

	function t:resetToSetUpKeyFrame()
		self.curKeyFrameStageIndex = 1
	end

	function t:goNextDeltaKeyFrameInfo()
		if self.curKeyFrameStageIndex >= #self.deltaKeyFrameInfos then
			return
		end
		self.curKeyFrameStageIndex = self.curKeyFrameStageIndex + 1;
	end

	local keyframes = compInfo[attr]
	local keyFrameInfos = {}
	for _, keyFrameInfo in pairs(keyframes) do
		table.insert(keyFrameInfos, keyFrameInfo)
	end
	keyFrameInfos = lume.sort(keyFrameInfos, "frame")
	
	local deltaKeyFrameInfos = {}
	for i = 1, #keyFrameInfos do 
		local deltaKeyFrameInfo = {}
		deltaKeyFrameInfos[i] = deltaKeyFrameInfo

		local curKeyFrameInfo = keyFrameInfos[i]
		local nextKeyFrameInfo = nil
		if i + 1 <= #keyFrameInfos then 
			nextKeyFrameInfo = keyFrameInfos[i + 1]
		else
			nextKeyFrameInfo = curKeyFrameInfo
		end
		if curKeyFrameInfo and nextKeyFrameInfo then 
			deltaKeyFrameInfo.fromFrame = curKeyFrameInfo.frame
			deltaKeyFrameInfo.toFrame = nextKeyFrameInfo.frame
			
			local deltaFrame = nextKeyFrameInfo.frame - curKeyFrameInfo.frame	
			if curKeyFrameInfo.anchorPoint and nextKeyFrameInfo.anchorPoint then
				deltaKeyFrameInfo.startAnchorPoint = curKeyFrameInfo.anchorPoint
				deltaKeyFrameInfo.endAnchorPoint = nextKeyFrameInfo.anchorPoint

				if deltaFrame > 0 then
					local deltaAnchorPointX = (nextKeyFrameInfo.anchorPoint.x - curKeyFrameInfo.anchorPoint.x) / deltaFrame
					local deltaAnchorPointY = (nextKeyFrameInfo.anchorPoint.y - curKeyFrameInfo.anchorPoint.y) / deltaFrame
					deltaKeyFrameInfo.deltaAnchorPoint = ccp(deltaAnchorPointX, deltaAnchorPointY) 
					if CA_DEBUG then
						print (string.format("pre calculate component %s delta anchorPoint %f,%f frame from %d to %d", compInfo.imageName, deltaAnchorPointX, deltaAnchorPointY, curKeyFrameInfo.frame, nextKeyFrameInfo.frame))
					end
				end
			end

			if curKeyFrameInfo.position and nextKeyFrameInfo.position then
				deltaKeyFrameInfo.startPosition = curKeyFrameInfo.position
				deltaKeyFrameInfo.endPosition = nextKeyFrameInfo.position

				if deltaFrame > 0 then
					local deltaPositionX = (nextKeyFrameInfo.position.x - curKeyFrameInfo.position.x) / deltaFrame
					local deltaPositionY = (nextKeyFrameInfo.position.y - curKeyFrameInfo.position.y) / deltaFrame * -1						
					deltaKeyFrameInfo.deltaPosition = ccp(deltaPositionX, deltaPositionY) 
					if CA_DEBUG then
						print (string.format("pre calculate component %s delta position %f,%f frame from %d to %d", compInfo.imageName, deltaPositionX, deltaPositionY, curKeyFrameInfo.frame, nextKeyFrameInfo.frame))
					end
				end
			end

			if curKeyFrameInfo.scale and nextKeyFrameInfo.scale then
				deltaKeyFrameInfo.startScale = curKeyFrameInfo.scale
				deltaKeyFrameInfo.endScale = nextKeyFrameInfo.scale

				if deltaFrame > 0 then
					local deltaScaleX = (nextKeyFrameInfo.scale.x - curKeyFrameInfo.scale.x) / deltaFrame
					local deltaScaleY = (nextKeyFrameInfo.scale.y - curKeyFrameInfo.scale.y) / deltaFrame
					deltaKeyFrameInfo.deltaScale = ccp(deltaScaleX, deltaScaleY)
					if CA_DEBUG then
						print (string.format("pre calculate component %sdelta scale %f,%f frame from %d to %d", compInfo.imageName, deltaScaleX, deltaScaleY, curKeyFrameInfo.frame, nextKeyFrameInfo.frame))
					end
				end
			end

			if curKeyFrameInfo.rotation and nextKeyFrameInfo.rotation then
				deltaKeyFrameInfo.startRotation = curKeyFrameInfo.rotation
				deltaKeyFrameInfo.endRotation = nextKeyFrameInfo.rotation
				
				if deltaFrame > 0 then
					local deltaRotation = (nextKeyFrameInfo.rotation - curKeyFrameInfo.rotation) / deltaFrame
					deltaKeyFrameInfo.deltaRotation = deltaRotation
					if CA_DEBUG then
						print (string.format("pre calculate component %s delta rotation %f frame from %d to %d", compInfo.imageName, deltaRotation, curKeyFrameInfo.frame, nextKeyFrameInfo.frame))
					end
				end
			end

			if curKeyFrameInfo.opacity and nextKeyFrameInfo.opacity then
				deltaKeyFrameInfo.startOpacity = curKeyFrameInfo.opacity
				deltaKeyFrameInfo.endOpacity = nextKeyFrameInfo.opacity

				if deltaFrame > 0 then
					local deltaOpacity = (nextKeyFrameInfo.opacity - curKeyFrameInfo.opacity) / deltaFrame
					deltaKeyFrameInfo.deltaOpacity = deltaOpacity
					if CA_DEBUG then
						print (string.format("pre calculate component %s delta opacity %f  frame from %d to %d", compInfo.imageName, deltaOpacity, curKeyFrameInfo.frame, nextKeyFrameInfo.frame))
					end
				end
			end
		end
	end
	t.deltaKeyFrameInfos = deltaKeyFrameInfos
	return t
end

function ComponentAnimation:prepareAnimation(animName, animComponentInfoJson, preCalculate)
	assert(animName, "animation name must be a valid string")
	assert(animComponentInfoJson and animComponentInfoJson ~= "", "animComponentInfoJson not valid")
	preCalculate = preCalculate == nil and DEFAULT_ENABLE_PRE_CALCULATION or preCalculate

	if self:getAnimDataByName(animName) then 
		if CA_DEBUG then
			print(string.format("animation %s has already prepared", animName))
		end
		return 
	end

	local animComponentInfo = getJsonData(animComponentInfoJson)
	if animComponentInfo then 
		local animData = {}
		animData.preCalculate = preCalculate
		animData.frameCount = animComponentInfo.keyFrameInfo.frameCount
		animData.hierarchyInfo = animComponentInfo.hierarchyInfo
	-- print("frameCount componentsCount", self.frameCount, table.nums(animationData.components))

		animData.componentDatas = {}
		for compID, compInfo in pairs(animComponentInfo.keyFrameInfo.components) do
			local componentData = {}
			componentData.ID = compID
			componentData.imageName = compInfo.imageName
			componentData.blendMode = compInfo.blendMode

			if compInfo.startKeyFrame then
				componentData.startKeyFrame = tonumber(compInfo.startKeyFrame)
				componentData.lastFrameCount = tonumber(compInfo.lastFrameCount)
				componentData.loopCount = tonumber(compInfo.loopCount)
				if CA_DEBUG then
					print("set startKeyFrame %d lastFrameCount %d loopCount %d", componentData.startKeyFrame, componentData.lastFrameCount, componentData.loopCount)
				end
			end

			componentData.attrKeyFrameInfosDatas = {}
			componentData.attrDeltaKeyFrameInfosDatas = {}
			for _, attr in ipairs(componentAttrs) do
				if not animData.preCalculate then
					componentData.attrKeyFrameInfosDatas[attr] = self:getAttrKeyFrameInfosData(compInfo, attr)
				else
					componentData.attrDeltaKeyFrameInfosDatas[attr] = self:getDeltaAttrKeyFrameInfosData(compInfo, attr)
				end
			end
		
			table.insert(animData.componentDatas, componentData)
		end

		-- save animation data to map
		self.animDatas[animName] = animData
	end

	self:prepareAnimationComponents(animName)
end

local function stopFrameAnimation(component)
	component:stopAllActions()
	component:setVisible(false)
	component.runningAnimation = false
end

function ComponentAnimation:prepareAnimationComponents(animName)
	local animData = self:getAnimDataByName(animName)
	if animData == nil then 
		return
	end

	self.curPreparedAnimName = animName

	self.baseNode:removeAllChildrenWithCleanup(true)
	for i, k in ipairs(self.components) do 
		-- local component = self.components[i]
		-- component:removeFromParentAndCleanup(true)
		self.components[i] = nil
	end 

	-- check to add components for animation
	for _, componentData in ipairs(animData.componentDatas) do
		-- local component = display.newSprite("#" .. compInfo.imageName)
		local component = self:getComponentByIDAndImageName(componentData.ID, componentData.imageName)
		if component == nil then 
			if componentData.lastFrameCount then
				if CA_DEBUG then
					print(string.foramt("create frame animation component %s ID %d lastFrame %d", componentData.imageName, componentData.ID, componentData.lastFrameCount))
				end
				component = createFrameAnimationComponent(componentData.imageName)
			else
				if tonumber(componentData.ID) == animData.hierarchyInfo.max then
				-- if componentData.imageName:find("none.png") then 
					if self.useBatch then
						-- component = display.newBatchNode(self.atlasFile)		
						component = display.newSprite("#" .. componentData.imageName)
					else 
						component = CCNodeRGBA:new()
						component:autorelease();
						component:setContentSize(32, 32)
						component:setAnchorPoint(0.5, 0.5)
					end
				else
					component = display.newSprite("#" .. componentData.imageName)
				end
			end 
			if component then 
				component.data = componentData
				component:setTag(componentData.ID)
				table.insert(self.components, component)
				if CA_DEBUG then
					print(string.format("create animation %s component %s ID %d", animName, componentData.imageName, componentData.ID))
				end
			else 
				if CA_DEBUG then
					print(string.format("create animation %s component %s ID %d faield", animName, componentData.imageName, componentData.ID))
				end
			end
		else
			component.data = componentData
			component:setTag(componentData.ID)
		end

		if component then 
			if componentData.blendMode == blendModeAdd then 
				local blendFunc = ccBlendFunc:new();
				blendFunc.src = GL_SRC_ALPHA
				blendFunc.dst = GL_ONE
				component:setBlendFunc(blendFunc);
			end
		end
	end

	-- set animation to setup key frame state
	for _, componentData in ipairs(animData.componentDatas)  do 
		local component = self:getComponentByID(componentData.ID)
		if component then 
			local parentID = animData.hierarchyInfo[tostring(componentData.ID)]
			if parentID and parentID > 0 then
				local parent = self:getComponentByID(tostring(parentID))
				if parent then
					component.parentID = parentID
					if CA_DEBUG then
						print(string.format("add %s ID %s to ID %s", componentData.imageName, componentData.ID, parentID))
					end
					component:addTo(parent, parentID - componentData.ID, componentData.ID)
					
				else
					if CA_DEBUG then
						print(string.format("component %s got wrong parent %s", componentData.ID, parentID))
					end
				end
			else
				local zOrder = componentData.ID * -1
				if animData.hierarchyInfo.max then 
					zOrder = animData.hierarchyInfo.max - componentData.ID
				end
				if CA_DEBUG then
					print(string.format("add %s ID %s to self z %d", componentData.imageName, componentData.ID, zOrder))
				end
				component:addTo(self.baseNode, zOrder, componentData.ID)
				-- component:addTo(self, zOrder, componentData.ID)
			end
			if CA_DEBUG then
				print(string.foramt("setComponentToSetUp %s ID %d", componentData.imageName, componentData.ID))
			end
			self:setComponentToAnimationSetUp(component, componentData, animData)
		end
	end
end

function ComponentAnimation:startScheduler()
	if self.scheduler == nil then
		-- self.elapsed = 0
		-- self.scheduler = scheduler.scheduleGlobal(function(dt)
		self.scheduler = self:schedule(function() 	
			if self.curAnimName ~= nil then
				-- self.elapsed = self.elapsed + dt
				-- self.frameCounter = math.floor(self.elapsed / (1 / FPS * self.timeScale))
				self.frameCounter = self.frameCounter + 1

				-- print("self.frameCounter", self.frameCounter)
				local animData = self:getCurAnimData()
				-- print("animData.frameCount", animData.frameCount)
				if animData and self.frameCounter > animData.frameCount then 
					self:done()
					return 
				end

				if CA_DEBUG then
					print("curFrameCounter frameCount:", self.frameCounter, self.animDatas[self.curAnimName].frameCount)
				end

				self:updateAnimation()
				self:checkEvent()
				if CA_DEBUG then
					print("curAnimName: ", self.curAnimName)
				end
			end
		end, 1 / FPS * self.timeScale)
	end
end

function ComponentAnimation:stopScheduler()
	if self.scheduler then
		-- scheduler.unscheduleGlobal(self.scheduler)
		self:stopAction(self.scheduler)
		self.scheduler = nil
	end
end

function ComponentAnimation:onEnter()
	if CA_DEBUG then
		print("ComponentAnimation:onEnter")
	end

	self:startScheduler()
end

function ComponentAnimation:onExit()
	if CA_DEBUG then
		print("ComponentAnimation:onExit")
	end
	self:stopScheduler()
end

function ComponentAnimation:resetEventStatus()
	for _, event in ipairs(self.events) do 
		event.dispatched = false
	end
end

function ComponentAnimation:checkEvent()
	for _, event in ipairs(self.events) do 
		if event.animName == self.curAnimName and event.frame <= self.frameCounter and not event.dispatched then 
			event.dispatched = true
			if self.eventHandler then 
				self.eventHandler(event)
			end 
		end
	end
end

function ComponentAnimation:setEvent(animName, name, frame)
	local exist = false
	for _, event in ipairs(self.events) do
		if event.animName == animName and event.name == name then 
			event.frame = frame
			exist = true
			break
		end
	end
	if not exist then 
		table.insert(self.events, {animName = animName, name = name, frame = frame, dispatched = false})
	end
end

function ComponentAnimation:updateAnimation()
	local animData = self:getCurAnimData()

	for _, component in ipairs(self.components) do
		if component.data then 
			if component.data.startKeyFrame then 
				if self.frameCounter >= component.data.startKeyFrame and component.data.loopCount then 
					if not component.runningAnimation then
						runFrameAnimation(component, component.data.loopCount)
						if CA_DEBUG then
							print(string.format("startFrameAnimation %s at keyFrame %d last frames %d", component.data.imageName, self.frameCounter, component.data.lastFrameCount))
						end
					end
				end
				if component.data.loopCount and component.data.loopCount ~= 0 then 
					if self.frameCounter >= component.data.startKeyFrame + component.data.lastFrameCount * component.data.loopCount then 
						if component.runningAnimation then
							stopFrameAnimation(component)
							if CA_DEBUG then
								print(string.format("stopFrameAnimation %s at keyFrame %d", component.data.imageName, self.frameCounter))
							end
						end
					end
				end
			end

			local function isPointEqual(p1, p2) 
				return p1.x == p2.x and p1.y == p2.y
			end
		
			for _, attr in ipairs(componentAttrs) do
				if not animData.preCalculate then 
					local attrKeyFrameInfosData = component.data.attrKeyFrameInfosDatas[attr]
					if attrKeyFrameInfosData ~= nil then
						local curKeyFrameInfo = attrKeyFrameInfosData:getCurKeyFrameInfo()
						local nextKeyFrameInfo = attrKeyFrameInfosData:getNextKeyFrameInfo()

						if curKeyFrameInfo and nextKeyFrameInfo then
							local deltaFrame = nextKeyFrameInfo.frame - curKeyFrameInfo.frame

							if curKeyFrameInfo.anchorPoint and nextKeyFrameInfo.anchorPoint and not isPointEqual(curKeyFrameInfo.anchorPoint, nextKeyFrameInfo.anchorPoint) then
								local deltaAnchorPointX = (nextKeyFrameInfo.anchorPoint.x / component:size().width - curKeyFrameInfo.anchorPoint.x / component:size().width) / deltaFrame
								local deltaAnchorPointY = ((component:size().height - nextKeyFrameInfo.anchorPoint.y) / component:size().height - (component:size().height - curKeyFrameInfo.anchorPoint.y) / component:size().height) / deltaFrame
								component:setAnchorPoint(component:getAnchorPoint().x + deltaAnchorPointX, component:getAnchorPoint().y + deltaAnchorPointY)
								if CA_DEBUG then
									print (string.format("component %s ID %d make delta anchorPoint %f,%f", component.data.imageName, component.data.ID, deltaAnchorPointX, deltaAnchorPointY))
								end
							end

							if curKeyFrameInfo.position and nextKeyFrameInfo.position and not isPointEqual(curKeyFrameInfo.position, nextKeyFrameInfo.position) then
								local deltaPositionX = (nextKeyFrameInfo.position.x - curKeyFrameInfo.position.x) / deltaFrame
								local deltaPositionY = ((component:size().height - nextKeyFrameInfo.position.y) - (component:size().height - curKeyFrameInfo.position.y)) / deltaFrame
								component:setPosition(component:getPositionX() + deltaPositionX, component:getPositionY() + deltaPositionY)
								if CA_DEBUG then
									print (string.format("component %s ID %d make delta position %f,%f", component.data.imageName, component.data.ID, deltaPositionX, deltaPositionY))
								end
							end

							if curKeyFrameInfo.scale and nextKeyFrameInfo.scale and not isPointEqual(curKeyFrameInfo.scale, nextKeyFrameInfo.scale) then
								local deltaScaleX = (nextKeyFrameInfo.scale.x - curKeyFrameInfo.scale.x) / deltaFrame
								local deltaScaleY = (nextKeyFrameInfo.scale.y - curKeyFrameInfo.scale.y) / deltaFrame
								component:setScaleX(component:getScaleX() + deltaScaleX)
								component:setScaleY(component:getScaleY() + deltaScaleY)
								if CA_DEBUG then
									print (string.format("component %s ID %d make delta scale %f,%f", component.data.imageName, component.data.ID, deltaScaleX, deltaScaleY))
								end
							end

							if curKeyFrameInfo.rotation and nextKeyFrameInfo.rotation and curKeyFrameInfo.rotation ~= nextKeyFrameInfo.rotation then
								local deltaRotation = (nextKeyFrameInfo.rotation - curKeyFrameInfo.rotation) / deltaFrame
								component:setRotation(component:getRotation() + deltaRotation)
								if CA_DEBUG then
									print (string.format("component %s ID %d make delta rotation %f", component.data.imageName, component.data.ID, deltaRotation))
								end
							end

							if curKeyFrameInfo.opacity and nextKeyFrameInfo.opacity and curKeyFrameInfo.opacity ~= nextKeyFrameInfo.opacity then
								local deltaOpacity = (nextKeyFrameInfo.opacity - curKeyFrameInfo.opacity) / deltaFrame
								local opacity = component:getOpacity() + deltaOpacity
								if opacity > 255 then 
									opacity = 255
								elseif opacity < 0 then 
									opacity = 0
								end
								component:setOpacity(opacity)
								if CA_DEBUG then
									print (string.format("component %s ID %d make delta opacity %f", component.data.imageName, component.data.ID, deltaOpacity))
								end
							end

							if nextKeyFrameInfo then 
								if self.frameCounter >= nextKeyFrameInfo.frame then 
									-- component.data.curKeyFrameIndex = component.data.curKeyFrameIndex + 1
									attrKeyFrameInfosData:goNextKeyFrameInfo()
									if CA_DEBUG then
										print (string.format("component %s comes to key frame %d, curKeyFrameIndex %d", component.data.imageName, nextKeyFrameInfo.frame, attrKeyFrameInfosData.curKeyFrameIndex))
									end
								end
							end
						end
					end
				else
					local attrDeltaKeyFrameInfosData = component.data.attrDeltaKeyFrameInfosDatas[attr]
					if attrDeltaKeyFrameInfosData then
						local deltaKeyFrameInfo = attrDeltaKeyFrameInfosData:getCurDeltaKeyFrameInfo()
						if deltaKeyFrameInfo then
							if deltaKeyFrameInfo.deltaAnchorPoint then
								local deltaAnchorPointX = deltaKeyFrameInfo.deltaAnchorPoint.x / component:size().width
								local deltaAnchorPointY = deltaKeyFrameInfo.deltaAnchorPoint.y / component:size().height

								component:setAnchorPoint(component:getAnchorPoint().x + deltaAnchorPointX, component:getAnchorPoint().y + deltaAnchorPointY)
								
								if CA_DEBUG then
									print (string.format("component %s ID %d make delta anchorPoint %f,%f", component.data.imageName, component.data.ID, deltaAnchorPointX, deltaAnchorPointY))
								end
							end

							if deltaKeyFrameInfo.deltaPosition then
								component:setPosition(component:getPositionX() + deltaKeyFrameInfo.deltaPosition.x, component:getPositionY() + deltaKeyFrameInfo.deltaPosition.y)
								if CA_DEBUG then
									print (string.format("component %s ID %d make delta position %f,%f", component.data.imageName, component.data.ID, deltaKeyFrameInfo.deltaPosition.x, deltaKeyFrameInfo.deltaPosition.y))
								end
							end

							if deltaKeyFrameInfo.deltaScale then
								component:setScaleX(component:getScaleX() + deltaKeyFrameInfo.deltaScale.x)
								component:setScaleY(component:getScaleY() + deltaKeyFrameInfo.deltaScale.y)
								if CA_DEBUG then
									print (string.format("component %s ID %d make delta scale %f,%f", component.data.imageName, component.data.ID, deltaKeyFrameInfo.deltaScale.x, deltaKeyFrameInfo.deltaScale.y))
								end
							end

							if deltaKeyFrameInfo.deltaRotation then
								component:setRotation(component:getRotation() + deltaKeyFrameInfo.deltaRotation)
								if CA_DEBUG then
									print (string.format("component %s ID %d make delta rotation %f", component.data.imageName, component.data.ID, deltaKeyFrameInfo.deltaRotation))
								end
							end
							
							if deltaKeyFrameInfo.deltaOpacity then
								local opacity = component:getOpacity() + deltaKeyFrameInfo.deltaOpacity
								if opacity < 0 then 
									opacity = 0
								elseif opacity > 255 then 
									opacity = 255 
								end
								component:setOpacity(opacity)
								if CA_DEBUG then
									print (string.format("component %s ID %d make delta opacity %f", component.data.imageName, component.data.ID, deltaKeyFrameInfo.deltaOpacity))
								end
							end
						end

						if self.frameCounter >= deltaKeyFrameInfo.toFrame then 
							attrDeltaKeyFrameInfosData:goNextDeltaKeyFrameInfo()
							if CA_DEBUG then
								print (string.format("component %s comes to key frame %d, curKeyFrameStageIndex %d", component.data.imageName, deltaKeyFrameInfo.toFrame, attrDeltaKeyFrameInfosData.curKeyFrameStageIndex))
							end
						end
					end
				end
			end

			if CA_DEBUG then
				print(string.format("component %s ID %d at frame %d anchorPoint (%f,%f) position (%f,%f) scale (%f,%f) rotation (%f) opacity (%f)", component.data.imageName, component.data.ID, self.frameCounter, component:getAnchorPoint().x, component:getAnchorPoint().y, component:getPositionX(), component:getPositionY(), component:getScaleX(), component:getScaleY(), component:getRotation(), component:getOpacity()))
			end
		end
		
	end
end

function ComponentAnimation:done()
	-- self.elapsed = 0
	self.frameCounter = 0
	self.loopCounter = self.loopCounter + 1

	self:resetEventStatus()

	if self.completionHandler then 
		self.completionHandler(self.curAnimName, self.loopCounter)
	end

	local animData = self:getCurAnimData()
	if animData then
		self:resetToSetUp(animData)
	end

	if self.loopCount ~= loopCountForever and self.loopCounter >= self.loopCount then
		self:stop()
	end
end

function ComponentAnimation:stop()
	self.curAnimName = nil
	self.curPreparedAnimName = nil
	-- self.elapsed = 0
	self.frameCounter = 0
	self.loopCounter = 0
	self.loopCount = 0
end

function ComponentAnimation:resetToSetUp(animData)
	for _, component in ipairs(self.components) do
		if component.runningAnimation then 
			stopFrameAnimation(component)
		end
		if component.data then
			self:setComponentToAnimationSetUp(component, component.data, animData)
		end
	end
end

function ComponentAnimation:getAnimDataByName(animName)
	if animName == nil then 
		return nil
	end
	return self.animDatas[animName]
end

function ComponentAnimation:getCurAnimData()
	return self:getAnimDataByName(self.curAnimName)
end

function ComponentAnimation:setComponentToAnimationSetUp(component, componentData, animData)
	if CA_DEBUG then
		print(string.format("set Component %s ID %s to SetUp", componentData.imageName, componentData.ID))
	end
	for _, attr in ipairs(componentAttrs) do
		if not animData.preCalculate then 
			local attrKeyFrameInfosData = componentData.attrKeyFrameInfosDatas[attr]
			if attrKeyFrameInfosData then 
				attrKeyFrameInfosData:resetToSetUpKeyFrame()
				local keyFrameInfo = attrKeyFrameInfosData:getCurKeyFrameInfo()
				if keyFrameInfo then
					self:setComponentKeyFrameInfo(component, keyFrameInfo)
				end
			end
		else
			local attrDeltaKeyFrameInfosData = componentData.attrDeltaKeyFrameInfosDatas[attr]
			if attrDeltaKeyFrameInfosData then 
				attrDeltaKeyFrameInfosData:resetToSetUpKeyFrame()
				local deltaKeyFrameInfo = attrDeltaKeyFrameInfosData:getCurDeltaKeyFrameInfo()
				if deltaKeyFrameInfo then 
					self:applyComponentWithStartOfDeltaKeyFrameInfo(component, deltaKeyFrameInfo)
				end
			end
		end
	end

		-- if componentData.imageName == "none.png" then 
	if tonumber(componentData.ID) == animData.hierarchyInfo.max then
		if CA_DEBUG then
			print ("componentData hierarchyMax", componentData.ID, hierarchyMax)
		end
		component:setPosition(0, 0)
	end
end

function ComponentAnimation:applyComponentWithStartOfDeltaKeyFrameInfo(component, deltaKeyFrameInfo)
	if deltaKeyFrameInfo.startAnchorPoint then
		component:setAnchorPoint(deltaKeyFrameInfo.startAnchorPoint.x / component:size().width, (component:size().height - deltaKeyFrameInfo.startAnchorPoint.y) / component:size().height)
		if CA_DEBUG then 
			print(string.format("component %s setAnchorPoint (%f,%f) at keyframe %d", component.data.imageName, component:getAnchorPoint().x, component:getAnchorPoint().y, deltaKeyFrameInfo.fromFrame))
		end
	end
	if deltaKeyFrameInfo.startPosition then
		if component.parentID and component:getParent() ~= nil then
			component:setPosition(deltaKeyFrameInfo.startPosition.x, component:getParent():size().height - deltaKeyFrameInfo.startPosition.y)
		else
			component:setPosition(deltaKeyFrameInfo.startPosition.x, -1 * deltaKeyFrameInfo.startPosition.y)
		end
		if CA_DEBUG then
			print(string.format("component %s setPosition (%f,%f) at keyframe %d", component.data.imageName, component:getPositionX(), component:getPositionY(), deltaKeyFrameInfo.fromFrame))
		end
	end
	if deltaKeyFrameInfo.startScale then
		component:setScaleX(deltaKeyFrameInfo.startScale.x)
		component:setScaleY(deltaKeyFrameInfo.startScale.y)
		if CA_DEBUG then
			print(string.format("component %s setScale (%f,%f) at keyframe %d", component.data.imageName, component:getScaleX(), component:getScaleY(), deltaKeyFrameInfo.fromFrame))
		end
	end
	if deltaKeyFrameInfo.startRotation then
		component:setRotation(deltaKeyFrameInfo.startRotation)
		if CA_DEBUG then
			print(string.format("component %s setRotation (%f) at keyframe %d", component.data.imageName, component:getRotation(), deltaKeyFrameInfo.fromFrame))
		end
	end
	if deltaKeyFrameInfo.startOpacity then
		local opacity = deltaKeyFrameInfo.startOpacity
		if opacity < 0 then 
			opacity = 0
		elseif opacity > 255 then 
			opacity = 255
		end
		component:setOpacity(opacity)
		if CA_DEBUG then
			print(string.format("component %s setOpacity (%f) at keyframe %d", component.data.imageName, component:getOpacity(), deltaKeyFrameInfo.fromFrame))
		end
	end
end

function ComponentAnimation:setComponentKeyFrameInfo(component, keyFrameInfo)
	if keyFrameInfo.anchorPoint then
		component:setAnchorPoint(keyFrameInfo.anchorPoint.x / component:size().width, (component:size().height - keyFrameInfo.anchorPoint.y) / component:size().height)
		if CA_DEBUG then
			print(string.format("component %s setAnchorPoint (%f,%f)", component.data.imageName, component:getAnchorPoint().x, component:getAnchorPoint().y))
		end
	end
	if keyFrameInfo.position then
		if component.parentID and component:getParent() ~= nil then
			component:setPosition(keyFrameInfo.position.x, component:getParent():size().height - keyFrameInfo.position.y)
		else
			component:setPosition(keyFrameInfo.position.x, -1 * keyFrameInfo.position.y)
		end
		if CA_DEBUG then
			print(string.format("component %s setPosition (%f,%f)", component.data.imageName, component:getPosition()))
		end
	end
	if keyFrameInfo.scale then
		component:setScaleX(keyFrameInfo.scale.x)
		component:setScaleY(keyFrameInfo.scale.y)
		if CA_DEBUG then
			print(string.format("component %s setScale (%f,%f)", component.data.imageName, component:getScaleX(), component:getScaleY()))
		end
	end
	if keyFrameInfo.rotation then
		component:setRotation(keyFrameInfo.rotation)
		if CA_DEBUG then
			print(string.format("component %s setRotation (%f)", component.data.imageName, component:getRotation()))
		end
	end
	if keyFrameInfo.opacity then
		component:setOpacity(keyFrameInfo.opacity)
		if CA_DEBUG then
			print(string.format("component %s setOpacity (%f)", component.data.imageName, component:getOpacity()))
		end
	end
end


return ComponentAnimation