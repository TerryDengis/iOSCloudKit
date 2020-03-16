//
//  ViewController.swift
//  CloudKitDB
//
//  Created by Terry Dengis on 12/16/18.
//  Copyright © 2018 Terry Dengis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let cloudKitManger = CloudKitManger ()
    
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var itemDescr: UITextField!
    @IBOutlet weak var points: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    var currentRecords: [MemorizedItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCloudData()
    }


    @IBAction func createMemorizedItem(_ sender: Any) {
        let mItem = MemorizedItem ()
        mItem.category = category.text ?? "default"
        mItem.itemDescription = itemDescr.text ?? "default"
        let pointsString = points.text ?? "0"
        mItem.points = Int (pointsString)!
        
        cloudKitManger.addMemorizedItem(mItem)
    }
    
    func printCurrentItems () {
        print ("\(String(describing: currentRecords))")
    }
    
    func loadCloudData () {
        cloudKitManger.getMemorizedItems(for: self)
    }
    
    @IBAction func refreshList(_ sender: Any) {
        loadCloudData()
    }
}

