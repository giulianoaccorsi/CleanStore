//
//  CreateOrderSwitchCell.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 09/06/22.
//

import UIKit

protocol CreateOrderSwitchCellDelegate {
    func isON()
    func isOFF()
}

class CreateOrderSwitchCell: UITableViewCell {
    
    static let identifier: String = "CreateOrderSwitchCell"
    var delegate: CreateOrderSwitchCellDelegate?
    
    let titleLabel: UILabel = {
        let title = UILabel(frame: .zero)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        return title
    }()
    
    lazy var switchButton: UISwitch = {
        let switchButton = UISwitch(frame: .zero)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)
        return switchButton
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, switchButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(titleLabel: String) {
        self.titleLabel.text = titleLabel
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
    
    @objc func switchStateDidChange(){
        if (switchButton.isOn == true){
            print("UISwitch state is now ON")
            delegate?.isON()
        }
        else{
            print("UISwitch state is now Off")
            delegate?.isOFF()
        }
    }
}




