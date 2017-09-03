//
//  MainTimer.swift
//  RZJ Schedule
//
//  Created by Gaby Ecanow on 9/2/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

let timerKey = "com.EcaKnowGames.timerNotificationKey"

class MainTimer: NSObject {
    
    var hour=0, minute=0, second=0, weekday=0
    var endHour = [0,0,0,0,0,0,0,0], endMin = [0,0,0,0,0,0,0,0]
    
    var tefillahHourEnd : Int!
    var tefillahMinuteEnd : Int!
    let LATE_START = 4 //wednesday
    let FRIDAY_SCHEDULE = 6 //friday
    
    var currentPeriod = "", currentTimer = "", upNext = ""
    var cpi = -1 //current period index
    
    var mySchedule : Schedule!
    var myPassingPeriod : PassingPeriod!
    
    convenience init(_ s: Schedule) {
        self.init()
        setTime()
        
        mySchedule = s
        myPassingPeriod = PassingPeriod(endMinArr: endMin, i: cpi)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findCurrentPeriod), userInfo: nil, repeats: true)
    }
    
    func setDate() {
        let date = Date()
        let calendar = Calendar.current
        weekday = calendar.component(.weekday, from: date)
        hour = calendar.component(.hour, from: date)
        minute = calendar.component(.minute, from: date)
        second = calendar.component(.second, from: date)
    }
    
    @objc private func findCurrentPeriod() {
        //set the proper Date
        setDate()
        
        // (attempts to) find the index of the current period, according
        // the current hour and time
        var index = 0
        var found = false
        while (!found && index < mySchedule.periods.count) {
            if (hour > endHour[index]) {
                index += 1
            } else { // hour <= endHour[index]
                if (minute >= endMin[index]) {
                    index += 1
                    // make sure you shouldn't update it even more!
                    if (index < mySchedule.periods.count &&
                        endHour[index-1] == endHour[index] && minute >= endMin[index]) {
                        index += 1
                    }
                }
                found = true
            }
        }
        
        // Sets the text to display what period is now, what period is next,
        // and how much time there is left
        if (hour < tefillahHourEnd || (hour == tefillahHourEnd && minute < tefillahMinuteEnd)) {
            currentPeriod = "Tefillah";
            upNext = "First Period Class: " + mySchedule.getSchedule(weekday)[0]
            currentTimer = timeLeft(tefillahHourEnd, tefillahMinuteEnd)
            
            
            cpi = -1
        } else if (hour < endHour [0]) {
            currentPeriod = mySchedule.getSchedule(weekday)[0]
            upNext = "Up Next: " + mySchedule.getSchedule(weekday)[1]
            currentTimer = timeLeft(endHour[0], endMin[0])
            
            cpi = 0
        } else if (index < mySchedule.periods.count) {
            currentPeriod = mySchedule.getSchedule(weekday)[index]
            cpi = index
            
            if (index+1 < mySchedule.periods.count) {
                upNext = "Up Next: " + mySchedule.getSchedule(weekday)[index+1]
            } else {
                upNext = "Up Next: School's Over";
            }
            currentTimer = timeLeft(endHour[index], endMin[index]);
        } else {
            currentPeriod = "School's Over!";
            upNext = "";
            currentTimer = "";
            
            cpi = -1
        }
        
        // the passing period timer:
        myPassingPeriod.i = cpi //-1?
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: timerKey), object: self)
    }
    
    /**
     * Returns a string representation of how much time is left
     * in the current period.
     */
    private func timeLeft(_ hourEnd: Int, _ minuteEnd: Int) -> String {
        var rHour = hourEnd - hour
        var rMin = minuteEnd - minute - 1
        if (minute > minuteEnd) {
            rMin = minuteEnd + (60 - minute)
            if (rHour == 1) { rHour = 0 }
        }
        var rSec = 60 - second
        if (rSec == 60) {
            rSec = 0
            rMin += 1
        }
        
        if (rMin == 5 && rSec <= 10) {
            //Handheld.Vibrate()
        }
        
        let hString = String(rHour) + ":"
        var mString = "", sString = ""
        
        if (rMin < 10) {
            mString = "0" + String(rMin) + ":"
        } else {
            mString = String(rMin) + ":"
        }
        if (rSec < 10) {
            sString = "0" + String(rSec)
        } else {
            sString = String(rSec)
        }
        
        return hString + mString + sString
    }
    
    func setTime() {
        if (weekday == LATE_START) {
            endHour [0] = 10; endMin [0] = 35 // end of first period
            endHour [1] = 11; endMin [1] = 28 // end of second period
            endHour [2] = 12; endMin [2] = 21 // end of third period
            endHour [3] = 12; endMin [3] = 51 // end of lunch period
            endHour [4] = 13; endMin [4] = 44 // end of fourth period
            endHour [5] = 14; endMin [5] = 37 // end of fifth period
            endHour [6] = 14; endMin [6] = 52 // end of mincha period
            endHour [7] = 15; endMin [7] = 42 // end of sixth period
            tefillahHourEnd = 9
            tefillahMinuteEnd = 42
        } else if (weekday == FRIDAY_SCHEDULE) {
            if (UserDefaults.standard.value(forKey: "shortFri") as! Bool) {
                endHour [0] = 9; endMin [0] = 34 // end of first period
                endHour [1] = 10; endMin [1] = 11 // end of second period
                endHour [2] = 10; endMin [2] = 21 // end of break period
                endHour [3] = 10; endMin [3] = 55 // end of third period
                endHour [4] = 11; endMin [4] = 32 // end of fourth period
                endHour [5] = 12; endMin [5] = 1 // end of lunch period
                endHour [6] = 12; endMin [6] = 38 // end of fifth period
                endHour [7] = 13; endMin [7] = 15 // end of sixth period
            } else {
                endHour [0] = 9; endMin [0] = 44 // end of first period
                endHour [1] = 10; endMin [1] = 31 // end of second period
                endHour [2] = 10; endMin [2] = 39 // end of break period
                endHour [3] = 11; endMin [3] = 23 // end of third period
                endHour [4] = 12; endMin [4] = 10 // end of fourth period
                endHour [5] = 12; endMin [5] = 41 // end of lunch period
                endHour [6] = 13; endMin [6] = 28 // end of fifth period
                endHour [7] = 14; endMin [7] = 15 // end of sixth period
            }
            tefillahHourEnd = 8
            tefillahMinuteEnd = 57
        } else {
            endHour [0] = 9; endMin[0] = 48 // end of first period
            endHour [1] = 10; endMin [1] = 45 // end of second period
            endHour [2] = 11; endMin [2] = 42 // end of third period
            endHour [3] = 12; endMin [3] = 24 // end of lunch period
            endHour [4] = 13; endMin [4] = 21 // end of fourth period
            endHour [5] = 14; endMin [5] = 18 // end of fifth period
            endHour [6] = 14; endMin [6] = 33 // end of mincha period
            endHour [7] = 15; endMin [7] = 27 // end of sixth period
            tefillahHourEnd = 8
            tefillahMinuteEnd = 51
        }
    }
}
