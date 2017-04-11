//
//  DialogNewViewController.swift
//  AntService
//
//  Created by 张晓飞 on 2017/3/22.
//  Copyright © 2017年 zhenyuntong. All rights reserved.
//

import UIKit
import Toaster
import SwiftyJSON

class DialogNewViewController: UIViewController {

    @IBOutlet weak var ptvContent: PlaceholderTextView!
    @IBOutlet weak var idtfStart: IQDropDownTextField!
    @IBOutlet weak var idtfStartTime: IQDropDownTextField!
    @IBOutlet weak var idtfEnd: IQDropDownTextField!
    @IBOutlet weak var idtfEndTime: IQDropDownTextField!
    @IBOutlet weak var vEnd: UIView!
    @IBOutlet weak var lcEndHeight: NSLayoutConstraint!
    @IBOutlet weak var lcTimeWidth: NSLayoutConstraint!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnEnd: UIButton!
    var json : JSON?
    var bModify = false
    var personId = ""
    var date : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lcTimeWidth.constant = SCREENWIDTH - 32
        lcEndHeight.constant = 0
        vEnd.isHidden = true
        idtfStart.dropDownMode = .datePicker
        idtfEnd.dropDownMode = .datePicker
        idtfStartTime.dropDownMode = .timePicker
        idtfEndTime.dropDownMode = .timePicker
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        idtfStart.dateFormatter = formatter
        idtfEnd.dateFormatter = formatter
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        idtfStartTime.timeFormatter = timeFormatter
        idtfEndTime.timeFormatter = timeFormatter
        idtfStart.rightView = rightView(name: "icon_arrow_right", size: CGSize(width: 20, height: 20))
        idtfStart.rightViewMode = .always
        idtfEnd.rightView = rightView(name: "icon_arrow_right", size: CGSize(width: 20, height: 20))
        idtfEnd.rightViewMode = .always
        idtfStartTime.rightView = rightView(name: "icon_arrow_right", size: CGSize(width: 20, height: 20))
        idtfStartTime.rightViewMode = .always
        idtfEndTime.rightView = rightView(name: "icon_arrow_right", size: CGSize(width: 20, height: 20))
        idtfEndTime.rightViewMode = .always
        
        ptvContent.text = json?["content"].string
        if let start = json?["start"].string {
            bModify = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "删除", style: .plain, target: self, action: #selector(DialogNewViewController.deleteLog))
            let date = Date(timeIntervalSince1970: Double(start)!)
            idtfStart.date = date
            if json?["allDay"].string ?? "1" == "1" {
                idtfStartTime.selectedItem = "08:00"
            }else{
                idtfStartTime.date = date
            }
        }else{
            idtfStart.date = date
        }
        if let end = json?["end"].string{
            let date = Date(timeIntervalSince1970: Double(end)!)
            idtfEnd.date = date
            idtfEndTime.date = date
        }else{
            idtfEndTime.selectedItem = "12:00"
        }
        
        btnAll.isSelected = json?["allDay"].string ?? "1" == "1"
        lcTimeWidth.constant = btnAll.isSelected ? SCREENWIDTH - 32 : (SCREENWIDTH - 48) / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rightView(name : String, size : CGSize) -> UIView {
        let view = UIView()
        view.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        let iv = UIImageView(image: UIImage(named: name))
        iv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iv)
        view.addConstraint(NSLayoutConstraint(item: iv, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: iv, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: iv, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: size.width))
        view.addConstraint(NSLayoutConstraint(item: iv, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: size.height))
        
        return view
    }
    
    @IBAction func allday(_ sender: Any) {
        resign()
        if btnAll.isSelected {
            btnAll.isSelected = false
            
        }else{
            btnAll.isSelected = true
        }
        lcTimeWidth.constant = btnAll.isSelected ? SCREENWIDTH - 32 : (SCREENWIDTH - 48) / 2
        UIView.animate(withDuration: 0.3) { 
            [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    @IBAction func endtime(_ sender: Any) {
        resign()
        if btnEnd.isSelected {
            btnEnd.isSelected = false
        }else{
            btnEnd.isSelected = true
        }
        vEnd.isHidden = !btnEnd.isSelected
        lcEndHeight.constant = btnEnd.isSelected ? 90 : 0
    }
    @IBAction func save(_ sender: Any) {
        resign()
        guard let content = ptvContent.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            Toast(text: "请输入工作内容").show()
            return
        }
        let isallday = btnAll.isSelected ? 1 : 0
        let isend = btnEnd.isSelected ? 1 : 0
        var params = ["content" : content]
        params["isallday"] = "\(isallday)"
        params["isend"] = "\(isend)"
        if isend > 0 {
            guard let end = idtfEnd.selectedItem , end.characters.count > 0 else {
                Toast(text: "请选择结束时间").show()
                return
            }
            params["enddate"] = end
        }else{
            params["enddate"] = ""
        }
        if let array = idtfEndTime.selectedItem?.components(separatedBy: ":") {
            if array.count == 2 {
                params["e_hour"] = array[0]
                params["e_minute"] = array[1]
            }
        }
        params["startdate"] = idtfStart.selectedItem!
        if let array =  idtfStartTime.selectedItem?.components(separatedBy: ":") {
            if array.count == 2 {
                params["s_hour"] = array[0]
                params["s_minute"] = array[1]
            }
        }
        if let jid = json?["id"].string {
            params["id"] = jid
        }
        let hud = showHUD(text: "提交中...")
        NetworkManager.installshared.request(type: .post, url: bModify ? NetworkManager.installshared.appUpdateWorkLog : NetworkManager.installshared.appAddWorkLog, params: params){
            [weak self] (json , error) in
            hud.hide(animated: true)
            if let object = json {
                if let result = object["result"].int , result == 1000 {
                    Toast(text: self!.bModify ? "修改成功" : "保存成功").show()
                    NotificationCenter.default.post(name: Notification.Name("dialog\(self!.personId)"), object: 1)
                    _ = self?.navigationController?.popViewController(animated: true)
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
    
    func resign() {
        ptvContent.resignFirstResponder()
        idtfStart.resignFirstResponder()
        idtfStartTime.resignFirstResponder()
        idtfEnd.resignFirstResponder()
        idtfEndTime.resignFirstResponder()
    }
    
    func deleteLog() {
        let hud = showHUD(text: "删除中...")
        NetworkManager.installshared.request(type: .post, url:  NetworkManager.installshared.appDelWorkLog, params: ["id" : json?["id"].string ?? ""]){
            [weak self] (json , error) in
            hud.hide(animated: true)
            if let object = json {
                if let result = object["result"].int , result == 1000 {
                    Toast(text: "删除成功").show()
                    NotificationCenter.default.post(name: Notification.Name("dialog\(self!.personId)"), object: 1)
                    _ = self?.navigationController?.popViewController(animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
