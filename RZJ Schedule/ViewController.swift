//
//  ViewController.swift
//  RZJ Schedule
//
//  Created by Gaby Ecanow on 9/1/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MainTimerDelegate {
    
    var dayList : [UIButton]!
    @IBOutlet weak var a: UIButton!
    @IBOutlet weak var b: UIButton!
    @IBOutlet weak var c: UIButton!
    @IBOutlet weak var bb: UIButton!
    @IBOutlet weak var cc: UIButton!
    @IBOutlet weak var currentDay: UIButton!
    @IBOutlet weak var dayToolbar: UIView!
    @IBOutlet weak var settingsToolbar: UIView!
    
    
    let weekdays = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var classSchedules = [Schedule("A"), Schedule("B"), Schedule("C"), Schedule("BB"), Schedule("CC")]
    
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var timeLeftText: UILabel!
    @IBOutlet weak var upNext: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let selectedBorder = CGFloat(4)
    
    var myTimer : MainTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsToolbar.isHidden = true
        dayList = [a, b, c, bb, cc]
        
        setDate()
        
        myTimer = MainTimer(classSchedules[0]) // just for initialization
        myTimer.delegate = self
        setTodaysSchedule()
        
        currentDay.setTitle(String(myTimer.mySchedule.type), for: .normal)
    }
    @IBAction func onTappedDay(_ sender: UIButton) {
        for d in dayList {
            d.layer.borderWidth = 0
        }
        
        UserDefaults.standard.setValue(sender.tag, forKey: "DayTag")
        dayToolbar.isHidden = true
        
        setTodaysSchedule()
    }
    @IBAction func onTappedChangeDay(_ sender: Any) {
        dayToolbar.isHidden = !dayToolbar.isHidden
        
        // animate it!!!!!
        if !dayToolbar.isHidden {
            for d in dayList {
                let ogCenter = d.center
                d.center = (sender as AnyObject).center
                UIView.animate(withDuration: 0.5, animations: {
                    d.center = ogCenter
                })
            }
        }
    }
    @IBAction func onTappedSettings(_ sender: Any) {
        settingsToolbar.isHidden = !settingsToolbar.isHidden
    }
    private func setTodaysSchedule() {
        let tag = UserDefaults.standard.value(forKey: "DayTag") as! Int
        myTimer.mySchedule = classSchedules[tag]
        
        dayList[tag].layer.borderWidth = selectedBorder
        currentDay.setTitle(String(myTimer.mySchedule.type), for: .normal)
        
        // also check for weird schedules!
    }
    
    private func setDate() {
        let date = Date()
        let calendar = Calendar.current
        
        let weekday = weekdays[calendar.component(.weekday, from: date)]
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        let year = String(calendar.component(.year, from: date))
        dateLabel.text = weekday + " " + month + "." + day + "." + year
    }
    
    func update() {
        period.text = myTimer.currentPeriod
        upNext.text = myTimer.upNext
        timeLeftText.text = myTimer.currentTimer
    }
    
    //=====================================================
    // Exchange of schedules when updating each 
    // period in full schedule vc
    //=====================================================
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! FullScheduleViewController
        dvc.timer = myTimer
    }
}

