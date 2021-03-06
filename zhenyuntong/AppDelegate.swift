//
//  AppDelegate.swift
//  zhenyuntong
//
//  Created by 张晓飞 on 2016/12/3.
//  Copyright © 2016年 zhenyuntong. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//import CocoaAsyncSocket

//var sqlManager : SQLiteManager?
var MODELITEM = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?
    //var clientSocket : GCDAsyncSocket?
    var _mapManager: BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: 30/255.0, green: 160/255.0, blue: 20/255.0, alpha: 1)], for: .selected)
        application.setStatusBarStyle(.lightContent, animated: false)
        IQKeyboardManager.sharedManager().enable = true
        
//        ShareSDK.registerApp("iosv1101", activePlatforms:[
//            SSDKPlatformType.typeSinaWeibo.rawValue,
//            SSDKPlatformType.typeWechat.rawValue,
//            SSDKPlatformType.typeQQ.rawValue],
//                             onImport: { (platform : SSDKPlatformType) in
//                                switch platform
//                                {
//                                case SSDKPlatformType.typeSinaWeibo:
//                                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
//                                case SSDKPlatformType.typeWechat:
//                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
//                                case SSDKPlatformType.typeQQ:
//                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
//                                default:
//                                    break
//                                }
//                                
//        }) { (platform : SSDKPlatformType, appInfo : NSMutableDictionary?) in
//            
//            switch platform
//            {
//            case SSDKPlatformType.typeSinaWeibo:
//                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                appInfo?.ssdkSetupSinaWeibo(byAppKey: "568898243",
//                                            appSecret : "38a4f8204cc784f81f9f0daaf31e02e3",
//                                            redirectUri : "http://www.sharesdk.cn",
//                                            authType : SSDKAuthTypeBoth)
//                
//            case SSDKPlatformType.typeWechat:
//                //设置微信应用信息
//                appInfo?.ssdkSetupWeChat(byAppId: "wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
//                
//            case SSDKPlatformType.typeQQ:
//                //设置QQ应用信息
//                appInfo?.ssdkSetupQQ(byAppId: "100371282",
//                                     appKey : "aed9b0303e3ed1e27bae87c33761161d",
//                                     authType : SSDKAuthTypeWeb)
//            default:
//                break
//            }
//            
//        }
        
        //startSocket() // 启动socket
        //createDB()
        
        Bugly.start(withAppId: "a105156434")
        
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("4EPSALve9pBxDUL8SKKGgW2xznTfZg0I", generalDelegate: nil)
        if ret == false {
            print("manager start failed!")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    func createDB() {
        sqlManager = SQLiteManager(delegate: self)
        sqlManager?.createDB()
    }
    /* {
     areaId = 0;
     areaUserId = 0;
     lastMsg = "\U4e60\U8fd1\U5e73\U4f1a\U89c1\U4fc4\U7f57\U65af\U56fd\U5bb6\U675c\U9a6c\U4e3b\U5e2d";
     lastMsgId = 2;
     lastMsgType = 1;
     lastTime = "2016-04-30 15:30:52";
     sessionIcon = "http://img1.imgtn.bdimg.com/it/u=2358564231,2373673478&fm=21&gp=0.jpg";
     sessionId = 1;
     sessionName = "\U7cfb\U7edf\U516c\U544a";
     sessionType = 1;
     state = 0;
     unReadCount = 0;
     }*/
    // MARK: -SQLDelegate
    var SQLsyntaxs: [String] {
        return [
            
            SQLite(create: "chat")
                .cloumn("id").INTEGER.PRIMARYKEY.AUTOINCREMENT.NOTNULL
                .cloumn("areaId").INTEGER
                .cloumn("areaUserId").INTEGER
                .cloumn("lastMsg").TEXT
                .cloumn("lastMsgId").INTEGER
                .cloumn("lastMsgType").INTEGER
                .cloumn("lastTime").TEXT
                .cloumn("sessionIcon").TEXT
                .cloumn("sessionId").INTEGER
                .cloumn("sessionName").TEXT
                .cloumn("sessionType").INTEGER
                .cloumn("state").INTEGER
                .cloumn("unReadCount").INTEGER
                .value
        ]
    }
    
    var dbPathName: String {
        return "/zhenyuntong.sqlite"
    }
    
    func tablePrimaryKey(table: String) -> String {
        return "id"
    }
    
    
    // socket
    func startSocket() {
        clientSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            let mac = UserDefaults.standard.string(forKey: "mac") ?? "http://120.24.254.101:8080"
            let array = mac.components(separatedBy: ":")
            let ip = array[1].substring(from: array[1].index(array[1].startIndex, offsetBy: 2))
            print("ip:\(ip)")
            try clientSocket?.connect(toHost: ip, onPort: 9888)
        }catch {
            print(error)
        }
    }

    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("成功：\(host):\(port)")
        sendLoginMessage()
        clientSocket?.readData(to: "\r\n\r\n".data(using: .utf8)!, withTimeout: -1, tag: 0)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("失败：\(err)")
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        do {
            let message = try IMMessage.parse(from: data)
            switch message.messageType {
            case .send:
                print("send")
            case .squeeze:
                print("squeeze")
            default:
                print("other")
            }
            
        }catch {
            
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print("write success")
    }
    
    // 登录
    func sendLoginMessage() {
        let message = IMMessage()
        message.messageType = .login
        message.content = ""
        message.senderId = "\(UserDefaults.standard.integer(forKey: "userId"))"
        if let data = message.data() {
            clientSocket?.write(data, withTimeout: -1, tag: 0)
        }
    }
    */
}

