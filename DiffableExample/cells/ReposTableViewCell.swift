//
//  ReposTableViewswift
//  GitHubRepos
//
//  Created by Arie Guttman on 31/08/2017.
//  Copyright © 2017 Arie Guttman. All rights reserved.
//

import UIKit

class ReposTableViewCell: UITableViewCell {
    
    // MARK: - Storyboard properties
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var repoTitleLbl: UILabel!
    @IBOutlet weak var repoNameLbl: UILabel!
    
    @IBOutlet weak var startgazersCountLbl: UILabel!
    @IBOutlet weak var descriptionTitleLbl: UILabel!
    @IBOutlet weak var descriptioinLbl: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    func config(repo: Repository) {
        loginLbl.text = repo.repoOwner.login
        repoTitleLbl.text = "Name:"
        repoNameLbl.text = repo.repoName
        descriptionTitleLbl.text = "Desc:"
        descriptioinLbl.text = repo.repoDescription ?? "No description available"
        startgazersCountLbl.text = "\(repo.stargazersCount)"
        
        favoriteImage.isHidden = true
        
    }
    
}
