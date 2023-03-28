//
//  ConnectorView.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/27/23.
//

import SwiftUI

struct ConnectorView: View {
    @State private var queryEval: QueryEval = .and
    
    var body: some View {
        HStack {
            Text(queryEval.rawValue.uppercased())
                .modifier(InsetText(color: queryEval.color))
                .onTapGesture {
                    queryEval.toggle()
                }
            
            Spacer()
        }
        .padding()
    }
}

struct ConnectorView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectorView()
    }
}
