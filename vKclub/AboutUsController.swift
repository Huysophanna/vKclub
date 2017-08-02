//
//  TableViewController.swift
//  vKclub
//
//  Created by HuySophanna on 20/7/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit
import Foundation

class AboutUsTableCell: UITableViewCell{
    @IBOutlet weak var Imageitem: UIImageView!
    @IBOutlet weak var titleItem: UILabel!
    @IBOutlet weak var decriptionItem: UITextView!
    
    
    
    func changeImageContentMode() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            Imageitem.contentMode = .scaleAspectFit
        } else if UI_USER_INTERFACE_IDIOM() == .phone {
            Imageitem.contentMode = .scaleToFill
        }
    }
    
}
class AccommodationController:  UITableViewController {
    var accommodationData = [[String: AnyObject]]()
    var selectedArticle: [String: AnyObject]!
    var selectedArticleImage: UIImage!
    var indexOfCellToExpand: Int!
    var expandedLabel: UILabel!

    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        indexOfCellToExpand = -1
        let path =  Bundle.main.path(forResource: "AboutUs", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        accommodationData = jsonResult["accommodation"] as! [[String: AnyObject]]
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.all
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return accommodationData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accommodationTableView", for: indexPath) as! AboutUsTableCell
        
        cell.changeImageContentMode()
        
        let accommodation = self.accommodationData[indexPath.row]
        let photoURL = accommodation["Photo"] as! String
        let title = accommodation["Title"] as! String
        let intro = accommodation["Intro"] as! String
        let image = UIImage(named:photoURL)
        let newimag = UIComponentHelper.resizeImage(image: image!, targetSize: CGSize(width: 400, height: 400))
        cell.Imageitem.image = newimag
        cell.titleItem.text = title
        cell.decriptionItem.text = intro
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticle = accommodationData[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! AboutUsTableCell
        selectedArticleImage = cell.Imageitem.image
        self.performSegue(withIdentifier: "SgaccommodationusWebView", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! AccommodationWebViewController
        detailsVC.accommodationData = selectedArticle
    }
}


class ActivityController: UITableViewController {
    var ativityData = [[String: AnyObject]]()
    var indexOfCellToExpand: Int!
    var expandedLabel: UILabel!
    var selectedArticle: [String: AnyObject]!
    var selectedArticleImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        indexOfCellToExpand = -1
        let path =  Bundle.main.path(forResource: "AboutUs", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        ativityData = jsonResult["activity"] as! [[String: AnyObject]]
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.all
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ativityData.count
    }
    
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    //
    //    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    //
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityTableView", for: indexPath) as! AboutUsTableCell
        
        cell.changeImageContentMode()
        
        let ativity = self.ativityData[indexPath.row]
        let photoURL = ativity["Photo"] as! String
        let title = ativity["Title"] as! String
        let intro = ativity["Intro"] as! String
        let image = UIImage(named:photoURL)
        let newimag = UIComponentHelper.resizeImage(image: image!, targetSize: CGSize(width: 400, height: 400))
        cell.Imageitem.image = newimag
        cell.titleItem.text = title
        cell.decriptionItem.text = intro
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticle = ativityData[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! AboutUsTableCell
        selectedArticleImage = cell.Imageitem.image
        self.performSegue(withIdentifier: "SgativityWebview", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! AtivityWebViewController
        detailsVC.ativityData = selectedArticle
        
    }
}



class  PropertyController: UITableViewController {
    var propertyData = [[String: AnyObject]]()
    var indexOfCellToExpand: Int!
    var expandedLabel: UILabel!
    var selectedArticle: [String: AnyObject]!
    var selectedArticleImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        indexOfCellToExpand = -1
        let path =  Bundle.main.path(forResource: "AboutUs", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        propertyData = jsonResult["property"] as! [[String: AnyObject]]
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
        let tabBarHeight = self.tabBarController?.tabBar.bounds.height
        self.edgesForExtendedLayout = UIRectEdge.all
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return propertyData.count
    }
    
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    //
    //    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }     //
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "propertyTableView", for: indexPath) as! AboutUsTableCell
        
        cell.changeImageContentMode()
        
        let property = self.propertyData[indexPath.row]
        let photoURL =  property["Photo"] as! String
        let title =  property["Title"] as! String
        let intro = property["Intro"] as! String
        let image = UIImage(named:photoURL)
        let newimag = UIComponentHelper.resizeImage(image: image!, targetSize: CGSize(width: 400, height: 400))
        cell.Imageitem.image = newimag
        cell.titleItem.text = title
        cell.decriptionItem.text = intro
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticle = propertyData[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! AboutUsTableCell
        selectedArticleImage = cell.Imageitem.image
        self.performSegue(withIdentifier: "SgpropertyWebView", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! PropertyWebViewController
        detailsVC.propertyData = selectedArticle
        }
}

class AccommodationWebViewController: UIViewController{
    var accommodationData: [String: AnyObject]!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var noInternet: UILabel!
    let internetConnection = InternetConnection()
    override func viewDidLoad() {
        super.viewDidLoad()
        if InternetConnection.isConnectedToNetwork() {
            noInternet.alpha = 0
            
        } else{
            self.PresentAlertController(title: "Something went wrong", message: "Please Check you internet connection ", actionTitle: "Got it")
            return
        }
       
        let url = NSURL (string: (accommodationData["url"] as? String)!)
        let requestObj = URLRequest(url: url! as URL)
        webView.loadRequest(requestObj)
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


class AtivityWebViewController: UIViewController {
    var ativityData: [String: AnyObject]!
    @IBOutlet weak var noInternet: UILabel!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if InternetConnection.isConnectedToNetwork() {
            noInternet.alpha = 0
            print("have internet")
        } else{
            self.PresentAlertController(title: "Something went wrong", message: "Please Check you internet connection ", actionTitle: "Got it")
            return
        }

        let url = NSURL (string: (ativityData["url"] as? String)!)
        let requestObj = URLRequest(url: url! as URL)
        webView.loadRequest(requestObj)
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



class PropertyWebViewController: UIViewController {
    var propertyData: [String: AnyObject]!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var noInternet: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if InternetConnection.isConnectedToNetwork() {
            
            noInternet.alpha = 0
        } else{
            self.PresentAlertController(title: "Something went wrong", message: "Please Check you internet connection ", actionTitle: "Got it")
            return
        }

        let url = NSURL (string: (propertyData["url"] as? String)!)
        let requestObj = URLRequest(url: url! as URL)
        webView.loadRequest(requestObj)
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
 }








