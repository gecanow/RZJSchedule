//
//  FullScheduleViewController.swift
//  RZJ Schedule
//
//  Created by Gaby Ecanow on 9/1/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

class FullScheduleViewController: UIViewController {
    
    //========//
    // FIELDS //
    //========//
    
    @IBOutlet weak var largeDayLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var schedule : Schedule!
    var timer : MainTimer!
    
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    var allPeriodButtons : [UIButton]!
    
    //===============//
    // VIEW DID LOAD //
    //===============//
    override func viewDidLoad() {
        super.viewDidLoad()
        schedule = timer.mySchedule
        dateLabel.text = timer.dateText
        
        largeDayLabel.text = schedule.type
        allPeriodButtons = [one, two, three, four, five, six, seven, eight]
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name(rawValue: timerKey), object: nil)
        updateUI()
    }
    
    //--------------------------------------------------
    // Is called when NSNotificationCenter recieves a
    // notification (timer updated -> update() called)
    //--------------------------------------------------
    func update() {
        dateLabel.text = timer.dateText
        clockLabel.text = ""
        
        if timer.cpi >= 0 && timer.cpi <= allPeriodButtons.count {
            clockLabel.text = timer.currentTimer
            allPeriodButtons[timer.cpi].setTitleColor(.red, for: .normal)
            
            let x = clockLabel.frame.midX
            let y = allPeriodButtons[timer.cpi].frame.midY
            clockLabel.center = CGPoint(x: x, y: y)
        }
    }
    
    //--------------------------------------------------
    // Sends an alert w/ a textfield to update the name
    // of the class during a certain period
    //--------------------------------------------------
    @IBAction func onTappedPeriod(_ sender: UIButton) {
        let index = (sender as AnyObject).tag!
        let t = "Update \(schedule.getScheduleTitles(timer.weekday)[index])"
        let alertController = UIAlertController(title: t, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (tf) in
            tf.text = self.schedule.getSchedule(self.timer.weekday)[index]
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = alertController.textFields![0]
            self.resetPeriod(index, withStr: textField.text!)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //--------------------------------------------------
    // Handles seguing to the main vc
    //--------------------------------------------------
    @IBAction func onTappedExit(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindFromFull", sender: self)
    }
    
    //--------------------------------------------------
    // Updates the entire UI to display the correct
    // period titles and classes
    //--------------------------------------------------
    func updateUI() {
        for forIndex in 0..<schedule.periods.count {
            let myTitle = schedule.getScheduleTitles(timer.weekday)[forIndex] + ": " + schedule.getSchedule(timer.weekday)[forIndex]
            allPeriodButtons[forIndex].setTitle(myTitle, for: .normal)
        }
    }
    
    //--------------------------------------------------
    // Resets the classes for a single period
    //--------------------------------------------------
    func resetPeriod(_ num: Int, withStr: String) {
        schedule.periods[num] = withStr
        UserDefaults.standard.setValue(withStr, forKey: schedule.type + String(num))
        updateUI()
    }
}
