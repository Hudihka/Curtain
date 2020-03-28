//
//  BottomSheetController.swift
//  NestedScrollView
//
//  Created by ugur on 12.08.2018.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit

//проект взят отсюда
//https://github.com/OfTheWolf/UBottomSheet


open class BottomSheetController: UIViewController {
	
	//высота видимой части шторки
	
	open var heightCurtain: CGFloat{
        return 500
    }
    
    private var topY: CGFloat {
        return hDdevice - heightCurtain
    }
    
	//процент начиная от которого начинаем редактироват блюр и диссмисем
	//процент от высоты шторки
	
    open var procentDissimis: CGFloat{
		return 0.5
    }
    
//	точка начиная от которой начинаем дисмисьть и менять альфу
	
    var middleY: CGFloat{
		return hDdevice - (procentDissimis * heightCurtain)
    }
	
	private func isDissmis(_ newYPosition: CGFloat) -> Bool{
		return newYPosition > middleY
	}
	
	private func alhaKoef(_ newYPosition: CGFloat) -> CGFloat{
		
		if isDissmis(newYPosition) == false {
			return 1
		} else {
			let mid = middleY
			return (hDdevice - newYPosition) / (hDdevice - mid)
		}
	}
    
    var panView: UIView!{
        return view
    }
    
    var containerView = UIView()
    
    var parentView: UIView!
    
    var lastOffset: CGPoint = .zero
    var startLocation: CGPoint = .zero
	

//	заморозить смещение контента
    var freezeContentOffset = false
    
    
    private var SV: UIScrollView?
    var didLayoutOnce = false
    var topConstraint: NSLayoutConstraint?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
		
        SV?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new, .old], context: nil)

    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        panView.frame = containerView.bounds

        if !didLayoutOnce{
            didLayoutOnce = true
            snapTo(position: topY)
        }
    }
    
    
	func setupGestures(){
		
//		let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//		self.view.addGestureRecognizer(pan)
		
		if SV == nil, let SV = self.view.ub_firstSubView(ofType: UIScrollView.self){
			self.SV = SV
			self.SV?.panGestureRecognizer.addTarget(self, action: #selector(handleScrollPan(_:)))
		}
		
		
	}
    
	//жесты скролл вью
	
    override open func observeValue(forKeyPath keyPath: String?,
									of object: Any?, change: [NSKeyValueChangeKey : Any]?,
									context: UnsafeMutableRawPointer?) {
		
        if keyPath == #keyPath(UIScrollView.contentOffset) {
            if let scroll = SV, scroll.contentOffset.y < 0{
                SV?.setContentOffset(.zero, animated: false)
            }
        }
    }
	
    @objc func handleScrollPan(_ recognizer: UIPanGestureRecognizer){
//		let velY = recognizer.velocity(in: self.panView).y
//
////		ведем палец в нииз
////		при условии что таблица немного отскроллена
//
//        if SV!.contentOffset.y > 0 && velY >= 0{
//            lastOffset = SV!.contentOffset
//            self.startLocation = recognizer.translation(in: self.SV!)
//            return
//        }
//
//		if recognizer.state == .began{
//			freezeContentOffset = false
//			lastOffset = SV!.contentOffset
//			self.startLocation = recognizer.translation(in: self.SV!)
//		} else if recognizer.state == .changed{
//
////			            let dy = recognizer.translation(in: self.SV!).y - startLocation.y
//			            let f = getFrame(for: velY)
//			            topConstraint?.constant = f.minY
//
////				print(f.minY)
//
//
//			            startLocation = recognizer.translation(in: self.SV!)
//
//			            if containerView.frame.minY > topY && velY < 0{
//			                freezeContentOffset = true
//			                SV!.setContentOffset(lastOffset, animated: false)
//			            }else{
//			                lastOffset = SV!.contentOffset
//			            }
//
//
//
//
//		}
//
////
////        switch recognizer.state {
////        case .began:
////            freezeContentOffset = false
////            lastOffset = SV!.contentOffset
////            self.startLocation = recognizer.translation(in: self.SV!)
////        case .changed:
////
////            let dy = recognizer.translation(in: self.SV!).y - startLocation.y
////            let f = getFrame(for: dy)
////            topConstraint?.constant = f.minY
////
////            startLocation = recognizer.translation(in: self.SV!)
////
////            if containerView.frame.minY > topY && velY < 0{
////                freezeContentOffset = true
////                SV!.setContentOffset(lastOffset, animated: false)
////            }else{
////                lastOffset = SV!.contentOffset
////            }
////        default:
////
////			print("------------")
////			snapTo(position: nextLevel(recognizer: recognizer))
////        }
    }
//
//    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
//
//		dragView(recognizer)
//
//		if recognizer.state == .ended {
////			snapTo(position: nextLevel(recognizer: recognizer))
//		}
//
//    }
    
    func dragView(_ recognizer: UIPanGestureRecognizer){
        let dy 		 = recognizer.translation(in: self.panView).y
		let newFrame = getFrame(for: dy)
		
		panView.frame = newFrame
		
        topConstraint?.constant = newFrame.minY
    }
	
	//новый фрейм
    
    private func getFrame(for dy: CGFloat) -> CGRect{
		
		let offset 	  = dy > 0 ? dy : -3 * sqrt(abs(dy))
		let newHeight = heightCurtain - offset
		let newY 	  = hDdevice - newHeight
//
//		print("alpha \(alhaKoef(newY))")
		
		let f = containerView.frame
		
        return CGRect(x: f.minX,
					  y: hDdevice - newY,
					  width: f.width,
					  height: newHeight)
    }
    
	
	
    func snapTo(position: CGFloat){
        let f = self.containerView.frame == .zero ? self.view.frame : self.containerView.frame

        guard position != f.minY else{return}

        if freezeContentOffset && SV!.panGestureRecognizer.state == .ended{
            SV!.setContentOffset(lastOffset, animated: false)
        }
        

        let h = f.maxY - position
        let rect = CGRect(x: f.minX, y: position, width: f.width, height: h)
        self.topConstraint?.constant = rect.minY

        animate(animations: {
            self.parent?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    open func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: animations, completion: completion)
    }
	
	//конечная позиция
    
    func nextLevel(recognizer: UIPanGestureRecognizer) -> CGFloat {
        
        let velY = recognizer.velocity(in: self.view).y
		
		if velY < 0 {
			return heightCurtain
		} else {
			//если hDevaise то диссмисем
			return isDissmis(velY + heightCurtain) ? hDdevice : heightCurtain
		}
    }
}

extension BottomSheetController: Pannable{

    public func attach(to parent: UIViewController) {
        parent.ub_add(self, in: containerView)
        parent.ub_add(self, in: containerView) { (view) in
            view.edges([.left, .right, .top, .bottom], to: parent.view, offset: .zero)
        }
        
        topConstraint = parent.view.constraints.first { (c) -> Bool in
            c.firstItem as? UIView == self.containerView && c.firstAttribute == .top
        }
        
        let bottomConstraint = parent.view.constraints.first { (c) -> Bool in
            c.firstItem as? UIView == self.containerView && c.firstAttribute == .bottom
        }
		
        
        bottomConstraint?.constant = 0
    }
    
    public func detach() {
        self.ub_remove()
        self.containerView.removeFromSuperview()
    }
    
}


