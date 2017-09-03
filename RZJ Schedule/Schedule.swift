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
    var periodTitles = ["Period 1", "Period 2", "Period 3","Lunch", "Period 4", "Period 5", "Period 6", "Period 7"]
    
    convenience init(_ kind: String) {
        self.init()
        type = kind
        
        // update the period list
        for i in 0..<8 {
            if UserDefaults.standard.value(forKey: type + String(i)) == nil {
                UserDefaults.standard.set(periods[i], forKey: type + String(i))
            } else {
                periods[i] = UserDefaults.standard.value(forKey: type + String(i)) as! String
            }
        }
    }
    
    func getSchedule(_ weekday: Int) -> [String] {
        if weekday == 6 {
            return friday(forArr: periods)
        } else {
            return periods
        }
    }
    func getScheduleTitles(_ weekday: Int) -> [String] {
        if weekday == 6 {
            return friday(forArr: periodTitles)
        } else {
            return periodTitles
        }
    }
    
    private func friday(forArr: [String]) -> [String] {
        return [forArr[0], forArr[1], "Break", forArr[2], forArr[4],
        forArr[3], forArr[5], forArr[7]]
    }
}
