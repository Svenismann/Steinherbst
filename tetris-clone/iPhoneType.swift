//
//  iPhoneType.swift
//  tetris-clone
//
//  Created by Sven Forstner on 16.11.16.
//  Copyright © 2016 Sven Forstner. All rights reserved.


import Foundation
import UIKit

// class to determine iPhone screenSize
// add func with return value to use globally

// ExampleCode

//  func placeHolder() -> CGFloat {
//      var value = CGFloat()
//
//      if iphoneType() == "iPhone 5" {
//          value = 60
//      } else if iphoneType() == "iPhone 6"{
//          value = 70
//      } else if iphoneType() == "iPhone 6 Plus" {
//          value = 80
//      }
//      return value
//  }

// use inside class 

// let iPhoneType = iPhoneTypeSize().iPhoneType()
// in viewDidLoad add : print(iPhoneType)

// let placeHolderSize = iPhoneTypeSize().placeHolder()
// someElementThatNeedsSize = placeHolderSize

class iPhoneTypeSize {

    func iphoneType() -> String {
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        var type = ""
        
        if screenSize == CGRect(x: 0.0, y: 0.0, width: 320.0, height: 568.0){
            type = "iPhone 5"
        } else if screenSize == CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0) {
            type = "iPhone 6"
        } else if screenSize == CGRect(x: 0.0, y: 0.0, width: 414.0, height: 736.0) {
            type = "iPhone 6 Plus"
        }
        
        return type
    }
    
    func blockSize() -> CGFloat {
        
        var size: CGFloat = 20.0
        
        if iphoneType() == "iPhone 5" {
            size = 20.0
        } else if iphoneType() == "iPhone 6" {
            size = 25.0
        } else if iphoneType() == "iPhone 6 Plus" {
            size = 30.0
        }
        
        return size
        
    }
}
