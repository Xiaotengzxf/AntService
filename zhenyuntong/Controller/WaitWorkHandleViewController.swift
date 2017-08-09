//
//  WaitWorkHandleViewController.swift
//  AntService
//
//  Created by 张晓飞 on 2017/4/2.
//  Copyright © 2017年 zhenyuntong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toaster

class WaitWorkHandleViewController: UIViewController , IQDropDownTextFieldDelegate {

    @IBOutlet weak var idtfUser: IQDropDownTextField!
    @IBOutlet weak var tvReason: PlaceholderTextView!
    @IBOutlet weak var lblTitle: UILabel!
    var arrayUser : [JSON]!
    var wfId = 0
    var userId = ""
    var bCommercial = false
    var stepId = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idtfUser.itemList = arrayUser.map{$0["name"].stringValue}
        idtfUser.isOptionalDropDown = false
        lblTitle.text = bCommercial ? "商机委托" : "委托工作流"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true) { 
            
        }
    }

    @IBAction func submit(_ sender: Any) {
        idtfUser.resignFirstResponder()
        tvReason.resignFirstResponder()
        if userId.characters.count == 0 || userId == "0" {
            Toast(text: "请选择委托人").show()
            return
        }
        let reason = tvReason.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if reason.characters.count == 0 {
            Toast(text: "请输入委托理由").show()
            return
        }
        let hud = showHUD(text: "保存中...")
        var params : [String : Any] = [bCommercial ? "id" : "wf_id" : "\(wfId)" , bCommercial ? "remark" : "ent_remark" : reason , "ent_to" : userId]
        if bCommercial {
            params["stepid"] = "\(stepId)"
        }
        NetworkManager.installshared.request(type: .post, url: bCommercial ? NetworkManager.installshared.appOppoEntrust : NetworkManager.installshared.appWFEntrust, params: params) {[weak self] (json, error) in
            hud.hide(animated: true)
            if let object = json {
                if let result = object["result"].int , result == 1000 {
                    Toast(text: "保存成功").show()
                    self?.dismiss(animated: true, completion: { 
                        NotificationCenter.default.post(name: Notification.Name("commerciallist"), object: 2)
                    })
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
    
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        for json in arrayUser {
            if json["name"].stringValue == item {
                userId = "\(json["id"].stringValue)"
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
