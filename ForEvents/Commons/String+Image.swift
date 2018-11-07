//
//  String+Image.swift
//  MadridShops
//
//  Created by luis gomez alonso on 7/9/18.
//  Copyright © 2018 luis gomez alonso. All rights reserved.
//

import UIKit

extension String {
    func loadImage(into imageview: UIImageView) {
        let queue = OperationQueue()
        queue.addOperation {
            if let url = URL(string: self),
               let data = NSData(contentsOf: url),
               let image = UIImage(data: data as Data) {
                
                OperationQueue.main.addOperation {
                    imageview.image = image
                }
            }
        }
    }
}
