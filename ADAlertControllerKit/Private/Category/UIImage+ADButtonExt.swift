//
//  UIImage+ADButtonExt.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/8.
//

import UIKit

// 如果某个枚举只在自己模块内使用,可以不用前缀
enum ButtonImagePosition: Int {
    // 图片在左，文字在右，默认
    case left = 0
    // 图片在右，文字在左
    case right
    // 图片在上，文字在下
    case top
    // 图片在下，文字在上
    case bottom
    
    var isHorizontal: Bool {
        return self == .left || self == .right
    }
    
    var isVertical: Bool {
        return self == .top || self == .bottom
    }
}

extension CGSize {
    mutating func resetWidth(_ width: CGFloat) {
        self = CGSize(width: width, height: self.height)
    }
}

extension UIButton {
    
    fileprivate typealias ButtonEdgeInsets = (image: UIEdgeInsets, title: UIEdgeInsets, content: UIEdgeInsets)
    
    // MARK: - public func
    // 设置UIButton中图片在文字的什么位置
    func setImagePosition(postion: ButtonImagePosition, spacing: CGFloat) {
        
        guard let title = self.title(for: .normal) else { return }
                
        if self.isSelected {
            self.setImage(self.currentImage, for: .selected)
        } else {
            self.setImage(self.currentImage, for: .normal)
        }
        
        let imageSize = self.imageView?.image?.size ?? CGSize(width: 1, height: 1)
        let font = self.titleLabel?.font ?? UIFont.systemFont(ofSize: 12)
        var titleSize = title.size(withAttributes: [NSAttributedString.Key.font: font])
        
        if postion.isHorizontal {
            if self.frame.size.width - imageSize.width < titleSize.width {
                titleSize.resetWidth(self.frame.size.width - imageSize.width)
            }
        }
        
        let edgeinsets = self .makeEdgeInsets(postion, spacing, imageSize, titleSize)
        
        self.imageEdgeInsets = edgeinsets.image
        self.titleEdgeInsets = edgeinsets.title
        self.contentEdgeInsets = edgeinsets.content
    }
    
    fileprivate func makeEdgeInsets(_ postion: ButtonImagePosition, _ spacing: CGFloat, _ imageSize: CGSize, _ titleSize: CGSize) -> ButtonEdgeInsets {
        
        let imageOffsetX: CGFloat = (imageSize.width + titleSize.width) * 0.5 - imageSize.width * 0.5
        let imageOffsetY: CGFloat = imageSize.height * 0.5 + spacing * 0.5
        
        let labelOffsetX: CGFloat = (imageSize.width + titleSize.width * 0.5) - (imageSize.width + titleSize.width) * 0.5
        let labelOffsetY: CGFloat = titleSize.height * 0.5 + spacing * 0.5
        
        let tempWidth = max(titleSize.width, imageSize.width)
        let tempHeight = max(titleSize.height, imageSize.height)
        
        let changedWidth: CGFloat = titleSize.width + imageSize.width - tempWidth
        let changedHeight: CGFloat = titleSize.height + imageSize.height + spacing - tempHeight
        
        let labelWidth = titleSize.width
        let imageWidth = imageSize.width
        
        switch postion {
        case .left:
            return (image: UIEdgeInsets(top: 0, left: -spacing * 0.5, bottom: 0, right: spacing * 0.5),
                    title: UIEdgeInsets(top: 0, left: spacing * 0.5, bottom: 0, right: -spacing * 0.5),
                    content: UIEdgeInsets(top: 0, left: spacing * 0.5, bottom: 0, right: spacing * 0.5))
            
        case .right:
            return (image: UIEdgeInsets(top: 0, left: labelWidth + spacing * 0.5,
                                        bottom: 0, right: -(labelWidth + spacing * 0.5)),
                    title:  UIEdgeInsets(top: 0, left: -(imageWidth + spacing * 0.5),
                                         bottom: 0, right: imageWidth + spacing * 0.5),
                    content: UIEdgeInsets(top: 0, left: spacing * 0.5, bottom: 0, right: spacing * 0.5))
            
        case .top:
            return (image: UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX,
                                        bottom: imageOffsetY, right: -imageOffsetX),
                    title: UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX,
                                        bottom: -labelOffsetY, right: labelOffsetX),
                    content: UIEdgeInsets(top: imageOffsetY, left: -changedWidth * 0.5,
                                          bottom: changedHeight-imageOffsetY, right: -changedWidth * 0.5))
        case .bottom:
            return (image: UIEdgeInsets(top: imageOffsetY, left: imageOffsetX,
                                        bottom: -imageOffsetY, right: -imageOffsetX),
                    title:  UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX,
                                         bottom: labelOffsetY, right: labelOffsetX),
                    content: UIEdgeInsets(top: changedHeight-imageOffsetY, left: -changedWidth * 0.5,
                                          bottom: imageOffsetY, right: -changedWidth * 0.5))
            
        }
    }
    
}
