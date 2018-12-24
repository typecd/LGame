local lume = require("base/framework/lume")
local HelperTools = class("HelperTools");

---將外部設定值拷貝到目標之中
-- 
-- 這裡會將目標的鑰匙拿去和源比對，如果源內有值才會將資料拷貝到目標之中
-- 可以避免外部將亂七八糟的資料都設定到target上
-- 
-- @table target目標表，類別內部屬性
-- @table source來源表，外部設定值
function HelperTools.assingTableValue(target, source)
    if not source and type(source) ~= "table" then return; end
    for k, _ in pairs(source) do
        if type(source[k]) == "table" then
            HelperTools.assingTableValue(target[k], source[k]);
        else
            target[k] = source[k];
        end
    end
end

--- 偵測是否在目標物上
function HelperTools.isClickInTarget(target, x, y)
    local parent = target:getParent()
    if not parent then return false; end

    local clickPoint = parent:convertToNodeSpace(ccp(x, y))
    local rect = target:boundingBox()

    return rect:containsPoint(clickPoint)
end

--- 權重選擇
-- @param weightTable 帶入權重數字表
-- @param seed 亂數種子
-- @return 回傳傳入表被選重的index值
function HelperTools.weightedchoice(weightTable, seed)
    local cumulativeWeights = { }
    local seed = seed or 1
    local total = 0
    for i = 1, #weightTable do
        cumulativeWeights[i] = total + weightTable[i]
        total = total + weightTable[i]
    end

    math.randomseed(tonumber(tostring(math.floor(os.time() / seed)):reverse():sub(1, 6)))
    local rnd = math.random() * total
    for i = 1, #weightTable do
        if rnd < cumulativeWeights[i] then
            return i
        end
    end
    
    return #weightTable
end


