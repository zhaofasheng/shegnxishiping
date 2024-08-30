//
//  NoticeSendVoiceTools.swift
//  NoticeXi
//
//  Created by li lei on 2023/7/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeSendVoiceTools: UIView {

    @objc public var imgButton = FSCustomButton()
    @objc public var topicButton = FSCustomButton()
    @objc public var bgmButton = FSCustomButton()
    @objc public var shareButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        

        self.imgButton.frame = CGRect(x: 15, y: 13, width: 24, height: 24)
        self.imgButton.setImage(UIImage(named: "senimgv_img"), for: .normal)
        self.addSubview(self.imgButton)
        
        let label = UILabel(frame: CGRect(x: 40, y: 0, width: NoticeSwiftFile.screenWidth-40-15, height: frame.size.height))
        label.text = "*以店主身份匿名发布"
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(hexString: "#5C5F66")
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
