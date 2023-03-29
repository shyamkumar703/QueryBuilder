//
//  QueryFilterView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/29/23.
//

import SwiftUI

struct QueryFilterView<QueryableElement: Queryable>: View {
    @State private var userFilters: [(String, QueryNode<QueryableElement>)] = QueryBuilderSDK.fetchFilters(for: QueryableElement.self)
    
    var filterOptions: [[FilterOptions]] {
        var queryOptions = [[FilterOptions]]()
        var options: [FilterOptions] = userFilters.map({ FilterOptions.query($0) })
        queryOptions.append(options)
        
        var additionalOptions: [FilterOptions] = [.addNew]
        
        if currentFilter != nil {
            additionalOptions.append(.editCurrentFilter)
            additionalOptions.append(.clearFilter)
        }
        queryOptions.append(additionalOptions)
        
        return queryOptions
    }
    
    @State private var currentFilter: (String, QueryNode<QueryableElement>)? = nil
    @State private var showFilterSheet: Bool = false
    @State private var showEditFilterSheet: Bool = false
    
    @Binding var allItems: [QueryableElement]
    @Binding var filteredItems: [QueryableElement]?
    
    var body: some View {
        Menu(
            content: {
                Section { viewForFilterOption(index: 0) }
                Section { viewForFilterOption(index: 1) }
            },
            label: {
                if let currentFilter {
                    Text("Filter: \(currentFilter.0)")
                } else {
                    Text("Filter")
                }
            }
        )
        .sheet(isPresented: $showFilterSheet) {
            QueryBuilderViewModel<QueryableElement>(
                userFilters: $userFilters,
                currentFilter: $currentFilter,
                filteredItems: $filteredItems,
                elements: allItems
            ).createView()
        }
        .sheet(isPresented: $showEditFilterSheet) {
            if let currentFilter {
                QueryBuilderViewModel<QueryableElement>(
                    userFilters: $userFilters,
                    currentFilter: $currentFilter,
                    filteredItems: $filteredItems,
                    elements: allItems,
                    node: currentFilter.1,
                    name: currentFilter.0
                ).createView()
            }
        }
    }
    
    @ViewBuilder private func viewForFilterOption(index: Int) -> some View {
        ForEach(filterOptions[index]) { option in
            switch option {
            case .query(let (name, node)):
                Button(
                    action: {
                        if name != currentFilter?.0 {
                            currentFilter = (name, node)
                            filteredItems = allItems.filter({ node.evaluate($0) })
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
                        filteredItems = nil
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
    }
}

extension QueryFilterView {
    enum FilterOptions: Identifiable {
        case query((String, QueryNode<QueryableElement>))
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
