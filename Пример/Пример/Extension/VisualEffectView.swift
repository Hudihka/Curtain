//
//  VisualEffectView.swift
//  VisualEffectView
//
//  Created by Lasha Efremidze on 5/26/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//
//swiftlint:disable force_cast

import UIKit

enum EnumBlureValue {
    case min
    case light
    case midl
    case dark
    case max
}

/// VisualEffectView is a dynamic background blur view.
open class VisualEffectView: UIVisualEffectView {
	
	var enumBlureValue: EnumBlureValue = .midl
	
    /// Returns the instance of UIBlurEffect.
    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()

    /**
     Tint color.

     The default value is nil.
     */
    open var colorTint: UIColor? {
        get { return _value(forKey: "colorTint") as? UIColor }
        set { _setValue(newValue, forKey: "colorTint") }
    }

    /**
     Tint color alpha.

     The default value is 0.0.
     */
    open var colorTintAlpha: CGFloat {
        get { return _value(forKey: "colorTintAlpha") as! CGFloat }
        set { _setValue(newValue, forKey: "colorTintAlpha") }
    }

    /**
     Blur radius.

     The default value is 0.0.
     */
    open var blurRadius: CGFloat {
        get { return _value(forKey: "blurRadius") as! CGFloat }
        set { _setValue(newValue, forKey: "blurRadius")
            if newValue < 0.1 {
                self.scale = 0.3
            } else if newValue < 0.3 {
                self.scale = 0.6
            } else {
                self.scale = 1
            }}
    }

    /**
     Scale factor.

     The scale factor determines how content in the view is mapped from the logical coordinate space (measured in points) to the device coordinate space (measured in pixels).

     The default value is 1.0.
     */
    private var scale: CGFloat {
        get { return _value(forKey: "scale") as! CGFloat }
        set { _setValue(newValue, forKey: "scale") }
    }

    // MARK: - Initialization

    override public init(effect: UIVisualEffect?) {
        super.init(effect: effect)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        scale = 1
    }

    // MARK: - Helpers

    /// Returns the value for the key on the blurEffect.
    private func _value(forKey key: String) -> Any? {
        return blurEffect.value(forKeyPath: key)
    }

    /// Sets the value for the key on the blurEffect.
    private func _setValue(_ value: Any?, forKey key: String) {
        blurEffect.setValue(value, forKeyPath: key)
        self.effect = blurEffect
    }
}


extension VisualEffectView {
	
	private func maxValuesBlure() -> (alpha: CGFloat, radius: CGFloat, colorTintAlpha: CGFloat) {
		
		switch self.enumBlureValue {
		case .midl:
			return (alpha: 1, radius: 5, colorTintAlpha: 0.15)
		case .light:
			return (alpha: 1, radius: 1, colorTintAlpha: 0.05)
		case .dark:
			return (alpha: 1, radius: 1, colorTintAlpha: 0.8)
		case .min:
		    return (alpha: 0, radius: 0, colorTintAlpha: 0)
		case .max:
			return (alpha: 1, radius: 10, colorTintAlpha: 0.15)
		}
	
	}
	
	
	
    func blureValue() {
		
		let tupl = maxValuesBlure()
		
        switch self.enumBlureValue {
        case .midl:
			self.alpha = tupl.alpha
			self.blurRadius = tupl.radius
			self.colorTintAlpha = tupl.colorTintAlpha
			
			self.colorTint = UIColor.black

        case .light:
			self.alpha = tupl.alpha
			self.blurRadius = tupl.radius
			self.colorTintAlpha = tupl.colorTintAlpha
			
			self.colorTint = UIColor.black.withAlphaComponent(0.05)
        case .dark:
			self.alpha = tupl.alpha
			self.blurRadius = tupl.radius
			self.colorTintAlpha = tupl.colorTintAlpha
			
			self.colorTint = UIColor.black
			
		case .min:
			self.alpha = tupl.alpha
			self.blurRadius = tupl.radius
			self.colorTintAlpha = tupl.colorTintAlpha
			
			self.colorTint = UIColor.clear

		case .max:
			self.alpha = tupl.alpha
			self.blurRadius = tupl.radius
			self.colorTintAlpha = tupl.colorTintAlpha
			
			self.colorTint = UIColor.black
        }
    }

    func blureAt(_ koef: CGFloat) {
		
		if koef > 1 {
			return
		}
		
		let tupl = maxValuesBlure()
		
        self.alpha = tupl.alpha * koef
		self.blurRadius = tupl.radius * koef
		self.colorTintAlpha = tupl.colorTintAlpha * koef
    }

}
