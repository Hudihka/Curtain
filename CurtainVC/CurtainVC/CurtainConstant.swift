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
	
	//высота видимой части шторки
	
	static var heightCurtain: CGFloat = 450
	
	private static let size = CGSize(width: wDdevice, height: hDdevice)
	
	// стартовая позция шторки
	
	static let startFrame = CGRect(origin: CGPoint(x: 0, y: hDdevice), size: size)
	
	//конечное положение шторки
	
	private static let finishYPoint: CGFloat = hDdevice - heightCurtain
	
	static let finishFrame = CGRect(origin: CGPoint(x: 0,
													y: finishYPoint),
									size: size)
	
	//процентрное значение,
	//когда высота шторки равна procentReloadBlure * heightCurtain
	//начиинаем менять блюр и альфу
	
	private static let procentReloadBlure: CGFloat = 0.6
	
	//это высота шторки начиная с которой мы меняем блюр
	
	private static let hStartRelodBlure = procentReloadBlure * heightCurtain
	
	private static let startYPositionReloadBlure = hDdevice - hStartRelodBlure
	
	static func koefBlure(newPosition: CGFloat) -> CGFloat {
		
		if startYPositionReloadBlure >= newPosition {
			return 1
		} else {
			let newValue = newPosition - startYPositionReloadBlure
			return (hStartRelodBlure - newValue) / hStartRelodBlure
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
			yDelta = -3 * sqrt(abs(translatedPointY))
		}
		
		
		return CGRect(origin: CGPoint(x: 0, y: finishYPoint + yDelta), size: size)
	}
	
}
