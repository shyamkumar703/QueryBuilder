//
//  Conformance.swift
//  QueryBuilder
//
//  Created by Shyam Kumar on 3/25/23.
//

import Foundation

extension Comparable where Self: IsComparable {
    func evaluate(comparator: Comparator, against value: Self) -> Bool {
        switch comparator {
        case .less:
            return self < value
        case .greater:
            return self > value
        case .lessThanOrEqual:
            return self <= value
        case .greaterThanOrEqual:
            return self >= value
        case .equal:
            return self == value
        case .notEqual:
            return self != value
        }
    }
}

extension Bool: IsComparable {
    typealias ViewType = BoolComparableView
    
    func getValidComparators() -> [Comparator] {
        [.equal, .notEqual]
    }
    
    func evaluate(comparator: Comparator, against value: Bool) -> Bool {
        // TODO: - Replace print statements with logs
        switch comparator {
        case .less:
            print("Bool comparison does not support <, running != instead")
            return self != value
        case .greater:
            print("Bool comparsion does not support >, running != instead")
            return self != value
        case .lessThanOrEqual:
            print("Bool comparison does not support <=, running == instead")
            return self == value
        case .greaterThanOrEqual:
            print("Bool comparison does not support >=, running == instead")
            return self == value
        case .equal:
            return self == value
        case .notEqual:
            return self != value
        }
    }
}

extension Date: IsComparable {
    typealias ViewType = DateComparableView
}
extension String: IsComparable {
    typealias ViewType = EmptyComparableView
}
extension Int: IsComparable {
    typealias ViewType = EmptyComparableView
}
extension Double: IsComparable {
    typealias ViewType = EmptyComparableView
}
extension Float: IsComparable {
    typealias ViewType = EmptyComparableView
}
