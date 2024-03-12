//
//  NoticeVipLelveCell.swift
//  NoticeXi
//
//  Created by li lei on 2023/8/30.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeVipLelveCell: BaseCell {

    public var index = 0
    var leleImageView :UIImageView?
    var leveMarkL :UILabel?
    var titleL :UILabel?
    var currentL :UILabel?
    var backProView :UIView?
    var currentProView :UIView?
    var titleL1 :UILabel?
    @objc public var upBlock :((_ up :Bool) ->Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.contentView.backgroundColor = self.backgroundColor
        
        self.leleImageView = UIImageView(frame: CGRect(x: 40, y: 0, width: NoticeSwiftFile.screenWidth-100, height: NoticeSwiftFile.screenWidth-100))
        self.leleImageView?.backgroundColor = UIColor(hexString: "#DFE0E5")
        self.leleImageView?.setAllCorner(20)
        self.contentView.addSubview(self.leleImageView!)
        
        self.leveMarkL = UILabel.init(frame: CGRect(x: 0, y: 0, width: 78, height: 32))
        self.leveMarkL?.textAlignment = NSTextAlignment.center
        self.leveMarkL?.font = UIFont.systemFont(ofSize: 13)
        self.leveMarkL?.setTopleftAndbottomRightCorner(20)
        self.leleImageView?.addSubview(self.leveMarkL!)
        
        self.titleL = UILabel.init(frame: CGRect(x: 0, y: 15, width: NoticeSwiftFile.screenWidth-100, height: 17))
        self.titleL?.textAlignment = NSTextAlignment.center
        self.titleL?.font = UIFont.systemFont(ofSize: 12)
        self.titleL?.textColor = UIColor(hexString: "#5C5F66")
        self.leleImageView?.addSubview(self.titleL!)
        
        self.currentL = UILabel.init(frame: CGRect(x: 30, y: NoticeSwiftFile.screenWidth-100-60, width: NoticeSwiftFile.screenWidth-100-30, height: 17))
        self.currentL?.font = UIFont.systemFont(ofSize: 12)
        self.currentL?.textColor = UIColor(hexString: "#5C5F66")
        self.leleImageView?.addSubview(self.currentL!)
        
        self.backProView = UIView(frame: CGRect(x: 30, y: CGRectGetMaxY(self.currentL!.frame)+7, width: NoticeSwiftFile.screenWidth-100-60, height: 8))
        self.backProView?.backgroundColor = UIColor(hexString: "#25262E")?.withAlphaComponent(0.2)
        self.backProView?.setAllCorner(4)
        self.leleImageView?.addSubview(self.backProView!)
        
        self.currentProView = UIView(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth-100-60, height: 8))
        self.currentProView?.backgroundColor = UIColor(hexString: "#25262E")
        self.currentProView?.setAllCorner(4)
        self.backProView?.addSubview(self.currentProView!)
        
        self.titleL1 = UILabel.init(frame: CGRect(x: 30, y:  NoticeSwiftFile.screenWidth-100-60, width: NoticeSwiftFile.screenWidth-100, height: 22))
        self.titleL1?.font = UIFont.systemFont(ofSize: 16)
        self.titleL1?.textColor = UIColor(hexString: "#25262E")
        self.leleImageView?.addSubview(self.titleL1!)
        self.titleL1?.isHidden = true
        
        self.leleImageView?.isUserInteractionEnabled = true
        self.currentL?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action:#selector(upVipTap))
        self.currentL?.addGestureRecognizer(tap)
    }
    
    @objc public func upVipTap(){
        self.upBlock?(true)
    }

    public func refreshCellWith(userM:NoticeUserInfoModel?){
     
        self.leleImageView?.image = UIImage.init(named: String(format: "vip_img_%d", self.index))
        
        let currentPoints = ((Int)(userM?.points ?? "0") ?? 0)//当前发电值
        let currentLevel = ((Int)(userM?.level ?? "0") ?? 0)//当前等级
        
        self.leveMarkL?.isHidden = true
        
        if self.index == 0{
            self.titleL?.text = ""
        }else{
   
            if NoticeTools.getLocalType() == 1{
                self.titleL?.text = String(format:" %d Support-Point to Lv%d", self.index*10,self.index)
            }else if NoticeTools.getLocalType() == 2{
                self.titleL?.text = String(format:" %d発電ポイントでLv%d解放", self.index*10,self.index)
            }else{
                self.titleL?.text = String(format:" %d发电值解锁Lv%d", self.index*10,self.index)
            }
        }
        
        self.backProView?.isHidden = false
        
        self.currentL?.textColor = UIColor(hexString: "#5C5F66")
        self.backProView?.backgroundColor = UIColor(hexString: "#25262E")?.withAlphaComponent(0.2)
        self.currentProView?.backgroundColor = UIColor(hexString: "#25262E")
        
        if self.index >= 22 && currentLevel >= 22{//等级已经拉满
            self.backProView?.isHidden = true
            self.currentL?.text = NoticeTools.chinese("你已达到等级上限，感谢你让声昔走得更远", english: " Max level reached. Thank you!", japan: "レベルが最大に達しました!")
            self.currentL?.frame = CGRect(x: 30, y: NoticeSwiftFile.screenWidth-100-25-17, width: NoticeSwiftFile.screenWidth-100-30, height: 17)
        }else{
            self.backProView?.isHidden = false;
            self.currentL?.frame = CGRect(x: 30, y: NoticeSwiftFile.screenWidth-100-60, width: NoticeSwiftFile.screenWidth-100-30, height: 17)
            if currentLevel > self.index{//如果等级大余当前位置
                self.currentL?.text = NoticeTools.chinese("你已超过该等级", english: "You have exceeded this level.", japan: "このレベルを超えています")
                self.currentProView?.frame = CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth-100-60, height: 8)
            }else if currentLevel == self.index{//如果等级等于当前位置
                let allwidth = (CGFloat)(NoticeSwiftFile.screenWidth-100-60)
            
                self.currentProView?.frame = CGRect(x: 0, y: 0, width:Int(allwidth) * currentPoints / (self.index+1) / 10, height: 8)
                
                if NoticeTools.getLocalType() == 1{
                    self.currentL?.text = String(format:"Now %d， %d needed to lv%d", currentPoints,(self.index+1)*10 - currentPoints,self.index+1)
                }else if NoticeTools.getLocalType() == 2{
                    self.currentL?.text = String(format:"現在は%d，Lv%dには%dが必要", currentPoints,self.index+1,(self.index+1)*10 - currentPoints)
                }else{
                    self.currentL?.text = String(format:" 当前发电值%d，到Lv%d还需%d", currentPoints,self.index+1,(self.index+1)*10 - currentPoints)
                }
                
            }else if currentLevel < self.index{//如果等级小于当前位置
                if NoticeTools.getLocalType() == 1{
                    self.currentL?.text = String(format:"Now %d， %d needed to lv%d", currentPoints,self.index*10 - currentPoints,self.index)
                }else if NoticeTools.getLocalType() == 2{
                    self.currentL?.text = String(format:"現在は%d，Lv%dには%dが必要", currentPoints,self.index,self.index*10 - currentPoints)
                }else{
                    self.currentL?.text = String(format:" 当前发电值%d，到Lv%d还需%d", currentPoints,self.index,self.index*10 - currentPoints)
                }
                if(self.index > 0){
                    let allwidth = CGFloat(NoticeSwiftFile.screenWidth-100-60)
                    self.currentProView?.frame = CGRect(x: 0, y: 0, width:Int(allwidth) * currentPoints / self.index / 10, height: 8)
                }
            }
        }
        
        if self.index >= 22 {
            self.currentL?.textColor = UIColor(hexString: "#FFD2E3")
            self.currentProView?.backgroundColor = UIColor(hexString: "#FFD2E3")
            self.backProView?.backgroundColor = UIColor(hexString: "#FFD2E3")?.withAlphaComponent(0.2)
        }
        
        self.currentL?.isUserInteractionEnabled = false
        self.titleL1?.isHidden = true
        if (Int)(userM?.level ?? "0") == self.index {//如果当前等级等于当前位置，就是当前等级
            self.leveMarkL?.text = NoticeTools.getLocalStr(with: "zb.current")
            self.leveMarkL?.backgroundColor = UIColor(hexString: "#000000")?.withAlphaComponent(0.2)
            self.leveMarkL?.textColor = UIColor(hexString: "#FFFFFF")
            self.leveMarkL?.isHidden = false
            
            if ((userM?.isSendVip) != nil) {//体验版的会员
                if userM?.isSendVip == true{
                    self.currentL?.isUserInteractionEnabled = true
                    self.leveMarkL?.text = NoticeTools.chinese("体验版", english: "Limited", japan: "体験版")
                    self.titleL1?.isHidden = false
                    
                    if ((userM?.isTodayExpire) != nil) {
                        if userM?.isTodayExpire == true{
                            userM?.overDays = "0"
                        }
                    }
                    if (NoticeTools.getLocalType() == 1){
                        self.titleL1?.text = String(format: "Exp in %@ days", userM?.overDays ?? "0")
                    }else if (NoticeTools.getLocalType() == 2){
                        self.titleL1?.text = String(format: "有効期限 %@ 日", userM?.overDays ?? "0")
                    }else{
                        self.titleL1?.text = String(format: "你的会员 %@ 天后到期", userM?.overDays ?? "0")
                    }
                    
                    let str1 = NoticeTools.chinese("解锁永久VIP>", english: "Go Pro", japan: "期限を解除")
                    var str2 = String(format: "%@到期 ", userM?.expirationTimeYmd ?? "")
                    if (NoticeTools.getLocalType() == 1){
                        str2 = String(format: "Exp %@ ", userM?.expirationTimeYmd ?? "")
                    }else if (NoticeTools.getLocalType() == 2){
                        str2 = String(format: "期限%@ ", userM?.expirationTimeYmd ?? "")
                    }
                    
                    self.currentL?.frame = CGRect(x: 30, y: NoticeSwiftFile.screenWidth-100-25-10, width: NoticeSwiftFile.screenWidth-100-30, height: 17)
                    self.currentL?.attributedText = DDHAttributedMode.setColorString(str2+str1, setColor: UIColor.white, setLengthString: str1, beginSize: str2.count)
                    self.backProView?.isHidden = true
                }
            }
            
        }else if ((Int)(userM?.level ?? "0") ?? 0 < self.index){//如果当前等级小于当前位置，则代表未解锁
            self.leveMarkL?.text = NoticeTools.chinese("未解锁", english: "Locked", japan: "ロック")
            self.leveMarkL?.backgroundColor = UIColor(hexString: "#000000")?.withAlphaComponent(1)
            self.leveMarkL?.textColor = UIColor(hexString: "#FFFFFF")
            self.leveMarkL?.isHidden = false
        }
        
        if((Int)(userM?.level ?? "0") ?? 0) == 0{//等级为零
            self.currentProView?.frame = CGRect(x: 0, y: 0, width: 0, height: 8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
