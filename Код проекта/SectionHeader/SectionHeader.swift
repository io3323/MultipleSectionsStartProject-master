//
//  ЫусешщтРуфвук.swift
//  MultipleSections
//
//  Created by Игорь Островский on 06.10.2022.
//  Copyright © 2022 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit
class SectionHeader:UICollectionReusableView{
    static let reuseId = "SectionHeader"
    let title = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cunstomizeElements()
        setupConstraints()
        
    }
    private func cunstomizeElements(){
        title.textColor = .black
        title.font = UIFont(name: "avenir", size: 20)
        title.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupConstraints(){
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
