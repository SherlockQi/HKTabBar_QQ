//
//  HKTabBarItem.swift
//  TABDemo
//
//  Created by Heikki on 2019/2/28.
//  Copyright © 2019年 Heikki. All rights reserved.
//

import UIKit

class HKTabBarModel: NSObject {
    
    public var title: String = ""
    public var imageName: String?
    ///大图偏移距离
    public var distance: CGFloat = 10
    ///小图便宜差异系数
    public var mini_x_Coef:CGFloat = 0.15
    public var mini_y_Coef:CGFloat = 0.15
    
    /**
     * imageName 图片名称
     * title 文字
     * distance 最大的便宜距离
     * mini_x_Coef 小图x偏移系数
     * mini_y_Coef 小图y偏移系数
     *
     */
    
    init(imageName: String ,title: String, distance: CGFloat, mini_x_Coef: CGFloat , mini_y_Coef:CGFloat) {
        self.imageName = imageName
        self.title = title
        self.distance = distance
        self.mini_x_Coef = mini_x_Coef
        self.mini_y_Coef = mini_y_Coef
    }
    
    convenience init(imageName: String ,title: String) {
        self.init(imageName: imageName, title: title, distance: 10, mini_x_Coef: 0.15, mini_y_Coef: 0.15)
    }

}
