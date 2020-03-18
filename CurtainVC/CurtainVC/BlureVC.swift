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
	
	var panGestureRecognizer: UIPanGestureRecognizer?
	
	var SV: UIScrollView?
	
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
	
	static func dismissBlure(completion: (() -> Void)?) {
		
		if let VC = UIApplication.shared.workVC as? BlureVC {
			if VC.enumBlure == .spiner{
				VC.dismiss(animated: false, completion: completion)
			} else {
				VC.curtainAnimmate(addCurtain: false, completionDissmis: completion)
			}
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
	
	private func curtainAnimmate(addCurtain: Bool, completionDissmis: (() -> Void)? = nil){
		
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
					self?.dismiss(animated: false, completion: completionDissmis)
				}
			}
			
		})
		
		
	}

	//MARK: gestures

	
    private func addPanGestures(){
		self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:)))
		panGestureRecognizer?.minimumNumberOfTouches = 1

		curtain?.addGestureRecognizer(panGestureRecognizer!)
		
		let tabGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        blureView?.addGestureRecognizer(tabGestureRecognizer)
		
		//жест при тапе по шторки убираем клавиатуру
		
		self.curtain?.recurrenceAllSubviews.forEach({ (view) in
			
			if let svView = view as? UIScrollView{
				self.SV = svView
				panGestureRecognizer?.delegate = self
			}
			
			if view.isTFView{
				let tabGestureRecognizerCurtain = UITapGestureRecognizer(target: self, action: #selector(tapGestureCurtain(sender:)))
				curtain?.addGestureRecognizer(tabGestureRecognizerCurtain)
				tabGestureRecognizerCurtain.require(toFail: panGestureRecognizer!)
			}
			
			
			
		})
		
    }
	
	@objc func panGesture(sender: UIPanGestureRecognizer) {
		
		print("=====")
		let translatedPoint = sender.translation(in: self.view).y
		let frame = CurtainConstant.newFrame(translatedPointY: translatedPoint)
		
		self.curtain?.frame = frame
		
		let koef = CurtainConstant.koefBlure(newPosition: frame.origin.y)
		
		self.aphaAllContentCurtain(alpha: koef, dissmisKeybord: true)
		self.blureView.blureAt(koef)
		
		if sender.state == .ended {
			let dismiss = CurtainConstant.dismiss(yPoint: frame.origin.y)
			self.finalGestureAnimate(dismiss)
		}
		
	}
	
	@objc func tapGesture(sender: UIPanGestureRecognizer) {
		if let array = self.curtain?.recurrenceAllSubviews{
			for view in array {
				if view.uiviewTextFirsResponser(){
					return
				}
			}
		}
		self.curtainAnimmate(addCurtain: false)
	}
	
	@objc func tapGestureCurtain(sender: UIPanGestureRecognizer) {
		
		self.curtain?.recurrenceAllSubviews.forEach({ (view) in
			if view.uiviewTextFirsResponser(){
				return
			}
		})
	}
	
	private func aphaAllContentCurtain(alpha: CGFloat?, dissmisKeybord: Bool){
		self.curtain?.recurrenceAllSubviews.forEach({ (view) in
			
			if let alpha = alpha {
				view.alpha = alpha
			}
			
			if dissmisKeybord{
				view.uiviewTextFirsResponser()
			}
			
		})
	}
	
	private func finalGestureAnimate(_ dismiss: Bool){
		
		blureView.enumBlureValue = dismiss ? .min : .max
		let finishAlpha: CGFloat = dismiss ? 0 : 1
		let frame = dismiss ?  CurtainConstant.startFrame : CurtainConstant.finishFrame
		
		UIView.animate(withDuration: smallWayTimeInterval,
					   delay: 0,
					   options: [.curveEaseOut],
					   animations: {
						self.blureView.blureValue()
						self.curtain?.frame = frame
						self.aphaAllContentCurtain(alpha: finishAlpha, dissmisKeybord: false)
		}) {[weak self] (compl) in
			if compl, dismiss{
				self?.dismiss(animated: false, completion: nil)
			}
		}
		
	}

}

extension BlureVC: UIGestureRecognizerDelegate{
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		
//		if let gesters =
//
//		let velocity: CGPoint = gestureRecognizer.velocity(in: SV)
//
//		print(velocity)
		
		guard let myGesters = self.panGestureRecognizer else {return true}
//
		if myGesters.isEqual(gestureRecognizer){
			
			if myGesters.location(in: SV).y < 0 {
				print("жест не в таблице")
			} else if SV?.contentOffset.y == 0{
				self.panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer
				print("нулю офсет равен")
			} else {
				print("жест в таблице")
			}
			
//			print(myGesters.location(in: SV).y)
//			print(myGesters.location(in: self.curtain).y)
			
		}
		
		
		
		
//		if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) == false{
//			return true
//		}
//
////
//		if gestureRecognizer.isEqual(SV?.panGestureRecognizer) == false {
//
//			if SV?.contentOffset.y != 0 {
//				return false
//			}
//
//			let velocity: CGPoint = UIPanGestureRecognizer().velocity(in: SV)
//
//			print(velocity)
//			if velocity.y > abs(velocity.x){
//				return true
//			}
//
//
//			return true
//		}
		
		
		return true
	}
	
	
}


extension UIView {
	
    var recurrenceAllSubviews: [UIView] {//получение всех UIView
        var all = [UIView]()
        func getSubview(view: UIView) {
            all.append(view)
            guard !view.subviews.isEmpty else {
                return
            }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)

        return all
    }
	
	@discardableResult func uiviewTextFirsResponser() -> Bool{
		
		if let TF = self as? UITextField, TF.isFirstResponder{
			TF.resignFirstResponder()
			return true
		}
		
		
		if let TV = self as? UITextView, TV.isFirstResponder{
			TV.resignFirstResponder()
			return true
		}
		
		
		return false
	}
	
	var isTFView: Bool{
		
		if let _ = self as? UITextField{
			return true
		}
		
		
		if let _ = self as? UITextView{
			return true
		}
		
		
		return false
	}
	
}
