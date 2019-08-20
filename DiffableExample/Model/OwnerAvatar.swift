//
//  OwnerAvatar.swift
//  GitHubRepos
//
//  Created by Arie Guttman on 31/08/2017.
//  Copyright © 2017 Arie Guttman. All rights reserved.
//

import Foundation
import UIKit

class OwnerAvatar : NSObject, NSCoding{
    //MARK: - properties
    
    /// owner Id
    var ownerId: Int
    
    /// String URL for avatar picture
    var avatarImage: UIImage?
    
    
     init(ownerId: Int) {
        self.ownerId = ownerId
        self.avatarImage = nil
        super.init()
    }
    
    
    
    public required init?(coder aDecoder: NSCoder) {
        
        self.ownerId = aDecoder.decodeInteger(forKey: Constants.CodingString.ownerId) 
 
        //decode avatar
        if let avatarData = aDecoder.decodeObject(forKey: Constants.CodingString.avatarData) as? Data {
            self.avatarImage = UIImage(data: avatarData)
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ownerId, forKey: Constants.CodingString.ownerId)
        //encode avatar
        if let avatarImage = self.avatarImage {
            let avatarData = avatarImage.jpegData(compressionQuality: 1.0)
//            let avatarData = UIImagePNGRepresentation(avatarImage)
            aCoder.encode(avatarData, forKey: Constants.CodingString.avatarData)
        }
    }
}


