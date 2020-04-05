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
	
	//радиус шторки
	static let radiusCurtain: CGFloat? = 15
	
	//чем больше kDown, тем проще тянут в низ
	
	private static let kDown: CGFloat = 6
	
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
	
	private static let procentReloadBlure: CGFloat = 0.9
	
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
	//начиинаем дисмисеть
	
	private static let procentDissmisCurtain: CGFloat = 0.75
	
	// дисмисмисем
	
	static func dismiss(yPoint: CGFloat) -> Bool {
		
		let pointDissmis = hDdevice - procentDissmisCurtain * heightCurtain
		
		return yPoint > pointDissmis
	}
	
	//выщитываем новый фрейм
	
	static func newFrame(translatedPointY: CGFloat) -> CGRect{
				//тянем в низ
		let k: CGFloat = translatedPointY > 0 ? kDown : -3
		
		let yDelta: CGFloat = k * sqrt(abs(translatedPointY))
		
		return CGRect(origin: CGPoint(x: 0, y: finishYPoint + yDelta), size: size)
	}
	
	//новый радиус
	//радиус плавно меняется между начальной позицией
	//и позицией когда начинаем менять альфу
	
	static func newRadius(translatedPointY: CGFloat) -> CGFloat?{
		
		if let radius = radiusCurtain {
			
			//тянем в низ
			if translatedPointY > 0{
				
				let newPosition = kDown * sqrt(translatedPointY) + finishYPoint
				
				if newPosition >= startYPositionReloadBlure{
					return 0
				} else {
					
					let dist = finishYPoint - startYPositionReloadBlure
					let way = newPosition - startYPositionReloadBlure
					
					return way * radius / dist
				}
				
				
			} else {
				return radiusCurtain
			}
			
		}
		
		return nil
		
	}
	
	
}
