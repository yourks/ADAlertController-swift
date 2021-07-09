//
//  ADAlertAction.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/25.
//

import UIKit

//按钮点击回调
typealias ADAlertActionHandler = (_ alertAction :ADAlertAction) -> Void

class ADAlertAction: NSObject {

    // MARK: - proprety/pubilc
    
    //用于按钮点击后销毁vc
    public var viewController :UIViewController?

    //按钮能否点击
    public var enabled :Bool?{
        didSet{
            self.button?.isEnabled = enabled ?? true
        }
    }

    
    // MARK: - proprety/private
    
    //父视图 ADAlertControllerViewProtocol
    private var _mainView :ADAlertControllerViewProtocol?

    //按钮点击回调
    private var _handler :ADAlertActionHandler?
    
    //title
    private var _title :String?
    
    //message
    private var _image :UIImage?
    
    //按钮类型默认 ADActionStyleDefault
    private var _style :ADActionStyle?
    
    //按钮配置
    private var _configuration :ADAlertActionConfiguration?
    
    //按钮
    //FIXME: button 类型问题
    public var button :UIButton?


    //MARK: - init
    internal override init() {
        super.init()
    }
    

    //MARK: - init static 类方法
    static func actionWithTitle(_ title :String, _ actionStyle :ADActionStyle, complete alertActionHandler: @escaping ADAlertActionHandler ) -> ADAlertAction  {
        
        let action :ADAlertAction = ADAlertAction.actionWithTitleFull(title, nil, ADActionStyle.ADActionStyleDefault, complete: alertActionHandler, configuration: ADAlertActionConfiguration.defaultConfigurationWithActionStyle(style: actionStyle))

        return action
    }
    
    static func actionWithTitle(_ image :UIImage, _ actionStyle :ADActionStyle, complete alertActionHandler: @escaping ADAlertActionHandler ) -> ADAlertAction  {
        
        let action :ADAlertAction = ADAlertAction.actionWithTitleFull(nil, image, ADActionStyle.ADActionStyleDefault, complete: alertActionHandler, configuration: ADAlertActionConfiguration.defaultConfigurationWithActionStyle(style: actionStyle))

        return action
    }

    static func actionWithTitleFull(_ title :String?,_ image :UIImage?, _ style :ADActionStyle, complete alertActionHandler: @escaping ADAlertActionHandler ,configuration :ADAlertActionConfiguration?) -> ADAlertAction  {
        
        let action :ADAlertAction = ADAlertAction()
        action._title = title ;
        action._image = image ;
        action._style = style;
        
        action._handler = alertActionHandler
        
        action._configuration = configuration ?? ADAlertActionConfiguration.defaultConfigurationWithActionStyle(style: style)
        
        return action
    }
    
    //MARK: - public func
    public func handlerDismissBlock(action :ADAlertAction) -> Void {
        ADAlertController.hidenAlertVC(vc: action.viewController as! ADAlertController)
    }

    public func loadView() -> UIView {
        let actionBtn :ADAlertButton = ADAlertButton(type: UIButton.ButtonType.custom)
        actionBtn.addTarget(self, action:#selector(actionTapped(sender:)), for:UIControl.Event.touchUpInside)
        
        actionBtn.setBackgroundImage(UIImage.ad_imageWithTheColor(color: UIColor.white.withAlphaComponent(0)), for: UIControl.State.normal)
        actionBtn.setBackgroundImage(UIImage.ad_imageWithTheColor(color: UIColor.white.withAlphaComponent(0)), for: UIControl.State.highlighted)

        if _image != nil&&_title != nil {
            actionBtn.setImage(_image, for: UIControl.State.normal)
            actionBtn.setTitle(_title, for: UIControl.State.normal)
            actionBtn.setImagePosition(postion: .top, spacing: 5)
        }
        if _image != nil&&_title == nil{
            actionBtn.setImage(_image, for: UIControl.State.normal)
        }
        if _image == nil&&_title != nil {
            actionBtn.setTitle(_title, for: UIControl.State.normal)
        }

        let buttonConfiguration :ADAlertActionConfiguration = _configuration!
        
        actionBtn.setTitleColor(buttonConfiguration.disabledTitleColor, for: UIControl.State.disabled)
        actionBtn.setTitleColor(buttonConfiguration.titleColor, for: UIControl.State.normal)
        actionBtn.setTitleColor(buttonConfiguration.titleColor, for: UIControl.State.highlighted)
        if buttonConfiguration.titleFont != nil {
            actionBtn.titleLabel?.font = buttonConfiguration.titleFont
        }
        
        self.button = actionBtn;

        return actionBtn
    }
    
    
    //MARK: - @objc func
    @objc func actionTapped(sender :UIButton) -> Void {
        _handler?(self);
        self.handlerDismissBlock(action: self)
    }
}

