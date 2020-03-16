//
//  CloudKitManger.swift
//  CloudKitDB
//
//  Created by Terry Dengis on 12/16/18.
//  Copyright © 2018 Terry Dengis. All rights reserved.
//

import CloudKit
import UIKit

class CloudKitManger {
    
    private var container = CKContainer.default()
    private(set) var accountStatus = CKAccountStatus.couldNotDetermine
    private var cloudDatabase: CKDatabase?
    
    init () {
        container = CKContainer.default()
        requestAccountStatus()
        setUpNotificationHandling()
        cloudDatabase = container.privateCloudDatabase
    }
    
    func addMemorizedItem (_ item: MemorizedItem) {
        let record = CKRecord(recordType: Record.memorized)
        record.setValue(item.id, forKey: Record.MemorizedItem.id)
        record.setValue(item.category, forKey: Record.MemorizedItem.category)
        record.setValue(item.itemDescription, forKey: Record.MemorizedItem.itemDescription)
        record.setValue(item.points, forKey: Record.MemorizedItem.points)

        
        cloudDatabase?.save(record, completionHandler: { (record, error) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                print ("Saved Memorized Item")
            }
        })
    }
    
    func getMemorizedItems (for vc:ViewController) {
        let predicate = NSPredicate (value: true)
        let query = CKQuery(recordType: Record.memorized, predicate: predicate)
        let descriptor = NSSortDescriptor(key: Record.MemorizedItem.itemDescription, ascending: true)
        query.sortDescriptors = [descriptor]

        cloudDatabase?.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                var currentRecords = [MemorizedItem]()
                for record in records! {
                    let item = MemorizedItem ()
                    item.id = record.value(forKeyPath: Record.MemorizedItem.id) as! String
                    item.category = record.value(forKeyPath: Record.MemorizedItem.category) as! String
                    item.itemDescription = record.value(forKeyPath: Record.MemorizedItem.itemDescription) as! String

                    item.points = record.value(forKeyPath: Record.MemorizedItem.points) as! Int
                    currentRecords.append(item)
                }
                vc.currentRecords = currentRecords
                vc.printCurrentItems()
            }
        })

    }
    
    func requestAccountStatus () {
        container.accountStatus { (accountStatus, error) in
            if let error = error {
                print (error.localizedDescription)
            }
            self.accountStatus = accountStatus
            switch self.accountStatus {
            case .available :
                print ("User Logged into iCloud")
            case .couldNotDetermine :
                print ("Unable to Determine iCloud Status")
            case .restricted :
                print ("Not permitted to Access iCloud account")
            case .noAccount :
                print ("User Not Signed into iCloud")
            }
         }
    }
    
    fileprivate func setUpNotificationHandling () {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(accountDidChange(_:)), name: Notification.Name.CKAccountChanged, object: nil)
        
    }
    
    @objc private func accountDidChange (_ notification: Notification) {
        DispatchQueue.main.async {
            self.requestAccountStatus()
        }
    }
}
