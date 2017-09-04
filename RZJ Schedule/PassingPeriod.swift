//
//  PassingPeriod.swift
//  RZJ Schedule
//
//  Created by Gaby Ecanow on 9/3/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

class PassingPeriod: NSObject {
    
    //========//
    // FIELDS //
    //========//
    
    var i = 0
    var endMin : [Int]!
    
    //==================//
    // CONVENIENCE INIT //
    //==================//
    convenience init(endMinArr: [Int], i: Int) {
        self.init()
        endMin = endMinArr
        self.i = i
    }
    
    //--------------------------------------------------
    // Calculates the time of the passing period
    //--------------------------------------------------
    func calculateTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let sec = calendar.component(.second, from: date)
        var min = 0
        
        if (i > 0) {
            min = calendar.component(.minute, from: date) - (endMin[i])
            if (calendar.component(.minute, from: date) < endMin[i]) {
                min = (60 - endMin[i]) + calendar.component(.minute, from: date)
            }
        }
        
        print("Passing Period: \(min):0\(sec)")
        if (i >= 0 && min < 3) {
            if sec < 10 {
                return "Passing Period: \(min):0\(sec)"
            } else {
                return "Passing Period: \(min):\(sec)"
            }
        } else {
            return "";
        }
    }
}
