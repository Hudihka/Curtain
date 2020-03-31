//
//  FieldInputAccessoryView.swift
//  ChefMarket_2.0
//
//  Created by Nikita Gorobets on 04.05.2018.
//  Copyright © 2018 itMegaStar. All rights reserved.
//

import UIKit


class FieldInputAccessoryView: UIView {
    
    var doneBlock: () -> () = { }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
        
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        Bundle.main.loadNibNamed("FieldInputAccessoryView", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: bounds.width, height: toolbar.frame.height)
    }
    
    
    // MARK: - Actions
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        doneBlock()
    }
    
}
