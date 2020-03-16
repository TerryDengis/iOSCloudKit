//
//  DataModel.swift
//  CloudKitDB
//
//  Created by Terry Dengis on 12/16/18.
//  Copyright © 2018 Terry Dengis. All rights reserved.
//

import Foundation

class Item  {
    @objc dynamic var id = UUID ().uuidString
    @objc dynamic var day = ""
    @objc dynamic var meal = ""
    @objc dynamic var category = ""
    @objc dynamic var itemDescription = ""
    @objc dynamic var points = 0
}

class Day {
    @objc dynamic var id = UUID ().uuidString
    @objc dynamic var date = ""
    @objc dynamic var goal = 0
}

class MemorizedItem {
    @objc dynamic var id = UUID ().uuidString
    @objc dynamic var category = ""
    @objc dynamic var itemDescription = ""
    @objc dynamic var points = 0
    
    func lowercased () -> String {
        return itemDescription.lowercased()
    }
    
}

struct Record {
    static let item = "Item"
    static let day = "Day"
    static let memorized = "MemorizedItem"
    struct MemorizedItem {
        static let id = "id"
        static let category = "category"
        static let itemDescription = "itemDescription"
        static let points = "points"
    }
}

