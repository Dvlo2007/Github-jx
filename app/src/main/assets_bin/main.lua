require "import"
import "android.content.*"
import "android.widget.*"
import "android.view.*"

-- 主布局
activity.setContentView(loadlayout{
    LinearLayout;
    orientation="vertical";
    padding="20dp";
    layout_width="fill";
    layout_height="fill";

    -- 网页链接文字（天蓝色）
    {
        TextView;
        text="网页链接";
        textSize="16sp";
        textColor="#00BFFF"; -- 天蓝色
        paddingBottom="5dp";
        layout_width="fill";
    };

    -- 输入框 + 按钮（同一行）
    {
        LinearLayout;
        orientation="horizontal";
        layout_width="fill";
        layout_height="wrap";

        {
            EditText;
            id="input";
            hint="https://github.com/User/Reposi";
            singleLine=true;
            layout_weight="1"; -- 自动扩展宽度
            layout_width="0dp";
        };

        {
            Button;
            text="清空并粘贴";
            id="pasteBtn";
            layout_width="wrap";
        };
    };

    -- 转换选项（单选按钮）
    {
        RadioGroup;
        orientation="horizontal";
        gravity="center";
        paddingTop="20dp";
        paddingBottom="20dp";

        {
            RadioButton;
            text="kGiHub";
            id="kGiHubRadio";
            paddingLeft="20dp";
            paddingRight="20dp";
            checked=true; -- 默认选中
        };

        {
            RadioButton;
            text="jsDelivr";
            id="jsDelivrRadio";
            paddingLeft="20dp";
            paddingRight="20dp";
        };

        {
            RadioButton;
            text="Proxy";
            id="proxyRadio";
            paddingLeft="5dp";
            paddingRight="5dp";
        };
    };

    -- 操作按钮（同一行）
    {
        LinearLayout;
        orientation="horizontal";
        gravity="center";
        paddingTop="20dp";

        {
            Button;
            text="开始转换";
            id="convertBtn";
        };

        {
            Button;
            text="转换并打开";
            id="convertAndOpenBtn";
        };

        {
            Button;
            text="转换并分享";
            id="convertAndShareBtn";
        };
    };
})

-- 转换函数
function convertUrl(url, mode)
    if not url or url == "" then
        return nil, "请输入GitHub链接"
    end
    
    if not url:match("^https?://github%.com/.+") then
        return nil, "无效的GitHub链接"
    end
    
    url = url:gsub("#.*$", ""):gsub("%?.*$", "")
    
    if mode == "kGiHub" then
        return url:gsub("github%.com", "raw.githubusercontent.com"):gsub("/blob/", "/")
    elseif mode == "jsDelivr" then
        return url:gsub("github%.com", "cdn.jsdelivr.net/gh"):gsub("/blob/", "/")
    elseif mode == "proxy" then
        return url:gsub("github%.com", "ghproxy.com/https://github.com")
    else
        return nil, "未知的转换模式"
    end
end

-- 清空并粘贴按钮事件
pasteBtn.onClick = function()
    input.setText("")
    local clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)
    if clipboard.hasPrimaryClip() then
        local item = clipboard.getPrimaryClip().getItemAt(0)
        input.setText(item.getText())
    else
        Toast.makeText(activity, "剪贴板为空", Toast.LENGTH_SHORT).show()
    end
end

-- 开始转换按钮事件
convertBtn.onClick = function()
    local url = input.getText().toString()
    local mode = kGiHubRadio.isChecked() and "kGiHub" 
              or jsDelivrRadio.isChecked() and "jsDelivr" 
              or "proxy"
    
    local converted, err = convertUrl(url, mode)
    if converted then
        input.setText(converted)
        Toast.makeText(activity, "转换成功", Toast.LENGTH_SHORT).show()
    else
        Toast.makeText(activity, err, Toast.LENGTH_SHORT).show()
    end
end

-- 转换并打开按钮事件
convertAndOpenBtn.onClick = function()
    local url = input.getText().toString()
    local mode = kGiHubRadio.isChecked() and "kGiHub" 
              or jsDelivrRadio.isChecked() and "jsDelivr" 
              or "proxy"
    
    local converted, err = convertUrl(url, mode)
    if converted then
        input.setText(converted)
        activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(converted)))
    else
        Toast.makeText(activity, err, Toast.LENGTH_SHORT).show()
    end
end

-- 转换并分享按钮事件
convertAndShareBtn.onClick = function()
    local url = input.getText().toString()
    local mode = kGiHubRadio.isChecked() and "kGiHub" 
              or jsDelivrRadio.isChecked() and "jsDelivr" 
              or "proxy"
    
    local converted, err = convertUrl(url, mode)
    if converted then
        input.setText(converted)
        local intent = Intent(Intent.ACTION_SEND)
        intent.setType("text/plain")
        intent.putExtra(Intent.EXTRA_TEXT, converted)
        activity.startActivity(Intent.createChooser(intent, "分享链接"))
    else
        Toast.makeText(activity, err, Toast.LENGTH_SHORT).show()
    end
end