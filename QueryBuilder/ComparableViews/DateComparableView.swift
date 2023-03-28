//
//  DateComparableView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/26/23.
//

import SwiftUI

struct DateComparableView: ComparableView {
    @State var value: Date = Date()
    @State private var shouldShowSheet: Bool = false
    
    var body: some View {
        Text(value.formatted())
            .modifier(InsetText(color: .red))
            .onTapGesture { shouldShowSheet.toggle() }
            .sheet(isPresented: $shouldShowSheet) {
                VStack {
                    Text("Select date")
                        .font(.system(.headline, design: .monospaced, weight: .bold))
                    DatePicker(selection: $value, in: ...Date.now, displayedComponents: [.date, .hourAndMinute]) {
                        Text("Select a date")
                    }
                    .labelsHidden()
                }
                .presentationDetents([.fraction(0.15)])
            }
    }
    
    static func create() -> DateComparableView {
        return DateComparableView()
    }
}

struct DateComparableView_Previews: PreviewProvider {
    static var previews: some View {
        DateComparableView()
    }
}
