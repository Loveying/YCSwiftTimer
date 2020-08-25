//
//  ViewController.swift
//  YCSwiftTimer
//
//  Created by Loveying on 08/25/2020.
//  Copyright (c) 2020 Loveying. All rights reserved.
//

import UIKit
import YCSwiftTimer

class ViewController: UIViewController {

    private var timer: SwiftTimer?
    
    private var countDownTimer: SwiftCountDownTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        testSingleTimer()
        //testRepeaticTimer()
        //testThrottle()
        //testRescheduleRepeating()
        //testRescheduleHandler()
        //testCountDownTimer()
    }

    /// 单独执行一次的定时器
    func testSingleTimer() {
        timer = SwiftTimer(interval: .fromSeconds(3.5), handler: {_ in
            print("testSingleTimer")
        })
        timer?.start()
    }

    /// 重复执行的定时器
    func testRepeaticTimer() {
        timer = SwiftTimer.repeaticTimer(interval: .fromSeconds(1.0), handler: { _ in
            print("testRepeaticTimer")
        })
        timer?.start()
    }
    

    /// 测试节流
    func testThrottle() {
        timer = SwiftTimer.repeaticTimer(interval: .fromSeconds(1.0), handler: { _ in
            SwiftTimer.throttle(interval: .fromSeconds(1.0), identifier: "throttle", handler: {
                print("throttle action")
            })
            print("testThrottle")
        })
        timer?.start()
    }
    
    /// 测试改变时间间隔
    func testRescheduleRepeating() {
        var count = 0
        timer = SwiftTimer.repeaticTimer(interval: .fromSeconds(1.0), handler: { timer in
            count = count + 1
            if count == 3 {
                timer.rescheduleRepeating(interval: .seconds(3))
            }
            print("testRescheduleRepeating")
        })
        timer?.start()
    }
    
    /// 测试重新开始
    func testRescheduleHandler() {
        timer = SwiftTimer(interval: .seconds(2), handler: {_ in
            print("should not pass")
        })
        timer?.rescheduleHandler(handler: { _ in
            print("testRescheduleHandler")
        })
        timer?.start()
    }
    
    /// 测试倒计时
    func testCountDownTimer() {
        countDownTimer = SwiftCountDownTimer(interval: .seconds(1), times: 10, handler: { (_, leftTime) in
            print("\(leftTime)")
        })
        countDownTimer?.start()
    }
    

}

