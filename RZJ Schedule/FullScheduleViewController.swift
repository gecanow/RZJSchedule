//
//  FullScheduleViewController.swift
//  RZJ Schedule
//
//  Created by Gaby Ecanow on 9/1/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit

class FullScheduleViewController: UIViewController {
    
    @IBOutlet weak var largeDayLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schedule = timer.mySchedule
        
        largeDayLabel.text = schedule.type
        allPeriodButtons = [one, two, three, four, five, six, seven, eight]
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name(rawValue: timerKey), object: nil)
        for i in 0..<schedule.periods.count {
            updateUI(forIndex: i)
        }
    }
    
    func update() {
        clockLabel.text = timer.currentTimer
        
        if timer.cpi >= 0 && timer.cpi <= allPeriodButtons.count {
            allPeriodButtons[timer.cpi].setTitleColor(.red, for: .normal)
            
            let x = clockLabel.frame.midX
            let y = allPeriodButtons[timer.cpi].frame.midY
            clockLabel.center = CGPoint(x: x, y: y)
        }
    }
    
    @IBAction func onTappedPeriod(_ sender: UIButton) {
        let index = (sender as AnyObject).tag!
        let t = schedule.periodTitles[index]
        let m = "Update Class"
        let alertController = UIAlertController(title: t, message: m, preferredStyle: .alert)
        
        alertController.addTextField { (tf) in
            tf.text = self.schedule.periods[index]
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = alertController.textFields![0]
            self.resetPeriod(index, withStr: textField.text!)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onTappedExit(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindFromFull", sender: self)
    }
    
    func updateUI(forIndex: Int) {
        let myTitle = schedule.periodTitles[forIndex] + ": " + schedule.periods[forIndex]
        allPeriodButtons[forIndex].setTitle(myTitle, for: .normal)
    }
    
    func resetPeriod(_ num: Int, withStr: String) {
        schedule.periods[num] = withStr
        UserDefaults.standard.setValue(withStr, forKey: schedule.type + String(num))
        updateUI(forIndex: num)
    }
}
