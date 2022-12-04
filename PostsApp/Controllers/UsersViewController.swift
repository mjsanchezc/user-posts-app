//
//  UsersViewController.swift
//  PostsApp
//
//  Created by Maria Jose Sanchez Cairazco on 2/12/22.
//

import Foundation
import Alamofire
import UIKit

private struct UsersViewSegues {
    static let Posts = "segueToPosts"
}

class UsersViewController: UIViewController, PostsViewDelegate {
    @IBOutlet private weak var tableView: UITableView?
    
    private let session = Session()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var users: [User] = []
    private var filteredUsers: [User] = []
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
        initSearchController()
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case UsersViewSegues.Posts:
            let vc = segue.destination as! PostsViewController
            vc.user = sender as? User
            
        default:
            break
        }
    }
    
    private func getUsers() {
        AF.request(URLs.users.rawValue, method: .get, parameters: nil, headers: nil).responseDecodable(of: [User].self) { response in
            if let responseData = response.data {
                do {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    self.users = try self.decoder.decode([User].self, from: responseData)
                    self.tableView?.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar usuario"
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            
            let backgroundView = textField.subviews.first
            backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            backgroundView?.subviews.forEach({ $0.removeFromSuperview() })
            backgroundView?.layer.cornerRadius = 5
            backgroundView?.layer.masksToBounds = true
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    func seePosts(user: User) {
        self.performSegue(withIdentifier: UsersViewSegues.Posts, sender: user)
    }
}

// Table delegate methods
extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.delegate = self
        
        if searchController.isActive {
            cell.load(filteredUsers[indexPath.row])
        } else {
            cell.load(users[indexPath.row])
        }
        
        return cell
    }
}

// Search bar delegate methods
extension UsersViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text ?? ""
        
        filerForSearchText(searchText)
    }
    
    func filerForSearchText(_ searchText: String) {
        filteredUsers = users.filter {
            user in
            if !searchText.isEmpty, let name = user.name {
                let match = name.lowercased().contains(searchText.lowercased())
                
                return match
            } else {
                return false
            }
        }
        
        tableView?.reloadData()
    }
}
