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

///Supported repos period segments
enum RepoSegments: Int {
    case Day = 0
    case Week
    case Month
}

class ViewController: UIViewController {
    
    @IBOutlet weak var filterSegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: UITableViewDiffableDataSource<Section, Repository>! = nil
    static let reuseIdentifier = "ReposTableViewCell"
    
    var repo: Array<Repository>?
    var filteredRepo: Array<Repository>?
    var olderDate = Date()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "GitHub Repositories"
        repo = Array<Repository>()
        filteredRepo = Array<Repository>()
        filterSegment.selectedSegmentIndex = 0
        didTapSegment(index: filterSegment.selectedSegmentIndex)
        setupTable()
//        configureDataSource()
//        updateUI(animated: false)
        getRepos(period: .Month) {  [weak self] (result, error) in
            if let error = error {
                print("error: \(error)")
            } else if let result = result {
                self?.repo = result
//                self?.updateUI()
                DispatchQueue.main.async {
                    self?.filteredRepo = self?.repo?.filter{$0.createdAt >= self?.olderDate ?? Date() }
                    self?.tableView.reloadData()
                }
                
            }
        }
    }

    
    //MARK: - Actions
    
    @IBAction func didTapSegment(_ sender: UISegmentedControl) {
        didTapSegment(index: sender.selectedSegmentIndex)
//        updateUI()
        filteredRepo = repo?.filter{$0.createdAt >= olderDate }
        tableView.reloadData()
        
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
    
    private func setupTable() {
        tableView.register(UINib(nibName: ViewController.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ViewController.reuseIdentifier)
        tableView.dataSource = self
        
        
        
    }
    
    private func configureDataSource() {
        
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

        
    }
    
    func updateUI(animated: Bool = true) {
        guard let repo = repo else { return }
        let filteredRepo = repo.filter{$0.createdAt >= olderDate }
        
        let currentSnapshot = NSDiffableDataSourceSnapshot<Section, Repository>()
        
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(filteredRepo, toSection: .main)
        
        dataSource.apply(currentSnapshot, animatingDifferences: animated)
    }
    
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
