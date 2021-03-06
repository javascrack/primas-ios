//
//  SegmentView.swift
//  Primas
//
//  Created by wang on 14/07/2017.
//  Copyright © 2017 wang. All rights reserved.
//

import UIKit
import SnapKit

class SegmentView: UIView {

    enum SegmentViewStyle: Int {
      case single = 1
      case subtitle
    }

    enum ItemIndex: Int {
      case left, right
    }

    var style: SegmentViewStyle = .single
    var currentActive: ItemIndex = .left {
      didSet {
        switch currentActive {
          case .left:
            setActiveStyle(.left)
          case .right:
            setActiveStyle(.right)
        }
      }
    }

    var width: CGFloat = 0
    var height: CGFloat = 0
    var padding: CGFloat = 0

    var activeColor = PrimasColor.shared.main.red_font_color
    var normalColor = PrimasColor.shared.main.light_font_color

    let leftContainer: UIView = UIView()
    let rightContainer: UIView = UIView()

    let leftTitleLabel: UILabel = {
      return ViewTool.generateLabel("", 16.0, PrimasColor.shared.main.light_font_color)
    }()

    let rightTitleLabel: UILabel = {
      return ViewTool.generateLabel("", 16.0, PrimasColor.shared.main.light_font_color)
    }()

    var leftSubTitleLabel: UILabel = {
      let _label = ViewTool.generateLabel("", 12.0, PrimasColor.shared.main.light_font_color)
      _label.font = primasNumberFont(12.0)
      return _label
    }()

    var rightSubTitleLabel: UILabel = {
      let _label = ViewTool.generateLabel("", 12.0, PrimasColor.shared.main.light_font_color)
      _label.font = primasNumberFont(12.0)
      return _label
    }()

    var leftActiveLine: UIView = {
      return ViewTool.generateLine(PrimasColor.shared.main.red_font_color, 1.0)
    }()

    var rightActiveLine: UIView = {
      return ViewTool.generateLine(PrimasColor.shared.main.red_font_color, 1.0)
    }()

    let bottomLine: UIView = {
      return ViewTool.generateLine(PrimasColor.shared.main.line_background_color)
    }()

    init(style: SegmentView.SegmentViewStyle, width: CGFloat? = SCREEN_WIDTH, height: CGFloat? = 50.0, padding: CGFloat? = SIDE_MARGIN) {
      super.init(frame: CGRect(x: 0, y: 0, width: width!, height: height!))
      self.style = style
      self.width = width!
      self.height = height!
      self.padding = padding!

    }

    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    func setup() {
      self.addSubview(leftContainer)
      self.addSubview(rightContainer)

      leftContainer.addSubview(leftTitleLabel)
      leftContainer.addSubview(leftActiveLine)

      rightContainer.addSubview(rightTitleLabel)
      rightContainer.addSubview(rightActiveLine)

      self.addSubview(bottomLine)

      if self.style == .subtitle {
        leftContainer.addSubview(leftSubTitleLabel)
        rightContainer.addSubview(rightSubTitleLabel)
      }

      setupLayout()
        
      addEvent()
    }

    func setupLayout() {
      bottomLine.snp.makeConstraints {
        make in 
        make.left.right.bottom.equalTo(self)
      }

      leftContainer.snp.makeConstraints {
        make in 
        make.left.equalTo(self).offset(self.padding)
        make.size.width.equalTo((self.width - padding * 2) / 2)
        make.top.bottom.equalTo(self)
      }

      leftActiveLine.snp.makeConstraints {
        make in 
        make.left.right.equalTo(leftContainer)
        make.bottom.equalTo(leftContainer.snp.bottom).offset(-0.5)
      }

      rightContainer.snp.makeConstraints {
        make in 
        make.left.equalTo(leftContainer.snp.right)
        make.right.equalTo(self).offset(-self.padding)
        make.top.bottom.equalTo(self)
      }

      rightActiveLine.snp.makeConstraints {
        make in 
        make.left.right.equalTo(rightContainer)
        make.bottom.equalTo(rightContainer.snp.bottom).offset(-0.5)
      }

      if self.style == SegmentViewStyle.single {
        leftTitleLabel.snp.makeConstraints {
          make in 
          make.center.equalTo(leftContainer)
        }

        rightTitleLabel.snp.makeConstraints {
          make in 
          make.center.equalTo(rightContainer)
        }
      } else {
        
        leftTitleLabel.snp.makeConstraints {
          make in 
          make.centerX.equalTo(leftContainer).offset(-leftSubTitleLabel.intrinsicContentSize.width / 2.0 - 2.5)
          make.centerY.equalTo(leftContainer)
        }

        leftSubTitleLabel.snp.makeConstraints {
          make in 
          make.left.equalTo(leftTitleLabel.snp.right).offset(5)
          make.bottom.equalTo(leftTitleLabel)
        }

        rightTitleLabel.snp.makeConstraints {
          make in 
          make.centerX.equalTo(rightContainer).offset(-rightSubTitleLabel.intrinsicContentSize.width / 2.0 - 2.5)
          make.centerY.equalTo(rightContainer)
        }

        rightSubTitleLabel.snp.makeConstraints {
          make in 
          make.left.equalTo(rightTitleLabel.snp.right).offset(5)
          make.bottom.equalTo(rightTitleLabel)
        }
      }
    }

    func bind(leftTitle: String, rightTitle: String, _ leftSubTitle: String? = "", _ rightSubTitle: String? = "") {
      leftTitleLabel.text = leftTitle
      rightTitleLabel.text = rightTitle
      leftSubTitleLabel.text = leftSubTitle
      rightSubTitleLabel.text = rightSubTitle
      
      self.currentActive = .left
      setup()
    }

    func addEvent() {
        leftContainer.isUserInteractionEnabled = true
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftTaped))
        leftTap.numberOfTapsRequired = 1
        leftContainer.addGestureRecognizer(leftTap)
        
        rightContainer.isUserInteractionEnabled = true
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightTaped))
        rightTap.numberOfTapsRequired = 1
        rightContainer.addGestureRecognizer(rightTap)
    }
    
    func leftTaped() {
        self.currentActive = .left
    }
    
    func rightTaped() {
        self.currentActive = .right
    }

    func setActiveStyle(_ item: ItemIndex) {
      switch item {
        case .left:
          leftTitleLabel.textColor = self.activeColor
          leftSubTitleLabel.textColor = self.activeColor
          leftActiveLine.backgroundColor = self.activeColor

          rightTitleLabel.textColor = self.normalColor
          rightSubTitleLabel.textColor = self.normalColor
          rightActiveLine.backgroundColor = UIColor.clear
        case .right:
          leftTitleLabel.textColor = self.normalColor
          leftSubTitleLabel.textColor = self.normalColor
          leftActiveLine.backgroundColor = UIColor.clear

          rightTitleLabel.textColor = self.activeColor
          rightSubTitleLabel.textColor = self.activeColor
          rightActiveLine.backgroundColor = self.activeColor
      }
    }

}
