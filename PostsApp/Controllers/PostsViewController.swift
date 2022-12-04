//
//  PostsViewController.swift
//  PostsApp
//
//  Created by Maria Jose Sanchez Cairazco on 3/12/22.
//

import Foundation
import Alamofire
import CoreData
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
        
        getPostsCoreData()
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
    
    private func getPostsRequest() {
        var params: Parameters = [:]
        
        if let userId = user?.id {
             params = ["userId": userId]
        }
        
        AF.request(URLs.posts.rawValue, method: .get, parameters: params, headers: nil).responseDecodable(of: [Post].self) { response in
            if let responseData = response.data {
                do {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    self.posts = try self.decoder.decode([Post].self, from: responseData)
                    self.savePostsCoreData(self.posts)
                    self.tableView?.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func savePostsCoreData(_ posts: [Post]) {
        for post in posts {
            let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let cdPost = CPosts(context: context)
            cdPost.setValue(post.id, forKey: #keyPath(CPosts.postId))
            cdPost.setValue(post.userId, forKey: #keyPath(CPosts.userId))
            cdPost.setValue(post.title, forKey: #keyPath(CPosts.title))
            cdPost.setValue(post.body, forKey: #keyPath(CPosts.body))
        }
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    private func getPostsCoreData() {
        let postsFetch: NSFetchRequest<CPosts> = CPosts.fetchRequest()
        let sortById = NSSortDescriptor(key: #keyPath(CPosts.postId), ascending: true)
        postsFetch.sortDescriptors = [sortById]
        do {
            let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try context.fetch(postsFetch)
            let filteredPosts = transformPosts(results)
            
            if results.count == 0 || filteredPosts.isEmpty {
                getPostsRequest()
            } else {
                posts = filteredPosts
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    private func transformPosts(_ posts: [CPosts]) -> [Post] {
        var returnPosts: [Post] = []
        
        for post in posts {
            if let userId = user?.id, post.userId == userId {
                let transformedPost = Post()
                transformedPost.id = Int(post.postId)
                transformedPost.userId = Int(post.userId)
                transformedPost.title = post.title
                transformedPost.body = post.body
                
                returnPosts.append(transformedPost)
            }
        }
        
        return returnPosts
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

