
local IapSGFailPop    = require("module/IapSG/sub/IapSGFailPop")
local IapSGSuccessPop = require("module/IapSG/sub/IapSGSuccessPop")

local IapSGHelper = class("IapSGHelper")

function IapSGHelper:getInstance()
    if self._instance == nil then        
        self._instance = IapSGHelper.new()  
    end  
    return self._instance 
end

function IapSGHelper:startPay(itemNo,count)
	self:_resetStatus()

	IapSGHelper.itemNo = itemNo
	IapSGHelper.count = count
	IapSGHelper.isPay = true
	-- loading
	Loading:showLoading({ during = 600})
	self:_startIap()
end

function IapSGHelper:_resetStatus()
	IapSGHelper.itemNo = 0
	IapSGHelper.count = 0
	IapSGHelper.isPay = false
end

function IapSGHelper:_startIap()
	PayToolsLua:iosPay(IapSGHelper.itemNo,self._checkOrder)
end

function IapSGHelper._checkOrder( success, data )
	Loading:removeLoading()
	IapSGHelper.isPay = false
	if success then
		IapSGSuccessPop.show(IapSGHelper.count)
		EventEngine.dispatch(EventName.UPDATE_GOLD, IapSGHelper.count);
	else
		IapSGFailPop.show()
	end
	
end

return IapSGHelper