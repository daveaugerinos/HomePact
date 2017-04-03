//
//  UIImage+Base64Encoding.swift
//  HomePact
//
//  Created by Ali Barış Öztekin on 2017-04-02.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

public extension UIImage {
    
    func base64Encode() ->String? {
        
        guard let data = UIImagePNGRepresentation(self) else {
            return nil
        }
        return data.base64EncodedString()
    
    }
    
}

public extension String {
    
    func decodeBase64Image() -> UIImage? {
        
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return UIImage(data: data)
        
    }
    
}
