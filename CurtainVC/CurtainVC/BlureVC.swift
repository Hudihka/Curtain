//
//  BlureVC.swift
//  CurtainVC
//
//  Created by Hudihka on 14/03/2020.
//  Copyright © 2020 Tatyana. All rights reserved.
//

import UIKit

enum EnumBlure{
	case spiner
	case curtain
}

let allWayTimeInterval: TimeInterval = 0.30
let smallWayTimeInterval: TimeInterval = 0.2

class BlureVC: UIViewController {
	
	@IBOutlet weak var blureView: VisualEffectView!
	@IBOutlet weak var spiner: UIActivityIndicatorView!
	
	var enumBlure: EnumBlure = .spiner
	
	var curtain: CurtainView?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		Vibro.weak()
		
    }
	
	//MARK: - CREATE
	
	static func route(value: EnumBlure = .spiner) -> BlureVC{
		
		let storubord = UIStoryboard(name: "Main", bundle: nil)
		let VC = storubord.instantiateViewController(withIdentifier: "BlureVC") as! BlureVC
		VC.enumBlure = value
		
		
		return VC
    }
	
	//лучше всего для шторок
	
	static func presentBlure(value: EnumBlure = .spiner) {
		
		let VC = BlureVC.route(value: value)
		UIApplication.shared.workVC.present(VC, animated: false, completion: nil)
    }
	
	//только для сппинера
	
	static func dismissBlure(completion: (() -> Void)?) {
		
		if let VC = UIApplication.shared.workVC as? BlureVC, VC.enumBlure == .spiner{
			VC.dismiss(animated: false, completion: completion)
		}
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

		newValue()
    }
    
	
	private func newValue(){
		
		switch enumBlure {
		case .spiner:
			blureView.blureValue()
			self.spiner.startAnimating()
		case .curtain:
			self.curtain = CurtainView()
			curtainAnimmate(addCurtain: true)
		}
	}
	
	private func curtainAnimmate(addCurtain: Bool){
		
		guard let curtain = curtain else {return}
		
		if addCurtain {
			self.view.addSubview(curtain)
			
			self.curtain?.dissmisBlock = {
				self.curtainAnimmate(addCurtain: false)
			}
		}
		
		blureView.enumBlureValue = addCurtain ? .max : .min
		let frame = addCurtain ? CurtainConstant.finishFrame : CurtainConstant.startFrame
		
		UIView.animate(withDuration: allWayTimeInterval,
					   delay: 0,
					   usingSpringWithDamping: 0.8,
					   initialSpringVelocity: 0,
					   options: .curveEaseInOut,
					   animations: {
						
						self.blureView.blureValue()
						curtain.frame = frame
						
		}, completion: {[weak self] (compl) in
			if compl{
				
				if addCurtain {
					self?.addPanGestures()
				} else {
					self?.dismiss(animated: false, completion: nil)
				}
			}
			
		})
		
		
	}

	//gestures

	
    private func addPanGestures(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:)))
        panGestureRecognizer.minimumNumberOfTouches = 1

        curtain?.addGestureRecognizer(panGestureRecognizer)
    }
	
	@objc func panGesture(sender: UIPanGestureRecognizer) {
		
		let translatedPoint = sender.translation(in: self.view).y
		let frame = CurtainConstant.newFrame(translatedPointY: translatedPoint)
		
		self.curtain?.frame = frame
		
		let koef = CurtainConstant.koefBlure(translatedPointY: translatedPoint)
		
		//		print(koef)
		
		self.curtain?.alpha = koef
		self.blureView.blureAt(koef)
		
		if sender.state == .ended {
			let dismiss = CurtainConstant.dismiss(yPoint: frame.origin.y)
			self.finalGestureAnimate(dismiss)
		}
		
		
		
		//		print(translatedPoint)
		//
		//
		//		if translatedPoint >= 0 {
		//
		//		} else {
		//
		//		}
		//
		//
		//		            if sender.state == .ended {
		//		                self.dismisViewCurtainTask(back: translatedPoint > yPointDissmis)
		//		            }
		
		
		//        let yPoint = translatedPoint - startReloadAlphaY
		//        let koef = 1 - (yPoint / allWayReloadAlpha)
		//
		//        let curtainActive = curtainFilters ?? curtainTF
		//
		//        if translatedPoint >= finishPointYCurtainFilters {
		//            curtainActive?.frame = CGRect(x: 0, y: translatedPoint, width: wDdevice, height: heightCurtainFilters)
		//
		//            if translatedPoint > startReloadAlphaY , koef <= 1{
		//                blureView?.blureAt(koef)
		//                curtainAlpha(alpha: koef)
		//            }
		//
		//            if sender.state == .ended {
		//                self.dismisViewCurtainTask(back: translatedPoint > yPointDissmis)
		//            }
		//
		//        } else {
		//            curtainActive?.frame = finishFrameCurtainFilters
		//        }
	}
	
	private func finalGestureAnimate(_ dismiss: Bool){
		
		blureView.enumBlureValue = dismiss ? .min : .max
		let frame = dismiss ?  CurtainConstant.startFrame : CurtainConstant.finishFrame
		
		UIView.animate(withDuration: smallWayTimeInterval,
					   delay: 0,
					   options: [.curveEaseOut],
					   animations: {
						self.blureView.blureValue()
						self.curtain?.frame = frame
		}) {[weak self] (compl) in
			if compl, dismiss{
				self?.dismiss(animated: false, completion: nil)
			}
		}
		
		
		
		
	}

}
