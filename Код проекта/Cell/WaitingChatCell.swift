//
//  WaitingChatCell.swift
//  MultipleSections
//
//  Created by Игорь Островский on 05.10.2022.
//  Copyright © 2022 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class WaitingChatCell: UICollectionViewCell{
    static var reuseId:String = "WaitingChatCell"
    let friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 1)
        
        friendImageView.frame = self.bounds
        addSubview(friendImageView)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    func configure(with chat:MChat){
        friendImageView.image = UIImage(named: chat.friendImage)
    }
    required init(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
