//
//  ContentView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/25/23.
//

import SwiftUI

class QueryPredicateViewModel<QueryableElement: Queryable>: ObservableObject, Identifiable {
    var id = UUID()
    var elements = [QueryableElement]()
    @Published var comparator: Comparator = .less
    @Published var queryableParam: PartialKeyPath<QueryableElement> = QueryableElement.queryableParameters.first!.key {
        didSet {
            if !validComparators.contains(selectedComparator) {
                selectedComparator = validComparators.randomElement()!
            }
        }
    }
    @Published var selectedComparator: Comparator = .less
    @Published var showCompanionView: Bool = false
    
    var validComparators: [Comparator] {
        Comparator.validComparators(for: comparatorView.value)
    }
    
    var comparatorView: any ComparableView {
        if let type = QueryableElement.queryableParameters[queryableParam] {
           return type.createAssociatedView(options: options)
        } else {
            // TODO: - Error-handle appropriately
            return EmptyComparableView()
        }
    }
    
    var options: [any IsComparable] {
        elements.compactMap({ $0[keyPath: queryableParam] as? (any IsComparable) })
    }
     
    func createQueryNode() -> QueryNode<QueryableElement> {
        return QueryNode(comparator: comparator, compareToValue: comparatorView.value, comparableObject: QueryableElement.self, objectKeyPath: queryableParam)
    }
    
    func createView() -> QueryPredicateView<QueryableElement> {
        QueryPredicateView(viewModel: self)
    }
    
}

struct QueryPredicateView<QueryableElement: Queryable>: View {
    @ObservedObject var viewModel: QueryPredicateViewModel<QueryableElement>
    
    var body: some View {
        return HStack(alignment: .center) {
            Menu(
                content: {
                    ForEach(QueryableElement.queryableParameters.filter({ $0.key != viewModel.queryableParam }), id: \.key) { param in
                        Button(QueryableElement.stringFor(param.key)) {
                            viewModel.queryableParam = param.key
                        }
                    }
                },
                label: {
                    Text(QueryableElement.stringFor(viewModel.queryableParam))
                        .modifier(InsetText())
                }
            )
            .transaction { transaction in
                transaction.animation = nil
            }
            
            ComparatorView(selectedComparator: $viewModel.selectedComparator, validComparators: viewModel.validComparators)
            
            AnyView(viewModel.comparatorView)
            
            Spacer()
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
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
        QueryPredicateViewModel<Article>().createView()
    }
}
