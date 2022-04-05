//
//  ArrayExtension.swift
//  happit
//
//  Created by Андрей  on 25.03.2022.
//

import Foundation

extension Array where Element: Equatable {
    func difference(from other: [Element]) -> [Element] {
        let thisArray = self
        let otherArray = other
        var difference = [Element]()
        
        for element in thisArray {
            if !otherArray.contains(element) {
                difference.append(element)
            }
        }
        
        for element in otherArray {
            if !thisArray.contains(element) {
                difference.append(element)
            }
        }
        
        return difference
    }
    
    static func / (this: [Element], other: [Element]) -> [Element] {
        var difference = [Element]()
        
        for element in this {
            if !other.contains(element) {
                difference.append(element)
            }
        }
        
        return difference
    }
}
