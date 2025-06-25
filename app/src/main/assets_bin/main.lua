require "import"
import "android.content.*"
import "android.widget.*"
import "android.view.*"

-- 创建主布局
local layout = LinearLayout(activity)
layout.setOrientation(1)
layout.setPadding(20, 20, 20, 20)

-- 标题
local title = TextView(activity)
title.setText("GitHub链接转换工具")
title.setTextSize(20)
title.setGravity(Gravity.CENTER)
title.setTextColor(0xFF000000)
layout.addView(title)

-- 输入框
local inputLayout = LinearLayout(activity)
inputLayout.setOrientation(1)
inputLayout.setPadding(0, 30, 0, 10)

local inputLabel = TextView(activity)
inputLabel.setText("输入GitHub链接:")
inputLayout.addView(inputLabel)

local input = EditText(activity)
input.setHint("例如: https://github.com/user/repo/blob/main/file.txt")
input.setSingleLine(true)
inputLayout.addView(input)

layout.addView(inputLayout)

-- 按钮布局
local buttonLayout = LinearLayout(activity)
buttonLayout.setOrientation(0)
buttonLayout.setGravity(Gravity.CENTER)

local rawBtn = Button(activity)
rawBtn.setText("转Raw链接")
buttonLayout.addView(rawBtn)

local downloadBtn = Button(activity)
downloadBtn.setText("转下载链接")
buttonLayout.addView(downloadBtn)

layout.addView(buttonLayout)

-- 结果布局
local resultLayout = LinearLayout(activity)
resultLayout.setOrientation(1)
resultLayout.setPadding(0, 30, 0, 0)

local resultLabel = TextView(activity)
resultLabel.setText("转换结果:")
resultLayout.addView(resultLabel)

local result = EditText(activity)
result.setSingleLine(true)
result.setFocusable(false)
resultLayout.addView(result)

local copyBtn = Button(activity)
copyBtn.setText("复制结果")
resultLayout.addView(copyBtn)

layout.addView(resultLayout)

-- 设置主视图
activity.setContentView(layout)

-- 创建菜单
function onCreateOptionsMenu(menu)
    menu.add("设置")
    return true
end

function onOptionsItemSelected(item)
    if item.title == "设置" then
        activity.newActivity("settings")
    end
    return true
end

-- 转换函数
local function convertUrl(url, mode)
    if not url:match("^https?://github%.com/.+") then
        return nil, "无效的GitHub链接"
    end
    
    url = url:gsub("#.*$", ""):gsub("%?.*$", "")
    
    if mode == "raw" then
        return url:gsub("github%.com", "raw.githubusercontent.com"):gsub("/blob/", "/")
    elseif mode == "download" then
        return url:gsub("/blob/", "/raw/")
    else
        return nil, "未知的转换模式"
    end
end

-- 按钮事件
rawBtn.onClick = function()
    local url = input.getText().toString()
    if url == "" then
        Toast.makeText(activity, "请输入GitHub链接", Toast.LENGTH_SHORT).show()
        return
    end
    
    local converted, err = convertUrl(url, "raw")
    if converted then
        result.setText(converted)
    else
        Toast.makeText(activity, err, Toast.LENGTH_SHORT).show()
    end
end

downloadBtn.onClick = function()
    local url = input.getText().toString()
    if url == "" then
        Toast.makeText(activity, "请输入GitHub链接", Toast.LENGTH_SHORT).show()
        return
    end
    
    local converted, err = convertUrl(url, "download")
    if converted then
        result.setText(converted)
    else
        Toast.makeText(activity, err, Toast.LENGTH_SHORT).show()
    end
end

copyBtn.onClick = function()
    local text = result.getText().toString()
    if text ~= "" then
        local clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)
        local clip = ClipData.newPlainText("GitHub链接", text)
        clipboard.setPrimaryClip(clip)
        Toast.makeText(activity, "已复制到剪贴板", Toast.LENGTH_SHORT).show()
    else
        Toast.makeText(activity, "没有可复制的内容", Toast.LENGTH_SHORT).show()
    end
end