//
//  CreateOrderTextFieldCell.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 08/06/22.
//

import UIKit

protocol CreateOrderTextFieldCellDelegate {
    func valueChanged(value: String)
}

class CreateOrderTextFieldCell: UITableViewCell {
    
    static let identifier: String = "CreateOrderTextFieldCell"
    var delagete: CreateOrderTextFieldCellDelegate?
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        return title
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.backgroundColor = .white
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return textField
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, textField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
    }
    
    
    func setupCell(titleLabel: String, keyboardType: FormSection.Field.TextFieldKeyboardType) {
        self.titleLabel.text = titleLabel
        switch keyboardType {
        case .numberPad:
            self.textField.keyboardType = .numberPad
        case .email:
            self.textField.keyboardType = .emailAddress
        case .normal:
            self.textField.keyboardType = .default
        case .decimalPad:
            self.textField.keyboardType = .decimalPad
        }
        
    }
    
    func setupLayout() {
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.heightAnchor.constraint(equalToConstant: 40),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}

extension CreateOrderTextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delagete?.valueChanged(value: textField.text ?? String())
    }
}



