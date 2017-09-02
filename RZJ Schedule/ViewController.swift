//
//  ViewController.swift
//  RZJ Schedule
//
//  Created by Gaby Ecanow on 9/1/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dayList : [UIButton]!
    @IBOutlet weak var a: UIButton!
    @IBOutlet weak var b: UIButton!
    @IBOutlet weak var c: UIButton!
    @IBOutlet weak var bb: UIButton!
    @IBOutlet weak var cc: UIButton!
    @IBOutlet weak var currentDay: UIButton!
    @IBOutlet weak var dayToolbar: UIView!
    @IBOutlet weak var settingsToolbar: UIView!
    
    
    let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var weekday : String!
    var hour : Int!
    var minute : Int!
    var second : Int!
    
    var mySchedule : Schedule!
    var classSchedules : [Schedule] = [Schedule("A"), Schedule("B"), Schedule("C"), Schedule("BB"), Schedule("CC")]
    
    var endHour = [0,0,0,0,0,0,0,0]
    var endMin = [0,0,0,0,0,0,0,0]
    
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var timeLeftText: UILabel!
    @IBOutlet weak var upNext: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var tefillahHourEnd : Int!
    var tefillahMinuteEnd : Int!
    
    let LATE_START = "wednesday"
    let FRIDAY_SCHEDULE = "friday"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsToolbar.isHidden = true
        dayList = [a, b, c, bb, cc]
        let dayTag = UserDefaults.standard.value(forKey: "DayTag") as! Int
        dayList[dayTag].layer.borderWidth = 2
        
        setDate()
        setTodaysSchedule()
        setTime()
        
        currentDay.setTitle(String(mySchedule.type), for: .normal)
        
        findCurrentPeriod()
    }
    @IBAction func onTappedDay(_ sender: UIButton) {
        for d in dayList {
            d.layer.borderWidth = 0
        }
        
        UserDefaults.standard.setValue(sender.tag, forKey: "DayTag")
        sender.layer.borderWidth = 2
        currentDay.setTitle(sender.titleLabel?.text, for: .normal)
        dayToolbar.isHidden = true
        
        setTodaysSchedule()
    }
    @IBAction func onTappedChangeDay(_ sender: Any) {
        dayToolbar.isHidden = !dayToolbar.isHidden
    }
    @IBAction func onTappedSettings(_ sender: Any) {
        settingsToolbar.isHidden = !settingsToolbar.isHidden
    }
    
    
    private func setDate() {
        let date = Date()
        let calendar = Calendar.current
        
        weekday = weekdays[calendar.component(.weekday, from: date)]
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        let year = String(calendar.component(.year, from: date))
        dateLabel.text = weekday + " " + month + "." + day + "." + year
        
        hour = calendar.component(.hour, from: date)
        minute = calendar.component(.minute, from: date)
        second = calendar.component(.second, from: date)
    }
    private func setTodaysSchedule() {
        let tag = UserDefaults.standard.value(forKey: "DayTag") as! Int
        mySchedule = classSchedules[tag]
        // check for special schedule like extended tefillah!
    }
    private func findCurrentPeriod() {
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
        
        // the passing period timer:
        //PassingPeriod.index = index-1;
        
        // Sets the text to display what period is now, what period is next,
        // and how much time there is left
        if (hour < tefillahHourEnd || (hour == tefillahHourEnd && minute < tefillahMinuteEnd)) {
            period.text = "Tefillah";
            upNext.text = "First Period Class: " + mySchedule.periods[0]
            timeLeftText.text = "Time Left: " + timeLeft(tefillahHourEnd, tefillahMinuteEnd)
        } else if (hour < endHour [0]) {
            period.text = "You Have:\n" + mySchedule.periods[0]
            upNext.text = "Up Next: " + mySchedule.periods[1]
            timeLeftText.text = "Time Left: " + timeLeft(endHour[0], endMin[0])
        } else if (index < mySchedule.periods.count) {
            period.text = "You Have:\n" + mySchedule.periods[index]
            if (index+1 < mySchedule.periods.count) {
                upNext.text = "Up Next: " + mySchedule.periods[index+1]
            } else {
                upNext.text = "Up Next: School's Over";
            }
            timeLeftText.text = "Time Left: " + timeLeft (endHour[index], endMin[index]);
        } else {
            period.text = "School's Over!";
            upNext.text = "";
            timeLeftText.text = "";
        }
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
        
        return hString + mString + sString;
    }
    
    func setTime() {
        if (weekday.lowercased() == LATE_START) {
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
        } else if (weekday.lowercased() == FRIDAY_SCHEDULE) {
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
            endHour [0] = 9; endMin [0] = 48 // end of first period
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
    
    func wednesday() -> String {
        return LATE_START
    }
    func friday() -> String {
        return FRIDAY_SCHEDULE
    }
    
    //=====================================================
    // Exchange of schedules when updating each 
    // period in full schedule vc
    //=====================================================
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! FullScheduleViewController
        dvc.schedule = mySchedule
    }
}

