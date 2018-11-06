//
//  Colors.swift
//  vKclub
//
//  Created by Machintos-HD on 9/25/18.
//  Copyright © 2018 WiAdvance. All rights reserved.
//

import Foundation

import UIKit


extension UIColor {
    //Initializes a UIColor based off of a hex string
    convenience init(hexString:String, alpha:CGFloat){
        var cleanHex:String!
        //Eliminate common prefixes
        if(hexString.hasPrefix("#")){
            cleanHex = hexString.substring(from: hexString.characters.index(hexString.startIndex, offsetBy: 1))
        }
        else if(hexString.hasPrefix("0x")){
            cleanHex = hexString.substring(from: hexString.characters.index(hexString.startIndex, offsetBy: 2))
        }
        else{
            cleanHex = hexString
        }
        
        //Check for correct length
        if(cleanHex.characters.count != 6){
            self.init(red:0/255.0,green:0/255.0,blue:0/255.0, alpha: alpha)
        }
        else{
            let rString = cleanHex.substring(to: cleanHex.index(cleanHex.startIndex, offsetBy: 2))
            var gString = cleanHex.substring(from: cleanHex.index(cleanHex.startIndex, offsetBy: 2))
            gString = gString.substring(to: gString.characters.index(gString.startIndex, offsetBy: 2))
            var bString = cleanHex.substring(from: cleanHex.index(cleanHex.startIndex, offsetBy: 4))
            bString = bString.substring(to: bString.characters.index(bString.startIndex, offsetBy: 2))
            
            var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
            
            self.init(red:CGFloat(r)/255.0,green:CGFloat(g)/255,blue:CGFloat(b)/255,alpha:alpha)
        }
    }
}
