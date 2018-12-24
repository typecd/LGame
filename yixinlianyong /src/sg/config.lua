CONFIG = {}
-- 【BASE_IMAGE不要修改，自动适配开发框架和实际平台】
-- 【iphonex代码请直接使用if BA.IS_IPHONEX then的形式】
-- 【BA.IS_IPHONEX的值可以在hello.lua里修改】

-- 【CONFIG.REVIEW_PATH是小游戏的资源路径】
-- 【请小游戏开发人员按下面的方式组合资源路径：CONFIG.REVIEW_PATH .. a.png】
CONFIG.REVIEW_PATH   = BASE_IMAGE .. "review/"

IMG_PATH = CONFIG.REVIEW_PATH .. "/running/"
-- 【从这里可以自定义全局变量，比如CONFIG.A = "xxxx"】

CONFIG.TIME_DATA = {
    {
        name = "萌新小試",
        disc = '堅持5"',
        target = 5,
        reward = 50,
    },
    {
        name = "初出茅廬",
        disc = '堅持30"',
        target = 30,
        reward = 150,
    },
    {
        name = "小有成就",
        disc = '堅持60"',
        target = 60,
        reward = 400,
    },
    {
        name = "熟能生巧",
        disc = '堅持90"',
        target = 90,
        reward = 800,
    },
    {
        name = "爐火純青",
        disc = '堅持150"',
        target = 130,
        reward = 2000,
    },
    {
        name = "仁者無敵",
        disc = '堅持200"',
        target = 200,
        reward = 9000,
    },
}

CONFIG.SPORT_DATA = {
    {
        name = "寸莛擊鐘",
        disc = '越過障礙20个',
        target = 20,
        reward = 50,
    },
    {
        name = "獨出手眼",
        disc = '越過障礙80个',
        target = 80,
        reward = 150,
    },
    {
        name = "大器小用",
        disc = '越過障礙150个',
        target = 150,
        reward = 400,
    },
    {
        name = "綽有餘裕",
        disc = '越過障礙220个',
        target = 220,
        reward = 800,
    },
    {
        name = "逞異夸能",
        disc = '越過障礙380个',
        target = 380,
        reward = 2000,
    },
    {
        name = "揮斥八級",
        disc = '越過障礙500个',
        target = 500,
        reward = 9000,
    },
}

CONFIG.WEALTH_DATA = { --儋石之储 金玉满堂 发财致富 鸿商富贾 猗顿之富 万贯家财
    {
        name = "儋石之儲",
        disc = '收穫$10个',
        target = 10,
        reward = 20,
    },
    {
        name = "金玉滿堂",
        disc = '收穫$30个',
        target = 30,
        reward = 50,
    },
    {
        name = "發財致富",
        disc = '收穫$40个',
        target = 40,
        reward = 90,
    },
    {
        name = "鴻商富賈",
        disc = '收穫$80个',
        target = 80,
        reward = 200,
    },
    {
        name = "萬貫家財",
        disc = '收穫$100个',
        target = 100,
        reward = 500,
    },
    {
        name = "猗顿之富 ",
        disc = '收穫$200个',
        target = 200,
        reward = 1000,
    },
}

CONFIG.Hero_Size = {
    CCSize(22,36),
    CCSize(16,27),
    CCSize(16,27),
    CCSize(16,27),
    CCSize(16,27),
    CCSize(16,27),
    CCSize(16,27),
    CCSize(16,27),
}


CONFIG.Hero_Res_Name = {
    "pp_run",
    "foga_run",
    "kier_run",
    "leiyeshi_run",
    "liang_run",
    "lijiaer_run",
    "nuoli_run",
    "nanali_run",
}

CONFIG.Hero_Count = BA.IS_IPHONEX and 8 or 6

CONFIG.Touch_Music = IMG_PATH .. "/run"
