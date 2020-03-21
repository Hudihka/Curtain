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
    
    private var topY: CGFloat{
        return hDdevice - heightCurtain
    }
    
	//процент начиная от которого начинаем редактироват блюр и диссмисем
	//процент от высоты шторки
	
    open var procentDissimis: CGFloat{
		return 0.5
    }
    
//	точка начиная от которой начинаем дисмисьть и менять альфу
	
    var middleY: CGFloat{
		return hDdevice - ((1 + procentDissimis) * heightCurtain)
    }
	
	private func isDissmis(_ y: CGFloat) -> Bool{
		return y > middleY
	}
	
	private func alhaKoef(_ y: CGFloat) -> CGFloat{
		
		if isDissmis(y) == false {
			return 1
		} else {
			let mid = middleY
			return (y - mid) / (hDdevice - mid)
		}
	}
    
    var panView: UIView!{
        return view
    }
    
    var containerView = UIView()

    var pan: UIPanGestureRecognizer!
    
    var parentView: UIView!
    
    var lastOffset: CGPoint = .zero
    var startLocation: CGPoint = .zero
    var freezeContentOffset = false
    
    //tableview variables
    var listItems: [Any] = []
    var headerItems: [Any] = []
    
    open var scrollView: UIScrollView?{
        return autoDetectedScrollView
    }
    
    var autoDetectedScrollView: UIScrollView?
    
    var didLayoutOnce = false
    
    func findScrollView(from view: UIView) -> UIView?{
        return view.ub_firstSubView(ofType: UIScrollView.self)
    }
    
    
    var topConstraint: NSLayoutConstraint?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
        addObserver()

    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        panView.frame = containerView.bounds
        
        if !didLayoutOnce{
            didLayoutOnce = true
            snapTo(position: topY)
        }
    }
    
    func addObserver(){
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new, .old], context: nil)
    }
    
    func setupGestures(){
        if autoDetectedScrollView == nil{
            autoDetectedScrollView = findScrollView(from: self.view) as? UIScrollView
        }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(pan)
        self.scrollView?.panGestureRecognizer.addTarget(self, action: #selector(handleScrollPan(_:)))
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UIScrollView.contentOffset) {
            if let scroll = scrollView, scroll.contentOffset.y < 0{
                scrollView?.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    public func changePosition(to position: CGFloat){
        snapTo(position: position)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        
        switch recognizer.state {
        case .began: break
        case .changed:
            dragView(recognizer)
        default:
            snapTo(position: nextLevel(recognizer: recognizer))
        }
        
    }
    
    @objc func handleScrollPan(_ recognizer: UIPanGestureRecognizer){
        let vel = recognizer.velocity(in: self.panView)
        
        if scrollView!.contentOffset.y > 0 && vel.y >= 0{
            lastOffset = scrollView!.contentOffset
            self.startLocation = recognizer.translation(in: self.scrollView!)
            return
        }
        
        switch recognizer.state {
        case .began:
            freezeContentOffset = false
            lastOffset = scrollView!.contentOffset
            self.startLocation = recognizer.translation(in: self.scrollView!)
        case .changed:
			
//			print("0000000")
            let dy = recognizer.translation(in: self.scrollView!).y - startLocation.y
            let f = getFrame(for: dy)
            topConstraint?.constant = f.minY

            startLocation = recognizer.translation(in: self.scrollView!)
            
            if containerView.frame.minY > topY && vel.y < 0{
//				print("----------")
                freezeContentOffset = true
                scrollView!.setContentOffset(lastOffset, animated: false)
            }else{
				print("111111111")
                lastOffset = scrollView!.contentOffset
            }
        default:
            snapTo(position: nextLevel(recognizer: recognizer))
        }
    }
    
    func dragView(_ recognizer: UIPanGestureRecognizer){
        let dy = recognizer.translation(in: self.panView).y
        //        panView.frame = getFrame(for: dy)
        topConstraint?.constant = getFrame(for: dy).minY
        
        recognizer.setTranslation(.zero, in: self.panView)
    }
    
    func getFrame(for dy: CGFloat) -> CGRect{
        let f = containerView.frame
		//здесь было  min(max(topY, f.minY + dy), bottomY)
        let minY =  min(max(topY, f.minY + dy), 0)
        let h = f.maxY - minY
        return CGRect(x: f.minX, y: minY, width: f.width, height: h)
    }
    
    func snapTo(position: CGFloat){
        let f = self.containerView.frame == .zero ? self.view.frame : self.containerView.frame
        
        guard position != f.minY else{return}

        if freezeContentOffset && scrollView!.panGestureRecognizer.state == .ended{
            scrollView!.setContentOffset(lastOffset, animated: false)
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


