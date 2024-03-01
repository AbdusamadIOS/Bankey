//
//  Decimal+Utils.swift
//  Bankey
//
//  Created by Abdusamad Mamasoliyev on 01/03/24.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
