//
//  Constants.swift
//  GitHubRepos
//
//  Created by Arie Guttman on 29/08/2017.
//  Copyright © 2017 Arie Guttman. All rights reserved.
//

import Foundation


struct Constants {
    //MARK: - General 
    ///host basic API URL
    static let hostAPI = "https://api.github.com"
    /// used for calculate when to trigger paging mechanism
    static let numberOfReposReminingTillEndOfList = 20
    
    //MARK: -   conding strings
    struct CodingString {
        static let repoId = "repoId"
        static let fullRepoName = "fullRepoName"
        static let repoName = "repoName"
        static let privateRepo = "privateRepo"
        static let mainUrlString = "mainUrlString"
        static let repoDescription = "repoDescription"
        static let stargazersCount = "stargazersCount"
        static let language = "language"
        static let forks = "forks"
        static let createdAt = "createdAt"
        static let repoOwner = "repoOwner"
        static let ownerId = "ownerId"
        static let login = "login"
        static let avatarUrl = "avatarUrl"
        static let avatarData = "avatarData"
        
    }
    //MARK: - Notifications
    struct Notifications {
        static let fetchMoreData = "fetchMoreData"
    }
    struct NotificationInfo {
        static let period = "period"
    }
    
    //MARK: - cells identifies
    struct CellIdentifiers {
        static let reposCell = "reposCell"
    }
    
    //MARK: -   User defaults strings
    struct UserDefaultsString {
        static let favorites = "favorites"
        static let ownerAvatar = "ownerAvatar"
    }
    
    //MARK: -   Paging strings
    struct PagesDict {
        static let day = "day"
        static let week = "week"
        static let month = "month"
        static let page = "page"
        static let last = "last"
    }
    
    //MARK: - HTTP response codes
    enum ResponseStatusCode: Int {
        
        ///Response sucessful
        case HTTP_STATUS_OK = 200
        ///Response created
        case HTTP_STATUS_CREATED = 201
        ///Missing Token response from server
        case HTTP_STATUS_REDIRECT = 300
        case HTTP_STATUS_BAD_REQUEST = 400
        case HTTP_STATUS_AUTHENTICATION_FAILURE = 401
        case HTTP_STATUS_AUTHORIZATION_FAILURE = 403
        case HTTP_STATUS_NOT_FOUND = 404
        case HTTP_STATUS_BAD_SCHEMA = 405
        case HTTP_STATUS_INTERNAL_SERVER_ERROR = 500
        case HTTP_STATUS_BAD_GATEWAY = 502
        case HTTP_STATUS_MOBILE_GATEWAY_DOWN = 503
    }
    
    
    
    
}
//Mark: Notification name extension
extension Notification.Name {
    static let fetchMoreData = Notification.Name(Constants.Notifications.fetchMoreData)
}
