//
//  Owner.swift
//  GitHubRepos
//
//  Created by Arie Guttman on 29/08/2017.
//  Copyright © 2017 Arie Guttman. All rights reserved.
//

import Foundation


class Owner : NSObject, NSCoding, Codable{
    //MARK: - properties
    
    /// owner Id
    let ownerId: Int
    /// username used for login
    let login: String
    /// String URL for avatar picture
    let avatarUrl: String?
    
    
    //MARK: - required for JSON mapping
    enum CodingKeys: String, CodingKey {
        case ownerId = "id"
        case login
        case avatarUrl = "avatar_url"
        
        
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        
        self.ownerId = aDecoder.decodeInteger(forKey: Constants.CodingString.ownerId)
        self.login = aDecoder.decodeObject(forKey:Constants.CodingString.login) as! String
        self.avatarUrl = aDecoder.decodeObject(forKey:Constants.CodingString.avatarUrl) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ownerId, forKey: Constants.CodingString.ownerId)
        aCoder.encode(self.login, forKey: Constants.CodingString.login)
        aCoder.encode(self.avatarUrl, forKey: Constants.CodingString.avatarUrl)
 
    }
}
