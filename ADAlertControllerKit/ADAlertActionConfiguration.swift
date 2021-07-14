//
//  ADAlertActionConfiguration.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/29.
//

import UIKit

class ADAlertActionConfiguration: NSObject {
    
    /**
     alertAction 显示的标题字体,默认为[UIFont preferredFontForTextStyle:UIFontTextStyleBody]
     */
    public var titleFont: UIFont?

    /**
      alertAction 显示的标题颜色,默认为[UIColor darkGrayColor],若为ADActionStyleDestructive,默认为[UIColor redColor]
     */
    public var titleColor: UIColor?
    
    /**
      alertAction 不可用时的标题颜色,默认为[UIColor grayColor]的 0.6 透明度颜色,若为ADActionStyleDestructive,默认为[UIColor redColor]
     */
    public var disabledTitleColor: UIColor?

    /**
     根据alertview 类型,生成不同配置对象

     @param preferredStyle alertview类型
     @return 默认配置对象
     */
    public static func defaultConfigurationWithActionStyle(style: ADActionStyle) -> ADAlertActionConfiguration {
        let config: ADAlertActionConfiguration = ADAlertActionConfiguration()
        switch style {
        case .destructive:
            config.titleColor = UIColor.red
            config.disabledTitleColor = UIColor.red
        default:
            break
        }
        return config
    }
    
    // MARK: - 初始化方法
    private override init() {
        titleFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        titleColor = UIColor.darkGray
        disabledTitleColor = UIColor.gray.withAlphaComponent(0.6)
        super.init()
    }
}
