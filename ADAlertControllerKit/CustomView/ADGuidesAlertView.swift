//
//  ADGuidesAlertView.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/15.
//

import UIKit

// 这里声明代理方法不对
protocol ADGuidesAlertViewDelegate: AnyObject {
    func advertView(_ view: ADGuidesAlertView, didSelectItemAt index: Int)
}

/**
xcode中快速注释的方法:
 光标放在要注释的代码上面(类声明,函数,变量等),按
 Alt + Command + /
 或者 Command + ,打开偏好设置,选中 Key Bindings,在filter中输入 Add Documentation,这里显示的就是添加注释的快捷键
 

 */

class ADGuidesAlertView: UIView, UIScrollViewDelegate {

    // MARK: - propert/public
    /**
     当前页数
     */
    public var currentPage: Int? // 类都没有声明为public 这里的属性声明为public有什么意义

    /**
     当前列表
     */
    public var advertDataList: [Any]?
    /**
     代理
     */
    weak var delegate: ADGuidesAlertViewDelegate? // open仅用在可被继承的模块时,是最高权限的访问级别,通常用在类声明中,

    /**
     父视图
     */
    public var alertController: ADAlertController?

    /**
     最大宽度
     */
    public var viewWidth: CGFloat? {
        didSet {
            if viewWidth! > UIScreen.main.bounds.size.width - 60 {
                viewWidth! = UIScreen.main.bounds.size.width - 60
            }
        }
    }

    /**
     viewHeight
     */
    public var viewHeight: CGFloat? {
        didSet {
            if viewHeight! > UIScreen.main.bounds.size.height - 150 {
                viewHeight! = UIScreen.main.bounds.size.height - 150
            }
        }
    }

    // MARK: - propert/private
    /**
     内容视图
     */
    private var containerView: UIView?

    /**
     UIPageControl
     */
    private var pageControl: UIPageControl?

    /**
     closeBtn
     */
    private var closeBtn: ADAlertButton?

    /**
     scrollView
     */
    private var scrollView: UIScrollView?

    // MARK: - func/
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(delegate: ADGuidesAlertViewDelegate, dataArray: [Any]) {
        self.init(frame: CGRect.zero)

        self.delegate = delegate

        self.viewWidth = UIScreen.main.bounds.size.width - 60

        self.viewHeight = UIScreen.main.bounds.size.height - 150

        self.advertDataList = dataArray
        
        self.backgroundColor = UIColor.clear
        
        self.setupContentUI()

    }
    
    
    func setupContentUI() {

        // containerView
        containerView = UIView(frame: CGRect.zero)
        containerView?.backgroundColor = UIColor.clear
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView!)

        // scrollView
        scrollView = UIScrollView(frame: CGRect.zero)
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.delegate = self
        scrollView?.isDirectionalLockEnabled = true
        scrollView?.isPagingEnabled = true
        scrollView?.bounces = false
        containerView?.addSubview(scrollView!)

        // pageControl
        pageControl = UIPageControl.init()
        pageControl?.pageIndicatorTintColor = UIColor.white
        pageControl?.currentPageIndicatorTintColor = UIColor.gray
        pageControl?.numberOfPages = self.advertDataList?.count ?? 1
        containerView?.addSubview(pageControl!)

        // closeBtn
        closeBtn = ADAlertButton(type: UIButton.ButtonType.custom)
        closeBtn?.addTarget(self, action: #selector(onCloseAction(sender:)), for: UIControl.Event.touchUpInside)
        closeBtn?.setBackgroundImage(UIImage.init(named: "close@3x"), for: UIControl.State.normal)
        closeBtn?.setBackgroundImage(UIImage.init(named: "close@3x"), for: UIControl.State.highlighted)
        containerView?.addSubview(closeBtn!)

        
        scrollView?.backgroundColor = UIColor.clear
        pageControl?.backgroundColor = UIColor.clear
        closeBtn?.backgroundColor = UIColor.clear

    }
    
