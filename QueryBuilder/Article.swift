//
//  Article.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/25/23.
//

import Foundation

final class Article: Identifiable, Queryable {
    var id: String
    var author: String
    var postedAt: Date
    var likes: Int
    var isStarred: Bool
    
    var queryableParameters: [PartialKeyPath<Article>: any IsComparable.Type] = [
        \Article.author: String.self,
        \Article.postedAt: Date.self,
        \Article.likes: Int.self,
        \Article.isStarred: Bool.self
    ]
    var queryNode: AnyQueryNode? = nil
    
    init(id: String, author: String, postedAt: Date, likes: Int, isStarred: Bool) {
        self.id = id
        self.author = author
        self.postedAt = postedAt
        self.likes = likes
        self.isStarred = isStarred
    }
}

