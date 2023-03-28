//
//  EmptyComparableView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/26/23.
//

import SwiftUI

struct EmptyComparableView: ComparableView {
    var value: Int = 0
    
    var body: some View {
        Text("Empty")
    }
    
    static func create() -> EmptyComparableView {
        EmptyComparableView()
    }
}

struct EmptyComparableView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyComparableView()
    }
}
