//
//  Queryable.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/25/23.
//

import Foundation

protocol Queryable: AnyObject {
    var queryableParameters: [PartialKeyPath<Self>: any IsComparable.Type] { get set }
}

protocol AnyQueryNode: AnyObject {
    var comparator: Comparator { get }
    var link: QueryLink? { get set }
    
    func evaluate(_ obj: any Queryable) -> Bool
}

protocol IsComparable {
    func evaluate(comparator: Comparator, against value: Self) -> Bool
}

enum Comparator {
    case less
    case greater
    case lessThanOrEqual
    case greaterThanOrEqual
    case equal
    case notEqual
}

enum QueryEval {
    case and
    case or
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
    func evaluate<ValueType: IsComparable>(node: QueryNode<Element, ValueType>) -> [Self.Element] {
        return self.filter({ node.evaluate($0) })
    }
}
