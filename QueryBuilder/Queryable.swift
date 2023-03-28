//
//  Queryable.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/25/23.
//

import Foundation
import SwiftUI

protocol Queryable: AnyObject {
    static var queryableParameters: [PartialKeyPath<Self>: any IsComparable.Type] { get set }
    static func stringFor(_ keypath: PartialKeyPath<Self>) -> String
}

protocol AnyQueryNode: AnyObject {
    var comparator: Comparator { get }
    var link: QueryLink? { get set }
    
    func evaluate(_ obj: any Queryable) -> Bool
}

protocol IsComparable {
    associatedtype ViewType: ComparableView
    func evaluate(comparator: Comparator, against value: any IsComparable) -> Bool
    func getValidComparators() -> [Comparator]
    static func createAssociatedView() -> ViewType
}

extension IsComparable {
    func getValidComparators() -> [Comparator] { Comparator.allCases }
    static func createAssociatedView() -> ViewType { ViewType.create() }
}

enum Comparator: String, CaseIterable {
    case less = "less than"
    case greater = "greater than"
    case lessThanOrEqual = "less than or equal to"
    case greaterThanOrEqual = "greater than or equal to"
    case equal = "equal to"
    case notEqual = "not equal to"
}

enum QueryEval: String {
    case and
    case or
    
    mutating func toggle() {
        switch self {
        case .and: self = .or
        case .or: self = .and
        }
    }
    
    var color: Color {
        switch self {
        case .and: return Color.green
        case .or: return Color.purple
        }
    }
}

enum QueryLink {
    case and(AnyQueryNode)
    case or(AnyQueryNode)
    
    func value() -> AnyQueryNode {
        switch self {
        case .and(let node): return node
        case .or(let node): return node
        }
    }
}

extension Collection where Element: Queryable {
    func evaluate(node: QueryNode<Element>) -> [Self.Element] {
        return self.filter({ node.evaluate($0) })
    }
}
