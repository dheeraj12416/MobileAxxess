//
//  ViewController.swift
//  MobileAxxess
//
//  Created by Nannapuraju, Dheeraj R on 9/26/20.
//  Copyright © 2020 Dheeraj. All rights reserved.
//

import UIKit

enum SortType: Int {
    case Text = 1, Image
}

class ViewController: UIViewController {

    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var homeListTableView: UITableView!
    let homeContentTableViewCell = "HomeContentTableViewCell"
    var homeViewListArray = Array<HomeViewData>()
    var currentSortType = SortType.Text
    var pageOffset = 0
    var pageLimit = 5
    private let refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
        registerTableViewCells()
        fetchData()
    }
    
    func fetchData()
    {
        if (pageOffset == 0) {
            homeViewListArray.removeAll()
        }
        DatabaseUtilities().getHomeDataFromDB (sortType: currentSortType.rawValue, offSet: pageOffset, limit: pageLimit, completionHandler:{ (status, homeData, error) in
            if(status)
            {
                sortByButton.isHidden = false
                for(_, element) in homeData!.enumerated()
                {
                    homeViewListArray.append(element)
                }
                homeListTableView.reloadData()
            }
            else if homeViewListArray.count == 0
            {
                getHomeData(false)
            }
        })
    }
    
    @IBAction func sortTapped(_ sender: UIButton) {
        if currentSortType == SortType.Text {
            currentSortType = SortType.Image
            sender.isSelected = true
        }
        else
        {
            currentSortType = SortType.Text
            sender.isSelected = false
        }
        homeListTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        self.pageOffset = 0
        fetchData()
    }
    
    // MARK: - ConfigureTableView
    func configureTableView()
    {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            homeListTableView.refreshControl = refreshControl
        } else {
            homeListTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        homeListTableView.cellLayoutMarginsFollowReadableWidth = false

        homeListTableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: homeListTableView.frame.width, height: 1))
    }
    
    @objc private func refreshData(_ sender: Any) {
        getHomeData(true)
    }
    
    func registerTableViewCells()
    {
        homeListTableView.register(UINib(nibName: "HomeContentTableViewCell", bundle: nil), forCellReuseIdentifier:homeContentTableViewCell )
    }
    
    //Mark: - Invoke Web Service To Get Home Screen Data
    func getHomeData(_ isRefreshing : Bool)
    {
        if !isRefreshing {
          Functions().showHud()
        }
        APIHandler().getHomeList(parameters: [:], completionHandler: {(success, data, error) in
            DispatchQueue.main.async {
                if !isRefreshing {
                  Functions().hideHud()
                }
                if success
                {
                    DatabaseUtilities().saveHomeDataInDB(list: data!) { (status, error) in
                        if(status)
                        {
                            self.refreshControl.endRefreshing()
                            self.pageOffset = 0
                            self.fetchData()
                        }
                    }
                }
            }
        })
    }
    
    func load(_ indexPath : Int) {
        let homeView = (self.homeViewListArray[indexPath])
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL.init(string: homeView.text!)!) {
                DispatchQueue.main.async {
                    homeView.imageDownloaded = true
                    homeView.imageData = data
                    DatabaseUtilities().updateHomeDataInDB(response: homeView) { (status, error) in
                    }
                    self?.homeListTableView.reloadRows(at: [IndexPath.init(row: indexPath, section: 0)], with: .none)
                }
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //If we reach the end of the table.
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            self.pageOffset = 1 + self.pageOffset + self.pageLimit
            fetchData()
        }
    }
}

extension ViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController.init(nibName: "DetailViewController", bundle: nil)
        vc.data = (homeViewListArray[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewListArray.count > 0 ? (homeViewListArray.count) : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeContentTableViewCell, for: indexPath) as! HomeContentTableViewCell
        let data = (homeViewListArray[indexPath.row])
        cell.configureView(data)
        if(data.type == "image" && !data.imageDownloaded!)
        {
            load(indexPath.row)
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}
