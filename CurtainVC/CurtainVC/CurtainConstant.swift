//
//  CurtainConstant.swift
//  CurtainVC
//
//  Created by Hudihka on 14/03/2020.
//  Copyright © 2020 Tatyana. All rights reserved.
//

import Foundation
import UIKit

struct CurtainConstant {
	
	private static let size = CGSize(width: wDdevice, height: hDdevice)
	
	// стартовая позция шторки
	
	static let startFrame = CGRect(origin: CGPoint(x: 0, y: hDdevice), size: size)
	
	//высота видимой части шторки
	
	static var heightCurtain: CGFloat = 450
	
	//конечное положение шторки
	
	private static let finishYPoint: CGFloat = hDdevice - heightCurtain
	
	static let finishFrame = CGRect(origin: CGPoint(x: 0,
													y: finishYPoint),
									size: size)
	
	//процентрное значение,
	//когда высота шторки равна procentReloadBlure * heightCurtain
	//начиинаем менять блюр и альфу
	
	private static let procentReloadBlure: CGFloat = 0.9
	
	static var startYPositionReloadBlure: CGFloat {
		return hDdevice - procentReloadBlure * heightCurtain
	}
	
	func koefBlure(yPoint: CGFloat) -> CGFloat {
		
		let newValue = hDdevice - yPoint
		return newValue / CurtainConstant.startYPositionReloadBlure
		
	}
	
	//процентрное значение,
	//когда высота шторки равна procentReloadBlure * heightCurtain
	//начиинаем менять блюр и альфу
	
	private static let procentDissmisCurtain: CGFloat = 0.45
	
	static var startYPositionDissmis: CGFloat {
		return hDdevice - procentDissmisCurtain * heightCurtain
	}
}
