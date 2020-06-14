//
//  ViewController.swift
//  DiffableExample
//
//  Created by Arie Guttman on 19/08/2019.
//  Copyright © 2019 Arie Guttman. All rights reserved.
//

import UIKit
import NetworkPackage

enum Section: CaseIterable {
    case main
}

///Supported period types
enum Period {
    case Day
    case Week
    case Month
}

enum FilterType: Int {
    case time = 0
    case popularity
}

///Supported repos period segments
enum RepoSegments: Int {
    case Day = 0
    case Week
    case Month
}

class ViewController: UIViewController {
    
    @IBOutlet weak var filterSegment: UISegmentedControl!
    
    @IBOutlet weak var popularitySegment: UISegmentedControl!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    #if NEW
    var dataSource: UITableViewDiffableDataSource<Section, Repository>! = nil
    #endif
    static let reuseIdentifier = "ReposTableViewCell"
    
    var repo: Array<Repository>?
    var filteredRepo: Array<Repository>?
    var olderDate = Date()
    var timer: Timer?
    var popularitySelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "GitHub Repositories"
        navigationItem.largeTitleDisplayMode = .always
        repo = Array<Repository>()
        filteredRepo = Array<Repository>()
        filterSegment.selectedSegmentIndex = 2
        popularitySegment.selectedSegmentIndex = 0
        popularitySelected = popularitySegment.selectedSegmentIndex == 1
        didTapSegment(index: filterSegment.selectedSegmentIndex)
        setupTable()
        #if NEW
        configureDataSource()
        updateUI(animated: false)
        #endif
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
        internalTimerHandler()
    }
    
    
    //MARK: - Actions
    
    @IBAction func didTapSegment(_ sender: UISegmentedControl) {
        didTapSegment(index: sender.selectedSegmentIndex)
        #if NEW
        updateUI()
        #else
        filteredRepo = filterRepo()
        tableView.reloadData()
        #endif
        
    }
    
    @IBAction func didTapPopularitySegment(_ sender: UISegmentedControl) {
        didTapPopularitySegment(index: sender.selectedSegmentIndex)
        #if NEW
        updateUI()
        #else
        filteredRepo = filterRepo()
        tableView.reloadData()
        #endif
    }
    
    
    @objc func timerHandler(timer: Timer) {
        internalTimerHandler()
    }
    
    func internalTimerHandler() {
        getRepos(period: .Month) {  [weak self] (result, error) in
            if let error = error {
                print("error: \(error)")
            } else if let result = result {
                self?.repo = result
                #if NEW
                self?.updateUI()
                #else
                DispatchQueue.main.async {
                    self?.filteredRepo = self?.filterRepo()
                    self?.tableView.reloadData()
                }
                #endif
                
            }
        }
    }
    
}

extension ViewController {
    //MARK: - private implementation
    
    private func didTapSegment(index: Int) {
        switch index {
        case 0:
            olderDate = Date().addDays(days: -1)
        case 1:
            olderDate = Date().addDays(days: -7)
        case 2:
            olderDate = Date().addMonths(months: -1)
        default:
            olderDate = Date().addDays(days: -1)
        }
        
    }
    
    private func didTapPopularitySegment(index: Int) {
        popularitySelected = index == 1
        
    }
    
    private func filterRepo() -> Array<Repository> {
        guard let repo = repo else { return Array<Repository>()}
        
        let filterRepo = repo.filter{$0.createdAt >= olderDate}
        
        if popularitySelected {
            return filterRepo.sorted(by: {$0.stargazersCount > $1.stargazersCount})
        } else {
            return filterRepo.sorted(by: {$0.createdAt > $1.createdAt})
        }
    }
    
    private func setupTable() {
        tableView.register(UINib(nibName: ViewController.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ViewController.reuseIdentifier)
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        #if NEW
        #else
        tableView.dataSource = self
        #endif
        
        
    }
    
    private func configureDataSource() {
        #if NEW
        dataSource = UITableViewDiffableDataSource
            <Section, Repository>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath, item: Repository) -> UITableViewCell? in
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ViewController.reuseIdentifier,
                    for: indexPath) as? ReposTableViewCell else {return UITableViewCell() }
                
                cell.config(repo: item)
                return cell
        }
        dataSource.defaultRowAnimation = .fade
        #endif
        
    }
    
    func updateUI(animated: Bool = true) {
        #if NEW
        DispatchQueue.global().async {
            let filteredRepo = self.filterRepo()
            
            var currentSnapshot = NSDiffableDataSourceSnapshot<Section, Repository>()
            
            currentSnapshot.appendSections([.main])
            currentSnapshot.appendItems(filteredRepo, toSection: .main)
            
            self.dataSource.apply(currentSnapshot, animatingDifferences: animated)
        }
        #endif
    }
    
    
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepo?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.reuseIdentifier) as? ReposTableViewCell,
            let repo = filteredRepo
            else { return UITableViewCell()}
        let rep = repo[indexPath.row]
        cell.config(repo: rep)
        return cell
    }
}



extension ViewController {
    //MARK: - API implementation
    
    ///get from API the repos for the requested period
    private func getDataFromAPI(period:Period, completion: @escaping (( _ jsonObject:JsonAssociatedData?, _ error: Error?)->Void)) {
        let connection = ConnectionManager()
        
        //set REST request
        ///URL in string format for the connection
        let urlString = Constants.hostAPI + "/search/repositories"
        
        let requestedDate = Date().addMonths(months: -1)
        
        var params = Dictionary<String,String>()
        params["q"] = "created:>\(requestedDate.asQueryDate!)"
        params["sort"] = "stars"
        params["order"] = "desc"
        
        let request = Request(method: .get, path: urlString, params: params, header: Dictionary<String,String>())
        
        connection.execute(request: request) { (response) in
            if let error = response.error {
                print("Error: \(error)")
            } else if let data = response.data {
                //parse the json
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do{
                    let jsonParsed = try decoder.decode(JsonAssociatedData.self, from: data)
                    
                    completion(jsonParsed, nil)
                    return
                } catch let jsonError {
                    completion(nil, jsonError)
                    return
                }
            } else {
                completion(nil, iError.RuntimeError(reason: "Wrong Data returned from Server"))
                return
            }
            
        }
    }
    
    
    
    func getRepos(period:Period, completion: @escaping ((_ newData:Array<Repository>?,_ error: Error?)->Void))  {
        //Get data from server
        getDataFromAPI(period: period) { [weak self] (jsonParsedObject, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil,error)
                return
            } else {
                if let newRepos = jsonParsedObject?.repos  {
                    self?.repo = newRepos
                    
                    //update caller that new data arrived
                    return completion(newRepos,nil)
                    
                } else {
                    //no data arrived
                    return completion(nil,iError.NoDataArrived)
                }
            }
        }
    }
    
    
}
