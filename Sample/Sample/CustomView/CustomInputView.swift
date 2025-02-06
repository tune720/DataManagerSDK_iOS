//
//  CustomInputView.swift
//  Sample
//
//  Created by Enliple on 2024/12/17
//  Copyright ⓒ 2024 Enliple. All rights reserved.
//
    

import Foundation




import UIKit

class CustomInputView: UIView {
    
    // MARK: - UI Components
    private let inputBox1 = UITextField()
    private let inputBox2 = UITextField()
    private let toggleSwitch = UISwitch()
    private let dropdown = UIPickerView()
    private let addButton = UIButton(type: .system)
    
    // MARK: - Variables
    var inputType: InputType = .text
    var data: [String: Any] = [:]
    var key: String = ""
    var dropdownItems: [String] = []
    var buttonAction: (() -> Void)?
    
    private var pickerSelectedValue: String = ""
    
    // MARK: - InputType Enum
    enum InputType {
        case text, `switch`, dropdown, button
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - View Setup
    private func setupView() {
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.4)
        
        // Add inputBox1
        inputBox1.borderStyle = .roundedRect
        addSubview(inputBox1)
        
        // Add inputBox2
        inputBox2.borderStyle = .roundedRect
        addSubview(inputBox2)
        
        // Add Switch
        toggleSwitch.isHidden = true
        addSubview(toggleSwitch)
        
        // Add Dropdown (PickerView)
        dropdown.isHidden = true
        dropdown.delegate = self
        dropdown.dataSource = self
        addSubview(dropdown)
        
        // Add Button
        addButton.setTitle("Add Products", for: .normal)
        addButton.isHidden = true
        addButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(addButton)
        
        inputBox1.translatesAutoresizingMaskIntoConstraints = false
        inputBox2.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        layoutComponents()
    }
    
    // MARK: - Layout Components
    private func layoutComponents() {
        inputBox1.removeConstraints(inputBox1.constraints)
        inputBox2.removeConstraints(inputBox1.constraints)
        toggleSwitch.removeConstraints(inputBox1.constraints)
        dropdown.removeConstraints(inputBox1.constraints)
        addButton.removeConstraints(inputBox1.constraints)
        
        var layoutConstraints: [NSLayoutConstraint] = [
            inputBox1.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            inputBox1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            inputBox1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            inputBox1.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        if !inputBox2.isHidden {
            layoutConstraints.append(contentsOf: [
                inputBox2.topAnchor.constraint(equalTo: inputBox1.bottomAnchor, constant: 8),
                inputBox2.leadingAnchor.constraint(equalTo: inputBox1.leadingAnchor),
                inputBox2.trailingAnchor.constraint(equalTo: inputBox1.trailingAnchor),
                inputBox2.heightAnchor.constraint(equalToConstant: 40),
                inputBox2.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
        }
        
        if !toggleSwitch.isHidden {
            layoutConstraints.append(contentsOf: [
                toggleSwitch.centerXAnchor.constraint(equalTo: inputBox1.centerXAnchor),
                toggleSwitch.topAnchor.constraint(equalTo: inputBox1.bottomAnchor, constant: 8),
                toggleSwitch.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
        }
        
        if !dropdown.isHidden {
            layoutConstraints.append(contentsOf: [
                dropdown.topAnchor.constraint(equalTo: inputBox1.bottomAnchor, constant: 8),
                dropdown.leadingAnchor.constraint(equalTo: inputBox1.leadingAnchor),
                dropdown.trailingAnchor.constraint(equalTo: inputBox1.trailingAnchor),
                dropdown.heightAnchor.constraint(equalToConstant: 100.0),
                dropdown.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
        }
        
        if !addButton.isHidden {
            layoutConstraints.append(contentsOf: [
                addButton.topAnchor.constraint(equalTo: inputBox1.bottomAnchor, constant: 8),
                addButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                addButton.heightAnchor.constraint(equalToConstant: 40),
                addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
        }
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    
    // MARK: - Update View
    func updateView(key: String, data: [String: Any], inputType: InputType, dropdownItems: [String] = []) {
        self.key = key
        self.data = data
        self.inputType = inputType
        self.dropdownItems = dropdownItems
        
        inputBox1.text = key
        
        
        inputBox2.isHidden = true
        toggleSwitch.isHidden = true
        dropdown.isHidden = true
        addButton.isHidden = true
        
        switch inputType {
        case .switch:
            toggleSwitch.isHidden = false
            toggleSwitch.isOn = data[key] as? Bool ?? false
            
        case .dropdown:
            dropdown.isHidden = false
            pickerSelectedValue = data[key] as? String ?? ""
            dropdown.reloadAllComponents()
            
        case .button:
            addButton.isHidden = false
            
        case .text:
            inputBox2.isHidden = false
            if key.uppercased().contains("QTY") || key.uppercased().contains("QUANTITY") || key.uppercased().contains("PRICE") {
                inputBox2.text = "\(data[key] as? Int ?? 0)"
            } else {
                inputBox2.text = data[key] as? String ?? ""
            }
        }
        
        layoutComponents()
    }
    
    
    
    
    
    // MARK: - Button Action
    @objc private func buttonTapped() {
        buttonAction?()
    }
    
    // MARK: - Public Methods
    func setOnButtonClickListener(action: @escaping () -> Void) {
        self.buttonAction = action
    }
    
    func getKey() -> String {
        return inputBox1.text ?? ""
    }
    
    func getValue() -> String {
        switch inputType {
        case .switch:
            return "\(toggleSwitch.isOn)"
        case .dropdown:
            return pickerSelectedValue
        case .button:
            return ""
        case .text:
            return inputBox2.text ?? ""
        }
    }
}

// MARK: - UIPickerView Delegate & DataSource
extension CustomInputView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dropdownItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dropdownItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelectedValue = dropdownItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = dropdownItems[row]
        return label
    }
    
}
