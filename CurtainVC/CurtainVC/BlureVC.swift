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
	
	
	private var SV: UIScrollView?
	
	
	private var lastOffset: CGPoint = .zero
	private var startLocation: CGPoint = .zero
		
	//	заморозить смещение контента
	private var freezeContentOffset = false
	
	
	
	private var allView = [UIView]()
	
	private var sertchBar: UISearchBar?
	private var TFArray = [UITextField]()
	
//	var tableViewPanGestureRecognizer: UIPanGestureRecognizer?
	
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
		
		guard let curtain = self.curtain else {return}
		
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:)))
        curtain.addGestureRecognizer(panGestureRecognizer)
		
		//дисмис клавиатуры и всего
		
		let tabGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        blureView?.addGestureRecognizer(tabGestureRecognizer)
		
		self.allView = curtain.recurrenceAllSubviews
		self.allView.forEach { (view) in
			if let viewSV = view as? UIScrollView, viewSV.isScrollEnabled {
				self.SV = viewSV
				
				SV!.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new, .old], context: nil)
				
//				let panGestureRecognizerSV = UIPanGestureRecognizer(target: self, action: #selector(panGestureSV(sender:)))
//				self.SV!.addGestureRecognizer(panGestureRecognizerSV)
			}
			
			if let viewTF = view as? UITextField {
				self.TFArray.append(viewTF)
			}
			
			if let viewSB = view as? UISearchBar {
				self.sertchBar = viewSB
			}
		}

		
    }
	
	@objc func panGesture(sender: UIPanGestureRecognizer) {
		
		let translatedPoint = sender.translation(in: self.view).y
		let frame = CurtainConstant.newFrame(translatedPointY: translatedPoint)

		frameFromGestures(frame)
		
		if sender.state == .ended {
			let dismiss = CurtainConstant.dismiss(yPoint: frame.origin.y)
			self.finalGestureAnimate(dismiss)
		}
		
	}
	
	private func frameFromGestures(_ newFrame: CGRect){
		
		self.curtain?.frame = newFrame
		
		let koef = CurtainConstant.koefBlure(newPosition: newFrame.origin.y)
		
		self.aphaAllContentCurtain(alpha: koef)
		self.blureView.blureAt(koef)
	}
	
	@objc func tapGesture(sender: UIPanGestureRecognizer) {
		if uiviewTextFirsResponser(){
			return
		}
		
		self.curtainAnimmate(addCurtain: false)
	}
	
	//MARK: GESTURES SV
	
	@objc func panGestureSV(sender: UIPanGestureRecognizer) {

//		guard let curtain = self.curtain else {return}
//
		let pointY = sender.translation(in: self.view).y
		
		SV!.setContentOffset(CGPoint(x: 0, y: -1 * pointY), animated: false)
////
//		//		ведем палец в нииз
//		//		при условии что таблица немного отскроллена
//
//
//		let frame = CurtainConstant.newFrame(translatedPointY: pointY)
//
//		let SVcontent = SV!.contentSize.height
//		print(pointY)
//
////		if isDragAndDrop(pointY){
////			frameFromGestures(frame)
////		}
//
//		if pointY >= 0{
//			frameFromGestures(frame)
//		} else {
//			SV!.setContentOffset(CGPoint(x: 0, y: -1 * pointY), animated: false)
//		}
		
//		if isDragAndDrop(pointY){
//			frameFromGestures(frame)
//		} else {
//			SV!.setContentOffset(CGPoint(x: 0, y: -1 * pointY), animated: false)
//		}
		
		
//		if sender.state == .ended {
//				let dismiss = CurtainConstant.dismiss(yPoint: frame.origin.y)
//				self.finalGestureAnimate(dismiss)
//		}
//
//		if SV!.contentOffset.y > 0 && velY >= 0{
//			lastOffset = SV!.contentOffset
//			self.startLocation = sender.translation(in: self.SV!)
//			return
//		}
//
//
//
//		switch sender.state {
//		case .began:
//			freezeContentOffset = false
//			lastOffset = SV!.contentOffset
//			self.startLocation = sender.translation(in: self.SV!)
//		case .changed:
//
//			let dy = sender.translation(in: self.SV!).y - startLocation.y
//
//			print(dy)
//
//			let frame = CurtainConstant.newFrame(translatedPointY: dy)
//			self.curtain?.frame = frame
//
//			startLocation = sender.translation(in: self.SV!)
//
//			if curtain.frame.minY > CurtainConstant.finishFrame.origin.y && velY < 0{
//				freezeContentOffset = true
//				SV!.setContentOffset(lastOffset, animated: false)
//			}else{
//				lastOffset = SV!.contentOffset
//			}
//
//		default:
//
//			print("------------")
//		}
//
	}
	
	
	//переход из крайней позиции скролла таблицы в драг анд дроп шторки
	
	private func isDragAndDrop(_ tarnslateY: CGFloat) -> Bool{
		let minValue = min(SV!.frame.height, SV!.contentSize.height)
		
		return minValue > abs(tarnslateY)
	}
	
    override open func observeValue(forKeyPath keyPath: String?,
									of object: Any?, change: [NSKeyValueChangeKey : Any]?,
									context: UnsafeMutableRawPointer?) {
		
        if keyPath == #keyPath(UIScrollView.contentOffset), let scroll = self.SV {
			
			let offset = scroll.contentOffset.y
			
			if offset < 0{
                scroll.setContentOffset(.zero, animated: false)
				return
            }
			
			
			let height = scroll.frame.size.height
			let distanceFromBottom = scroll.contentSize.height - offset
			if distanceFromBottom < height {
				let scrollPosition = CGPoint(x: 0, y: scroll.contentSize.height - height)
				scroll.setContentOffset(scrollPosition, animated: false)
			}
			
        }
    }
	
	
	
	
	
	
	
	
	private func aphaAllContentCurtain(alpha: CGFloat){
		allView.forEach({$0.alpha = alpha})
		uiviewTextFirsResponser()
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
						self.aphaAllContentCurtain(alpha: finishAlpha)
		}) {[weak self] (compl) in
			if compl, dismiss{
				self?.dismiss(animated: false, completion: nil)
			}
		}
		
	}
	
	@discardableResult func uiviewTextFirsResponser() -> Bool{
		
		if sertchBar?.isFirstResponder ?? false{
			sertchBar?.resignFirstResponder()
			return true
		}
		
		if let TF = self.TFArray.first(where: {$0.isFirstResponder}){
			TF.resignFirstResponder()
			return true
		}
		
		return false
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
	
	
}

