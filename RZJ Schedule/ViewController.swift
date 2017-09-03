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
    var dayListCenters : [CGPoint]!
    
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
    
    let selectedBorder = CGFloat(5)
    
    var myTimer : MainTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsToolbar.isHidden = true
        dayList = [a, b, c, bb, cc]
        dayListCenters = [a.center, b.center, c.center, bb.center, cc.center]
        
        setDate()
        
        myTimer = MainTimer(classSchedules[0]) // just for initialization
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name(rawValue: timerKey), object: nil)
        
        setTodaysSchedule()
        
        currentDay.setTitle(String(myTimer.mySchedule.type), for: .normal)
    }
    @IBAction func onTappedDay(_ sender: UIButton) {
        for d in dayList {
            d.layer.borderWidth = 1
        }
        
        UserDefaults.standard.setValue(sender.tag, forKey: "DayTag")
        setTodaysSchedule()
    }
    
    @IBAction func onTappedChangeDay(_ sender: Any) {
        // animate it!!!!!
        for d in 0..<dayList.count {
            
            UIView.animate(withDuration: 0.5, animations: { 
                if self.dayList[d].center == self.dayListCenters[d] {
                    self.dayList[d].center = (sender as! UIButton).center
                } else {
                    self.dayList[d].center = self.dayListCenters[d]
                }
            })
            
        }
    }
    
    @IBAction func onTappedSettings(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            if !self.settingsToolbar.isHidden {
                (sender as! UIButton).transform = .identity
            } else {
               (sender as! UIButton).transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
            }
        })
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
        dateLabel.text = weekday + "\n" + month + "." + day + "." + year
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

