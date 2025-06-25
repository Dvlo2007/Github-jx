-- about.lua - 简洁关于页面（无开发者头像）
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
local function createCard()
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
    
    return card
end

-- 主布局
local layout = LinearLayout(activity)
layout.setOrientation(1)
layout.setBackgroundColor(0xFFF0F0F0)
layout.setPadding(dp2px(10), dp2px(10), dp2px(10), dp2px(10))

-- 应用信息卡片
local appCard = createCard()

local appHeader = LinearLayout(activity)
appHeader.setOrientation(0)
appHeader.setGravity(Gravity.CENTER_VERTICAL)

-- 应用图标
local appIcon = ImageView(activity)
appIcon.setLayoutParams(LinearLayout.LayoutParams(dp2px(50), dp2px(50)))
appIcon.setPadding(0, 0, dp2px(15), 0)

-- 加载应用图标
local appIconId = activity.getResources().getIdentifier("ic_launcher", "drawable", activity.getPackageName())
if appIconId ~= 0 then
    appIcon.setImageResource(appIconId)
end

local appInfoLayout = LinearLayout(activity)
appInfoLayout.setOrientation(1)

local appName = TextView(activity)
appName.setText("GitHub链接转换工具")
appName.setTextSize(18)
appName.setTextColor(0xFF333333)

local version = TextView(activity)
version.setText("版本: 1.0.0")
version.setTextSize(14)
version.setTextColor(0xFF666666)
version.setPadding(0, dp2px(5), 0, 0)

appInfoLayout.addView(appName)
appInfoLayout.addView(version)
appHeader.addView(appIcon)
appHeader.addView(appInfoLayout)
appCard.addView(appHeader)
layout.addView(appCard)

-- 开发者卡片（无头像）
local devCard = createCard()

local devTitle = TextView(activity)
devTitle.setText("开发者信息")
devTitle.setTextSize(16)
devTitle.setTextColor(0xFF333333)
devCard.addView(devTitle)

local devInfoLayout = LinearLayout(activity)
devInfoLayout.setOrientation(1)
devInfoLayout.setPadding(0, dp2px(10), 0, 0)

local devName = TextView(activity)
devName.setText("开发者: Dvlo")
devName.setTextSize(14)
devName.setTextColor(0xFF666666)

local contact = TextView(activity)
contact.setText("QQ: 3576731398")
contact.setTextSize(14)
contact.setTextColor(0xFF666666)
contact.setPadding(0, dp2px(5), 0, 0)

devInfoLayout.addView(devName)
devInfoLayout.addView(contact)
devCard.addView(devInfoLayout)
layout.addView(devCard)

-- 反馈按钮
local feedbackCard = createCard()

local feedbackBtn = Button(activity)
feedbackBtn.setText("用户反馈")
feedbackBtn.setTextSize(16)
feedbackBtn.setTextColor(0xFFFFFFFF)
feedbackBtn.setBackgroundDrawable(GradientDrawable()
    .setShape(GradientDrawable.RECTANGLE)
    .setColor(0xFF4285F4)
    .setCornerRadius(dp2px(30)))
feedbackBtn.setLayoutParams(LinearLayout.LayoutParams(-1, dp2px(45)))

-- 直接调用系统浏览器打开链接
feedbackBtn.onClick = function()
    local url = "https://support.qq.com/product/743331"
    local intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
    
    -- 检查是否有浏览器可用
    if intent.resolveActivity(activity.getPackageManager()) then
        activity.startActivity(intent)
    else
        Toast.makeText(activity, "未找到可用的浏览器", Toast.LENGTH_SHORT).show()
    end
end

feedbackCard.addView(feedbackBtn)
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