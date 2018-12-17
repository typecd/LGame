local TopBar = class("TopBar",function()
    return display.newSprite(CONFIG.R.score_bg)
end)

function TopBar:ctor()
    local star = display.newSprite(CONFIG.R.star);
    star:pos(30,29);
    star:addTo(self);

    local scoreLabel = CCLabelBMFont:create("", CONFIG.R.num1_fnt);
    self:add(scoreLabel);
    scoreLabel:pos(88,29);
    self.scoreLabel = scoreLabel;
    scoreLabel:scale(0.8);

    self:updateScore();
end

function TopBar:updateScore()
    print("updateScore ",CONFIG.totalScore)
    self.scoreLabel:setString(CONFIG.totalScore);
end

return TopBar