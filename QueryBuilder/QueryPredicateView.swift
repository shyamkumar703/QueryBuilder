//
//  ContentView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/25/23.
//

import SwiftUI

struct QueryPredicateView<QueryableElement: Queryable>: View {
    var queryableArray = [QueryableElement]()
    
//    private var queryNode = QueryNode(comparator: .less, compareToValue: 100, comparableObject: Article.self, objectKeyPath: \.likes)
    @State private var comparator: Comparator = .less
    @State private var queryableParam: PartialKeyPath<QueryableElement> = QueryableElement.queryableParameters.first!.key
    @State private var selectedComparator: Comparator = .less
    @State private var showCompanionView: Bool = false
    
    var comparatorView: any ComparableView {
        if let type = QueryableElement.queryableParameters[queryableParam] {
           return type.createAssociatedView()
        } else {
            // TODO: - Error-handle appropriately
            return EmptyComparableView()
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Menu(
                content: {
                    ForEach(QueryableElement.queryableParameters.filter({ $0.key != queryableParam }), id: \.key) { param in
                        Button(QueryableElement.stringFor(param.key)) {
                            self.queryableParam = param.key
                        }
                    }
                },
                label: {
                    Text(QueryableElement.stringFor(queryableParam))
                        .modifier(InsetText())
                }
            )
            .transaction { transaction in
                transaction.animation = nil
            }
            
            ComparatorView(selectedComparator: $selectedComparator)
            
            AnyView(comparatorView)
            
            Spacer()
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
    }
    
    func createQueryNode() -> AnyQueryNode? {
        if let type = QueryableElement.queryableParameters[queryableParam] {
            return QueryNode(comparator: comparator, compareToValue: comparatorView.value, comparableObject: QueryableElement.self, objectKeyPath: queryableParam)
        }
    }
}

struct InsetText: ViewModifier {
    private var color: Color
    private var shouldBold: Bool
    
    init(color: Color = .primary, shouldBold: Bool = false) {
        self.color = color
        self.shouldBold = shouldBold
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(shouldBold ? .system(.body, design: .monospaced, weight: .bold) : .system(.body, design: .monospaced))
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(color.opacity(0.1))
            )
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
}

struct QueryPredicateView_Previews: PreviewProvider {
    static var previews: some View {
        QueryPredicateView<Article>()
            .preferredColorScheme(.light)
    }
}
