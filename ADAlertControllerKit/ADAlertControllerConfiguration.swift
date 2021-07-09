//
//  ADAlertControllerConfiguration.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/25.
//

import UIKit

class ADAlertControllerConfiguration: NSObject {
    /**
     alertController 类型,默认 alert类型
     */
    var preferredStyle :ADAlertControllerStyle = ADAlertControllerStyle.ADAlertControllerStyleAlert
    //ADAlertControllerStyle.Alert
    /**
     点击背景是否关闭警告框视图,默认 NO
     */
    var hidenWhenTapBackground :Bool = false
    /**
     针对 alert 类型视图,是否允许手势滑动关闭警告框视图,默认 NO
     */
    var swipeDismissalGestureEnabled: Bool = false
    /**
      针对alert 类型视图,若只有两个按钮时,是否总是垂直排列,默认 NO
     */
    var alwaysArrangesActionButtonsVertically: Bool = false
    
    /**
     覆盖在最底下的蒙版 view 的背景色,默认0.5透明度的黑色
     */
    var alertMaskViewBackgroundColor: UIColor =  UIColor.black.withAlphaComponent(0.5)

    /**
     内容容器视图背景色,默认白色
     */
    var alertViewBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)

    /**
     内容容器视图背景色,默认白色
     */
    var alertContainerViewBackgroundColor: UIColor = UIColor.white

    /**
     按钮背景色 ActionsView
     */
    var alertActionsViewBtnBackgroundColors: Array<UIColor> = Array()

    /**
     内容容器视图圆角,默认4
     */
    var alertViewCornerRadius: CGFloat = 4.0

    /**
     标题文本颜色,默认系统颜色
     */
    var titleTextColor: UIColor = UIColor.black

    /**
     详细消息文本颜色,默认系统颜色
     */
    var messageTextColor: UIColor = UIColor.black

    /**
     在按钮周围是否显示分割线,默认 NO  按钮间的showsSeparators 可以通过 控制actionButtonStackView?.spacing = 0.0; 来控制
     */
    var showsSeparators: Bool = false

    /**
      分割线颜色,默认[UIColor lightGrayColor]  按钮间的separatorColor 可以通过 控制actionButtonStackView?.背景色 来控制
     */
    var separatorColor: UIColor = UIColor.lightGray

    /**
    内部自定义 view 四周边距
     */
    var contentViewInset: UIEdgeInsets = UIEdgeInsets()

    /**
     messageText 四周边距
     */
    var messageTextInset: UIEdgeInsets = UIEdgeInsets()

    /**
     标题文本字体,默认[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
     */
    var titleFont: UIFont?

    /**
     详细消息文本字体,默认是[UIFont preferredFontForTextStyle:UIFontTextStyleBody]
     */
    var messageFont: UIFont?

    /**
     背景是否需要模糊效果,默认YES,未实现
     */
    var backgroundViewBlurEffects: Bool = true


    // MARK: - 初始化方法
    private override init(){
        super.init()
    }
    
    init(preferredStyle :ADAlertControllerStyle) {
        self.preferredStyle = preferredStyle;
    }

    /**
     根据alertview 类型,生成不同配置对象

     @param preferredStyle alertview类型
     @return 默认配置对象
     */
    static  func defaultConfigurationWithPreferredStyle(preferredStyle :ADAlertControllerStyle) -> ADAlertControllerConfiguration{
        
        let config :ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: preferredStyle)
        
        config.alertContainerViewBackgroundColor = UIColor.white;
        config.alertMaskViewBackgroundColor = UIColor.black.withAlphaComponent(0.5);
        
        if (preferredStyle != ADAlertControllerStyle.ADAlertControllerStyleSheet) {
            config.alertViewCornerRadius = 4;
        }
        
        config.separatorColor = UIColor.lightGray;
        config.titleFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        config.messageFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)

        return config;
    }


}
