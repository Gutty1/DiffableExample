//
//  Page.swift
//  GitHubRepos
//
//  Created by Arie Guttman on 01/09/2017.
//  Copyright © 2017 Arie Guttman. All rights reserved.
//

import Foundation

struct Page {
    ///page period
    let period: Period
    ///Next page number to fetch from server
    private var nextPage: Int
    ///Indicates that last page was fetched
    private var gotLastPage: Bool
    
    init(period:Period) {
        self.period = period
        self.nextPage = 1
        self.gotLastPage = false
    }
    ///increment page number
    mutating func incrementPage(){
    nextPage += 1
    }
    
    ///set last page reached
    mutating func setLastPage(){
        gotLastPage = true
    }
    /// indicates if last page has been reached already
    func lastPageFetched()->Bool{
        return gotLastPage
    }
    ///get page number to fetch
    func  getPageNumberToFetch()-> Int {
        return nextPage
    }
    
    
}

extension Page: Equatable {}

func ==(lhs: Page, rhs: Page) -> Bool {
    let areEqual = lhs.period == rhs.period
    return areEqual
}
