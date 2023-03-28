//
//  BoolComparableView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/26/23.
//

import SwiftUI

protocol ComparableView: View {
    associatedtype ValueType: IsComparable
    var value: ValueType { get }
    static func create() -> Self
}

struct BoolComparableView: ComparableView {
    @State var value: Bool = true
    
    var body: some View {
        Text(value ? "true": "false")
            .modifier(InsetText(color: .red))
            .onTapGesture {
                value.toggle()
            }
    }
    
    static func create() -> BoolComparableView {
        BoolComparableView()
    }
}

struct BoolComparableView_Previews: PreviewProvider {
    static var previews: some View {
        BoolComparableView()
    }
}
