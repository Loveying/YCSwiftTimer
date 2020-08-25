//
//  SwiftTimer.swift
//
//  Created by Xyy on 2020/8/25.
//  Copyright © 2020 sany. All rights reserved.
//

import Foundation

public class SwiftTimer {
    
    private var isRunning = false
    
    private let repeats: Bool
        
    private var handler: SwiftTimerHandler
    
    private let internalTimer: DispatchSourceTimer
    
    public typealias SwiftTimerHandler = (SwiftTimer) -> Void

    /// 创建定时器
    /// - Parameters:
    ///   - interval: 时间间隔
    ///   - repeats: 是否重复
    ///   - queue: 队列
    ///   - handler: 事件处理
    public init(interval: DispatchTimeInterval,
                repeats: Bool = false,
                queue: DispatchQueue = .main,
                handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        self.repeats = repeats
        
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            guard let `self` = self else { return }
            handler(self)
        }
        
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        } else {
            internalTimer.schedule(deadline: .now() + interval)
        }
    }
    
    /// 创建重复执行的定时器
    /// - Parameters:
    ///   - interval: 时间间隔
    ///   - queue: 队列
    ///   - handler: 事件处理
    /// - Returns: 重复执行的定时器
    public static func repeaticTimer(interval: DispatchTimeInterval,
                                     queue: DispatchQueue = .main,
                                     handler: @escaping SwiftTimerHandler) -> SwiftTimer {
        return SwiftTimer(interval: interval, repeats: true, queue: queue, handler: handler)
    }
    
    /// 释放
    deinit {
        if !isRunning {
            internalTimer.resume()
        }
    }
    
    /// 失效
    public func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            internalTimer.cancel()
        }
    }
    
    /// 开始
    public func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }
    
    /// 暂停
    public func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }
    
    /// 重新重复执行
    public func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }
    
    /// 重新重复执行处理
    public func rescheduleHandler(handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        internalTimer.setEventHandler { [weak self] in
            guard let `self` = self else { return }
            handler(self)
        }
    }
}


// MARK: - Throttle
public extension SwiftTimer {
    
    private static var workItems:[String: DispatchWorkItem] = [:]
    
    /// 重复执行定时器，延迟一定时间内执行自己的操作，达到节流的目的
    /// - Parameters:
    ///   - interval: 时间间隔
    ///   - identifier: 标识符
    ///   - queue: 队列
    ///   - handler: 事件处理
    static func throttle(interval: DispatchTimeInterval,
                         identifier: String, queue: DispatchQueue = .main ,
                         handler: @escaping () -> Void) {
        if workItems[identifier] != nil {
            return;
        }
        let item = DispatchWorkItem {
            handler()
            workItems.removeValue(forKey: identifier)
        }
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item);
    }
    
    /// 取消节流的定时器
    /// - Parameter identifier: 标识符
    static func cancelThrottlingTimer(identifier: String) {
        if let item = workItems[identifier] {
            item.cancel()
            workItems.removeValue(forKey: identifier)
        }
    }
}


// MARK: - 倒计时的定时器
public class SwiftCountDownTimer {
    
    private var leftTimes: Int
    
    private let originalTimes: Int
    
    private let internalTimer: SwiftTimer
    
    private let handler: (SwiftCountDownTimer, _ leftTimes: Int) -> Void
    
    /// 创建倒计时的定时器
    /// - Parameters:
    ///   - interval: 时间间隔
    ///   - times: 总时间
    ///   - queue: 队列
    ///   - handler: 事件处理
    public init(interval: DispatchTimeInterval,
                times: Int,
                queue: DispatchQueue = .main,
                handler: @escaping (SwiftCountDownTimer, _ leftTimes: Int) -> Void) {
        self.leftTimes = times
        self.originalTimes = times
        self.handler = handler
        
        internalTimer = SwiftTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in })
        internalTimer.rescheduleHandler { [weak self]  swiftTimer in
            guard let `self` = self else { return }
            if self.leftTimes > 0 {
                self.leftTimes -= 1
                self.handler(self, self.leftTimes)
            } else {
                self.internalTimer.suspend()
            }
        }
    }
    
    /// 开始
    public func start() {
        internalTimer.start()
    }
    
    /// 暂停
    public func suspend() {
        internalTimer.suspend()
    }
    
    /// 重新开始
    public func reCountDown() {
        leftTimes = originalTimes
    }
    
}


// MARK: - DispatchTimeInterval支持Double类型
public extension DispatchTimeInterval {
    static func fromSeconds(_ seconds: Double) -> DispatchTimeInterval {
        return .milliseconds(Int(seconds * 1000))
    }
}