-- 玩家假名列表
local FAKENAME_LIST = { "在下老陰比", "一桿狙打天下", "反手就是一槍", "叫我半仙", "誅仙", "別動我開槍了", "絕地撿垃圾", "絕地XXX", "專業撿垃圾", "空投沒命撿", "絕地快遞", "絕命快遞", "別說話吻我", "刺激chi吃雞", "人帥是非多", "沒槍就很狂", "開門送溫暖", "開門你的快遞", "我是d快遞員", "在下伏地魔", "CaaryX", "擦槍走火", "一槍就夠了", "代號XXX", "國際代號XX", "6到沒朋友", "致命98K", "快遞員XX", "開門送快遞的", "年少未曾輕狂", "馬鹿殺手", "盒子已成精", "我偷塔賊溜", "我逃跑賊溜", "我槍法賊溜", "專殺菜雞", "隊友我都不扶", "小鹿吖", "兔兔突", "不給你吃雞", "吃雞都不叫", "牛皮不用吹", "僅此而已", "如履薄冰", "傷心是男人", "南末", "兩肋插刀", "大姨媽打老婆", "如今啥都難", "從訫開始", "青春染紙流年", "萌萌鹿哈尼", "糾結d3心", "你背叛我", "葬嬡", "青春瀟瑟了", "輪囘li巡影", "烈性釹子", "醉狀擺弄姿態", "血緣關係戲子", "vannesa", "柚子未成年", "姚貝娜再見", "一個人在回憶", "天天也很帥", "窒息的鬼魅", "萁實佷介意", "萬賤穿心", "多喜歡張傑吖", "代表月亮消滅", "莈什庅是怺恆", "清風清雲", "相交的平行線", "泡菜煎餅", "紅色的傻子", "只是形式上", "高冷國王i", "稀薄空氣", "棄者後會無期", "如此放蕩", "動感超人", "叼著棒棒糖", "空虛德現實", "淚痕", "永久太賣弄", "Run鯨魚", "藍天下的迷彩", "半路青春", "訫狠痛", "經不起誘惑", "收起你de逼範", "BarBar", "maniubi", "天下無雙", "獨孤天下", "梅長蘇", "飛留", "漠雨見", "LYBNo1", "白日夢", "不好玩", "變色龍", "專打擦邊球", "3000MB", "偷偷點鬼火", "woshiLYB", "RoseMary穎", "Flower穎", "Make堇晨", "mango甜甜", "冷眸2Cruel", "老農民", "殘夢Dangerou", "冷夜色cheeks", "玩命dancers", "情緒控hea2t", "夢徒Dream", "豹女郎", "茶蘼", "逃亡者的詭異", "離人過客", "抽象heart", "你的專屬Tool", "Please遠離我", "紛亂9Demon", "惆悵Burlk", "Yoshi惟美", "旖旎ecstAsy", "深空控DISE", "心奴控bar", "單人House", "破相broken", "Nixon瘋子", "藍顏Memory", "我是壞人", "Believeme", "Cruelheart", "放空砲", "Memorie", "帶我走", "MadDog", "Imfine", "YouAndme", "老狐狸的尾巴", "Tothelonel", "Than後知後覺", "離沫傾城wind", "Distance失落", "似懂非懂", "giveup", "saygoodbye", "你看不見我", "Shadowlover", "八槍子打不著", "Amonologue", "Agoni", "彼岸花Triste", "bridesmai", "滾雪球", "Elijah", "Ean", "Ed", "Melody", "Shirley", "Vivian", "Joyce", "收學費", "紅牌出場", "夏天", "Dream", "黑色的雪", "lovedearly", "Kissme", "草莓味小王子", "若離勿哭", "別開槍自己人", "別動吃煙霧彈", "快來舔包", "東京神話", "暗夜玫瑰", "恍如一場夢", "撩妹高手", "誘惑嘵節", "壞氣少爺", "範二先生", "菩提聖者", "如此Clever", "風起而散的日", "污界槓把子", "D調de華麗", "Rush匪徒", "宛若清風", "煙肺的需求", "半夏時光", "縱情天下", "風漸消逝", "傲笑九天", "自倚修行", "幽冥崖子", "哥de寂寞", "Confuse初顏", "Sweet沫", "Lucy貝貝", "空城Memory", "Nimei雪", "Destiny沫兮", "MeMe撒謊伱", "BABYGIRL", "summer夢", "蜜桃pmy", "吻我", "DeviL熙", "Speed無限速", "Confuse傾城", "Antidote溫瞳", "Missyou", "Fast", "Jay誓言", "Fame陌軒", "單裑繢鏃", "Angel王", "NIdaye峰", "Messi", "工蜂M", "璐客比", "迪達爾", "瑪利奧", "平底鍋", "大吉大利", "Roger", "Gipa", "Rey", "蘇察哈爾", "把你鼠標移開", "槍法好的出奇", "專打美女", "我是認真爆頭", "奇葩閃閃", "死亡一槍", "先殺我隊友啊", "從坑到神坑", "名字長別躲草", "失眠青年", "飛奔de小豬", "日久生姦情", "別追本人已婚", "我智商開外掛", "千雞變", "菠蘿吹雪", "鄉巴佬", "反派作風", "人民戰士別惹", "Throwwweep", "帥很耗CPU", "人走茶涼", "三點一線", "假摔天王", "內馬爾", "C羅", "Zinedine", "Liuzzz", "Ronaldo", "貝克漢", "魯尼", "蘇牙", "LumbMill", "GustavXX", "TryfelliILL", "Shadow", "shiva", "Nopnoped", "Survivors", "Baha", "Jazzzzz", "Scar", "fuenz", "BallocBa", "Miccoily", "Dazeface", "Jimmy", "HaxMax", "Lighter", "Nighters", "近在咫尺", "笑傲江湖", "老男孩", "煙花易冷", "內衣先生", "斗羅", "五月天", "最強男神", "半路跌倒", "幽蘭", "龍龍", "我站著不動", "YY", "嚇到吃手", "大雕萌妹" };
--- 取得指定數量隨機不重複命名
-- @param amount 獲得命名數量
-- @return 回傳amount數量的名字[table]
function HelperTools.getRandomNames(amount)
    local fakeNameList = lume.shuffle(FAKENAME_LIST);
    
    local names = {}
    for i = 1 , amount do
        names[i] = fakeNameList[i];
    end

    return names;
end


return HelperTools;
