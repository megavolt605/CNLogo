//
//  CNLDatePickerView.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 25/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLFoundationTools

public typealias CNLDatePickerValueChanged = (_ datePicker: CNLDatePicker, _ date: Date) -> Void

open class CNLDatePicker: UIPickerView {
    
    fileprivate let maxRowCount = 500
    fileprivate let dayCount = 31
    fileprivate let monthCount = 12
    fileprivate let yearCount = 110
    
    fileprivate let calendar = Calendar.current
    
    open var year: Int = 2000
    open var month: Int = 1
    open var day: Int = 1
    
    open var valueChanged: CNLDatePickerValueChanged?
    
    open var date: Date {
        var dc = DateComponents()
        dc.calendar = calendar
        dc.year = year
        dc.month = month
        dc.day = day
        while !dc.isValidDate(in: calendar) {
            day -= 1
        }
        dc.day = day
        let date = dc.date!.addingTimeInterval(TimeInterval(calendar.timeZone.secondsFromGMT()))
        return date
    }
    
    open func setDate(_ date: Date, animated: Bool) {
        
        let dc = (calendar as Calendar).dateComponents([.day, .month, .year], from: date)
        
        year = dc.year!
        month = dc.month!
        day = dc.day!
        var s = (maxRowCount / 2 / dayCount) * dayCount
        selectRow(s + day - 1, inComponent: 0, animated: animated)
        
        s = (maxRowCount / 2 / monthCount) * monthCount
        selectRow(s + month - 1, inComponent: 1, animated: animated)
        
        s = (maxRowCount / 2 / yearCount) * yearCount
        selectRow(s + year - 1900, inComponent: 2, animated: animated)
        
        valueChanged?(self, date)
    }
    
    func initialization() {
        dataSource = self
        delegate = self
        setDate(date, animated: false)
        //calendar.timeZone = NSTimeZone.localTimeZone()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
}

extension CNLDatePicker: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxRowCount
    }
    
}

extension CNLDatePicker: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0: return 60
        case 1: return 150
        case 2: return 70
        default: return 30
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let s = pickerView.rowSize(forComponent: component)
        let v = UIView(frame: CGRect(x: 0.0, y: 0.0, width: s.width, height: s.height))
        let l = UILabel(frame: v.bounds)
        l.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        l.isOpaque = false
        l.textColor = UIColor.white
        l.font = UIFont.systemFont(ofSize: 24.0)
        l.textAlignment = .center
        switch component {
        case 0: // day
            var b = l.frame
            b.size.width -= 5.0
            l.text = "\(row % dayCount + 1)"
        case 1: // month
            let df = DateFormatter()
            df.dateFormat = "MMMM"
            var dc = DateComponents()
            dc.year = 2000
            dc.month = row % monthCount + 1
            dc.day = 1
            dc.calendar = calendar
            l.text = "\(df.string(from: dc.date!))"
        case 2: // year
            l.text = "\(1900 + row % yearCount)"
        default: break
        }
        v.addSubview(l)
        return l
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            let s = (maxRowCount / 2 / dayCount) * dayCount
            day = row - s + 1
            while day <= 0 { day += dayCount }
            while day > dayCount { day -= dayCount }
            selectRow(s + day - 1, inComponent: component, animated: false)
        case 1:
            let s = (maxRowCount / 2 / monthCount) * monthCount
            month = row - s + 1
            while month <= 0 { month += monthCount }
            while month > monthCount { month -= monthCount }
            selectRow(s + month - 1, inComponent: component, animated: false)
        case 2:
            let s = (maxRowCount / 2 / yearCount) * yearCount
            year = row - s
            while year <= 0 { year += yearCount }
            while year > yearCount { year -= yearCount }
            selectRow(s + year, inComponent: component, animated: false)
            year += 1900
        default: break
        }
        setDate(date, animated: true)
    }
    
}
