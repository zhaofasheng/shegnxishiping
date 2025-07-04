//
//  NoticeSupplyProController.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeSupplyProController: NoticeBaseCellController {

    @objc public var getL :UILabel?
    @objc public var startBtn :UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
        self.navBarView.isHidden = false
        
        self.navBarView.backButton.setImage(UIImage.init(named: "Image_blackBack"), for: .normal)
        self.view.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.tableView.backgroundColor = self.view.backgroundColor;
        self.navBarView.titleL.text = "申请开通店铺"
        self.navBarView.titleL.textColor = UIColor.init(hexString: "#25262E");
        
        self.tableView.frame = CGRect(x: 0, y:NoticeSwiftFile.NAVHEIGHT(), width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT())
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height+60))
        self.tableView.tableHeaderView = view
        
        let imageView = UIImageView.init(frame: CGRect(x: (NoticeSwiftFile.screenWidth-335)/2, y:20, width: 335, height: 417))
        imageView.image = UIImage.init(named: "Image_shopliuc")
        view.addSubview(imageView)
        
        self.startBtn = UIButton.init(frame: CGRect(x: 68, y: imageView.frame.size.height+30+imageView.frame.origin.y+30, width: NoticeSwiftFile.screenWidth-68*2, height: 50))
        self.startBtn?.layer.cornerRadius = 25
        self.startBtn?.layer.masksToBounds = true
        self.startBtn?.backgroundColor = UIColor.init(hexString: "#0099E6")
        view.addSubview(self.startBtn!)
        self.startBtn?.setTitle("申请", for: .normal)
        self.startBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.startBtn?.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
        self.startBtn?.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        
//        self.getL = UILabel.init(frame: CGRect(x: 0, y: self.startBtn!.frame.size.height+self.startBtn!.frame.origin.y, width: NoticeSwiftFile.screenWidth, height: 40))
//        self.getL?.font = UIFont.systemFont(ofSize: 14)
//        self.getL?.textColor = UIColor.init(hexString: "#8A8F99")
//        self.getL?.attributedText = DDHAttributedMode.setColorString("*申请即同意《咨询开店服务协议》", setColor: UIColor.init(hexString: "#0099E6"), setLengthString: "《咨询开店服务协议》", beginSize: 6)
//        self.getL?.textAlignment = NSTextAlignment.center
//        view.addSubview(self.getL!)
//        self.getL?.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(proTap))
        self.getL?.addGestureRecognizer(tap)
    }
    
    @objc func proTap(){

    }
    
    @objc func nextClick(){
        let ctl = NoticeSupplyOpenShopController()
        self.navigationController?.pushViewController(ctl, animated: true)
    }


}
