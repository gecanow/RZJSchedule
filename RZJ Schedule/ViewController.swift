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
    @IBOutlet weak var settingsToolbar: UIView!
    
    var classSchedules = [Schedule("A"), Schedule("B"), Schedule("C"), Schedule("BB"), Schedule("CC")]
    
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var timeLeftText: UILabel!
    @IBOutlet weak var upNext: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var passingPeriodLabel: UILabel!
    
    
    let selectedBorder = CGFloat(5)
    
    var myTimer = MainTimer(Schedule("None")) // just for initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsToolbar.isHidden = true
        dayList = [a, b, c, bb, cc]
        dayListCenters = [a.center, b.center, c.center, bb.center, cc.center]
        
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
            
            if dayList[d].center == dayListCenters[d] {
                UIView.animate(withDuration: 0.5, animations: { 
                    self.dayList[d].center = (sender as! UIButton).center
                }, completion: { (void) in
                    self.dayList[d].isHidden = true
                })
            } else {
                self.dayList[d].isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.dayList[d].center = self.dayListCenters[d]
                })
            }
            
        }
    }
    
    @IBAction func onTappedSettings(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            if !self.settingsToolbar.isHidden {
                (sender as! UIButton).transform = .identity
            } else {
               (sender as! UIButton).transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
        })
        settingsToolbar.isHidden = !settingsToolbar.isHidden
    }
    
    @IBAction func onTappedShortFridaySwitch(_ sender: UISwitch) {
        // MAKE SURE THIS WORKS!!!!!
        UserDefaults.standard.set(sender.isOn, forKey: "shortFri")
        myTimer.setTime()
    }
    
    @IBAction func onTappedExtendTefillahSwitch(_ sender: UISwitch) {
        // extend that tefillah!
    }
    
    private func setTodaysSchedule() {
        let tag = UserDefaults.standard.value(forKey: "DayTag") as! Int
        myTimer.mySchedule = classSchedules[tag]
        dateLabel.text = myTimer.dateText
        
        dayList[tag].layer.borderWidth = selectedBorder
        currentDay.setTitle(String(myTimer.mySchedule.type), for: .normal)
        
        // also check for weird schedules!
    }
    
    func update() {
        period.text = myTimer.currentPeriod
        upNext.text = myTimer.upNext
        timeLeftText.text = myTimer.currentTimer
        passingPeriodLabel.text = myTimer.myPassingPeriod.calculateTime()
        dateLabel.text = myTimer.dateText
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

