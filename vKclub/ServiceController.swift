//
//  ServiceController.swift
//  vKclub
//
//  Created by HuySophanna on 26/6/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import Foundation
import UIKit

class ServiceController: UIViewController {
    var incomingCallInstance = IncomingCallController()
   
    //    var dashboardInstance = DashboardController()
    @IBOutlet weak var inKiriromContent: UIView!
    @IBOutlet weak var bottomLine: UIView!
    override func viewDidLoad() {
        InternetConnection.getServiceExtensions()
        InternetConnection.AskAudioPermission()
        //put proper content based on app mode
        if CHCK_USER_LOCATION == IN_KIRIROM {
            inKiriromContent.isHidden = false
            bottomLine.isHidden = false
        } else {
            inKiriromContent.isHidden = true
            bottomLine.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //*** This is required to fix navigation bar forever disappear on fast backswipe bug.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func GotoBookpage(_ sender: Any) {
        self.performSegue(withIdentifier: "SgGotoBookpage", sender: self)
    }
    
    @IBAction func CallToDepartmentAction(_ sender: Any) {
        
        if InternetConnection.CheckAudioPermission(){
            if service_extensions.isEmpty {
                InternetConnection.makeCall()
                return
            }
            switch getExtensionSucc {
            case "Extension":
                 switch (sender as! UIButton).tag {
                    case 1:
                        switch CHCK_USER_LOCATION {
                        case IN_KIRIROM:
                            if  LinphoneManager.CheckLinphoneConnectionStatus() == false {
                                PresentAlertController(title: "Something went wrong", message: "You are not connected to our server. Please ensure that you are connected to our network and try again later.", actionTitle: "Okay")
                                return
                            }
                           CallToAction(phoneNumber: service_extensions[0])
                           break
                            
                        case OFF_KIRIROM:
                            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
                                UIApplication.topViewController()?.PresentAlertController(title: "Warning", message: "Your device doesn't support with this feature ", actionTitle: "Got it")
                                return
                            }
                            let alertController = UIAlertController(title: nil, message: "Contact us", preferredStyle: .actionSheet)
                            
                            let defaultAction = UIAlertAction(title: "English Speaker: (+855) 78 777 284", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                                if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
                                    self.PresentAlertController(title: "Something went wrong", message: "Your device doesn't support with this feature ", actionTitle: "Got it")
                                    
                                    return
                                }
                                guard let number = URL(string: "tel://" + "078777284" ) else { return }
                                UIApplication.shared.open(number, options: [:], completionHandler: nil)
                                
                            })
                            
                            let deleteAction = UIAlertAction(title: "Khmer Speaker: (+855) 96 2222 735", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                                if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
                                    self.PresentAlertController(title: "Something went wrong", message: "Your device doesn't support with this feature ", actionTitle: "Got it")
                                    
                                    return
                                }
                                guard let number = URL(string: "tel://" + "0962222735" ) else { return }
                                UIApplication.shared.open(number, options: [:], completionHandler: nil)
                                
                            })
                            
                            
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            if let popoverController = alertController.popoverPresentationController {
                                popoverController.sourceView = self.view
                                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                                popoverController.permittedArrowDirections = []
                            }
                            alertController.addAction(defaultAction)
                            alertController.addAction(deleteAction)
                            alertController.addAction(cancelAction)
                            self.present(alertController, animated: true, completion: nil)
                           
                            break
                        case UNIDENTIFIED:
                            UIComponentHelper.LocationPermission(INAPP_UNIDENTIFIEDSetting: false)
                            
                            break
                        case INAPP_UNIDENTIFIED:
                            UIComponentHelper.LocationPermission(INAPP_UNIDENTIFIEDSetting: true)
                            break
                        default:
                            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
                                UIApplication.topViewController()?.PresentAlertController(title: "Warning", message: "Your device doesn't support with this feature ", actionTitle: "Got it")
                                return
                            }
                            //call using carrier phone number
                            //                           let number = URL(string: "tel://" + "0962222735")
                            let url: NSURL = URL(string: "TEL://0962222735")! as NSURL
                            //                            UIApplication.shared.open(number!, options: [:], completionHandler: nil)
                            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                            
                            break
                            
                        }
                    case 2:
                        //housekeeping
                        CallToAction(phoneNumber: service_extensions[1])
                        break
                    case 3:
                        //massage
                        CallToAction(phoneNumber: service_extensions[2])
                        break
                    case 4:
                        //pineviewkitchen
                        CallToAction(phoneNumber: service_extensions[3])
                        break
                    case 5:
                        //activity
                        CallToAction(phoneNumber: service_extensions[4])
                        break
                    default:
                        //operation
                        CallToAction(phoneNumber: service_extensions[5])
                        break
                    }
                break
                
            case "400":
                InternetConnection.makeCall()
                break
            case "getExtensionSucc":
                InternetConnection.makeCall()
               
                break
                
            default:
                InternetConnection.makeCall()
                break
            }
            
        } else {
            let LocationPermissionAlert = UIAlertController(title: "Audio Permission Denied.", message: "Turn on Audio Service to process the internal phone call", preferredStyle: UIAlertControllerStyle.alert)
            
            LocationPermissionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler:nil)
            }))
            LocationPermissionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present( LocationPermissionAlert, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    func CallToAction(phoneNumber: String) {
        IncomingCallController.dialPhoneNumber = phoneNumber
        self.incomingCallInstance.callToFlag = true
        LinphoneManager.makeCall(phoneNumber: phoneNumber)
    }
    
}

class BookingViewController: UIViewController ,UIWebViewDelegate{
    var propertyData: [String: AnyObject]!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var noInternet: UILabel!
    let internetConnection = InternetConnection()
    override func viewDidLoad() {
        super.viewDidLoad()
        if InternetConnection.isConnectedToNetwork() {
            noInternet.isHidden = true
        } else{
            self.PresentAlertController(title: "Something went wrong", message: "Please Check your internet connection ", actionTitle: "Got it")
            return
        }
        let vkiriromurl : String = "http://vkirirom.com/en/reservation.php"
        let url = NSURL (string: vkiriromurl)
        let requestObj = URLRequest(url: url! as URL)
        self.view.addSubview(webView)
        webView.delegate = self as UIWebViewDelegate
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit
        
        webView.loadRequest(requestObj)
        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if(error.localizedDescription == "The Internet connection appears to be offline."){
            noInternet.isHidden = false
            self.PresentAlertController(title: "Something went wrong", message: "Please Check your internet connection ", actionTitle: "Got it")
            UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
        }
        
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

