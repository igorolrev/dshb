//
// WidgetBattery.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2014, 2015  beltex <https://github.com/beltex>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

struct WidgetBattery: WidgetType {
    
    private var widget: WidgetBase
    
    init(var window: Window = Window()) {
        widget = WidgetBase(name: "Battery", window: window)

        
        let stats: [(name: String, maxValue: Double, unit: Meter.Unit)] =
  [("Charge", 100.0, .Percentage),
   ("Capacity Degradation", Double(battery.designCapacity()), .MilliampereHour),
   ("Cycles", Double(battery.designCycleCount()), .None),
   ("Time Remaining", 0.0, .None)]
        
        window.point.y++
        for stat in stats {
            widget.meters.append(Meter(name: stat.name,
                                       winCoords: window,
                                       max: stat.maxValue,
                                       unit: stat.unit))
            window.point.y++
        }
        
        
        widget.meters[0].lowPercentage = 0.2
        widget.meters[0].midPercentage = 0.0
        widget.meters[0].highPercentage = 0.8
        widget.meters[0].lowColour = Int32(3)
        widget.meters[0].highColour = Int32(1)
        
        widget.meters[1].lowColour = Int32(3)
        widget.meters[1].highColour = Int32(1)
    }
    
    mutating func draw() {
        let charge = battery.charge()
        widget.meters[0].draw(String(Int(battery.charge())),
                       percentage: charge / 100.0)
        
        var v1 = battery.maxCapactiy()
        var v2 = battery.cycleCount()
        
        widget.meters[1].draw(String(v1 - Int(widget.meters[1].max)),
                              percentage:  Double(v1) / widget.meters[1].max)
        widget.meters[2].draw(String(v2), percentage: Double(v2) / widget.meters[2].max)
        widget.meters[3].draw(battery.timeRemainingFormatted(), percentage: 0.0)
    }
    
    mutating func resize(window: Window) -> Int32 {
        return widget.resize(window)
    }
}
