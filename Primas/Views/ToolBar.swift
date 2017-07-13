//
//  ToolBar.swift
//  Primas
//
//  Created by wang on 06/07/2017.
//  Copyright © 2017 wang. All rights reserved.
//

import UIKit
import SnapKit
import Foundation
import SwiftIconFont

class ToolBar: UIToolbar {
    
    enum ItemType: Int {
      case popular = 1
      case group, pen, value, myself
    }

    var fixedItems: [UIBarButtonItem] = []

    static let itemColor: UIColor = PrimasColor.shared.main.home_tool_bar_item_color
    static let itemSize: CGFloat = 20.0

    static func makeButtonItem(_ code: String, _ title: String, size: CGFloat? = ToolBar.itemSize) -> UIBarButtonItem {
      let _view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
      let _icon = UILabel()
      let _title = UILabel()

      _view.addSubview(_icon)
      _view.addSubview(_title)

      _icon.text = code
      _icon.textColor = ToolBar.itemColor
      _icon.font = UIFont.iconfont(ofSize: size!)

      _title.text = title
      _title.textColor = ToolBar.itemColor
      _title.font = UIFont.systemFont(ofSize: 10)
      
      _icon.snp.makeConstraints {
          make in
          make.top.equalTo(_view)
          make.centerX.equalTo(_view)
      }
      
      _title.snp.makeConstraints {
          make in
          make.centerX.equalTo(_view)
          make.bottom.equalTo(_view).offset(0)
      }
      
      let _bar = UIBarButtonItem(customView: _view)
      
      return _bar
    }
    
    static func makeActivedButtonItem(_ code: String, size: CGFloat? = 26.0) -> UIBarButtonItem {
    
      let _view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
      let _icon = UILabel()

      _view.addSubview(_icon)
      _view.backgroundColor = UIColor.red
      _view.clipsToBounds = true
      _view.layer.cornerRadius = 35.0 / 2

      _icon.text = code
      _icon.textColor = UIColor.white
      _icon.font = UIFont.iconfont(ofSize: size!)

      _icon.snp.makeConstraints {
        make in
        make.center.equalTo(_view)
      }

      let _bar = UIBarButtonItem(customView: _view)


      return _bar
    }
    
    let popular: UIBarButtonItem = {
        let _bar = ToolBar.makeButtonItem(Iconfont.popular.rawValue, "推荐")
        _bar.tag = ToolBar.ItemType.popular.rawValue
        return _bar
    }()
    
    let group: UIBarButtonItem = {
        let _bar = ToolBar.makeButtonItem(Iconfont.group.rawValue, "圈子")
        _bar.tag = ToolBar.ItemType.group.rawValue
        return _bar
    }()
    
    let pen: UIBarButtonItem = {
        let _bar = ToolBar.makeActivedButtonItem(Iconfont.pen.rawValue)
        _bar.tag = ToolBar.ItemType.pen.rawValue
        return _bar
    }()

    let value: UIBarButtonItem = {
        let _bar = ToolBar.makeButtonItem(Iconfont.value.rawValue, "贡献值")
        _bar.tag = ToolBar.ItemType.value.rawValue
        return _bar
    }()
    
    let myself: UIBarButtonItem = {
        let _bar = ToolBar.makeButtonItem(Iconfont.icon_self.rawValue, "我的")
        _bar.tag = ToolBar.ItemType.myself.rawValue
        return _bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let items = [popular, group, pen, value, myself]

        for item in items {
          item.customView?.isUserInteractionEnabled = true
          let tapRecongnizer = UITapGestureRecognizer(target: self, action: #selector(selectTaped))
          tapRecongnizer.numberOfTapsRequired = 1
          item.customView?.addGestureRecognizer(tapRecongnizer)
        }

        self.setItems(items, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func getItems() -> Array<UIBarButtonItem> {
      if fixedItems.count != 0 {
        return fixedItems
      }

      let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
      var arr = [flexible]

      for item in items! {


          arr.append(item)
          arr.append(flexible)
      }
        
      return arr
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 49
        return size
    }
    
    func selectTaped(gesture: UITapGestureRecognizer) {
        let _view = gesture.view!

        switch _view {
            case popular.customView!:
              toController(HomeViewController())
            case group.customView!:
              break;
            case pen.customView!:
              break;
            case value.customView!:
              toController(ValueViewController())
            case myself.customView!:
              toController(ProfileViewController())
            default:
              break;
        }

    }

}
