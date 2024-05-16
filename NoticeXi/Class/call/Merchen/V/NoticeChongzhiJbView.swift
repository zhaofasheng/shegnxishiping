//
//  NoticeChongzhiJbView.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/5.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeChongzhiJbView: UIView {

    @objc public var titleL :UILabel?
    @objc public var moneyL :UILabel?
    @objc public var markL :UILabel?
    @objc public var allL :UILabel?
    @objc public var payJBView :NoticePayjbView?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        
        let imageView = UIImageView.init(frame: CGRect(x: 20, y: 8, width: NoticeSwiftFile.screenWidth-40, height: (NoticeSwiftFile.screenWidth-40)*144/335))
        imageView.image = UIImage(named: "sx_myjingbiall")
        self.addSubview(imageView)
        
        self.titleL = UILabel.init(frame: CGRect(x: 24, y: 32, width: NoticeSwiftFile.screenWidth-24-40, height: 20))
        self.titleL?.textColor = UIColor.init(hexString: "#5C5F66")
        self.titleL?.font = UIFont.systemFont(ofSize: 14)
        self.titleL?.text = "鲸币余额"
        imageView.addSubview(self.titleL!)
        
        self.moneyL = UILabel.init(frame: CGRect(x: 24, y: 72, width: NoticeSwiftFile.screenWidth-80, height:26))
        self.moneyL?.textColor = UIColor.init(hexString: "#14151A")
        self.moneyL?.font = UIFont.init(name: "PingFangSC-Medium", size: 26)
        imageView.addSubview(self.moneyL!)
        
        self.markL = UILabel.init(frame: CGRect(x: 20, y: CGRectGetMaxY(imageView.frame)+25, width: NoticeSwiftFile.screenWidth-80, height:20))
        self.markL?.textColor = UIColor.init(hexString: "#14151A")
        self.markL?.text = "鲸币充值"
        self.markL?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.markL!)
 
        self.payJBView = NoticePayjbView.init(frame: CGRect(x: 0, y: CGRectGetMaxY(self.markL!.frame)+10, width: NoticeSwiftFile.screenWidth, height: 292))
        self.addSubview(self.payJBView!)
        
        self.allL = UILabel.init(frame: CGRect(x: 20, y: (self.payJBView?.frame.origin.y ?? 0)+292+20, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.getSwiftTextHeight(str: "说明：\n1.充值鲸币，不支持提现\n2.充值24小时未到账，请联系声昔客服小二", width: NoticeSwiftFile.screenWidth-40, font: 14)))
        self.allL?.textColor = UIColor.init(hexString: "#5C5F66")
        self.allL?.font = UIFont.systemFont(ofSize: 14)
        self.allL?.numberOfLines = 0
        self.allL?.text = "说明：\n1.充值鲸币，不支持提现\n2.充值24小时未到账，请联系声昔客服小二"
        self.addSubview(self.allL!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
