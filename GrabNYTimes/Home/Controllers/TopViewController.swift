//
//  TopViewController.swift
//  GrabNYTimes
//
//  Created by Jitesh Sharma on 04/10/18.
//  Copyright © 2018 Jitesh Sharma. All rights reserved.
//

import UIKit
import SDWebImage

class TopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    @IBOutlet weak var homeTableView: UITableView!
    
        var articleArray = Array<AnyObject>()
        var refreshControl: UIRefreshControl!
        var filteredArray = Array<AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        homeTableView.addSubview(refreshControl)
        self.registerNibs()
        self.getMostViewedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        filteredArray = articleArray
        homeTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    @objc func refreshArticles() {
        self.getMostViewedData()
    }
    
    func getMostViewedData() {
        
        let requestString = String(format:baseURL,NY_API_Key)
        
        if (SharedManager.shared.isInternetConnectivityAvailable() == false) { return
        } else {
            
            print(ProcessInfo.processInfo.environment)
                self.showAnimatingIndicator()
                DispatchQueue.global(qos: .userInitiated).async
                    {
                        NetworkManager.sharedInstance.sendUrlRequestToServer(url: requestString, parameters: nil, taskType: 1, complitionHandler: { (response,status) in
                            if(status)
                            {
                                print("Success")
                                self.handleResponseForMostViewed(response as! NSDictionary)
                            }
                            else
                            {
                                DispatchQueue.main.async
                                    {
                                        self.stopAnimatingIndicator()
                                        self.refreshControl.endRefreshing()
                                }
                            }
                            
                        })
                        
                        
                }
            }
        }
    
    func handleResponseForMostViewed(_ responseObject: NSDictionary)
    {

        filteredArray.removeAll()
        articleArray.removeAll()
        let articles: Array = responseObject.value(forKey: "results") as! Array<AnyObject> 
        for item in articles {
            var article = Dictionary<String,String>()
            article["url"] = item["url"] as? String
            article["byline"] = item["byline"] as? String
            article["title"] = item["title"] as? String
            article["published_date"] = item["published_date"] as? String
            let arr: Array = (item["media"] as? Array<AnyObject>)!
            let object: AnyObject = (arr.first)!
            let mediaArray: Array = (object["media-metadata"] as? Array<AnyObject>)!
            for mediaItem in mediaArray {
                if (mediaItem["format"] as! String).elementsEqual("Standard Thumbnail") {
                    let mediaUrl: String = (mediaItem["url"] as? String)!
                    article["mediaUrl"] = mediaUrl
                }
            }
            articleArray.append(article as AnyObject)
        }
        DispatchQueue.main.async
            {
                self.filteredArray = self.articleArray
                self.homeTableView.reloadData()
                self.stopAnimatingIndicator()
                self.refreshControl.endRefreshing()
        }
    }
    
    func registerNibs() {
        
        let homeCustomTableViewCellNib = UINib.init(nibName: "HomeCustomTableViewCell", bundle: Bundle.main)
        homeTableView.register(homeCustomTableViewCellNib, forCellReuseIdentifier: "HomeCustomTableViewCell")
    }
    
    // MARK:  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeCustomTableViewCell") as! HomeCustomTableViewCell
        if filteredArray.count > 0 {
            
            cell.titleLabel.text = filteredArray[indexPath.row].value(forKey: "title") as? String
            
            let byText: String = filteredArray[indexPath.row].value(forKey: "byline") as! String
            let dateText: String = filteredArray[indexPath.row].value(forKey: "published_date") as! String
            let text = String(format: "%@\n%@", byText, dateText)
            let at = NSMutableAttributedString(string: text)
            let p1 = NSMutableParagraphStyle()
            let p2 = NSMutableParagraphStyle()
            p1.alignment = .left
            p2.alignment = .right
            at.addAttribute(.paragraphStyle, value: p1, range: NSRange(location: 0, length: byText.count))
            at.addAttribute(.paragraphStyle, value: p2, range: NSRange(location: byText.count, length: dateText.count))
            cell.descriptionLabel?.numberOfLines = 0
            cell.descriptionLabel?.attributedText = at
            cell.descriptionImageView.sd_setImage(with: URL(string: filteredArray[indexPath.row].value(forKey: "mediaUrl") as! String), placeholderImage: UIImage(named: "placeholder.png"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let webViewController = WebViewController()
        
        webViewController.webURLString = (filteredArray[indexPath.row].value(forKey: "url") as? String)!
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.homeTableView.bounds.size.width, height: 10))
        return view
    }
    
    // MARK:  UISearchBarDelegate
    
    func updateSearchResults(for searchController: UISearchController) {
        print("jbcd")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray.removeAll()
        for item in articleArray {
            let title: String = item["title"] as! String
            if title.contains(searchText) {
                filteredArray.append(item)
            }
        }
        if filteredArray.count < 1 {
            filteredArray = articleArray
        }
        homeTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if filteredArray.count < 1 {
            filteredArray = articleArray
        }
        searchBar.removeFromSuperview()
        homeTableView.reloadData()
    }
    
    // MARK:  IBActions
    
    @IBAction func searchAction(_ sender: Any) {
        
        // Create the search controller and specify that it should present its results in this same view
        let searchController = UISearchController(searchResultsController: nil)
        
        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        
        // Make this class the delegate and present the search
        searchController.searchBar.delegate = self
        searchController.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func showMeMyMenu () {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
        
    }
}
