-- settings.lua - 简洁设置页面
require "import"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.graphics.drawable.GradientDrawable"
import "android.net.Uri"

-- dp转px函数
function dp2px(dpValue)
    local scale = activity.getResources().getDisplayMetrics().density
    return dpValue * scale + 0.5
end

-- 创建卡片函数
local function createCard(title)
    local bg = GradientDrawable()
    bg.setShape(GradientDrawable.RECTANGLE)
    bg.setColor(0xFFFFFFFF)
    bg.setCornerRadius(dp2px(15))
    bg.setStroke(1, 0xFFDDDDDD)
    
    local card = LinearLayout(activity)
    card.setBackgroundDrawable(bg)
    card.setOrientation(1)
    card.setPadding(dp2px(20), dp2px(20), dp2px(20), dp2px(20))
    
    local params = LinearLayout.LayoutParams(-1, -2)
    params.setMargins(dp2px(15), dp2px(10), dp2px(15), dp2px(10))
    card.setLayoutParams(params)
    
    local titleView = TextView(activity)
    titleView.setText(title)
    titleView.setTextSize(16)
    titleView.setTextColor(0xFF333333)
    card.addView(titleView)
    
    return card
end

-- 主布局
local layout = LinearLayout(activity)
layout.setOrientation(1)
layout.setBackgroundColor(0xFFF0F0F0)
layout.setPadding(dp2px(10), dp2px(10), dp2px(10), dp2px(10))

-- 关于卡片
local aboutCard = createCard("关于本应用")
aboutCard.onClick = function()
    activity.newActivity("about")
end
aboutCard.setClickable(true)
layout.addView(aboutCard)

-- 反馈卡片（直接调用系统浏览器）
local feedbackCard = createCard("用户反馈")
feedbackCard.onClick = function()
    local url = "https://support.qq.com/product/743331"
    local intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
    
    -- 检查是否有浏览器可用
    if intent.resolveActivity(activity.getPackageManager()) then
        activity.startActivity(intent)
    else
        Toast.makeText(activity, "未找到可用的浏览器", Toast.LENGTH_SHORT).show()
    end
end
feedbackCard.setClickable(true)
layout.addView(feedbackCard)

activity.setContentView(layout)

-- 返回按钮
if activity.getActionBar() then
    activity.getActionBar().setDisplayHomeAsUpEnabled(true)
end

function onOptionsItemSelected(item)
    if item.getItemId() == android.R.id.home then
        activity.finish()
    end
    return true
end