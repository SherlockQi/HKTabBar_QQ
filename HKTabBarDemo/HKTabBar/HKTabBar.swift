//
//  HKTabBar.swift
//  TABDemo
//
//  Created by Heikki on 2019/2/18.
//  Copyright © 2019年 Heikki. All rights reserved.
//

import UIKit

protocol HKTabBarDelegate : NSObjectProtocol {
    func hk_tabBar(_ tabBar: HKTabBar, didSelect item: HKDragButton ,index: Int)
}

class HKTabBar: UITabBar {

    static let TAG_BASE = 3000
    
    weak open var hk_delegate: HKTabBarDelegate?
    private var selectItem: HKDragButton?
    private var tabBarModels:[HKTabBarModel]?
    private var hk_itmes:[HKDragButton]? = [HKDragButton]()

    private var selectHandler: ((_ item: HKDragButton? , _ index: Int) -> ())?
   
    @objc private func itemDidClick(item: HKDragButton){
        guard item != selectItem else {
            return
        }
        selectItem?.isSelected = false
        selectItem?.updateState()
        selectItem = item
        selectItem?.isSelected = true
        selectItem?.updateState()
        
        if hk_delegate != nil {
            hk_delegate?.hk_tabBar(self, didSelect: item, index: item.tag - 3000)
        }else{
            selectHandler?(item , item.tag - 3000)
        }
    }
    
    convenience init(items:[HKTabBarModel], selectHandler: @escaping (_ item: HKDragButton? , _ index: Int) -> ()) {
        self.init(frame: CGRect.zero)
        self.tabBarModels = items
        self.selectHandler = selectHandler
        setItem()
    }
    convenience init(items:[HKTabBarModel]) {
        self.init(frame: CGRect.zero)
        self.tabBarModels = items
        setItem()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setItem(){

        guard tabBarModels != nil else {
            return
        }
        
        for i in 0 ..< tabBarModels!.count {

            let button = HKDragButton(item: tabBarModels![i])
            button.tag = HKTabBar.TAG_BASE + i

            button.addTarget(self, action: #selector(itemDidClick(item:)), for: .touchUpInside)
            addSubview(button)
            hk_itmes?.append(button)
        }
        
        hk_itmes?.first?.isSelected = true
        selectItem = hk_itmes?.first
        selectItem?.updateState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard tabBarModels != nil else {
            return
        }
        
        guard hk_itmes?.count != 0 else {
            return
        }

        for i in 0 ..< hk_itmes!.count {
            let count = CGFloat(hk_itmes!.count)
            let x = bounds.size.width * CGFloat(i) / count
            hk_itmes![i].frame = CGRect(x: x, y: 0, width: bounds.size.width / count, height: bounds.size.height);
        }

        self.subviews.forEach { (sbv) in
            if sbv .isKind(of: NSClassFromString("UITabBarButton").self!){
                sbv.removeFromSuperview()
            }
        }
    }
}


