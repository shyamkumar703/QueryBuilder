//
//  QueryBuilderView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/27/23.
//

import SwiftUI

struct QueryBuilderView<QueryableElement: Queryable>: View {
    @State private var views: [QueryView] = []
    @State private var filterName: String = ""
    @State private var isShowingFilterSaveAlert: Bool = false
    @Binding var userFilters: [(String, QueryNode<QueryableElement>)]
    
    @Environment(\.dismiss) var dismiss
    
    var elements: [QueryableElement]
    
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
                                    .predicate(QueryPredicateViewModel<QueryableElement>(elements: elements))
                                ]
                            }
                        },
                        label: {
                            Image(systemName: "plus")
                        }
                    )
                    .alert("Enter a name", isPresented: $isShowingFilterSaveAlert) {
                        TextField("Filter name", text: $filterName)
                        Button("Save", action: save)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            isShowingFilterSaveAlert = true
                        },
                        label: {
                            Text("Save")
                        }
                    )
                }
            }
        }
        .onAppear {
            if views.count == 0 {
                views.append(.predicate(QueryPredicateViewModel<QueryableElement>(elements: elements)))
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
    
    func save() {
        var node: QueryNode<QueryableElement>?
        switch views.first {
        case .predicate(let predicateView):
            node = predicateView.createQueryNode()
        default:
            // TODO: - Error handle appropriately
            return
        }
        
        var currentIndex = 2
        while currentIndex < views.count {
            if case let .connector(cvm) = views[currentIndex - 1],
               case let .predicate(qpv) = views[currentIndex] {
                node?.addNode(node: qpv.createQueryNode(), connectWith: cvm.queryEval)
                currentIndex += 1
            } else {
                // TODO: - Error handle appropriately
                return
            }
        }
        
        guard let node else {
            // TODO: - Error-handle appropriately here
            return
        }
        
        do {
            // save here
            try QueryBuilderSDK.save(node: node, with: filterName)
            userFilters.append((filterName, node))
            dismiss()
        } catch {
            // TODO: - Error handle appropriately
            print(error)
        }
    }
}

struct QueryBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        QueryBuilderView<Article>(userFilters: .constant([]), elements: [])
    }
}
