//
//  String.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 26.09.2022.
//

import Foundation

extension String {
    
    func conforms(to characterSet: CharacterSet) -> Bool {
        for scalar in unicodeScalars {
            if !characterSet.contains(scalar) { return false }
        }
        return true
    }
    
    func numberOfOccurrences(of character: Character) -> Int {
        let stringWithoutOccurrences = replacingOccurrences(of: "\(character)", with: "")
        return count - stringWithoutOccurrences.count
    }
    
}
