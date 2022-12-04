//
//  DataModel.swift
//  PostsApp
//
//  Created by Maria Jose Sanchez Cairazco on 3/12/22.
//

import Foundation

class User: Codable {
    var id: Int?
    var name: String?
    var phone: String?
    var email: String?
}

class Post: Codable {
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
}
