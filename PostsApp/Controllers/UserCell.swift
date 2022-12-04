//
//  UserCell.swift
//  PostsApp
//
//  Created by Maria Jose Sanchez Cairazco on 3/12/22.
//

import UIKit

protocol PostsViewDelegate {
    func seePosts(user: User)
}

class UserCell: UITableViewCell {
    @IBOutlet private weak var userNameLabel: UILabel?
    @IBOutlet private weak var userPhoneLabel: UILabel?
    @IBOutlet private weak var userMailLabel: UILabel?
    private var user: User?
    var delegate: PostsViewDelegate?
    
    func load(_ user: User) {
        self.user = user
        userNameLabel?.text = user.name
        userPhoneLabel?.text = user.phone
        userMailLabel?.text = user.email
    }
    
    @IBAction func onSeePostsTapped(_ sender: Any) {
        if let user = user {
            delegate?.seePosts(user: user)
        }
    }
}
