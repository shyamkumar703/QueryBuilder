//
//  QueryBuilderView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/27/23.
//

import SwiftUI

struct QueryBuilderView<QueryableElement: Queryable>: View {
    @State private var views: [QueryView] = [.predicate(QueryPredicateViewModel<QueryableElement>())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(views) { viewCase in
                    switch viewCase {
                    case .connector(let connector): connector.createView()
                    case .predicate(let predicate): predicate.createView()
                    }
                }
            }
            .navigationTitle("New filter")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            withAnimation {
                                views += [
                                    .connector(ConnectorViewModel()),
                                    .predicate(QueryPredicateViewModel<QueryableElement>())
                                ]
                            }
                        },
                        label: {
                            Image(systemName: "plus")
                        }
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            _ = save()
                        },
                        label: {
                            Text("Save")
                        }
                    )
                }
            }
        }
    }
    
    enum QueryView: Identifiable {
        case predicate(QueryPredicateViewModel<QueryableElement>)
        case connector(ConnectorViewModel)
        
        var id: UUID {
            switch self {
            case .predicate(let qpvm): return qpvm.id
            case .connector(let cvm): return cvm.id
            }
        }
    }
    
    func save() -> QueryNode<QueryableElement>? {
        var node: QueryNode<QueryableElement>?
        switch views.first {
        case .predicate(let predicateView):
            node = predicateView.createQueryNode()
        default:
            // TODO: - Error handle appropriately
            return nil
        }
        
        var currentIndex = 2
        while currentIndex < views.count {
            if case let .connector(cvm) = views[currentIndex - 1],
               case let .predicate(qpv) = views[currentIndex] {
                node?.addNode(node: qpv.createQueryNode(), connectWith: cvm.queryEval)
                currentIndex += 1
            } else {
                // TODO: - Error handle appropriately
                return nil
            }
        }
        
        return node
    }
}

struct QueryBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        QueryBuilderView<Article>()
    }
}
