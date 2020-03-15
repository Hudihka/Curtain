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
		
	}
	
	
}
