//
//  ADTabbarVC.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/6/23.
//

import UIKit

class ADTabbarVC: ADBaseTabBarVC {

    /*
     func addChildViewController(_ childController: UIViewController, title:String?, image:UIImage?, selectedImage:UIImage?) {

         childController.title = title
         childController.tabBarItem = UITabBarItem(title: nil,
                                                   image: image?.withRenderingMode(.alwaysOriginal),
                                                   selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))

         if UIDevice.current.userInterfaceIdiom == .phone {
             childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
         }
         addChild(ADNavVC(rootViewController: childController))
     }
     */
    // MARK: - 再次提问为啥这里用？ 能不用？ 或者用！ 多次练习包括使用后发现？确实是好用 表示包不确定根据语法 ？
    // 可能是 childerVC.tabBarItem = UITabBarItem(title: <#T##String?#>, image: <#T##UIImage?#>, selectedImage: <#T##UIImage?#>)
    func addChilderVC(_ childerVC: UIViewController, title: String?, nomalImageStr: String?, selectedImageStr: String? ) {
        childerVC.title = title
        
     childerVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: nomalImageStr!)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: selectedImageStr!)?.withRenderingMode(.alwaysOriginal))

        addChild(ADNavVC(rootViewController: childerVC))
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor.blue
        
        // MARK: -
        let functionVC = ADFunctionTableVC()
        addChilderVC(functionVC, title: "功能", nomalImageStr: "tab_home", selectedImageStr: "tab_home_S")

        let classVC = ADClassVC()
        addChilderVC(classVC, title: "分类", nomalImageStr: "tab_class", selectedImageStr: "tab_class_S")
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
