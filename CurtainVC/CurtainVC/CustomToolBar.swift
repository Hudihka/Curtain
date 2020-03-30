//
//  CustomToolBar.swift
//  CurtainVC
//
//  Created by Hudihka on 30/03/2020.
//  Copyright © 2020 Tatyana. All rights reserved.
//

import UIKit

class CustomToolBar: UIToolbar {
	
	@IBOutlet var counteinerView: UIToolbar!
	
	init() {
		super.init(frame: CGRect(x: 0, y: 0, width: wDdevice, height: 40))
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
		if let TB = loadViewFromNib("CustomToolBar") as? UIToolbar{
			counteinerView = TB
			counteinerView.frame = bounds
			counteinerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			addSubview(counteinerView )
		}
	}
	
	private func settingsView(){
		self.backgroundColor = UIColor.red
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
