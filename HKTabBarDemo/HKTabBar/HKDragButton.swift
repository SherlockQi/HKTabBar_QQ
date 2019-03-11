
//  HKDragButton.swift
//  TABDemo
//
//  Created by Heikki on 2019/2/18.
//  Copyright © 2019年 Heikki. All rights reserved.
//

import UIKit

//let HK_ITEM_WIDTH = HK_SCREEN_WIDTH / 3
//let HK_ITEM_HEIGHT = 49

class HKDragButton: UIButton {
    
    ///大图偏移距离
    public var distance: CGFloat = 10
    ///小图差异系数
    public var mini_x_Coef:CGFloat = 0.15
    public var mini_y_Coef:CGFloat = 0.15
    ///按钮名称
    public var title: String = ""
    
    //大图
    private var bigImage_normal: UIImage?
    private var bigImage_select: UIImage?
    
    private var miniImage_normal: UIImage?
    private var miniImage_select: UIImage?
    
    private var dragButton_x: CGFloat = 50
    private var dragButton_y: CGFloat = 50
    
    var itemH: CGFloat = 0
    var itemW: CGFloat = 0
    
    lazy var imageView_big: UIImageView = {
        let im = UIImageView()
        im.contentMode = .center
        return im
    }()
    
    lazy var imageView_mini: UIImageView = {
        let im = UIImageView()
        im.contentMode = .center
        return im
    }()
    
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemH = self.bounds.size.height
        itemW = self.bounds.size.width
        
        textLabel.frame = CGRect(x: 0.0, y: itemH - 15.0, width: itemW, height: 15.0)
        imageView_big.frame = CGRect(x: 0.0 , y: 0.0, width: itemW, height: itemH - 15.0)
        imageView_mini.frame = CGRect(x: 0.0 , y: 0.0, width: itemW, height: itemH - 15.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(item: HKTabBarModel) {
        self.init(frame: CGRect.zero)
        showsTouchWhenHighlighted = false
        adjustsImageWhenHighlighted = false
        imageView?.contentMode = .center
        imageView?.layer.masksToBounds = false
        
        distance = item.distance
        mini_x_Coef = item.mini_x_Coef
        mini_y_Coef = item.mini_y_Coef
        setImage(imageName: item.imageName!)
        title = item.title
        textLabel.text = title
        
        addSubview(imageView_big)
        addSubview(imageView_mini)
        addSubview(textLabel)
        addPan()
    }
    
    func updateState(){
        imageView_big.image = self.isSelected ? bigImage_select : bigImage_normal
        imageView_mini.image = self.isSelected ? miniImage_select : miniImage_normal
        textLabel.textColor = self.isSelected ? UIColor(displayP3Red: 104/255.0, green: 185/255.0, blue: 249/255.0, alpha: 1) : UIColor.gray

        guard self.isSelected else {
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.imageView_big.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            self.imageView_mini.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.imageView_big.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.imageView_mini.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    ///设置图片
    public func setImage(imageName: String) {

        bigImage_normal = UIImage(named: "big_" + imageName + "_normal")
        bigImage_select = UIImage(named: "big_" + imageName + "_select")
        miniImage_normal = UIImage(named: "mini_" + imageName + "_normal")
        miniImage_select = UIImage(named: "mini_" + imageName + "_select")
        imageView_big.image = bigImage_normal
        imageView_mini.image = miniImage_normal
    }
    
    
    private func addPan() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        self.addGestureRecognizer(pan)
    }
    
    @objc  func panGesture(_ pan: UIPanGestureRecognizer) {
        var point = pan.location(in: self)
        point = CGPoint(x: point.x - bounds.size.width * 0.5, y:  point.y - bounds.size.height * 0.5)
        if pan.state == .began || pan.state == .changed {
            let X = point.x
            let Y = point.y
            let R = sqrt(pow(X , 2) + pow(Y , 2))
            let scale = R / distance
            self.dragButton_x = X / scale
            self.dragButton_y = Y / scale
            
        } else if pan.state == .cancelled || pan.state == .failed || pan.state == .ended {
            self.dragButton_y = 0
            self.dragButton_x = 0
            UIView.animate(withDuration: 0.3) {
                self.imageView_big.frame = CGRect(x: 0.0 , y: 0.0, width: self.itemW, height: self.itemH - 15.0)
                self.imageView_mini.frame = CGRect(x: 0.0 , y: 0.0, width: self.itemW, height: self.itemH - 15.0)
            }
            return
        }
        dragIcon()
    }
    
    private func dragIcon() {
        let x =  (bounds.size.width - imageView_big.bounds.size.width) * 0.5 + dragButton_x
        let y =  (bounds.size.height - imageView_big.bounds.size.height) * 0.5 + dragButton_y
        
        self.imageView_big.frame = CGRect(x: x,
                                          y: y,
                                          width: self.imageView_big.bounds.size.width,
                                          height: self.imageView_big.bounds.size.height
        )
        
        self.imageView_mini.frame = CGRect(x: x + self.dragButton_x * mini_x_Coef,
                                           y: y + self.dragButton_y * mini_y_Coef,
                                           width: self.imageView_big.bounds.size.width,
                                           height: self.imageView_big.bounds.size.height
        )
    }
    
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: itemH - 20, width: itemW, height: 20)
    }
    
}






