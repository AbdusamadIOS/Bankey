//
//  PasswordStatusView.swift
//  Password
//
//  Created by Abdusamad Mamasoliyev on 11/03/24.
//

import Foundation
import UIKit

class PasswordStatusView: UIView {
    
    let stackView = UIStackView()
    let criteriaLabel = UILabel()
    
    let lengthCriteriaView = PasswordCriteriaView(text: "8-32 characters (no spaces)")
    let uppercaseCritriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")
    let lowercaseCritriaView = PasswordCriteriaView(text: "lowercase (a-z)")
    let digitCritriaView = PasswordCriteriaView(text: "digit (0-9)")
    let specialCharacterCritriaView = PasswordCriteriaView(text: "special character (e.g. !@#$%^)")
    
    var shouldResetCriteria: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension PasswordStatusView {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemFill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        
        criteriaLabel.translatesAutoresizingMaskIntoConstraints = false
        criteriaLabel.numberOfLines = 0
        criteriaLabel.attributedText = makeCriteriaMessage()
        
        lengthCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        uppercaseCritriaView.translatesAutoresizingMaskIntoConstraints = false
        lowercaseCritriaView.translatesAutoresizingMaskIntoConstraints = false
        digitCritriaView.translatesAutoresizingMaskIntoConstraints = false
        specialCharacterCritriaView.translatesAutoresizingMaskIntoConstraints = false
    }
    func layout() {
        
        stackView.addArrangedSubview(lengthCriteriaView)
        stackView.addArrangedSubview(criteriaLabel)
        stackView.addArrangedSubview(uppercaseCritriaView)
        stackView.addArrangedSubview(lowercaseCritriaView)
        stackView.addArrangedSubview(digitCritriaView)
        stackView.addArrangedSubview(specialCharacterCritriaView)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2)
        ])
    }
    private func makeCriteriaMessage() -> NSAttributedString {
        
        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        plainTextAttributes[.foregroundColor] = UIColor.secondaryLabel
        
        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        
        let attrText = NSMutableAttributedString(string: "Use at least", attributes: plainTextAttributes)
        attrText.append(NSAttributedString(string: " 3 of these 4 ", attributes: boldTextAttributes))
        attrText.append(NSAttributedString(string: "criteria when setting your password:", attributes: plainTextAttributes))
        
        return attrText
    }
}
//  MARK: Action
extension PasswordStatusView {
    func updateDisplay(_ text: String) {
        let lengthAndNoSpaceNet = PasswordCriteria.lengthAndNoSpaceMet(text)
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitMet = PasswordCriteria.digitMet(text)
        let specialCharacterMet = PasswordCriteria.specialCharacterMet(text)
        
        if shouldResetCriteria {
          // Inline valiation (✅ or ❌)
            lengthAndNoSpaceNet ? lengthCriteriaView.isCriteriaMet = true : lengthCriteriaView.reset()
            uppercaseMet ? uppercaseCritriaView.isCriteriaMet = true : uppercaseCritriaView.reset()
            lowercaseMet ? lowercaseCritriaView.isCriteriaMet = true : lowercaseCritriaView.reset()
            digitMet ? digitCritriaView.isCriteriaMet = true : digitCritriaView.reset()
            specialCharacterMet ? specialCharacterCritriaView.isCriteriaMet = true : specialCharacterCritriaView.reset()
        } else {
            lengthCriteriaView.isCriteriaMet = lengthAndNoSpaceNet
            uppercaseCritriaView.isCriteriaMet = uppercaseMet
            lowercaseCritriaView.isCriteriaMet = lowercaseMet
            digitCritriaView.isCriteriaMet = digitMet
            specialCharacterCritriaView.isCriteriaMet = specialCharacterMet
        }
    }
    func validate(_ text: String) -> Bool {
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitMet = PasswordCriteria.digitMet(text)
        let specialCharacterMet = PasswordCriteria.specialCharacterMet(text)

        // Ready Player1 🕹
        // Check for 3 of 4 criteria here...
        let checkable = [uppercaseMet, lowercaseMet, digitMet, specialCharacterMet]
        let metCriteria = checkable.filter { $0 }
        let lengthAndNoSpaceMet = PasswordCriteria.lengthAndNoSpaceMet(text)
        
        if lengthAndNoSpaceMet && metCriteria.count >= 3 {
            return true
        }
        
        return false
    }
    
    func reset() {
        lengthCriteriaView.reset()
        uppercaseCritriaView.reset()
        lowercaseCritriaView.reset()
        digitCritriaView.reset()
        specialCharacterCritriaView.reset()
    }
}
