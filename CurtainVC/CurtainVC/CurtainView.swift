//
//  CurtainView.swift
//  CurtainVC
//
//  Created by Hudihka on 14/03/2020.
//  Copyright © 2020 Tatyana. All rights reserved.
//

import UIKit

class CurtainView: UIView {

	var dissmisBlock: () -> () = { }
	
	init() {
		super.init(frame: CurtainConstant.startFrame)
		startDesing()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func startDesing(){
		self.backgroundColor = UIColor.red
		
		let button = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 50))
		button.backgroundColor = .green
		button.setTitle("Test Button", for: .normal)
		button.addTarget(self, action: #selector(dissmisSelf), for: .touchUpInside)

		self.addSubview(button)
		
		let TF = UITextView(frame: CGRect(x: 10, y: 10, width: 200, height: 30))
		TF.backgroundColor = UIColor.green
		self.addSubview(TF)
	}
	
	
	@objc func dissmisSelf(sender: UIButton!) {
	  dissmisBlock()
	}
}
