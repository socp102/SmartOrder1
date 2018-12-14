//
//  UIImage + Resize.swift
//  HelloMyPushMessage
//
//  Created by kimbely on 2018/10/26.
//  Copyright © 2018 kimbely. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(maxEdge: CGFloat) -> UIImage? {
        //檢查是否有必要縮圖
        guard size.width > maxEdge || size.height > maxEdge else {
            return self
        }
        //判斷最終size
        let finalSize:CGSize
        if size.width >= size.height {
            let ratio = size.width / maxEdge
            finalSize = CGSize(width: maxEdge, height: size.height/ratio)
        } else { //高 > 寬
            let ratio = size.height / maxEdge
            finalSize = CGSize(width: size.width/ratio, height: maxEdge)
        }
        //產出新圖
        UIGraphicsBeginImageContext(finalSize)// 要求系統生成油畫畫布
        let rect = CGRect (x: 0, y: 0, width: finalSize.width, height: finalSize.height)
        self.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()//釋放畫布 重要！
        return result
    }
}
