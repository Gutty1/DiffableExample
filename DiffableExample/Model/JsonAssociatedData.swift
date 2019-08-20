//
//  JsonAssociatedData.swift
//  GitHubRepos
//
//  Created by Arie Guttman on 30/08/2017.
//  Copyright © 2017 Arie Guttman. All rights reserved.
//

import Foundation
struct JsonAssociatedData : Codable{
    let totalCount: Double
    let incompleteResults: Bool
    let repos: Array<Repository>
    
    //MARK: - required for JSON mapping
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case repos = "items"
        
    }
}
