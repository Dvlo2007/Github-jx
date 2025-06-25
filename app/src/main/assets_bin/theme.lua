-- theme.lua - 界面设置页面（仅修改主题颜色）
require "import"
import "android.widget.*"
import "android.view.*"
import "android.content.Context"  -- 添加这行导入
import "android.graphics.drawable.GradientDrawable"

-- 共享偏好存储
local sharedPref = activity.getSharedPreferences("theme_prefs", Context.MODE_PRIVATE)
local editor = sharedPref.edit()

-- dp转px函数
function dp2px(dpValue)
    local scale = activity.getResources().getDisplayMetrics().density
    return dpValue * scale + 0.5
end

-- 创建卡片函数
local function createCard()
    local bg = GradientDrawable()
    bg.setShape(GradientDrawable.RECTANGLE)
    bg.setColor(0xFFFFFFFF)  -- 白色卡片背景
    bg.setCornerRadius(dp2px(15))
    bg.setStroke(1, 0xFFDDDDDD)  -- 灰色边框
    
    local card = LinearLayout(activity)
    card.setBackgroundDrawable(bg)
    card.setOrientation(1)
    card.setPadding(dp2px(15), dp2px(15), dp2px(15), dp2px(15))
    
    local params = LinearLayout.LayoutParams(-1, -2)
    params.setMargins(dp2px(10), dp2px(10), dp2px(10), dp2px(10))
    card.setLayoutParams(params)
    
    return card
end

-- 主布局
local layout = ScrollView(activity)
local mainLayout = LinearLayout(activity)
mainLayout.setOrientation(1)
mainLayout.setBackgroundColor(0xFFF0F0F0)  -- 保持默认背景色
mainLayout.setPadding(dp2px(10), dp2px(10), dp2px(10), dp2px(10))

-- 主题颜色选择卡片
local themeCard = createCard()

local themeTitle = TextView(activity)
themeTitle.setText("选择主题颜色")
themeTitle.setTextSize(18)
themeTitle.setTextColor(0xFF333333)
themeCard.addView(themeTitle)

-- 主题颜色选项
local themeGroup = RadioGroup(activity)
themeGroup.setOrientation(1)

-- 可用主题颜色
local themes = {
    {name = "蓝色主题", color = 0xFF4285F4},
    {name = "绿色主题", color = 0xFF34A853},
    {name = "红色主题", color = 0xFFEA4335},
    {name = "紫色主题", color = 0xFF9C27B0}
}

-- 当前选中的主题颜色
local currentThemeColor = sharedPref.getInt("theme_color", 0xFF4285F4)  -- 默认蓝色

-- 添加单选按钮
for i, theme in ipairs(themes) do
    local rb = RadioButton(activity)
    rb.setText(theme.name)
    rb.setTextSize(16)
    rb.setPadding(0, dp2px(10), 0, 0)
    rb.setTag(theme.color)
    
    -- 设置当前选中的主题
    if theme.color == currentThemeColor then
        rb.setChecked(true)
    end
    
    themeGroup.addView(rb)
end

themeCard.addView(themeGroup)
mainLayout.addView(themeCard)

-- 保存按钮
local saveBtn = Button(activity)
saveBtn.setText("应用主题")
saveBtn.setTextSize(18)
saveBtn.setTextColor(0xFFFFFFFF)

-- 按钮背景使用当前主题色
local btnBg = GradientDrawable()
btnBg.setShape(GradientDrawable.RECTANGLE)
btnBg.setColor(currentThemeColor)
btnBg.setCornerRadius(dp2px(30))

saveBtn.setBackgroundDrawable(btnBg)
saveBtn.setLayoutParams(LinearLayout.LayoutParams(-1, dp2px(48)).setMargins(dp2px(30), dp2px(20), dp2px(30), dp2px(20)))

saveBtn.onClick = function()
    -- 获取选中的主题颜色
    for i=0, themeGroup.getChildCount()-1 do
        local rb = themeGroup.getChildAt(i)
        if rb.isChecked() then
            currentThemeColor = rb.getTag()
            break
        end
    end
    
    -- 保存主题颜色
    editor.putInt("theme_color", currentThemeColor).apply()
    
    -- 更新按钮颜色
    btnBg.setColor(currentThemeColor)
    saveBtn.setBackgroundDrawable(btnBg)
    
    Toast.makeText(activity, "主题颜色已更新，重启应用后生效", Toast.LENGTH_SHORT).show()
end

mainLayout.addView(saveBtn)
layout.addView(mainLayout)
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