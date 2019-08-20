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
        
        //configure avatar
//        if !( repo.repoOwner.avatarUrl != nil && repo.repoOwner.avatarUrl!.isEmpty) {
//            viewModel.getAvatarImageForOwner(ownerId: repo.repoOwner.ownerId, avatarUrl: repo.repoOwner.avatarUrl!) { (image) in
//                DispatchQueue.main.async {
//                    if let avatarImage = image {
//                            UIView.transition(with: avatarImageView,
//                                              duration: 1,
//                                              options: .transitionCrossDissolve,
//                                              animations: {
//                                               avatarImageView.image = avatarImage
//                            },
//                                              completion: nil)
//
//                    }
//                }
//            }
//        }
    }
    
}
