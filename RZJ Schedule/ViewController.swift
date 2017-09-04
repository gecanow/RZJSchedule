//
//  ViewController.swift
//  RZJ Schedule
//
//  Created by Gaby Ecanow on 9/1/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //========//
    // FIELDS //
    //========//
    
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
    
    @IBOutlet weak var shortFriSwitch: UISwitch!
    @IBOutlet weak var extendTefillahSwitch: UISwitch!
    
    let selectedBorder = CGFloat(5)
    
    var myTimer = MainTimer(Schedule("None")) // just for initialization
    
    //===============//
    // VIEW DID LOAD //
    //===============//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shortFriSwitch.isOn = UserDefaults.standard.value(forKey: "shortFri") as! Bool
        extendTefillahSwitch.isOn = UserDefaults.standard.value(forKey: "extendedTefillah") as! Bool
        
        settingsToolbar.isHidden = true
        dayList = [a, b, c, bb, cc]
        dayListCenters = [a.center, b.center, c.center, bb.center, cc.center]
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name(rawValue: timerKey), object: nil)
        
        setTodaysSchedule()
    }
    
    //--------------------------------------------------
    // Helper function for the ViewDidLoad:
    // Sets up the proper type of day
    //--------------------------------------------------
    private func setTodaysSchedule() {
        let tag = UserDefaults.standard.value(forKey: "DayTag") as! Int
        myTimer.mySchedule = classSchedules[tag]
        dateLabel.text = myTimer.dateText
        
        dayList[tag].layer.borderWidth = selectedBorder
        currentDay.setTitle(String(myTimer.mySchedule.type), for: .normal)
    }
    
    //--------------------------------------------------
    // Responsible for changing the type of day
    // when a day button is tapped
    //--------------------------------------------------
    @IBAction func onTappedDay(_ sender: UIButton) {
        for d in 0..<dayList.count {
            dayList[d].layer.borderWidth = 1
            animateDayButtonAt(i: d)
        }
        UserDefaults.standard.setValue(sender.tag, forKey: "DayTag")
        setTodaysSchedule()
    }
    
    //--------------------------------------------------
    // Animates the day buttons to collapse or expand
    // with help from the helper function,
    // animateDayButton(: Int)
    //--------------------------------------------------
    @IBAction func onTappedChangeDay(_ sender: Any) {
        for d in 0..<dayList.count {
            animateDayButtonAt(i: d)
        }
    }
    private func animateDayButtonAt(i: Int) {
        if dayList[i].center == dayListCenters[i] {
            UIView.animate(withDuration: 0.5, animations: {
                self.dayList[i].center = self.currentDay.center
            }, completion: { (void) in
                self.dayList[i].isHidden = true
            })
        } else {
            self.dayList[i].isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.dayList[i].center = self.dayListCenters[i]
            })
        }
    }
    
    //--------------------------------------------------
    // Animates the settings buttons and reveals or
    // hides the settings toolbar
    //--------------------------------------------------
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
    
    //--------------------------------------------------
    // Resets the timer's time when either the short
    // friday switch is switched or the extended
    // tefillah switch is switched
    //--------------------------------------------------
    @IBAction func onTappedShortFridaySwitch(_ sender: UISwitch) {
        // MAKE SURE THIS WORKS!!!!!
        UserDefaults.standard.set(sender.isOn, forKey: "shortFri")
        myTimer.setTime()
    }
    @IBAction func onTappedExtendTefillahSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "extendedTefillah")
        myTimer.setTime()
    }
    
    //--------------------------------------------------
    // Is called when NSNotificationCenter recieves a
    // notification (timer updated -> update() called)
    //--------------------------------------------------
    func update() {
        period.text = myTimer.currentPeriod
        upNext.text = myTimer.upNext
        timeLeftText.text = myTimer.currentTimer
        passingPeriodLabel.text = myTimer.myPassingPeriod.calculateTime()
        dateLabel.text = myTimer.dateText
    }
    
    //--------------------------------------------------
    // Exchange of timer reference when segue to full
    // schedule vc is tapped
    //--------------------------------------------------
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! FullScheduleViewController
        dvc.timer = myTimer
    }
}

