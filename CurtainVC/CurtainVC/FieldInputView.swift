//
//  FieldInputView.swift
//  CurtainVC
//
//  Created by Hudihka on 31/03/2020.
//  Copyright © 2020 Tatyana. All rights reserved.
//

import UIKit

class FieldInputView: UIView {
	
	var doneBlock: () -> () = { }
	
	@IBOutlet var counteinerView: UIView!
	
	init() {
		super.init(frame: CGRect(x: 0, y: 0, width: wDdevice, height: 44))
	}
	
	override init (frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        settingsView()
    }
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	

	private func xibSetup() {
		counteinerView = loadViewFromNib("FieldInputView")
		counteinerView.frame = bounds
		counteinerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(counteinerView)
	}
	
	private func settingsView(){
	}
	
	@IBAction func done(_ sender: UIButton) {
		self.doneBlock()
	}
	

}

extension UIView {
	@objc func loadViewFromNib(_ name: String) -> UIView { //добавление вью созданной в ксиб файле
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: name, bundle: bundle)
		if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
			return view
		} else {
			return UIView()
		}
	}
}


extension UITextField {
	
	func addFieldView(){
		
		self.autocorrectionType = .no
		let viewInput = FieldInputView()
		self.inputAccessoryView = viewInput
		
		viewInput.doneBlock = {
			self.becomeFirstResponder()
		}
		
	}
	
}
