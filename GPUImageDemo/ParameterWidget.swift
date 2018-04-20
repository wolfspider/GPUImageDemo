//
//  ParameterWidget.swift
//  GPUImageDemo
//
//  Created by Simon Gladman on 23/10/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ParameterWidget: UIControl, UIPopoverControllerDelegate
{
    let label = UILabel(frame: CGRect.zero)
    let slider = UISlider(frame: CGRect.zero)
    
    
    override func didMoveToSuperview()
    {
        
		label.textColor = UIColor.white
		layer.backgroundColor = UIColor.darkGray.cgColor
        
        layer.cornerRadius = 5
        
		layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        
        addSubview(label)
        addSubview(slider)
        
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        
		slider.addTarget(self, action: #selector(ParameterWidget.sliderChangeHandler), for: UIControlEvents.valueChanged)
    }
    
    @objc func sliderChangeHandler()
    {
        value = slider.value
        
        popoulateLabel()
        
		sendActions(for: UIControlEvents.valueChanged)
    }
    
    func popoulateLabel()
    {
        if let fieldName = fieldName
        {
            label.text = fieldName + " = " + (NSString(format: "%.2f", value) as String)
        }
        else
        {
            label.text = ""
        }
    }
    
    var fieldName: String?
    {
        didSet
        {
            popoulateLabel();
        }
    }
    
    var value: Float = 0
        {
        didSet
        {
            slider.setValue(value, animated: true)
            popoulateLabel()
        }
    }
    
    var minimumValue: Float = 0.0
        {
        didSet
        {
            slider.minimumValue = minimumValue
        }
    }
    
    var maximumValue: Float = 1
        {
        didSet
        {
            slider.maximumValue = maximumValue
        }
    }
    
    override func layoutSubviews()
    {
        label.frame = CGRect(x: 5, y: -3, width: frame.width, height: frame.height / 2)
        slider.frame = CGRect(x: 0, y: frame.height - 30, width: frame.width, height: frame.height / 2)
    }
    
}
