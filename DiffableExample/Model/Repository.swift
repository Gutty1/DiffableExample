//
//  Repository.swift
//  GitHubRepos
//
//  Created by Arie Guttman on 29/08/2017.
//  Copyright © 2017 Arie Guttman. All rights reserved.
//

import Foundation

class Repository : Codable{
    //MARK: - properties
    
    ///Repository id
    let repoId: Int
    ///Repository full path name
    let fullRepoName: String
    ///Repository name
    let repoName:String
    ///Indicates if repository is private
    let privateRepo: Bool
    ///Main URL string for repository
    let mainUrlString: String
    ///Repository discription
    let repoDescription: String?
    ///Number of stars
    let stargazersCount: Int
    ///Repository language
    let language: String?
    ///Number of forks
    let forks: Int
    ///Creation date
    let createdAt: Date
    ///Repository owner details
    let repoOwner: Owner
    
    //MARK: - required for JSON mapping
    enum CodingKeys: String, CodingKey {
        case repoId = "id"
        case fullRepoName = "full_name"
        case repoName = "name"
        case privateRepo = "private"
        case mainUrlString = "html_url"
        case repoDescription = "description"
        case stargazersCount = "stargazers_count"
        case language
        case forks
        case createdAt = "created_at"
        case repoOwner = "owner"
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        
        self.repoId = aDecoder.decodeInteger(forKey: Constants.CodingString.repoId)
        self.fullRepoName = aDecoder.decodeObject(forKey:Constants.CodingString.fullRepoName) as! String
        self.repoName = aDecoder.decodeObject(forKey:Constants.CodingString.repoName) as! String
        self.privateRepo = aDecoder.decodeBool(forKey:Constants.CodingString.privateRepo)
        self.mainUrlString = aDecoder.decodeObject(forKey:Constants.CodingString.mainUrlString) as! String
        self.repoDescription = aDecoder.decodeObject(forKey:Constants.CodingString.repoDescription) as? String
        self.stargazersCount = aDecoder.decodeInteger(forKey:Constants.CodingString.stargazersCount)
        self.language = aDecoder.decodeObject(forKey:Constants.CodingString.language) as? String
        self.forks = aDecoder.decodeInteger(forKey:Constants.CodingString.forks) 
        self.createdAt = aDecoder.decodeObject(forKey:Constants.CodingString.createdAt) as! Date
        self.repoOwner = aDecoder.decodeObject(forKey:Constants.CodingString.repoOwner) as! Owner
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.repoId, forKey: Constants.CodingString.repoId)
        aCoder.encode(self.fullRepoName, forKey: Constants.CodingString.fullRepoName)
        aCoder.encode(self.repoName, forKey: Constants.CodingString.repoName)
        aCoder.encode(self.privateRepo, forKey: Constants.CodingString.privateRepo)
        aCoder.encode(self.mainUrlString, forKey: Constants.CodingString.mainUrlString)
        aCoder.encode(self.repoDescription, forKey: Constants.CodingString.repoDescription)
        aCoder.encode(self.stargazersCount, forKey: Constants.CodingString.stargazersCount)
        aCoder.encode(self.language, forKey: Constants.CodingString.language)
        aCoder.encode(self.forks, forKey: Constants.CodingString.forks)
        aCoder.encode(self.createdAt, forKey: Constants.CodingString.createdAt)
        aCoder.encode(self.repoOwner, forKey: Constants.CodingString.repoOwner)
        
    }
}


extension Repository : Hashable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.repoId == rhs.repoId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(repoId)
    }
}
