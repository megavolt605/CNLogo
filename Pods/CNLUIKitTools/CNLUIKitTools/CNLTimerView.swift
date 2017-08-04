//
//  CNLTimerView.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 25/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLFoundationTools

/// UIView with circular progress bar and label with time
open class CNLTimerView: UIView {
    
    // visual elements
    /// UILabel with time text
    open var timeLabel: UILabel!
    /// Initial text (before timer)
    open var timeLabelInitialText: String? = "Initial"
    /// Final text (after timer)
    open var timeLabelFinalText: String? = "Finished"
    
    // circle sub-layer
    /// CAShapeLayer with circular progress bar
    open var progressLayer = CAShapeLayer()
    /// progressLayer transform (default is rotation on -pi/2.0)
    open var progressLayerTransform = CATransform3DMakeRotation(CGFloat(-Double.pi / 2.0), 0.0, 0.0, 1.0)
    
    // time values
    /// Timer interval
    open var timerInterval: TimeInterval = 0.1
    /// Timer start date
    open var timerStartDate: Date!
    
    /// Direction of the progress indicator (false - clockwise, true - counterclockwise)
    open var backward: Bool = false
    
    /// Fill color of the progress indicator
    open var fillColor = UIColor.clear {
        didSet {
            progressLayer.fillColor = fillColor.cgColor
        }
    }
    
    /// Stroke color of the progress indicator
    open var strokeColor = UIColor.blue {
        didSet {
            progressLayer.strokeColor = strokeColor.cgColor
        }
    }
    
    /// Closure with formatting text for progress label (default - number of seconds)
    open var timeLabelText: ((_ timerView: CNLTimerView, _ time: TimeInterval) -> String)?
    
    /// Line width of the progress indicator
    open var lineWidth: CGFloat = 4.0 {
        didSet {
            progressLayer.lineWidth = lineWidth
            setNeedsLayout()
        }
    }
    
    /// Current progress (will animate changes)
    open var progress: CGFloat {
        get { return progressLayer.strokeEnd }
        set {
            if newValue >= 1.0 {
                progressLayer.strokeEnd = 1.0
            } else if newValue <= 0.0 {
                progressLayer.strokeEnd = 0.0
            } else {
                if backward {
                    progressLayer.strokeEnd = 1.0 - newValue
                } else {
                    progressLayer.strokeEnd = newValue
                }
            }
        }
    }
    
    // Private variables
    private var completion: (() -> Void)?
    private var timer: Timer?
    private var timerDuration: TimeInterval = 0.0
    
    /// Starts timer, calls completion closure when finished
    ///
    /// - Parameters:
    ///   - duration: Duration in seconds
    ///   - completion: Completion closure
    open func startTimer(duration: TimeInterval, completion: (() -> Void)? = nil) {
        self.completion = completion
        timerDuration = duration
        timerStartDate = Date()
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(timerFired(timer:)), userInfo: nil, repeats: true)
        updateProgress()
    }
    
    open func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Updates current progress
    open func updateProgress() {
        let timePassed = -timerStartDate.timeIntervalSinceNow
        if timePassed > timerDuration {
            timeLabel.text = timeLabelFinalText
            timer?.invalidate()
            self.timer = nil
            progress = backward ? 0.0 : 1.0
            completion?()
        } else {
            progress = CGFloat(timePassed) / CGFloat(timerDuration)
            if let text = timeLabelText?(self, timePassed) {
                timeLabel.text = text
            } else {
                if backward {
                    timeLabel.text = "\(Int(floor(timerDuration - timePassed)) + 1)"
                } else {
                    timeLabel.text = "\(Int(floor(timePassed)) + 1)"
                }
            }
        }
    }
    
    /// Timer function
    ///
    /// - Parameter timer: Source timer
    @objc open func timerFired(timer: Timer) {
        updateProgress()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        timeLabel.frame = bounds
        
        progressLayer.frame = bounds
        progressLayer.transform = progressLayerTransform
        let path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0))
        progressLayer.path = path.cgPath
    }
    
    /// Creates objects for the view (label, progress layer)
    open func createObjects() {
        timeLabel = UILabel() --> {
            $0.textAlignment = .center
            $0.text = timeLabelInitialText
            self.addSubview($0)
            return $0
        }
        
        progressLayer --> {
            $0.lineWidth = lineWidth
            $0.bounds = bounds
            $0.fillColor = fillColor.cgColor
            $0.strokeColor = strokeColor.cgColor
            $0.lineCap = kCALineCapRound
            self.layer.addSublayer($0)
        }
    }
    
    override public required init(frame: CGRect) {
        super.init(frame: frame)
        createObjects()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createObjects()
    }
    
}
