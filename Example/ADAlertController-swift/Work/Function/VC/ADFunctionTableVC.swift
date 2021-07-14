//
//  ADFunctionTableVC.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/23.
//

import UIKit
import MapKit

class ADFunctionTableVC: ADBaseVC, UITextFieldDelegate {
    

    var functionArr: Array = [ADFunctionModel]()
    
    // MARK: - 需要学习一种ADFunctionTableCell 的框架
    lazy var mainTableV: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.red
        table.separatorStyle = .none
        table.register(ADFunctionTableCell.self, forCellReuseIdentifier: "ADFunctionTableCell")
        return table
    }()
    
    
    // MARK: - 需要学习一种转换模型的框架
    func getData() -> [ADFunctionModel] {
        var functionArr: Array = [ADFunctionModel]()

        let functionDictArr: Array = [
            ["title": "仅标题的警告框", "selector": "alertStyleTitleOnly"],
            ["title": "仅内容的警告框", "selector": "alertStyleMessageOnly"],
            ["title": "同时包含标题内容的警告框", "selector": "alertStyleTitleAndMessage"],
            ["title": "内容视图可上下拖动的警告框", "selector": "alertStylePanEnable"],
            ["title": "添加自定义视图的警告框", "selector": "alertStyleCustomContentView"],
            ["title": "详细内容为长文本时自动滚动的警告框", "selector": "alertStyleLongMessage"],
            ["title": "可包含多个按钮的警告框", "selector": "alertStyleMultipButton"],
            ["title": "可包含多个图片按钮的警告框", "selector": "alertStyleImageButton"],
            ["title": "分组按钮的警告框", "selector": "alertStyleGroupButtons"],
            ["title": "另一种布局的AlertAction的警告框", "selector": "alertStyleImageAction"],
            ["title": "添加输入框的警告框", "selector": "alertStyleTextField"],
            ["title": "仅显示自定义视图的警告框", "selector": "alertStyleCustomContentViewOnly"],
            ["title": "仅标题的ActionSheet", "selector": "actionSheetStyleTitleOnly"],
            ["title": "包含标题和内容的ActionSheet", "selector": "actionSheetStyleTitleAndMessage"],
            ["title": "添加自定义视图的ActionSheet", "selector": "actionSheetStyleCustomContentView"],
            ["title": "包含多个按钮的ActionSheet", "selector": "actionSheetStyleMultipButton"],
            ["title": "包含多个图片按钮的ActionSheet", "selector": "actionSheetStyleImageButton"],
            ["title": "分组按钮的ActionSheet", "selector": "actionSheetStyleGroupButton"],
            ["title": "分组可滑动的ActionSheet", "selector": "actionSheetStyleScrollableButton"],
            ["title": "无边距风格的ActionSheet", "selector": "sheetStyle"],
            ["title": "无边距风格的ActionSheet的应用", "selector": "sheetStyleSample"],
            ["title": "优先级的应用", "selector": "prorityQueueSample"],
            ["title": "指定在某个控制器显示", "selector": "targetViewControllerSample"],
            ["title": "黑名单时不显示", "selector": "listSample"]
        ]
        
        for dic: Dictionary in functionDictArr {
            let model: ADFunctionModel = ADFunctionModel()
            model.selector = dic["selector"]
            model.title = dic["title"]
            functionArr.append(model)
        }
        return functionArr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 数据
        functionArr = self.getData()
        // 
        self.view.addSubview(self.mainTableV)
        self.mainTableV.snp.makeConstraints { (constraintMaker) in
            constraintMaker.left.right.top.equalToSuperview()
            constraintMaker.bottom.equalToSuperview().offset(0)
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ADFunctionTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functionArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell: ADFunctionTableCell = tableView.dequeueReusableCell(withIdentifier: "ADFunctionTableCell", for: indexPath) as! ADFunctionTableCell
        // swiftlint:enable force_cast
        cell.model = functionArr[indexPath.row]
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.red
        } else {
            cell.contentView.backgroundColor = UIColor.yellow
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: ADFunctionModel = functionArr[indexPath.row]
        let selector: Selector = NSSelectorFromString(model.selector!)
        performSelector(onMainThread: selector, with: nil, waitUntilDone: false)
    }

}

