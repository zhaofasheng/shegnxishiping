//
//  NoticeShouRuShopController.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/4.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShouRuShopController: NoticeBaseCellController {

    @objc public var headerView :NoticeShopSRHeadeerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.view.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        
        self.headerView = NoticeShopSRHeadeerView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: 584))
        self.tableView.tableHeaderView = self.headerView
        self.headerView?.frame = CGRectMake(0, 0, NoticeSwiftFile.screenWidth, CGRectGetMaxY(self.headerView!.tixianBtn!.frame)+30)
        self.tableView.reloadData()
        
        let proStr = "说明：\n1.提现额度：单笔提现最少不少于5元，最多不大于1000元\n2.提现时间：一般T+3个工作日\n4.实名认证：每个实名认证账号只可绑定一个声昔账号"
        let height = NoticeTools.getSpaceLabelHeight(proStr, with: UIFont.systemFont(ofSize: 14), withWidth: NoticeSwiftFile.screenWidth-40)
        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: height+30))
        footView.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        let label = UILabel.init(frame: CGRect(x: 20, y: 0, width: NoticeSwiftFile.screenWidth-40, height: height))
        label.textColor = UIColor.init(hexString: "#25262E")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.attributedText = NoticeTools.setLabelSpacewithValue(proStr, with: UIFont.systemFont(ofSize: 14))
        footView.addSubview(label)
        
        self.tableView.tableFooterView = footView
        
        self.navBarView.titleL.text = "收益"
        self.navBarView.needDetailButton = true
        self.navBarView.rightL.text = "提现记录"
        self.navBarView.rightTapBlock = {(righttap:Bool) in
            let ctl = NoticeShopChangeRecoderController();
            ctl.isJusttix = true
            self.navigationController?.pushViewController(ctl, animated: true)
        }
    }
}
