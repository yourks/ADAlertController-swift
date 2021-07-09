//
//  UIImage+ADButtonExt.swift
//  ADAlertController-swift
//
//  Created by apple on 2021/7/8.
//

import UIKit
// 如果某个枚举只在自己模块内使用,可以不用前缀

enum ButtonImagePosition :Int {
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

extension UIButton {
    
    //MARK: - public func
    
    // 设置UIButton中图片在文字的什么位置
    func setImagePosition(postion: ButtonImagePosition , spacing: CGFloat) -> Void {

        let title :NSString = self.title(for: UIControl.State.normal)! as NSString
        
        if self.isSelected == true {
            self.setImage(self.currentImage, for: UIControl.State.selected)
        }else{
            self.setImage(self.currentImage, for: UIControl.State.normal)
        }
        let imageWidth :CGFloat = self.imageView?.image?.size.width ?? 1
        let imageHeight :CGFloat = self.imageView?.image?.size.height ?? 1

        var labelWidth :CGFloat = title.size(withAttributes: [NSAttributedString.Key.font : self.titleLabel?.font as Any]).width
        let labelHeight :CGFloat = title.size(withAttributes: [NSAttributedString.Key.font : self.titleLabel?.font as Any]).height
        
        if postion.isHorizontal {
            if self.frame.size.width - imageWidth < labelWidth{
                labelWidth = self.frame.size.width - imageWidth
            }
        }
        
        let imageOffsetX :CGFloat = (imageWidth + labelWidth) / 2 - imageWidth / 2
        let imageOffsetY :CGFloat = imageHeight / 2 + spacing / 2
        let labelOffsetX :CGFloat = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2
        let labelOffsetY :CGFloat = labelHeight / 2 + spacing / 2

        var tempWidth :CGFloat
        if labelWidth >  imageWidth {
            tempWidth = labelWidth
        }else{
            tempWidth = imageWidth
        }
        let changedWidth :CGFloat = labelWidth + imageWidth - tempWidth
        var tempHeight :CGFloat
        if labelHeight >  imageHeight {
            tempHeight = labelHeight
        }else{
            tempHeight = imageHeight
        }

        let changedHeight :CGFloat = labelHeight + imageHeight + spacing - tempHeight

        switch postion {
        case .left:
            self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                left: -spacing/2,
                                                bottom: 0,
                                                right: spacing/2)
            self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                left: spacing/2,
                                                bottom: 0,
                                                right: -spacing/2)
            self.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                  left: spacing/2,
                                                  bottom: 0,
                                                  right: spacing/2)
            break
        case .right:
            self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                left: labelWidth + spacing/2,
                                                bottom: 0,
                                                right: -(labelWidth + spacing/2))
            self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                left: -(imageWidth + spacing/2),
                                                bottom: 0,
                                                right: imageWidth + spacing/2)
            self.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                  left: spacing/2,
                                                  bottom: 0,
                                                  right: spacing/2)
            break;
            
        case .top:
            self.imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY,
                                                left: imageOffsetX,
                                                bottom: imageOffsetY,
                                                right: -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsets(top: labelOffsetY,
                                                left: -labelOffsetX,
                                                bottom: -labelOffsetY,
                                                right: labelOffsetX)
            self.contentEdgeInsets = UIEdgeInsets(top: imageOffsetY,
                                                  left: -changedWidth/2,
                                                  bottom: changedHeight-imageOffsetY,
                                                  right: -changedWidth/2)
            break;

        case .bottom:
            self.imageEdgeInsets = UIEdgeInsets(top: imageOffsetY,
                                                left: imageOffsetX,
                                                bottom: -imageOffsetY,
                                                right: -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY,
                                                left: -labelOffsetX,
                                                bottom: labelOffsetY,
                                                right: labelOffsetX)
            self.contentEdgeInsets = UIEdgeInsets(top: changedHeight-imageOffsetY,
                                                  left: -changedWidth/2,
                                                  bottom: imageOffsetY,
                                                  right: -changedWidth/2)
            break;
        }


    }

    
}