extension ADFunctionTableVC {
    @objc func alertStyleTitleOnly() {
        
        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.cancel) { (_) in
            print("点击了取消")
        }

        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }

        let alertView: ADAlertController = ADAlertController(configuration: ADAlertControllerConfiguration.defaultConfigurationWithPreferredStyle(preferredStyle: ADAlertControllerStyle.alert), title: "这里是标题", message: "", actions: [cancelAction, sureAction])

        alertView.show()
        
    }
    
    @objc func alertStyleMessageOnly() {
        
        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.cancel) { (_) in
            print("点击了取消")
        }

        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }

        let alertView: ADAlertController = ADAlertController(configuration: ADAlertControllerConfiguration.defaultConfigurationWithPreferredStyle(preferredStyle: ADAlertControllerStyle.alert), title: "", message: "这里是内容", actions: [cancelAction, sureAction])

        alertView.show()
        
    }

    @objc func alertStyleTitleAndMessage() {
        
        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.cancel) { (_) in
            print("点击了取消")
        }

        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }

        let alertView: ADAlertController = ADAlertController(configuration: ADAlertControllerConfiguration.defaultConfigurationWithPreferredStyle(preferredStyle: ADAlertControllerStyle.alert), title: "这里是标题", message: "这里是内容这里是内容这里是内容这里是内容这里是内容这里是内容这里是内容这里是内容这里是内容这里是内容这里是内容这里是内容这里是内容里是内容这里是内容这里是内容", actions: [cancelAction, sureAction])

        alertView.show()
        
    }
    
    @objc func alertStylePanEnable() {
        
        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.cancel) { (_) in
            print("点击了取消")
        }

        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }
        

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true
        config.messageTextInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 20, right: 10)
        config.titleTextColor = UIColor.black
        config.messageTextColor = UIColor.gray
        config.swipeDismissalGestureEnabled = true
        
        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: "这里是内容这里是内容这里是内容这这里是内容", actions: [cancelAction, sureAction])

        alertView.show()
        
    }

    @objc func alertStyleCustomContentView() {
        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.cancel) { (_) in
            print("点击了取消")
        }

        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true
        config.messageTextInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 20, right: 10)
        
        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: "这里是内容这里这里是内容这里是内容这里是内容这里是内容", actions: [cancelAction, sureAction])

        
        // 添加自定义视图
        let mapView: MKMapView = MKMapView()
        alertView.contentView = mapView
        alertView.contentViewHeight = 250
        alertView.show()
    }

    
    @objc func alertStyleLongMessage() {
        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.cancel) { (_) in
            print("点击了取消")
        }

        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true
        config.messageTextInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 20, right: 10)
        config.messageTextColor = UIColor.gray
        config.messageFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        config.titleFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)

        let message = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: message, actions: [cancelAction, sureAction])

        alertView.show()

    }


    @objc func alertStyleMultipButton() {

        let actionConfig: ADAlertActionConfiguration = ADAlertActionConfiguration.defaultConfigurationWithActionStyle(style: ADActionStyle.default)
        
        let action1: ADAlertAction = ADAlertAction.actionWithTitleFull("WiFi 或者 移动网络", nil, ADActionStyle.cancel, complete: { (_) in
            print("选择了WiFi 或者 移动网络")
        }, configuration: actionConfig)
        
        let action2: ADAlertAction = ADAlertAction.actionWithTitleFull("移动网络", nil, ADActionStyle.cancel, complete: { (_) in
            print("选择了移动网络")
        }, configuration: actionConfig)

        let action3: ADAlertAction = ADAlertAction.actionWithTitleFull("WiFi", nil, ADActionStyle.cancel, complete: { (_) in
            print("选择了WiFi")
        }, configuration: actionConfig)

        let action4: ADAlertAction = ADAlertAction.actionWithTitleFull("不允许网络访问", nil, ADActionStyle.cancel, complete: { (_) in
            print("选择了不允许网络访问")
        }, configuration: actionConfig)

        
        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "请选择该 APP 允许访问的网络类型", message: nil, actions: [action1, action2, action3, action4])
        
        alertView.show()
    }

    @objc func alertStyleImageButton() {

        let actionConfig: ADAlertActionConfiguration = ADAlertActionConfiguration.defaultConfigurationWithActionStyle(style: ADActionStyle.default)
        
        let action1: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_1"), ADActionStyle.cancel, complete: { (_) in
            print("share_1")
        }, configuration: actionConfig)
        
        let action2: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_2"), ADActionStyle.cancel, complete: { (_) in
            print("share_2")
        }, configuration: actionConfig)

        let action3: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_3"), ADActionStyle.cancel, complete: { (_) in
            print("share_3")
        }, configuration: actionConfig)

        let action4: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_4"), ADActionStyle.cancel, complete: { (_) in
            print("share_4")
        }, configuration: actionConfig)

        let action5: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_5"), ADActionStyle.cancel, complete: { (_) in
            print("share_5")
        }, configuration: actionConfig)

        
        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: nil, actions: [action1, action2, action3, action4, action5])
        
        alertView.show()
    }
    
    @objc func alertStyleGroupButtons() {

        let actionConfig: ADAlertActionConfiguration = ADAlertActionConfiguration.defaultConfigurationWithActionStyle(style: ADActionStyle.default)
        
        let action1: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_1"), ADActionStyle.cancel, complete: { (_) in
            print("share_1")
        }, configuration: actionConfig)
        
        let action2: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_2"), ADActionStyle.cancel, complete: { (_) in
            print("share_2")
        }, configuration: actionConfig)

        let action3: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_3"), ADActionStyle.cancel, complete: { (_) in
            print("share_3")
        }, configuration: actionConfig)

        let action4: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_4"), ADActionStyle.cancel, complete: { (_) in
            print("share_4")
        }, configuration: actionConfig)

        let action5: ADAlertAction = ADAlertAction.actionWithTitleFull("短信", nil, ADActionStyle.cancel, complete: { (_) in
            print("短信")
        }, configuration: actionConfig)

        let group: ADAlertGroupAction = ADAlertGroupAction.groupActionWithActions(actions: [action1, action2, action3, action4, action5])

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: nil, actions: [group, action5, action5])

        alertView.show()
    }

    @objc func alertStyleImageAction() {

        let actionConfig: ADAlertActionConfiguration = ADAlertActionConfiguration.defaultConfigurationWithActionStyle(style: ADActionStyle.default)
        
        let action1: ADAlertAction = ADAlertAction.actionWithTitleFull("QQ", UIImage(named: "share_1"), ADActionStyle.cancel, complete: { (_) in
            print("share_1")
        }, configuration: actionConfig)
        
        let action2: ADAlertAction = ADAlertAction.actionWithTitleFull("QQ空间", UIImage(named: "share_2"), ADActionStyle.cancel, complete: { (_) in
            print("share_2")
        }, configuration: actionConfig)

        let action3: ADAlertAction = ADAlertAction.actionWithTitleFull("短信", UIImage(named: "share_3"), ADActionStyle.cancel, complete: { (_) in
            print("share_3")
        }, configuration: actionConfig)

        let action4: ADAlertAction = ADAlertAction.actionWithTitleFull("朋友圈", UIImage(named: "share_4"), ADActionStyle.cancel, complete: { (_) in
            print("share_4")
        }, configuration: actionConfig)

        let action5: ADAlertAction = ADAlertAction.actionWithTitleFull("微信", UIImage(named: "share_5"), ADActionStyle.cancel, complete: { (_) in
            print("短信")
        }, configuration: actionConfig)

        let group: ADAlertGroupAction = ADAlertGroupAction.groupActionWithActions(actions: [action1, action2, action3, action4, action5])

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true

//        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: nil, actions: [group, action5, action5])
        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: nil, actions: [group])

        alertView.show()
    }

    @objc func alertStyleTextField() {

        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.cancel) { (_) in
            print("点击了取消")
        }

        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }

        sureAction.enabled = false
        
        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: nil, actions: [sureAction, cancelAction])

        alertView .addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "请输入用户名"
            textField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            textField.delegate = self
        }
        
        alertView .addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "请输入密码"
            textField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            textField.delegate = self
        }

        alertView .addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "请输入手机号"
            textField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            textField.delegate = self
        }

        alertView .addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "请输入邮箱"
            textField.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            textField.delegate = self
        }

        alertView.show()
    }

    @objc func alertStyleCustomContentViewOnly() {
        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }
        
        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true
        //        ADAdvertView *advertView = [ADAdvertView advertViewWithDelegate:self dataArray:@[@"1",@"2"]]
        //        [advertView show]

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "没有完成", message: nil, actions: [sureAction])


        alertView.show()
    }
    
    
    @objc func actionSheetStyleTitleOnly() {
        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.sheetCancel) { (_) in
            print("点击了取消")
        }

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.actionSheet)
        config.showsSeparators = true

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "标题", message: nil, actions: nil )

        alertView.addActionSheetCancelAction(cancelAction: cancelAction)

        alertView.show()
    }
    
    @objc func actionSheetStyleTitleAndMessage() {
        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.sheetCancel) { (_) in
            print("点击了取消")
        }

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.actionSheet)
        config.showsSeparators = true

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "标题", message: "这里是内容,内容同样可以配置字体和字体颜色,以及长文本", actions: nil )

        alertView.addActionSheetCancelAction(cancelAction: cancelAction)

        alertView.show()
    }

    @objc func actionSheetStyleCustomContentView() {
        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.sheetCancel) { (_) in
            print("点击了取消")
        }

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.actionSheet)
        config.showsSeparators = true
        config.messageTextInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 20, right: 10)
        
        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: "这里是内容这里这里是内容这里是内容这里是内容这里是内容", actions: nil)

        alertView.addActionSheetCancelAction(cancelAction: cancelAction)

        // 添加自定义视图
        let mapView: MKMapView = MKMapView()
        alertView.contentView = mapView
        alertView.contentViewHeight = 250
        alertView.show()
    }

    @objc func actionSheetStyleMultipButton() {
        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.sheetCancel) { (_) in
            print("点击了取消")
        }
        let cancelAction1: ADAlertAction = ADAlertAction.actionWithTitle("添加", ADActionStyle.default) { (_) in
            print("点击了取消")
        }
        let cancelAction2: ADAlertAction = ADAlertAction.actionWithTitle("编辑", ADActionStyle.default) { (_) in
            print("点击了取消")
        }
        
        let cancelAction3: ADAlertAction = ADAlertAction.actionWithTitle("删除", ADActionStyle.destructive) { (_) in
            print("点击了取消")
        }

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.actionSheet)
        config.showsSeparators = true
        config.messageTextInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 20, right: 10)
        
        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: "这里是内容这里这里是内容这里是内容这里是内容这里是内容", actions: [cancelAction1, cancelAction2, cancelAction3])

        alertView.addActionSheetCancelAction(cancelAction: cancelAction)

        alertView.show()
    }

    @objc func actionSheetStyleImageButton() {
        let actionConfig: ADAlertActionConfiguration = ADAlertActionConfiguration.defaultConfigurationWithActionStyle(style: ADActionStyle.default)
        
        let action1: ADAlertAction = ADAlertAction.actionWithTitleFull("QQ", UIImage(named: "share_1"), ADActionStyle.cancel, complete: { (_) in
            print("share_1")
        }, configuration: actionConfig)
        
        let action2: ADAlertAction = ADAlertAction.actionWithTitleFull("QQ空间", UIImage(named: "share_2"), ADActionStyle.cancel, complete: { (_) in
            print("share_2")
        }, configuration: actionConfig)

        let action3: ADAlertAction = ADAlertAction.actionWithTitleFull("短信", UIImage(named: "share_3"), ADActionStyle.cancel, complete: { (_) in
            print("share_3")
        }, configuration: actionConfig)

        let action4: ADAlertAction = ADAlertAction.actionWithTitleFull("朋友圈", UIImage(named: "share_4"), ADActionStyle.cancel, complete: { (_) in
            print("share_4")
        }, configuration: actionConfig)

        let action5: ADAlertAction = ADAlertAction.actionWithTitleFull("微信", UIImage(named: "share_5"), ADActionStyle.cancel, complete: { (_) in
            print("短信")
        }, configuration: actionConfig)
        
        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.actionSheet)
        config.showsSeparators = true

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: nil, actions: [action1, action2, action3, action4, action5])

        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.sheetCancel) { (_) in
            print("点击了取消")
        }
        alertView.addActionSheetCancelAction(cancelAction: cancelAction)

        alertView.show()
    }

    @objc func actionSheetStyleGroupButton() {
        let actionConfig: ADAlertActionConfiguration = ADAlertActionConfiguration.defaultConfigurationWithActionStyle(style: ADActionStyle.default)
        
        let action1: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_1"), ADActionStyle.cancel, complete: { (_) in
            print("share_1")
        }, configuration: actionConfig)
        
        let action2: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_2"), ADActionStyle.cancel, complete: { (_) in
            print("share_2")
        }, configuration: actionConfig)

        let action3: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_3"), ADActionStyle.cancel, complete: { (_) in
            print("share_3")
        }, configuration: actionConfig)

        let action4: ADAlertAction = ADAlertAction.actionWithTitleFull(nil, UIImage(named: "share_4"), ADActionStyle.cancel, complete: { (_) in
            print("share_4")
        }, configuration: actionConfig)

        let action5: ADAlertAction = ADAlertAction.actionWithTitleFull("短信", nil, ADActionStyle.cancel, complete: { (_) in
            print("短信")
        }, configuration: actionConfig)

        let group: ADAlertGroupAction = ADAlertGroupAction.groupActionWithActions(actions: [action1, action2, action3, action4, action5])

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.actionSheet)
        config.showsSeparators = true

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: nil, actions: [group])

        let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.sheetCancel) { (_) in
            print("点击了取消")
        }
        alertView.addActionSheetCancelAction(cancelAction: cancelAction)

        alertView.show()

    }

    @objc func actionSheetStyleScrollableButton() {
        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }
        
        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true
        //        ADAdvertView *advertView = [ADAdvertView advertViewWithDelegate:self dataArray:@[@"1",@"2"]]
        //        [advertView show]

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "没有完成", message: nil, actions: [sureAction])


        alertView.show()
    }

    @objc func sheetStyle() {

        let cancelAction1: ADAlertAction = ADAlertAction.actionWithTitle("添加", ADActionStyle.default) { (_) in
            print("点击了取消")
        }
        let cancelAction2: ADAlertAction = ADAlertAction.actionWithTitle("编辑", ADActionStyle.default) { (_) in
            print("点击了取消")
        }

        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.sheet)
        config.showsSeparators = true
        config.messageTextInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 20, right: 10)
        
        let alertView: ADAlertController = ADAlertController(configuration: config, title: "这里是标题", message: "这里是内容这里这里是内容这里是内容这里是内容这里是内容", actions: [cancelAction1, cancelAction2])

        // 添加自定义视图
        let mapView: MKMapView = MKMapView()
        alertView.contentView = mapView
        alertView.contentViewHeight = 250
        alertView.show()
    }

    @objc func sheetStyleSample() {
        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }
        
        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "没有完成", message: nil, actions: [sureAction])


        alertView.show()
    }
    
    
    @objc func prorityQueueSample() {
        
        for index: NSInteger in 0..<10 {
            
            let style: ADAlertControllerStyle = (index % 2 == 0) ?ADAlertControllerStyle.alert : ADAlertControllerStyle.sheet
            
            var alertPrority: ADAlertPriority = ADAlertPriority.ADAlertPriorityDefault

            if index % 3 == 0 {
                alertPrority = ADAlertPriority.ADAlertPriorityDefault
            } else if index % 3 == 1 {
                alertPrority = ADAlertPriority.ADAlertPriorityHight
            } else {
                alertPrority = ADAlertPriority.ADAlertPriorityRequire
            }

            var aDescription: String = "Default"
            switch alertPrority {
            case ADAlertPriority.ADAlertPriorityDefault:
                aDescription = "Default"
            case ADAlertPriority.ADAlertPriorityHight:
                aDescription = "Hight"
            case ADAlertPriority.ADAlertPriorityRequire:
                aDescription = "Require"

            }
            
            let title: String = String(format: "当前是第%d个插入的队列的,优先级是%@", index+1, aDescription)
            let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: style)
            config.hidenWhenTapBackground = true
            
            switch style {
            case ADAlertControllerStyle.alert:
                let cancelAction1: ADAlertAction = ADAlertAction.actionWithTitle("添加", ADActionStyle.default) { (_) in
                    print("点击了取消")
                }
                let cancelAction2: ADAlertAction = ADAlertAction.actionWithTitle("编辑", ADActionStyle.default) { (_) in
                    print("点击了取消")
                }
                let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
                config.showsSeparators = true
                let alertView: ADAlertController = ADAlertController(configuration: config, title: title, message: nil, actions: [cancelAction1, cancelAction2])
                alertView.alertPriority = alertPrority
                alertView.enqueue()

            case ADAlertControllerStyle.sheet:
                // swiftlint:disable no_fallthrough_only
                fallthrough
                // swiftlint:enable type_body_length
            case ADAlertControllerStyle.actionSheet:
                
                let alertView: ADAlertController = ADAlertController(configuration: config, title: title, message: nil, actions: nil)
                let cancelAction: ADAlertAction = ADAlertAction.actionWithTitle("取消", ADActionStyle.sheetCancel) { (_) in
                    print("点击了取消")
                }
                alertView.addActionSheetCancelAction(cancelAction: cancelAction)
                alertView.enqueue()
            }
        }
        
    }

    
    @objc func targetViewControllerSample() {
        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }
        
        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "没有完成", message: nil, actions: [sureAction])

        alertView.show()
    }

    @objc func listSample() {
        let sureAction: ADAlertAction = ADAlertAction.actionWithTitle("确定", ADActionStyle.default) { (_) in
            print("点击了确定")
        }
        
        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: ADAlertControllerStyle.alert)
        config.showsSeparators = true
        //        ADAdvertView *advertView = [ADAdvertView advertViewWithDelegate:self dataArray:@[@"1",@"2"]]
        //        [advertView show]

        let alertView: ADAlertController = ADAlertController(configuration: config, title: "没有完成", message: nil, actions: [sureAction])

        alertView.show()
    }
}
