//
//  Item.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/23/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
