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
    
    /**
     * Called each time the application is opened,
     * and sets the schedules to the user-defined schedules
     * that have already been set.
     */
    private func setSpecialSchedules() {
        //    classesAFriday [0] = classesA [0];
        //    classesAFriday [1] = classesA [1];
        //    classesAFriday [2] = "Break";
        //    classesAFriday [3] = classesA [2];
        //    classesAFriday [4] = classesA [4];
        //    classesAFriday [5] = classesA [3];
        //    classesAFriday [6] = classesA [5];
        //    classesAFriday [7] = classesA [7];
        //
        //    classesBBFriday [0] = classesBB [0];
        //    classesBBFriday [1] = classesBB [1];
        //    classesBBFriday [2] = "Break";
        //    classesBBFriday [3] = classesBB [2];
        //    classesBBFriday [4] = classesBB [4];
        //    classesBBFriday [5] = classesBB [3];
        //    classesBBFriday [6] = classesBB [5];
        //    classesBBFriday [7] = classesBB [7];
        //
        //    classesCCFriday [0] = classesCC [0];
        //    classesCCFriday [1] = classesCC [1];
        //    classesCCFriday [2] = "Break";
        //    classesCCFriday [3] = classesCC [2];
        //    classesCCFriday [4] = classesCC [4];
        //    classesCCFriday [5] = classesCC [3];
        //    classesCCFriday [6] = classesCC [5];
        //    classesCCFriday [7] = classesCC [7];
    }
}
