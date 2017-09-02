//
//  Schedule.swift
//  RZJ Schedule
//
//  Created by Gaby Ecanow on 9/1/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

class Schedule: NSObject {
    var type : String!
    var periods = ["No Class Input", "No Class Input", "No Class Input",
                   "No Class Input", "No Class Input", "No Class Input",
                   "No Class Input", "No Class Input"]
    
    convenience init(_ kind: String) {
        self.init()
        type = kind
    }
}
