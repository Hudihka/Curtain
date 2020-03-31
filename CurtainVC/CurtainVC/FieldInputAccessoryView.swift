//
//  FieldInputAccessoryView.swift
//  ChefMarket_2.0
//
//  Created by Nikita Gorobets on 04.05.2018.
//  Copyright © 2018 itMegaStar. All rights reserved.
//

import UIKit

protocol FieldInputAccessoryViewDelegate: class {
    
    func fieldInputAccessoryViewDoneButtonTapped(_ fieldInputAccessoryView: FieldInputAccessoryView)
}

class FieldInputAccessoryView: UIView {
    
    var doneBlock: () -> () = { }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet weak var nextButtonItem: UIBarButtonItem!
    @IBOutlet weak var prevButtonItem: UIBarButtonItem!
    
    weak var delegate: FieldInputAccessoryViewDelegate?
    
    var firstFieldTag: Int?
    var lastFieldTag: Int?
    var currentFieldTag: Int? {
        
        didSet {
            
            if let currentFieldTag = currentFieldTag {
                
                doneButtonItem.isEnabled = true
                nextButtonItem.isEnabled = currentFieldTag != lastFieldTag
                prevButtonItem.isEnabled = currentFieldTag != firstFieldTag
                
            } else {
                
                toolbar.items?.forEach({
                    
                    $0.isEnabled = false
                })
            }
        }
    }
    
    
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
        
//        doneButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name:kLatoMedium, size: 15)!], for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: bounds.width, height: toolbar.frame.height)
    }
    
    
    // MARK: - Actions
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        doneBlock()
//        if let delegate = delegate {
//
//            delegate.fieldInputAccessoryViewDoneButtonTapped(self)
//        }
    }
    
}
