//
//  NoticeWorkedAlreadyController.swift
//  NoticeXi
//
//  Created by li lei on 2019/9/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeWorkedAlreadyController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @objc public var mangagerCode:String?
    @objc public var tableView:UITableView?
    var isDwon = true
    var lastId : String?
    var dataArr = [NoticeManagerJuBaoModel]()
    @objc public var type : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = NoticeOcToSwift.getBackColor()
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width:NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.BOTTOMHEIGHT()-58-NoticeSwiftFile.NAVHEIGHT()))
        self.tableView?.dataSource = self;
        self.tableView?.delegate = self;
        self.tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView?.rowHeight = 60.0
        self.tableView?.register(NoticeManagerWorkCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
        self.tableView?.backgroundColor = NoticeOcToSwift.getBackColor()
        self.creatRefresh()
        self.tableView?.mj_header.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(workedRequest), name: NSNotification.Name(rawValue:"worked"), object: nil)
    }
    
    @objc func workedRequest() {
        self.isDwon = true
        self.request()
    }
    
    /*请求数据*/
    func request() {
        
        var url = String(format: "admin/reports?confirmPasswd=%@&reportStatus=%@", self.mangagerCode!,self.type!)
        
        if self.isDwon {
            url = String(format: "admin/reports?confirmPasswd=%@&reportStatus=%@", self.mangagerCode!,self.type!)
        }else{
            url = String(format: "admin/reports?confirmPasswd=%@&reportStatus=%@&lastId=%@", self.mangagerCode!,self.type!,self.lastId ?? "")
        }
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: nil, isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.tableView?.mj_header.endRefreshing()
            self?.tableView?.mj_footer.endRefreshing()
            if success {
                
                let nsDict = dict! as NSDictionary
                guard (nsDict["data"] as? [NSDictionary]) != nil else {
                    //
                    return
                }
                
                if (self?.isDwon)! {
                    self?.isDwon = false
                    self?.dataArr .removeAll()
                }
                
                for dic in nsDict["data"] as! NSArray{
                    let model = NoticeManagerJuBaoModel.mj_object(withKeyValues: dic)
                    self?.dataArr.append(model!)
                }
                if (((self?.dataArr.count)!) > 0) {
                    let lastM = self?.dataArr[(self?.dataArr.count)!-1]
                    
                    self?.lastId = lastM?.jubaoId
                }
                self?.tableView?.reloadData()
            }
            
            }, fail: {[weak self] (error) in
                self?.tableView?.mj_header.endRefreshing()
                self?.tableView?.mj_footer.endRefreshing()
        })
    }
    
    /*创建刷新和加载更多*/
    func creatRefresh() {
        
        self.tableView?.mj_header = MJRefreshNormalHeader .init(refreshingBlock: { [weak self] in
            self?.isDwon = true
            self?.request()
        })
        self.tableView?.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {[weak self] in
            self?.isDwon = false
            self?.request()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NoticeManagerWorkCell
        cell.refreshData(model: self.dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1 = UITableViewRowAction.init(style: .normal, title:self.type == "2" ? "待调查" : "已处理") {[weak self] (action, indexPath) in
            self?.actionWith(row: indexPath.row, reportStatus: self!.type == "2" ? "0" : "2")
        }
        action1.backgroundColor = NoticeOcToSwift.getColorWith("#F67280")
        
        
        let action2 = UITableViewRowAction.init(style: .normal, title:self.type == "1" ? "待调查" : "待处理") {[weak self] (action, indexPath) in
            self?.actionWith(row: indexPath.row, reportStatus: self!.type == "1" ? "0" : "1")
        }
        action2.backgroundColor = NoticeOcToSwift.getColorWith("#CCCCCC")
        return [action1,action2]
    }
    
    func actionWith(row:NSInteger,reportStatus:String){
        let model = self.dataArr[row]
        
        let parm = NSMutableDictionary()
        parm.setObject(self.mangagerCode!, forKey: "confirmPasswd" as NSCopying)
        parm.setObject(reportStatus, forKey: "reportStatus" as NSCopying)
        DRNetWorking.shareInstance()?.request(withPatchPath: String(format: "admin/reports/%@", model.jubaoId), accept: nil, parmaer: parm, page: 0, success: { [weak self] (dict, success) in
            
            if success {
                self?.dataArr .remove(at: row)
                self?.tableView?.reloadData()
                self?.showToast(withText: reportStatus == "1" ? "已移到待处理" : (reportStatus == "2" ? "已移到已处理" : "已移到待调查"))
                if reportStatus == "0" {
                    NotificationCenter.default.post(name: NSNotification.Name("waitCheck"), object: nil, userInfo:nil)
                }else if reportStatus == "1" {
                    NotificationCenter.default.post(name: NSNotification.Name("waitWork"), object: nil, userInfo:nil)
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name("worked"), object: nil, userInfo:nil)
                }
            }
            
            }, fail: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.row]
        if model.resource_type == "4" || model.resource_type == "126" || model.resource_type == "147"{
            let ctl = NoticeUserInfoCenterController()
            ctl.userId = model.to_user_id
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "2"{
            return
        }else if model.resource_type == "3"{
            let ctl = NoticeMangerVoiceController()
            ctl.managerM = model.managerM
            ctl.mangagerCode = self.mangagerCode!
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "1"{
            let ctl = NoticeManagerWorldController()
            ctl.voiceM = model.voiceM
            ctl.mangagerCode = self.mangagerCode!
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "5"{
            let ctl = NoticeManagerWorldController()
            ctl.drawM = model.drawM
            ctl.mangagerCode = self.mangagerCode!
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "6"{
            let ctl = NoticeManagerWorldController()
            ctl.tuYaModel = model.tuyaModel;
            ctl.mangagerCode = self.mangagerCode!
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "7" {
            let ctl = NoticeTcPageController()
            ctl.tcDic = model.line
            ctl.mangagerCode = self.mangagerCode!
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "8" {
            let ctl = NoticeTopTenController()
            ctl.pyDic = model.dubbing
            ctl.mangagerCode = self.mangagerCode!
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "9"{
            let ctl = NoticeMangerVoiceController()
            ctl.groupM = model.groupChatModel
            ctl.mangagerCode = self.mangagerCode!
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "128"{
            let ctl = NoticeUserInfoCenterController()
            ctl.userId = model.to_user_id
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "130"{
            let ctl = NoticeBBSDetailController()
            ctl.posiId = model.commentM.post_id;
            ctl.commentM = model.commentM;
            ctl.needRequestDetail = true;
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "131" || model.resource_type == "132"{
            let ctl = NoticePyComController()
            ctl.managerCode = self.mangagerCode!
            ctl.jubaoComM = model.pyComM
            ctl.pyId = model.pyComM.dubbing_id
            ctl.type = model.resource_type;
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "10"{
            let ctl = NoticeMangerVoiceController()
            ctl.danmMu = model.danmM
            ctl.mangagerCode = self.mangagerCode!
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if model.resource_type == "141" || model.resource_type == "142"{

            self.showHUD()
            DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: "invitation/" + model.invitation_id, accept: "application/vnd.shengxi.v5.4.1+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
                self?.hideHUD()
                if success {
                    
                    let helpM = NoticeHelpListModel.mj_object(withKeyValues: dict!["data"])
                    let ctl = NoticeHelpDetailController()
                    if model.helpCommentArr.count > 0 {
                        ctl.isJubaoCom = true
                        ctl.comModel = model.helpCommentArr[0] as! NoticeHelpCommentModel
                        ctl.comModel.invitation_comment_parent_id = model.invitation_comment_parent_id;
                    }
                    ctl.helpModel = helpM!
                    self?.navigationController?.pushViewController(ctl, animated: true)
                }
                
                }, fail: {[weak self] (error) in
                    self?.hideHUD()
            })
        }else if model.resource_type == "143" {
            
            self.showHUD()
            DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: "podcast/" + model.podcast_id, accept: "application/vnd.shengxi.v4.9.7+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
                self?.hideHUD()
                if success {
                    
                    let bokeM = NoticeDanMuModel.mj_object(withKeyValues: dict!["data"])
                    
                    let ctl = NoticeSendBoKeController()
                    ctl.isJuBao = true
                    ctl.bokeModel = bokeM!
                    ctl.jubModel = model
                    ctl.managerCode = self!.mangagerCode!
                    self?.navigationController?.pushViewController(ctl, animated: true)
                }
                
                }, fail: {[weak self] (error) in
                    self?.hideHUD()
            })
        }else if model.resource_type == "144" {
            
            self.showHUD()
            DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: "podcast/" + model.podcast_id, accept: "application/vnd.shengxi.v4.9.7+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
                self?.hideHUD()
                if success {
                    
                    let bokeM = NoticeDanMuModel.mj_object(withKeyValues: dict!["data"])
                    
                    let comView = NoticeVoiceComDetailView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight))
                    comView.comModel = model.comBokeModel
                    comView.bokeModel = bokeM ?? NoticeDanMuModel()
                    comView.comId = model.comBokeModel.subId
                    comView.titleL.text = "被举报的播客评论/回复"
                    comView.voiceId = "0"
                    comView.fromBokeMsg = true
                    comView.show()
                    
                }
                
            }, fail: {[weak self] (error) in
                self?.hideHUD()
            })
        }else if model.resource_type == "146" {
            
            self.showHUD()
            DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: "mass/" + model.chatTeamM.mass_id, accept: "application/vnd.shengxi.v5.5.2+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
                self?.hideHUD()
                if success {
                    
                    let teamM = NoticeGroupListModel.mj_object(withKeyValues: dict!["data"])
                    teamM?.is_join = "1"
                    let ctl = NoticeTeamChatController()
                    ctl.chatM = model.chatTeamM;
                    ctl.teamModel = teamM!;
                    self?.navigationController?.pushViewController(ctl, animated: true)
                    
                }
                
            }, fail: {[weak self] (error) in
                self?.hideHUD()
            })
        }else if model.resource_type == "140"{
            
            let comView = NoticeVoiceComDetailView(frame: CGRect(x: 0, y: 10, width: NoticeOcToSwift.devoiceWidth(), height: NoticeOcToSwift.devoiceHeight()))
            comView.voiceM = model.voiceM
            comView.comModel = model.comModel
            comView.comId = model.comModel.subId
            comView.voiceId = model.voiceM.voice_id
            comView.titleL.text = "心情评论"
            comView.inputView.removeFromSuperview()
            comView.show()
        }
    }
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }

}
