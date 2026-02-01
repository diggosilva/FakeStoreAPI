//
//  CustomButton.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 31/01/26.
//

import UIKit

final class CustomButton: UIButton {

    init(image: UIImage? = nil, title: String = "", target: Any? = nil, action: Selector? = nil) {
        super.init(frame: .zero)
        setupButton(image: image, title: title)

        if let target, let action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton(image: UIImage? = nil, title: String = "") {
        var configuration = UIButton.Configuration.bordered()
        configuration.image = image
        configuration.title = title
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        configuration.imagePadding = 8

        self.configuration = configuration
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
