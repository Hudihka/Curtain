//
//  CurtainView.swift
//  CurtainVC
//
//  Created by Hudihka on 14/03/2020.
//  Copyright © 2020 Tatyana. All rights reserved.
//

import UIKit

class CurtainView: UIView {
	//нужно для направления прокрутки
	private var lastContentOffset: CGFloat = 0.5
	
	private var scrollViewObj: UIScrollView? {
		
		var SV: UIScrollView?
		
		self.recurrenceAllSubviews.forEach({ (view) in
			if let SVreturn = view as? UIScrollView {
				SV = SVreturn
			}
		})
		
		return SV
	}
	
	
	var dissmisBlock: () -> () = { }
	
	
	
	
	let dataArray = ["11111", "22222", "33333", "44444", "55555", "66666",
					 "77777", "88888", "99999", "00000", "10101", "20202"]
	var tableView = UITableView()
	
	init() {
		super.init(frame: CurtainConstant.startFrame)
		startDesing()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func startDesing(){
		self.backgroundColor = UIColor.red
		
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
		button.backgroundColor = .green
		button.setTitle("Test Button", for: .normal)
		button.addTarget(self, action: #selector(dissmisSelf), for: .touchUpInside)

		self.addSubview(button)
		
		self.desingTV()
	}
	
	
	@objc func dissmisSelf(sender: UIButton!) {
	  dissmisBlock()
	}
	
	private func addGestures(){
		
		
	}
	
}


//MARK: - TableView


extension CurtainView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		cell.textLabel?.text = dataArray[indexPath.row]
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		print(dataArray[indexPath.row])
	}
	
	
	func desingTV(){
		
		self.tableView = UITableView(frame: CGRect(x: 0, y: 100, width: wDdevice, height: 500))
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		
		self.addSubview(tableView)
		
		
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
		
		panGestureRecognizer.delegate = self
        tableView.addGestureRecognizer(panGestureRecognizer)
		
	}
	
    @objc func panGesture(sender: UIPanGestureRecognizer) {
		print("gesters")
    }
	
	
	func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//		print("1111")
	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//		scrollView.isScrollEnabled = true
//		print("2222") //поставили палец
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//		print("3333") //законченна анимация
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		//		таблица не скрольться в низ
		scrollView.isScrollEnabled = true
//		print("44444") //отпустили
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
//		таблица не скрольться в низ
		
		
//		print(scrollView.contentSize)
//
//
		if (self.lastContentOffset > scrollView.contentOffset.y), scrollView.contentOffset.y < 0.5 {
			scrollView.isScrollEnabled = false
		} else {
		   scrollView.isScrollEnabled = true
		}

		// update the new position acquired
		self.lastContentOffset = scrollView.contentOffset.y
    }
	
	
}


extension CurtainView: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && gestureRecognizer.view == tableView && gestureRecognizer.view == tableView {
            print("test 1")
        }
        return true
    }

//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && gestureRecognizer.view == tableView && gestureRecognizer.view == tableView {
//            print("test 2")
//        }
//        return true
//    }

}
