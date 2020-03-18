//
//  PXOneTapDisabledViewController.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 04/12/2019.
//

import UIKit

class PXOneTapDisabledViewController: UIViewController {

    init(title: PXText?, description: PXText?, primaryButton: PXAction?, secondaryButton: PXAction?, iconUrl: String?) {
        super.init(nibName: nil, bundle: nil)

        let containerView = PXComponentView()

        if let iconUrl = iconUrl {
            let image = PXUIImage(url: iconUrl)
            let imageView = PXUIImageView()
            imageView.image = image
            imageView.enableFadeIn()
            containerView.addSubviewToBottom(imageView, withMargin: PXLayout.M_MARGIN)
            PXLayout.setHeight(owner: imageView, height: 134)
            PXLayout.pinLeft(view: imageView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: imageView, withMargin: PXLayout.M_MARGIN).isActive = true
        }

        if let title = title {
            let label = UILabel()
            label.attributedText = title.getAttributedString(fontSize: PXLayout.XS_FONT, textColor: ThemeManager.shared.boldLabelTintColor(), backgroundColor: .clear)
            label.font = UIFont.ml_boldSystemFont(ofSize: PXLayout.M_FONT)
            label.textAlignment = .center
            label.numberOfLines = 0
            containerView.addSubviewToBottom(label, withMargin: PXLayout.M_MARGIN)
            PXLayout.pinLeft(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
        }

        if let description = description {
            let label = UILabel()
            label.attributedText = description.getAttributedString(fontSize: PXLayout.XS_FONT, textColor: ThemeManager.shared.boldLabelTintColor(), backgroundColor: .clear)
            label.font = UIFont.ml_regularSystemFont(ofSize: PXLayout.XS_FONT)
            label.textAlignment = .center
            label.numberOfLines = 0
            containerView.addSubviewToBottom(label, withMargin: PXLayout.M_MARGIN)
            PXLayout.pinLeft(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: label, withMargin: PXLayout.M_MARGIN).isActive = true
        }

        if let primaryAction = primaryButton {
            addNewButton(containerView: containerView, action: primaryAction, isSecondary: false, margin: PXLayout.L_MARGIN)
        }

        if let secondaryAction = secondaryButton {
            addNewButton(containerView: containerView, action: secondaryAction, isSecondary: true, margin: PXLayout.S_MARGIN)
        }

        containerView.pinLastSubviewToBottom(withMargin: 20)

        view.addSubviewAtFullSize(with: containerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    func addNewButton(containerView: PXComponentView, action: PXAction, isSecondary: Bool, margin: CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitle(action.label, for: .normal)
        if isSecondary {
            button.backgroundColor = UIColor.fromHex("#479AD1").withAlphaComponent(0.15)
            button.setTitleColor(UIColor.fromHex("#009ee3"), for: .normal)
        } else {
            button.backgroundColor = ThemeManager.shared.getAccentColor()
            button.titleLabel?.textColor = .white
        }
        button.layer.cornerRadius = 6

        containerView.addSubviewToBottom(button, withMargin: margin)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: PXLayout.M_MARGIN),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -PXLayout.M_MARGIN)
            ])

        button.add(for: .touchUpInside) {
            action.action()
        }
        return button
    }
}
