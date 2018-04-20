//
//  ViewController.swift
//  GPUImageDemo
//
//  Created by Simon Gladman on 21/02/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
    let pickerView = UIPickerView(frame: CGRect.zero)
    let sliderOne = ParameterWidget(frame: CGRect.zero)
    let sliderTwo = ParameterWidget(frame: CGRect.zero)
    let sliderThree = ParameterWidget(frame: CGRect.zero)
    
    let sourceImageView = UIImageView(frame: CGRect.zero)
    let targetImageView = UIImageView(frame: CGRect.zero)
    let hideButton = UIButton()
    var hideControls = false
    
    let gpuImageDelegate = GPUImageDelegate()
    
    var sourceImage: UIImage?
    {
        didSet
        {
            if let sourceImage = sourceImage
            {
                sourceImageView.image = sourceImage
                sliderChangeHandler()
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
		view.backgroundColor = UIColor.darkGray
        
        view.addSubview(sourceImageView)
		sourceImageView.contentMode = UIViewContentMode.scaleAspectFit
		sourceImageView.layer.backgroundColor = UIColor.gray.cgColor
		sourceImageView.layer.borderColor = UIColor.black.cgColor
        sourceImageView.layer.borderWidth = 5
        
        view.addSubview(targetImageView)
		targetImageView.contentMode = UIViewContentMode.scaleAspectFit
		targetImageView.layer.backgroundColor = UIColor.gray.cgColor
		targetImageView.layer.borderColor = UIColor.black.cgColor
        targetImageView.layer.borderWidth = 5
        
        view.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
    
		pickerView.backgroundColor = UIColor.darkGray
        pickerView.layer.cornerRadius = 5
		pickerView.layer.shadowColor = UIColor.black.cgColor
        pickerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        pickerView.layer.shadowOpacity = 0.5
   
        for slider in [sliderOne, sliderTwo, sliderThree]
        {
            view.addSubview(slider)
			slider.addTarget(self, action: #selector(ViewController.sliderChangeHandler), for: UIControlEvents.valueChanged)
        }
        
        sourceImage = UIImage(named: "DSC00776.jpg")
		populateLabels(filter: gpuImageDelegate.filters[pickerView.selectedRow(inComponent: 0)])
        
        hideButton.frame = CGRect(x: view.frame.width, y: 0, width: 150, height: 50)
        hideButton.backgroundColor = UIColor.gray
        hideButton.layer.masksToBounds = false
        hideButton.layer.shadowColor = UIColor(white: 0x000000, alpha: 0.5).cgColor
        hideButton.layer.shadowOpacity = 0.5
        hideButton.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        hideButton.layer.cornerRadius = 5.0
        hideButton.layer.borderWidth = 1.0
        hideButton.layer.borderColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        hideButton.setTitle("Hide Controls", for: .normal)
        hideButton.setTitleColor(.black, for: .normal)
        hideButton.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
        view.addSubview(hideButton)
        
    }
    
    @objc func buttonAction(sender: UIButton!)
    {
        print("button clicked")
        
        if(hideControls == false)
        {
            pickerView.isHidden = true
            sliderOne.isHidden = true
            sliderTwo.isHidden = true
            sliderThree.isHidden = true
            hideControls = true
        }
        else
        {
            pickerView.isHidden = false
            sliderOne.isHidden = false
            sliderTwo.isHidden = false
            sliderThree.isHidden = false
            hideControls = false
        }
        
    }
    
    func populateLabels(filter: ImageFilter)
    {
		let fieldNames = gpuImageDelegate.getFieldNamesForFilter(filter: filter)
  
		for (idx, slider): (Int, ParameterWidget) in [sliderOne, sliderTwo, sliderThree].enumerated()
        {
            if fieldNames.count > idx
            {
                slider.fieldName = fieldNames[idx]
                slider.value = 0.5
				UIView.animate(withDuration: 0.25, animations: {slider.alpha = 1})
            }
            else
            {
                slider.fieldName = nil
				UIView.animate(withDuration: 0.25, animations: {slider.alpha = 0})
            }
        }
        
        sliderChangeHandler()
    }

    @objc func sliderChangeHandler()
    {
        let values = [CGFloat(sliderOne.value), CGFloat(sliderTwo.value), CGFloat(sliderThree.value)]
		let filter = gpuImageDelegate.filters[pickerView.selectedRow(inComponent: 0)]
        
		targetImageView.image = gpuImageDelegate.applyFilter(filter: filter, values: values, sourceImage: sourceImage!)
    }
    
    // MARK: Picker View Support
    
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
		populateLabels(filter: gpuImageDelegate.filters[row])
    }
    
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return gpuImageDelegate.filters[row].rawValue
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return gpuImageDelegate.filters.count
    }
    
    // MARK: Layout stuff
    
    override func viewDidLayoutSubviews()
    {
        let top = topLayoutGuide.length
        let imageViewWidth = CGFloat(view.frame.width / 2)
        let pickerViewHeight : CGFloat = 216
        
        sourceImageView.frame = CGRect(x: 0, y: top, width: imageViewWidth, height: imageViewWidth).insetBy(dx: 10, dy: 10)
        targetImageView.frame = CGRect(x: imageViewWidth, y: top, width: imageViewWidth, height: imageViewWidth).insetBy(dx: 10, dy: 10)
        
        pickerView.frame = CGRect(x: 0, y: view.frame.height - pickerViewHeight - top, width: view.frame.width * 0.333, height: pickerViewHeight).insetBy(dx: 10, dy: 0)
        
        sliderOne.frame = CGRect(x: view.frame.width * 0.333, y: view.frame.height - pickerViewHeight - top - 5, width: view.frame.width * 0.666, height: pickerViewHeight / 3).insetBy(dx: 10, dy: 5)
        
        sliderTwo.frame = CGRect(x: view.frame.width * 0.333, y: view.frame.height - (pickerViewHeight / 1.5) - top, width: view.frame.width * 0.666, height: pickerViewHeight / 3).insetBy(dx: 10, dy: 5)
        
        sliderThree.frame = CGRect(x: view.frame.width * 0.333, y: view.frame.height - (pickerViewHeight / 3) - top + 5, width: view.frame.width * 0.666, height: pickerViewHeight / 3).insetBy(dx: 10, dy: 5)
    }
    
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.landscape
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

