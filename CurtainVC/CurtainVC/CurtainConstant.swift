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
	
	private static let procentReloadBlure: CGFloat = 0.5
	
	private static let startYPositionReloadBlure = hDdevice - procentReloadBlure * heightCurtain
	
	static func koefBlure(translatedPointY: CGFloat) -> CGFloat {
		
		let newPosition = finishYPoint + translatedPointY
		
		let newValue2 = hDdevice - newPosition - startYPositionReloadBlure
		print(newValue2)
		
		if startYPositionReloadBlure >= newPosition {
			return 1
		} else {
			let newValue = hDdevice - newPosition - startYPositionReloadBlure
			return abs(newValue) / startYPositionReloadBlure
		}
	}
	
	//процентрное значение,
	//когда высота шторки равна procentReloadBlure * heightCurtain
	//начиинаем менять блюр и альфу
	
	private static let procentDissmisCurtain: CGFloat = 0.45
	
	// дисмисмисем
	
	static func dismiss(yPoint: CGFloat) -> Bool {
		
		let pointDissmis = hDdevice - procentDissmisCurtain * heightCurtain
		
		return yPoint > pointDissmis
	}
	
	//выщитываем новый фрейм
	
	static func newFrame(translatedPointY: CGFloat) -> CGRect{
		
		var yDelta: CGFloat = 0
		
		if translatedPointY > 0{
			
			yDelta = translatedPointY
			
		} else {
			yDelta = -1 * sqrt(abs(translatedPointY))
		}
		
		
		return CGRect(origin: CGPoint(x: 0, y: finishYPoint + yDelta), size: size)
	}
	
}
