//
//  NoticeLeaderScrollView.swift
//  NoticeXi
//
//  Created by li lei on 2023/10/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeLeaderScrollView: UIView,UIScrollViewDelegate {

    @objc public var ImageView = UIImageView()
    var scrollView = UIScrollView()
    var nextButton = UIButton()
    var currentPage = 0
    var pageControl = UIPageControl(frame: CGRect(x:20, y: NoticeOcToSwift.devoiceHeight()-NoticeOcToSwift.devoiceBottomHeight()-20-35-30, width: NoticeOcToSwift.devoiceWidth()-40, height: 30))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.isUserInteractionEnabled = true
        //Img_leads0
        self.ImageView.frame = CGRect(x: 0, y: 0, width: 280, height: 320)
        self.ImageView.center = self.center
        self.ImageView.image = UIImage(named: "Img_leads0")
        self.addSubview(self.ImageView)
        self.ImageView.isUserInteractionEnabled = true
        
        let startBtn = UIButton(frame: CGRect(x: 60, y: 260, width: 160, height: 40))
        startBtn.backgroundColor = UIColor(hexString: "#25262E")
        startBtn.setAllCorner(20)
        startBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        startBtn.setTitleColor(UIColor.white, for: .normal)
        startBtn.setTitle("开始阅读", for: .normal)
        self.ImageView.addSubview(startBtn)
        startBtn.addTarget(self, action: #selector(startClick), for: .touchUpInside)
        
        let closeBtn = UIButton(frame: CGRect(x: 280-35, y: 0, width: 35, height: 35))
        closeBtn.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.ImageView.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        
        self.scrollView.frame = CGRect(x: 0, y: 0, width: NoticeOcToSwift.devoiceWidth(), height: NoticeOcToSwift.devoiceHeight())
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize(width: NoticeOcToSwift.devoiceWidth()*6, height: NoticeOcToSwift.devoiceHeight())
        self.addSubview(self.scrollView)
        self.scrollView.delegate = self
        self.scrollView.isHidden = true
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.bounces = false
      
        let textArr = ["“电话亭”：付费聊天功能(部分店铺可以免费试聊)，可语音连麦或文字聊天。满足条件后可开设自己的店铺",
                       "滑动观看更多店铺，点击「星星」可查看店铺更多信息；【流星电话】随机匹配有缘人",
                       "心情评论分为“留言和悄悄话”。“留言”是公开大家可见的，“悄悄话”是私密仅双方可见的",
                       "可选择发布内容：心情、播客投稿、求助帖。语音心情最长5分钟，播客不限时长",
                       "“播客页”包含播客、每日一阅、声昔小社团、求助帖、配音、文章、新手指南等功能",
                       "“我的”包含自己发布的内容、消息通知、VIP相关功能。有疑问请联系「客服」"]
        for i in 0...5{
            let leadImageV = UIImageView(frame: CGRect(x: NoticeOcToSwift.devoiceWidth() * CGFloat(i), y: 0, width: NoticeOcToSwift.devoiceWidth(), height: NoticeOcToSwift.devoiceHeight()))
            leadImageV.image = UIImage(named: String(format: "Img_leads%d", i+1))
            self.scrollView.addSubview(leadImageV)
            leadImageV.contentMode = ContentMode.scaleAspectFill
            leadImageV.clipsToBounds = true
            leadImageV.isUserInteractionEnabled = true
            
            var attHeight = NoticeTools.spaceHeight(textArr[i], with: UIFont.systemFont(ofSize: 14), withWidth: NoticeOcToSwift.devoiceWidth()-40)
            
            let label = UILabel(frame: CGRect(x: 20, y: NoticeOcToSwift.devoiceHeight()-NoticeOcToSwift.devoiceBottomHeight()-20-35-40-attHeight, width: NoticeOcToSwift.devoiceWidth()-40, height: attHeight))
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.white
            label.numberOfLines = 0
            leadImageV.addSubview(label)
            label.attributedText = NoticeTools.setAttstrValue(textArr[i], with: UIFont.systemFont(ofSize: 14))
            
        }
        
        self.nextButton.frame = CGRect(x:(NoticeOcToSwift.devoiceWidth()-138)/2, y: NoticeOcToSwift.devoiceHeight()-NoticeOcToSwift.devoiceBottomHeight()-20-35, width: 138, height: 35)
        self.nextButton.backgroundColor = UIColor(hexString: "#0099E6")
        self.nextButton.setAllCorner(35/2)
        self.nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.nextButton.setTitleColor(UIColor.white, for: .normal)
        self.nextButton.setTitle("下一页", for: .normal)
        self.addSubview(self.nextButton)
        self.nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        self.nextButton.isHidden = true
        
        self.pageControl.numberOfPages = textArr.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.white.withAlphaComponent(0.3)
        self.pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.addSubview(pageControl)
        self.pageControl.isHidden = true
        self.pageControl.isUserInteractionEnabled = false
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var index = scrollView.contentOffset.x/scrollView.bounds.size.width
        currentPage = Int(index)
        self.pageControl.currentPage = currentPage
        if currentPage == 5{
            self.nextButton.setTitle("开始使用", for: .normal)
        }else{
            self.nextButton.setTitle("下一页", for: .normal)
        }
        
    }
    
    @objc func nextClick(){
        if currentPage == 5 {
            self.closeClick()
            return
        }
        
        currentPage+=1
        self.scrollView.setContentOffset(CGPoint(x: NoticeOcToSwift.devoiceWidth()*CGFloat(currentPage), y: 0), animated: true)
        if currentPage == 5{
            self.nextButton.setTitle("开始使用", for: .normal)
        }else{
            self.nextButton.setTitle("下一页", for: .normal)
        }
        self.pageControl.currentPage = currentPage
    }
    
    @objc func startClick(){
        self.ImageView.isHidden = true
        self.scrollView.isHidden = false
        self.nextButton.isHidden = false
        self.pageControl.isHidden = false
    }
    
    @objc func closeClick(){
        NoticeTools.setMarkForLeader()
        self.removeFromSuperview()
    }
    
    @objc public func showView(){
        let window = UIApplication.shared.keyWindow;
        window!.addSubview(self);
        self.ImageView.layer.position = self.center
        self.ImageView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        UIView .animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:AnimationOptions.curveLinear, animations: {
            self.ImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (finished:Bool) in

        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
