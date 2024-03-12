//
//  NoticeVipLelveView.swift
//  NoticeXi
//
//  Created by li lei on 2023/8/30.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeVipLelveView: UIView,UITableViewDataSource,UITableViewDelegate {

    var currentLelveL:UILabel?
    var tableView:UITableView?
    var userM:NoticeUserInfoModel?
    @objc public var upClickBlock :((_ up :Bool) ->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        self.currentLelveL = UILabel.init(frame: CGRect(x: 0, y: 20, width: NoticeOcToSwift.devoiceWidth(), height: 42))
        self.currentLelveL?.font = UIFont.systemFont(ofSize: 30)
        self.currentLelveL?.textColor = UIColor(hexString: "#25262E")
        self.currentLelveL?.textAlignment = NSTextAlignment.center
        self .addSubview(self.currentLelveL!)
        
        let titleL = UILabel.init(frame: CGRect(x: 0, y: CGRectGetMaxY(self.currentLelveL!.frame), width: NoticeOcToSwift.devoiceWidth(), height: 17))
        titleL.font = UIFont.systemFont(ofSize: 12)
        titleL.textColor = UIColor(hexString: "#8A8F99")
        titleL.textAlignment = NSTextAlignment.center
        titleL.text = NoticeTools.chinese("我的", english: "My ", japan: "私の") + NoticeTools.getLocalStr(with: "zb.fdz")
        self.addSubview(titleL)
        
        self.tableView = UITableView()
        self.tableView?.dataSource = self;
        self.tableView?.delegate = self;
        self.tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView?.rowHeight = NoticeSwiftFile.screenWidth-100+40
        self.tableView?.transform = CGAffineTransformMakeRotation(-Double.pi/2)
        self.tableView?.frame = CGRect(x: 0, y: 97, width:NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenWidth-100)
        self.tableView?.register(NoticeVipLelveCell.self, forCellReuseIdentifier: "vipCell")
        self.tableView?.showsVerticalScrollIndicator = false
        self.tableView?.showsHorizontalScrollIndicator = false
        self.tableView?.backgroundColor = self.backgroundColor

        //增加下面三句（高度预算），解决scrollToRowAtIndexPath 滚动到指定位置偏差不准确问题
        self.tableView?.estimatedRowHeight = 0;
        self.tableView?.estimatedSectionFooterHeight = 0;
        self.tableView?.estimatedSectionHeaderHeight = 0;
        
        self.addSubview(self.tableView!)
        
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth-100, height: 10))
        headerView.backgroundColor = self.backgroundColor
        self.tableView?.tableHeaderView = headerView;
        
        self.refreshData()
    }
    
    @objc public func refreshData(){
        self.userM = NoticeSaveModel.getUserInfo()
        self.currentLelveL?.text = self.userM?.points
        self.tableView?.reloadData()
        let currentLevel = ((Int)(self.userM?.level ?? "0") ?? 0)//当前等级
        let offestY = self.tableView!.rowHeight
        self.tableView?.setContentOffset(CGPointMake(0,CGFloat(currentLevel)*offestY), animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vipCell") as! NoticeVipLelveCell
        cell.transform = CGAffineTransformMakeRotation(Double.pi/2)
        cell.index = indexPath.row
        cell.refreshCellWith(userM: self.userM ?? nil)
        cell.upBlock = {[weak self] (up) in
            if up {
                self?.upClickBlock?(true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 23
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
