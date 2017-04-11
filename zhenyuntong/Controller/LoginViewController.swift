//
//  LoginViewController.swift
//  zhenyuntong
//
//  Created by 张晓飞 on 2016/12/6.
//  Copyright © 2016年 zhenyuntong. All rights reserved.
//

import UIKit
import Toaster
import SwiftyJSON

class LoginViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var tvDomain: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let username = UserDefaults.standard.object(forKey: "username") as? String {
            userNameTextField.text = username
        }
        userNameTextField.leftView = leftView(name: "ic_login_icon_01", size: CGSize(width: 17, height: 20))
        pwdTextField.leftView = leftView(name: "ic_login_icon_02", size: CGSize(width: 17, height: 20))
        userNameTextField.leftViewMode = .always
        pwdTextField.leftViewMode = .always
    }
    
    func leftView(name : String, size : CGSize) -> UIView {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doLogin(_ sender: Any) {
        resign()
        let mobile = userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = pwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let domain = tvDomain.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if mobile == nil || mobile?.characters.count == 0 {
            Toast(text: "请输入用户名").show()
            return
        }else if pwd == nil || pwd?.characters.count == 0 {
            Toast(text: "请输入密码").show()
            return
        }else if domain == nil || domain?.characters.count == 0 {
            Toast(text: "请输入域名").show()
            return
        }
        let hud = self.showHUD(text: "加载中...")
        UserDefaults.standard.set(domain!, forKey: "domain")
        UserDefaults.standard.set(mobile!, forKey: "username")
        UserDefaults.standard.set(pwd!, forKey: "pwd")
        UserDefaults.standard.synchronize()
        NetworkManager.installshared.request(type: .post, url: NetworkManager.installshared.login, params: nil){
            [weak self] (json , error) in
            hud.hide(animated: true)
            if let object = json {
                if let result = object["result"].int , result == 1000 {
                    if var dict = object["data"].dictionaryObject {
                        for (key , value) in dict {
                            if value is NSNull {
                                dict[key] = ""
                            }
                        }
                        UserDefaults.standard.set(dict, forKey: "mine")
                        UserDefaults.standard.synchronize()
                    }
                    let tabbar = self?.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                    self?.view.window?.rootViewController = tabbar
                    
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

    @IBAction func doRegister(_ sender: Any) {
        resign()
        
    }
    
    @IBAction func doForgetPwd(_ sender: Any) {
        resign()
    }
    
    // 取消输入焦点
    func resign()  {
        userNameTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
        tvDomain.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let len = textField.text?.characters.count , len >= 20 {
            if range.length == 0 {
                return false
            }
        }
        return true
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
