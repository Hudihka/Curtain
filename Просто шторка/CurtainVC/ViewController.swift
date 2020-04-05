//
//  ViewController.swift
//  CurtainVC
//
//  Created by Hudihka on 14/03/2020.
//  Copyright © 2020 Tatyana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
	}

	@IBAction func presentBlure(_ sender: Any) {
		BlureVC.presentBlure(value: .curtain)
		
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//			BlureVC.dismissBlure(completion: nil)
		}
	}
	
}

