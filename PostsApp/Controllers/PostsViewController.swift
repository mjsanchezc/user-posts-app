//
//  PostsViewController.swift
//  PostsApp
//
//  Created by Maria Jose Sanchez Cairazco on 3/12/22.
//

import Foundation
import Alamofire
import UIKit

class PostsViewController: UIViewController {
    @IBOutlet private weak var userNameLabel: UILabel?
    @IBOutlet private weak var userPhoneLabel: UILabel?
    @IBOutlet private weak var userMailLabel: UILabel?
    @IBOutlet private weak var tableView: UITableView?
    
    private let session = Session()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var posts: [Post] = []
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPosts()
        setUserDetails()
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setUserDetails() {
        if let user = user {
            userNameLabel?.text = user.name
            userPhoneLabel?.text = user.phone
            userMailLabel?.text = user.email
        }
    }
    
    private func getPosts() {
        var params: Parameters = [:]
        
        if let userId = user?.id {
             params = ["userId": userId]
        }
        
        AF.request(URLs.posts.rawValue, method: .get, parameters: params, headers: nil).responseDecodable(of: [Post].self) { response in
            if let responseData = response.data {
                do {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    self.posts = try self.decoder.decode([Post].self, from: responseData)
                    self.tableView?.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// Table delegate methods
extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.load(posts[indexPath.row])
        
        return cell
    }
}

