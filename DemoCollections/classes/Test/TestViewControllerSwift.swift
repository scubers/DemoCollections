//
//  TestViewControllerSwift.swift
//  DemoCollections
//
//  Created by mima on 15/9/12.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

import Foundation
import UIKit

// 声明自定义运算符
infix operator <~ {}    // 中间运算符 a<~b
postfix operator +++ {} // 后缀运算符 a+++
prefix operator +++ {}  // 前缀运算符 +++a

// 实现自定义运算符
func <~ (inout left: Int, right: Int) {
    left += right;
}

postfix func +++ (inout param: Int) {
    
}

prefix func +++ (inout param: Int) {
    
}

class TestViewControllerSwift : UIViewController {
    
    
    weak var textField: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let textField = UITextField(frame: CGRectMake(0, 64, 100, 20))
        
        textField.backgroundColor = UIColor.purpleColor()
        
        self.textField = textField
        
        self.view.addSubview(textField)
        
        textField.delegate = self

        setupSubViews()

    }
    
    func setupSubViews() -> Void {
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        
        weak var ws = self;

        button.frame = CGRectMake(0, 100, 100, 100)
        
        button.backgroundColor = UIColor.yellowColor()
        
        self.view.addSubview(button)
        
    }
    
    func test() {
        print("")
    }
    
    deinit {
        print("")
    }
    
}



extension TestViewControllerSwift : UITextFieldDelegate {
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("sdlfjsldfkjsdfjslfdkj")
        return true;
    }
    
}


