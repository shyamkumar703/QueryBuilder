//
//  QueryBuilderView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/27/23.
//

import SwiftUI

struct QueryBuilderView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    QueryPredicateView<Article>()
                    ConnectorView()
                    QueryPredicateView<Article>()
                    ConnectorView()
                    QueryPredicateView<Article>()
                }
            }
            .navigationTitle("New filter")
        }
    }
}

struct QueryBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        QueryBuilderView()
    }
}
