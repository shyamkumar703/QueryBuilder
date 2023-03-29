//
//  ArticleList.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/28/23.
//

import SwiftUI

struct ArticleList: View {
    @State private var showFilterSheet: Bool = false
    
    var articles: [Article] = [
        Article(id: UUID().uuidString, author: "Test 1", postedAt: Date(), likes: 50, isStarred: true),
        Article(id: UUID().uuidString, author: "Test 2", postedAt: Date(), likes: 50, isStarred: false),
        Article(id: UUID().uuidString, author: "Test 3", postedAt: Date(), likes: 100, isStarred: false)
    ]
    
    @State var filteredArticles: [Article]?
    
    @State private var userFilters: [(String, QueryNode<Article>)] = QueryBuilderSDK.fetchFilters(for: Article.self)
    
    var filterOptions: [FilterOptions] {
        var options: [FilterOptions] = userFilters.map({ FilterOptions.query($0) })
        options.append(.addNew)
        return options
    }
    
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
                    Menu(
                        content: {
                            ForEach(filterOptions) { option in
                                switch option {
                                case .query(let (name, node)):
                                    Button(name) {
                                        filteredArticles = articles.filter({ node.evaluate($0) })
                                    }
                                case .addNew:
                                    Button("Add filter") {
                                        showFilterSheet.toggle()
                                    }
                                }
                            }
                        },
                        label: {
                            Text("Filter")
                        }
                    )
                }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            QueryBuilderView<Article>(userFilters: $userFilters, elements: articles)
        }
    }
}

extension ArticleList {
    enum FilterOptions: Identifiable {
        case query((String, QueryNode<Article>))
        case addNew
        
        var id: String {
            switch self {
            case .query(let pair): return pair.1.id
            case .addNew: return "addNew"
            }
        }
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList()
    }
}
