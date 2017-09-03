//
//  PassingPeriod.swift
//  RZJ Schedule
//
//  Created by Gaby Ecanow on 9/3/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

class PassingPeriod: NSObject {
    
    var i = 0
    var endMin : [Int]!
    
    convenience init(endMinArr: [Int], i: Int) {
        self.init()
        endMin = endMinArr
        self.i = i
    }
    
    func calculateTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let sec = calendar.component(.second, from: date)
        var min = 0
        
        if (i >= 0) {
            min = calendar.component(.minute, from: date) - (endMin[i])
            if (calendar.component(.minute, from: date) < endMin[i]) {
                min = (60 - endMin[i]) + calendar.component(.minute, from: date)
            }
        }
        
        
        if (i >= 0 && min < 3) {
            return "Passing Period: \(min):\(sec)"
        } else {
            return "";
        }
    }
}
