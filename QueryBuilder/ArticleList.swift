//
//  ArticleList.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/28/23.
//

import SwiftUI

struct ArticleList: View {
    @State var articles: [Article] = [
        Article(id: UUID().uuidString, author: "Test 1", postedAt: Date(), likes: 50, isStarred: true),
        Article(id: UUID().uuidString, author: "Test 2", postedAt: Date(), likes: 50, isStarred: false),
        Article(id: UUID().uuidString, author: "Test 3", postedAt: Date(), likes: 100, isStarred: false)
    ]
    
    @State var filteredArticles: [Article]?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredArticles ?? articles) { article in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(article.author)
                            Text(article.postedAt.formatted())
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(article.likes) likes")
                            Text(article.isStarred ? "Starred": "Not starred")
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Articles")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    QueryFilterView(allItems: $articles, filteredItems: $filteredArticles)
                }
            }
        }
    }
}
struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList()
    }
}
