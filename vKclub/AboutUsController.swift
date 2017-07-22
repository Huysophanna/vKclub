//
//  TableViewController.swift
//  vKclub
//
//  Created by HuySophanna on 20/7/17.
//  Copyright © 2017 WiAdvance. All rights reserved.
//

import UIKit
import Foundation

class AboutUsTableCell: UITableViewCell {
    @IBOutlet weak var Imageitem: UIImageView!
    
    @IBOutlet weak var titleItem: UILabel!
    
    
    @IBOutlet weak var decriptionItem: UITextView!
    
    
}

class AccommodationController:  UITableViewController {
    
    var accommodationData = [[String: AnyObject]]()
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
        print(accommodationData)
      
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
        return accommodationData.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "accommodationTableView", for: indexPath) as! AboutUsTableCell
       
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
}
class ActivityController: UITableViewController {
    
    var accommodationData = [[String: AnyObject]]()
    var indexOfCellToExpand: Int!
    var expandedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexOfCellToExpand = -1
        let path =  Bundle.main.path(forResource: "AboutUs", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        accommodationData = jsonResult["activity"] as! [[String: AnyObject]]
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
        print(accommodationData)
        
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
        return accommodationData.count
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
}
class  ProyotypeController: UITableViewController {
    
    var accommodationData = [[String: AnyObject]]()
    var indexOfCellToExpand: Int!
    var expandedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexOfCellToExpand = -1
        let path =  Bundle.main.path(forResource: "AboutUs", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        accommodationData = jsonResult["property"] as! [[String: AnyObject]]
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
        print(accommodationData)
        
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
        return accommodationData.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "proyotypeTableView", for: indexPath) as! AboutUsTableCell
        
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
}



