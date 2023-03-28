//
//  StringComparableView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/28/23.
//

import SwiftUI

struct StringComparableView: ComparableView {
    let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    @State var value: String = "A"
    var options: [(any IsComparable)]
    private var displayOptions: [String] {
        if let options = options as? [String],
           !options.isEmpty {
            return options
        } else {
            return alphabet
        }
    }
    
    var body: some View {
        Menu(
            content: {
                ForEach(displayOptions.filter({ $0 != value}).sorted(), id: \.self) { value in
                    Button(
                        action: {
                            self.value = value
                        },
                        label: {
                            Text(value)
                        }
                    )
                }
            },
            label: {
                Text(value)
                    .modifier(InsetText(color: .red))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
        .onAppear {
            value = displayOptions.randomElement()!
        }
    }
    
    static func create() -> StringComparableView {
        return StringComparableView(options: [])
    }
}

struct StringComparableView_Previews: PreviewProvider {
    static var previews: some View {
        StringComparableView(options: ["test", "test2"])
    }
}
