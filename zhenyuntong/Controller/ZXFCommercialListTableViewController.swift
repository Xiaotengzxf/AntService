//
//  ZXFCommercialListTableViewController.swift
//  AntService
//
//  Created by 张晓飞 on 2017/6/25.
//  Copyright © 2017年 zhenyuntong. All rights reserved.
//

import UIKit
import SwiftyJSON
import DZNEmptyDataSet
import MJRefresh
import Toaster
import TabPageViewController

class ZXFCommercialListTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var search = "" // 搜索关键词
    var page = 0  // 当前页码
    var state = 0 // 状态
    var data : [JSON] = []
    //var proCommerialList : CommercialListProtocol?
    var nShowEmpty = 2 // 1 无数据 2 加载中 3 无网络
    var bSearch = false
    var type = ""
    var includeMy = "n"
    var row = 0
    var tabPage : TabPageViewController!
    var stepId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [weak self] in
            self?.page = 0
            self?.loadData()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            [weak self] in
            self!.page += 1
            self?.loadData()
        })
        tableView.mj_footer.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(ZXFCommercialListTableViewController.handleNotification(notification:)), name: Notification.Name("commerciallist"), object: nil)
        
        if bSearch {
            self.navigationItem.rightBarButtonItem = nil
            self.title = "搜索结果"
        }else{
            tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        }
        
        self.loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - mothd
    func loadData() {
        var params : [String : Any] = ["type" : type, "state" : (state == 0 ? "" : "\(state)"), "page" : page, "seachdata" : search]
        if bSearch {
            params["includeMy"] = includeMy
        }
        NetworkManager.installshared.request(type: .post, url: NetworkManager.installshared.appOppoList, params: params) {[weak self] (json, error) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            if let object = json {
                if let result = object["result"].int {
                    if result == 1000 {
                        if self!.page == 0 {
                            self?.data.removeAll()
                        }
                        if let records = object["records"].int {
                            if records < 20 {
                                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                            }
                        }
                        if let arr = object["data"].array {
                            self!.data += arr
                        }
                        if self?.data.count == 0 {
                            self?.nShowEmpty = 3
                            self?.tableView.mj_footer.isHidden = true
                        }else{
                            self?.tableView.mj_footer.isHidden = false
                        }
                        self?.tableView.reloadData()
                    }else if result == 1004 {
                        if self?.page == 0 && self?.data.count ?? 0 == 0{
                            self?.nShowEmpty = 1
                            self?.tableView.reloadData()
                        }
                    }
                    
                }else{
                    if let message = object["msg"].string , message.characters.count > 0 {
                        Toast(text: message).show()
                    }
                }
            }else{
                if self?.page == 0 && self?.data.count ?? 0 == 0{
                    self?.nShowEmpty = 1
                    self?.tableView.reloadData()
                }else{
                    Toast(text: "网络异常，请稍后重试").show()
                }
                
            }
        }
    }
    
    func handleNotification(notification : Notification) {
        if let tag = notification.object as? Int {
            if tag == 1 {
                if let userInfo = notification.userInfo as? [String : Any] {
                    if let message = userInfo["message"] as? String {
                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "commerciallist") as? ZXFCommercialListTableViewController {
                            controller.search = message
                            controller.bSearch = true
                            controller.state = state
                            controller.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                }
            }else if tag == 2 {
                tabPage.navigationController?.popViewController(animated: true)
                self.tableView.mj_header.beginRefreshing()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let lblName = cell.contentView.viewWithTag(2) as? UILabel {
            lblName.text = data[indexPath.row]["name"].string
        }
        if let lblCustomerName = cell.contentView.viewWithTag(3) as? UILabel {
            lblCustomerName.text = "客户名称：\(data[indexPath.row]["custname"].string ?? "") 商机类型：\(data[indexPath.row]["flowtemp"].string ?? "")"
        }
        if let lblAdder = cell.contentView.viewWithTag(4) as? UILabel {
            lblAdder.text = "添加人：\(data[indexPath.row]["adduser_nickname"].string ?? "") 跟进人：\(data[indexPath.row]["curuser_nickname"].string ?? "")"
        }
        if let lblAddTime = cell.contentView.viewWithTag(5) as? UILabel {
            lblAddTime.text = "添加时间：\(data[indexPath.row]["addtime"].string ?? "")"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        row = indexPath.row
        let strId = data[indexPath.row]["id"].stringValue
        let hud = showHUD(text: "加载中...")
        NetworkManager.installshared.request(type: .post, url: NetworkManager.installshared.appOppoDetail, params: ["id" : strId]){
            [weak self] (json , error) in
            hud.hide(animated: true)
            if let object = json {
                if let result = object["result"].int , result == 1000 {
                    self!.tabPage = TabPageViewController.create()
                    self!.tabPage.title = "商机详情"
                    guard let detail = self?.storyboard?.instantiateViewController(withIdentifier: "commercialdetail") as? CommercialDetailTableViewController else {
                        return
                    }
                    detail.data = object["data"]
                    self!.stepId = object["data", "dealRecord"].arrayValue.count
                    guard let flow = self?.storyboard?.instantiateViewController(withIdentifier: "commercialflow") as? CommercialFlowTableViewController else {
                        return
                    }
                    flow.data = object["data"]
                    var option = TabPageOption()
                    option.tabBackgroundColor = UIColor.white
                    option.isTranslucent = false
                    option.tabHeight = 44
                    option.tabWidth = SCREENWIDTH / 2
                    self!.tabPage.option = option
                    self!.tabPage.tabItems = [(detail, "商机详情"), (flow, "商机流程")]
                    self!.tabPage.hidesBottomBarWhenPushed = true
                    if self!.state == 1 || self!.state == 2 {
                        if self!.state == 2 {
                            if let dealRecord = object["data", "dealRecord"].array {
                                let r_to = dealRecord.last!["r_to"].stringValue
                                let userinfo = UserDefaults.standard.object(forKey: "mine") as? [String : Any]
                                let pId = userinfo?["id"] as? String ?? ""
                                if dealRecord.count > 0 && r_to == pId {
                                    self!.tabPage.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "操作", style: .plain, target: self, action: #selector(ZXFCommercialListTableViewController.handleDetailEvent(sender:)))
                                }
                            }
                        }else{
                            self!.tabPage.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发起商机", style: .plain, target: self, action: #selector(ZXFCommercialListTableViewController.handleDetailEvent(sender:)))
                        }
                        
                    }
                    self?.navigationController?.pushViewController(self!.tabPage, animated: true)
                }else{
                    if let message = object["msg"].string , message.characters.count > 0 {
                        Toast(text: message).show()
                    }
                }
            }else{
                Toast(text: "网络异常，请稍后重试").show()
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - 空数据
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        var name = ""
        if nShowEmpty == 1 {
            name = "empty"
        }else if nShowEmpty == 2 {
            name = "jiazaizhong"
        }else if nShowEmpty == 3 {
            name = "empty"
        }
        return UIImage(named: name)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var message = ""
        if nShowEmpty == 1 {
            message = "世界上最遥远的距离就是没有WIFI...\n请点击屏幕重新加载！"
        }else if nShowEmpty == 2 {
            message = "加载是件正经事儿，走心加载中..."
        }else if nShowEmpty == 3 {
            message = "空空如也，啥子都没有噢！"
        }
        let att = NSMutableAttributedString(string: message)
        att.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 13)], range: NSMakeRange(0, att.length))
        return att
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return nShowEmpty == 2
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        if nShowEmpty > 0 && nShowEmpty != 2 {
            nShowEmpty = 2
            tableView.reloadData()
            loadData()
        }
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return nShowEmpty > 0
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(0.0, 0.0, 0.0, 1.0))
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi / 2), 0.0, 0.0, 1.0))
        animation.duration = 0.5
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        animation.autoreverses = false
        animation.fillMode = kCAFillModeForwards
        return animation
    }
    
    func handleDetailEvent(sender : Any) {
        if state == 2 {
            let sheet = UIAlertController(title: "操作", message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "处理", style: .default, handler: {[weak self] (action) in
                self?.loadNext(b: true)
            }))
            sheet.addAction(UIAlertAction(title: "委托", style: .default, handler: {[weak self] (action) in
                self?.loadEntrust()
            }))
            sheet.addAction(UIAlertAction(title: "销毁", style: .default, handler: {[weak self] (action) in
                if let controller = self?.storyboard?.instantiateViewController(withIdentifier: "waitworkclear") as? WaitWorkClearViewController {
                    controller.modalTransitionStyle = .crossDissolve
                    controller.modalPresentationStyle = .overFullScreen
                    controller.wfId = Int(self!.data[self!.row]["id"].stringValue) ?? 0
                    controller.bCommercial = true
                    self?.present(controller, animated: true, completion: {
                        
                    })
                }
            }))
            sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(sheet, animated: true) {
                
            }
        }else {
            self.loadNext(b: false)
        }
        
    }
    
    func loadNext(b : Bool) {
        let hud = showHUD(text: "加载中...")
        NetworkManager.installshared.request(type: .post, url: state == 2 ? NetworkManager.installshared.appOppoDispose : NetworkManager.installshared.appOppoLaunch, params: ["id" : data[row]["id"].stringValue]){
            [weak self] (json , error) in
            hud.hide(animated: true)
            if let object = json {
                if let result = object["result"].int , result == 1000 {
                    if let array = object["data"].array {
                        if let controller = self?.storyboard?.instantiateViewController(withIdentifier: "commercialhandle") as? CommercialHandleViewController {
                            controller.modalTransitionStyle = .crossDissolve
                            controller.modalPresentationStyle = .overFullScreen
                            controller.arrayStep = array
                            controller.wfId = Int(self!.data[self!.row]["id"].stringValue) ?? 0
                            controller.bComerical = b
                            self?.present(controller, animated: true, completion: {
                                
                            })
                        }
                    }
                }else{
                    if let message = object["msg"].string , message.characters.count > 0 {
                        Toast(text: message).show()
                    }
                }
            }else{
                Toast(text: "网络异常，请稍后重试").show()
            }
        }
    }
    
    func loadEntrust() {
        let hud = showHUD(text: "加载中...")
        NetworkManager.installshared.request(type: .post, url: NetworkManager.installshared.appOppoAllot, params: ["id" : data[row]["id"].stringValue, "setpid" : "1"]){
            [weak self] (json , error) in
            hud.hide(animated: true)
            if let object = json {
                if let result = object["result"].int , result == 1000 {
                    if let array = object["data"].array {
                        if let controller = self?.storyboard?.instantiateViewController(withIdentifier: "waitworkhandle") as? WaitWorkHandleViewController {
                            controller.modalTransitionStyle = .crossDissolve
                            controller.modalPresentationStyle = .overFullScreen
                            controller.arrayUser = array
                            controller.bCommercial = true
                            controller.wfId = Int(self!.data[self!.row]["id"].stringValue) ?? 0
                            controller.stepId = self!.stepId + 1
                            self?.present(controller, animated: true, completion: {
                                
                            })
                        }
                    }
                }else{
                    if let message = object["msg"].string , message.characters.count > 0 {
                        Toast(text: message).show()
                    }
                }
            }else{
                Toast(text: "网络异常，请稍后重试").show()
            }
        }
    }

}
