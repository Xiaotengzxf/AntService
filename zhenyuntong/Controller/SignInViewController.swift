//
//  SignInViewController.swift
//  AntService
//
//  Created by 张晓飞 on 2017/7/17.
//  Copyright © 2017年 zhenyuntong. All rights reserved.
//

import UIKit
import SwiftyJSON
import ALCameraViewController
import Toaster
import Photos

class SignInViewController: UIViewController, BMKLocationServiceDelegate {
    
    @IBOutlet weak var tvSuggestion: PlaceholderTextView!
    @IBOutlet weak var vAccessory: UIView!
    @IBOutlet weak var lblAccessory: UILabel!
    var image : UIImage?
    var cid = 0
    @IBOutlet weak var ivAccessory: UIImageView!
    @IBOutlet weak var lcHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLocation: UILabel!
    var _locService : BMKLocationService?

    override func viewDidLoad() {
        super.viewDidLoad()

        vAccessory.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1).cgColor
        vAccessory.layer.borderWidth = 0.5
        let tap = UITapGestureRecognizer(target: self, action: #selector(WaitWorkNewViewController.tap(recognizer:)))
        vAccessory.addGestureRecognizer(tap)
        
        _locService = BMKLocationService()
        _locService?.delegate = self
        //启动LocationService
        _locService?.startUserLocationService()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func save(_ sender: Any) {
        tvSuggestion.resignFirstResponder()
        let opinion = tvSuggestion.text
        let filepath = lblAccessory.text != "请选择" ? lblAccessory.text! : ""
        let hud = showHUD(text: "保存中...")
        let params = ["cid" : "\(cid)" , "content" : opinion ?? "" ,  "filepath" : filepath , "NE" : lblLocation.text ?? "0,0"]
        
        NetworkManager.installshared.upload(url: NetworkManager.installshared.appPunchOut, params: params, data: (image != nil ? UIImageJPEGRepresentation(image!, 0.2) : nil)) {[weak self] (json, error) in
            hud.hide(animated: true)
            if let object = json {
                if let result = object["result"].int , result == 1000 {
                    Toast(text: "签到成功").show()
                    self?.dismiss(animated: true, completion: {
                        
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
    
    // 添加附件
    func tap(recognizer : UITapGestureRecognizer) {
        let croppingEnabled = true
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
            // Do something with your image here.
            // If cropping is enabled this image will be the cropped version
            self?.dismiss(animated: true, completion: nil)
            self?.image = image
            if image != nil {
                self?.ivAccessory.image = image
                let height = (image!.size.width > SCREENWIDTH - 72) ? (image!.size.height * ((SCREENWIDTH - 72) / image!.size.width)) : (image!.size.height * (image!.size.width / (SCREENWIDTH - 72)))
                self?.lcHeight.constant = height
                
                let manager = PHImageManager.default()
                manager.requestImageData(for: asset!, options: nil, resultHandler: {[weak self] (data, path, orientation, other) in
                    self?.lblAccessory.text = path
                })
                
            }
        }
        self.present(cameraViewController, animated: true, completion: nil)
    }
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        _locService?.stopUserLocationService()
        lblLocation.text = "\(userLocation.location.coordinate.latitude),\(userLocation.location.coordinate.longitude)"
    }
    
}

