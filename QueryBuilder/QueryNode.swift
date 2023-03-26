//
//  QueryNode.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/25/23.
//

import Foundation

class QueryNode<U: Queryable, T: IsComparable>: AnyQueryNode {
    var comparator: Comparator
    var compareToValue: T
    var comparableObject: U.Type
    var objectKeyPath: PartialKeyPath<U>
    var link: QueryLink?
    
    init(comparator: Comparator, compareToValue: T, comparableObject: U.Type, objectKeyPath: PartialKeyPath<U>) {
        self.comparator = comparator
        self.compareToValue = compareToValue
        self.comparableObject = comparableObject
        self.objectKeyPath = objectKeyPath
    }
    
    func addNode<ValueType: IsComparable>(keypath: PartialKeyPath<U>, compareTo: ValueType, comparator: Comparator, connectWith: QueryEval) {
        let currentNode = QueryNode<U, ValueType>(
            comparator: comparator,
            compareToValue: compareTo,
            comparableObject: U.self,
            objectKeyPath: keypath
        )
        switch connectWith {
        case .and:
            let link: QueryLink = .and(currentNode)
            addLink(with: self, link: link)
        case .or:
            let link: QueryLink = .or(currentNode)
            addLink(with: self, link: link)
        }
    }
    
    func evaluate(_ obj: any Queryable) -> Bool {
        guard let obj = obj as? U else {
            // TODO: - Error handle
            return false
        }
        guard let objectValue = obj[keyPath: objectKeyPath] as? T else {
            // TODO: - Error handle
            return false
        }
        let currentNodeValue = objectValue.evaluate(comparator: comparator, against: compareToValue)
        guard let link else { return currentNodeValue }
        switch link {
        case .and(let node): return currentNodeValue && node.evaluate(obj)
        case .or(let node):
            return currentNodeValue || node.evaluate(obj)
        }
    }
    
    private func addLink(with node: AnyQueryNode, link: QueryLink) {
        if node.link != nil {
            switch node.link {
            case .and(let node):
                addLink(with: node, link: link)
            case .or(let node):
                addLink(with: node, link: link)
            case .none:
                // TODO: - Error handling
                return
            }
        } else {
            node.link = link
        }
    }
}