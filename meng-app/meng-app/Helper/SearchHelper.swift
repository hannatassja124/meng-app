//
//  SearchHelper.swift
//  meng-app
//
//  Created by Arya Ilham on 24/08/21.
//

import UIKit

class SearchHelper{
    static func createSearchController() -> UISearchController{
        let searchController = UISearchController()
        searchController.loadViewIfNeeded()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        
        return searchController
    }
}
