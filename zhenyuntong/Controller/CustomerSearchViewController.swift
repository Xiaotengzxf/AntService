//
//  CustomerSearchViewController.swift
//  AntService
//
//  Created by 张晓飞 on 2017/8/19.
//  Copyright © 2017年 zhenyuntong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toaster

class CustomerSearchViewController: UIViewController, IQDropDownTextFieldDelegate {

    @IBOutlet weak var lcTop: NSLayoutConstraint!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfStartDate: IQDropDownTextField!
    @IBOutlet weak var tfEndDate: IQDropDownTextField!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var btnWeek: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var ddtfState: IQDropDownTextField!
    @IBOutlet weak var lblHandler: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var vHandler: UIView!
    var other : [JSON] = []
    var oid = 0
    var addUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SCREENWIDTH == 320 {
            lcTop.constant = 10
            tfStartDate.font = UIFont.systemFont(ofSize: 9)
            tfEndDate.font = UIFont.systemFont(ofSize: 9)
        }
        self.title = "客户搜索"
        tfStartDate.dropDownMode = .datePicker
        tfEndDate.dropDownMode = .datePicker
        loadData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(recognizer:)))
        vHandler.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotificatiaon(notification:)), name: Notification.Name("CustomerSearch"), object: nil)
        
        vHandler.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1).cgColor
        vHandler.layer.borderWidth = 1.0
    }
    
    // 点击事件，选择用户列表
    func tap(recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "userlist") as? UserListTableViewController {
            controller.flag = 0
            controller.bSingle = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleNotificatiaon(notification: Notification) {
        if let userInfo = notification.userInfo as? [String : Any] {
            let json = JSON(userInfo)
            addUser = json["id"].stringValue
            lblHandler.text = json["nickname"].stringValue
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData() {
        NetworkManager.installshared.request(type: .post, url: NetworkManager.installshared.appCustConnType, params: nil){
            [weak self] (json , error) in
            if let object = json {
                if let result = object["result"].int , result == 1000 {
                    if let array = object["data"].array {
                        self?.other += array
                        self?.ddtfState.itemList = self!.other.map{$0["name"].stringValue}
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
    
    @IBAction func searchCustomer(_ sender: Any) {
        tfUserName.resignFirstResponder()
        tfPhone.resignFirstResponder()
        tfStartDate.resignFirstResponder()
        tfEndDate.resignFirstResponder()
        ddtfState.resignFirstResponder()
        var startDate = ""
        var endDate = ""
        var mobile = ""
        if let mobileTem = tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines), mobileTem.characters.count > 0 {
            if Invalidate.isPhoneNumber(phoneNumber: mobileTem) {
                mobile = mobileTem
            }else{
                Toast(text: "手机号码输入有误").show()
                return
            }
        }
        if let date = tfStartDate.text {
            startDate = changeDate(date: date)
        }
        if let date = tfEndDate.text {
            endDate = changeDate(date: date)
        }
        var params : [String : String] = [:]
        params["customer"] = tfUserName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        params["mobile"] = mobile
        params["adduser"] = addUser
        params["stime"] = startDate
        params["btime"] = endDate
        if oid > 0 {
            params["connType"] = "\(oid)"
        }
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "customer") as? CustomerViewController {
            controller.bSearch = true
            controller.params = params
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    @IBAction func getMonth(_ sender: Any) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy年MM月dd日"
        tfStartDate.text = format.string(from: date.addingTimeInterval(-60 * 60 * 24 * 30))
        tfEndDate.text = format.string(from: date)
    }
    
    @IBAction func getWeek(_ sender: Any) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy年MM月dd日"
        tfStartDate.text = format.string(from: date.addingTimeInterval(-60 * 60 * 24 * 7))
        tfEndDate.text = format.string(from: date)
    }
    
    @IBAction func getToday(_ sender: Any) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy年MM月dd日"
        tfStartDate.text = format.string(from: date)
        tfEndDate.text = format.string(from: date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfStartDate {
            if let text = textField.text, text.characters.count > 0 {
                tfStartDate.selectedItem = text
            }else{
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年MM月dd日"
                tfStartDate.selectedItem = formatter.string(from: date)
                tfStartDate.text = formatter.string(from: date)
                
            }
            
        }else if textField == tfEndDate {
            if let text = textField.text, text.characters.count > 0 {
                tfEndDate.text = text
            }else{
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年MM月dd日"
                tfEndDate.selectedItem = formatter.string(from: date)
                tfEndDate.text = formatter.string(from: date)
            }
            
        }
    }
    
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        if textField == ddtfState {
            let index = other.map{$0["name"].stringValue}.index(of: item!) ?? 0
            oid = other[index]["id"].intValue
        }
    }
    
    func changeDate(date : String) -> String {
        if date.characters.count > 0 {
            var d = date.replacingOccurrences(of: "年", with: "-")
            d = d.replacingOccurrences(of: "月", with: "-")
            d = d.replacingOccurrences(of: "日", with: "")
            let array = d.components(separatedBy: "-")
            if array.count == 3 {
                return array[0] + "-\(array[1].characters.count == 1 ? "0\(array[1])" : array[1])" + "-\(array[2].characters.count == 1 ? "0\(array[2])" : array[1])"
            }else{
                return ""
            }
        }
        return ""
    }

}
