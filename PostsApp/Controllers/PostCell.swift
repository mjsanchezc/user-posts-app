//
//  PostCell.swift
//  PostsApp
//
//  Created by Maria Jose Sanchez Cairazco on 3/12/22.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var bodyLabel: UILabel?
    
    func load(_ post: Post) {
        titleLabel?.text = post.title
        bodyLabel?.text = post.body
    }
}
