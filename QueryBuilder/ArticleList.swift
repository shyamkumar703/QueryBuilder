//
//  ArticleList.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/28/23.
//

import SwiftUI

struct ArticleList: View {
    @State private var showFilterSheet: Bool = false
    @State private var showEditFilterSheet: Bool = false
    
    var articles: [Article] = [
        Article(id: UUID().uuidString, author: "Test 1", postedAt: Date(), likes: 50, isStarred: true),
        Article(id: UUID().uuidString, author: "Test 2", postedAt: Date(), likes: 50, isStarred: false),
        Article(id: UUID().uuidString, author: "Test 3", postedAt: Date(), likes: 100, isStarred: false)
    ]
    
    var filteredArticles: [Article]? {
        if let currentFilter {
            return articles.filter({ currentFilter.1.evaluate($0) })
        } else {
            return nil
        }
    }
    
    @State private var userFilters: [(String, QueryNode<Article>)] = QueryBuilderSDK.fetchFilters(for: Article.self)
    
    var filterOptions: [FilterOptions] {
        var options: [FilterOptions] = userFilters.map({ FilterOptions.query($0) })
        options.append(.addNew)
        if currentFilter != nil {
            options.append(.editCurrentFilter)
            options.append(.clearFilter)
        }
        return options
    }
    
    @State private var currentFilter: (String, QueryNode<Article>)?
    
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
                                    Button(
                                        action: {
                                            if name != currentFilter?.0 {
                                                currentFilter = (name, node)
                                            }
                                        },
                                        label: {
                                            Text(name)
                                        }
                                    )
                                case .clearFilter:
                                    Button(
                                        role: .destructive,
                                        action: {
                                            currentFilter = nil
                                        },
                                        label: {
                                            HStack{
                                                Text("Clear filter")
                                                Image(systemName: "xmark.circle")
                                            }
                                        }
                                    )
                                case .addNew:
                                    Button(
                                        action: {
                                            showFilterSheet.toggle()
                                        },
                                        label: {
                                            HStack{
                                                Text("Add filter")
                                                Image(systemName: "plus.circle")
                                            }
                                        }
                                    )
                                case .editCurrentFilter:
                                    if let currentFilter {
                                        Button(
                                            action: {
                                                showEditFilterSheet.toggle()
                                            },
                                            label: {
                                                HStack{
                                                    Text("Edit \"\(currentFilter.0)\"")
                                                    Image(systemName: "pencil.circle")
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        },
                        label: {
                            if let currentFilter {
                                Text("Filter: \(currentFilter.0)")
                            } else {
                                Text("Filter")
                            }
                        }
                    )
                }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            QueryBuilderViewModel<Article>(
                userFilters: $userFilters,
                currentFilter: $currentFilter,
                elements: articles
            ).createView()
        }
        .sheet(isPresented: $showEditFilterSheet) {
            if let currentFilter {
                QueryBuilderViewModel<Article>(
                    userFilters: $userFilters,
                    currentFilter: $currentFilter,
                    elements: articles,
                    node: currentFilter.1,
                    name: currentFilter.0
                ).createView()
            }
        }
    }
}

extension ArticleList {
    enum FilterOptions: Identifiable {
        case query((String, QueryNode<Article>))
        case addNew
        case editCurrentFilter
        case clearFilter
        
        var id: String {
            switch self {
            case .query(let pair): return pair.1.id
            case .clearFilter: return "clearFilter"
            case .addNew: return "addNew"
            case .editCurrentFilter: return "editCurrentFilter"
            }
        }
    }
}

struct ArticleList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList()
    }
}