    func layoutContentView() {
                
        containerView?.snp.makeConstraints({ (constraintMaker) in
            constraintMaker.center.equalToSuperview()
            constraintMaker.width.equalTo(viewWidth!)
            constraintMaker.height.equalTo(viewHeight!)
        })

        scrollView?.snp.makeConstraints({ (constraintMaker) in
            constraintMaker.top.left.right.equalToSuperview()
            constraintMaker.width.equalTo(viewWidth!)
            constraintMaker.height.equalTo(viewHeight!-50)
            constraintMaker.bottom.equalToSuperview().offset(-50)
        })

        pageControl?.snp.makeConstraints({ (constraintMaker) in
            constraintMaker.centerX.equalToSuperview()
            constraintMaker.width.equalTo(viewWidth!)
            constraintMaker.bottom.equalTo(scrollView!).offset(-10)
        })

        closeBtn?.snp.makeConstraints({ (constraintMaker) in
            constraintMaker.centerX.equalToSuperview()
            constraintMaker.height.width.equalTo(30)
            constraintMaker.bottom.equalToSuperview().offset(-10)
        })
        
        
    }
    
    func configData() {
        if advertDataList?.count ?? 0 > 0 {
            var beforeImageView: UIImageView?
            for item: Int in 0..<advertDataList!.count {
                if let image = advertDataList![item] as? UIImage {
                    let imageView: UIImageView = UIImageView(image: image)
                    imageView.contentMode = UIView.ContentMode.scaleToFill
                    imageView.tag = 100 + item
                    imageView.backgroundColor = UIColor.clear
                    scrollView?.addSubview(imageView)
                    if beforeImageView == nil {
                        imageView.snp.makeConstraints { (constraintMaker) in
                            constraintMaker.left.equalTo(0)
                            constraintMaker.width.equalTo(viewWidth!)
                            constraintMaker.top.equalToSuperview()
                            constraintMaker.height.equalTo(viewHeight!)
                        }
                        imageView.backgroundColor = UIColor.clear
                    } else if advertDataList!.count-1 == item {
                        imageView.snp.makeConstraints { (constraintMaker) in
                            constraintMaker.left.equalTo(beforeImageView!.snp_right)
                            constraintMaker.right.equalToSuperview()
                            constraintMaker.width.equalTo(viewWidth!)
                            constraintMaker.top.equalToSuperview()
                            constraintMaker.height.equalTo(viewHeight!)
                        }
                        imageView.backgroundColor = UIColor.clear
                    } else {
                        imageView.snp.makeConstraints { (constraintMaker) in
                            constraintMaker.left.equalTo(beforeImageView!.snp_right)
                            constraintMaker.width.equalTo(viewWidth!)
                            constraintMaker.top.equalToSuperview()
                            constraintMaker.height.equalTo(viewHeight!)
                        }
                        imageView.backgroundColor = UIColor.clear
                    }
                    beforeImageView = imageView
                }
                
            }
            self.pageControl?.numberOfPages = advertDataList!.count
        }
    }

    // MARK: - @objc func
    @objc func actionTapped(tap: UITapGestureRecognizer) {
        self.delegate?.advertView(self, didSelectItemAt: tap.view?.tag ?? -1)
        alertController?.hiden()
    }
    
    @objc func onCloseAction(sender: UIButton) {
        alertController?.hiden()
    }

    public func show() {
        let config: ADAlertControllerConfiguration = ADAlertControllerConfiguration(preferredStyle: .alert)
        config.alertViewCornerRadius = 0
        config.alertContainerViewBackgroundColor = UIColor.clear
        
        alertController = ADAlertController(configuration: config, title: nil, message: nil, actions: nil)
        alertController?.maximumWidth = self.viewWidth
        alertController?.contentViewHeight = self.viewHeight
        alertController?.contentView = self
        
        self.layoutContentView()

        self.configData()
        
        alertController?.show()
    }
    
    public func hidden() {
        alertController?.hiden()
    }
    
    // MARK: - respondsToSelectorscrollviewdelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGPoint = scrollView.contentOffset
        self.currentPage = Int(offset.x / self.viewWidth! )
        self.pageControl?.currentPage = self.currentPage ?? 1
        self.pageControl?.updateCurrentPageDisplay()
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
