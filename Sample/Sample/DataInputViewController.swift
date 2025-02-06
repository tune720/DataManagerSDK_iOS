//
//  DataInputViewController.swift
//  Sample
//
//  Created by Enliple on 2024/12/18
//  Copyright ⓒ 2024 Enliple. All rights reserved.
//
    

import Foundation
import UIKit

import DataManagerSDK


class DataInputViewController: UIViewController {

    static func create(data:[String:Any]?) -> DataInputViewController? {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc: DataInputViewController? = storyBoard.instantiateViewController(withIdentifier: "DataInputViewController") as? DataInputViewController
        vc?.modalPresentationStyle = .overFullScreen
        vc?.dataBundle = data ?? [:]
        
        return vc
    }
    
    @IBOutlet weak var textViewTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var dataBundle: [String: Any] = [:]
    var products: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 키보드 이벤트 관찰자 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 터치 이벤트가 다른 뷰에도 전달되도록 설정
        textViewTitle.isUserInteractionEnabled = true
        textViewTitle.addGestureRecognizer(tapGesture)
        
        
        initData()
    }

    private func initData() {
        textViewTitle.text = dataBundle[PresetData.titleNameKey] as? String ?? ""
        
        dataBundle.forEach { key, value in
            if key == PresetData.titleNameKey || key == DMDefaultParams.type.rawValue {
                return
            }
            
            let inputView = CustomInputView()
            inputView.key = key
            
            switch key {
            case DMParams.products.rawValue:
                inputView.updateView(key: key, data: dataBundle, inputType: .button)
                inputView.buttonAction = {
                    let vc = ProductInputViewController.create(products: self.products)
                    self.present(vc!, animated: true)
                }
                
            case DMParams.gender.rawValue:
                inputView.updateView(key: key, data: dataBundle, inputType: .dropdown, dropdownItems: ["남", "여"])
                
            case DMDefaultParams.triggerCode.rawValue:
                inputView.updateView(key: key, data: dataBundle, inputType: .dropdown, dropdownItems: ["클릭", "페이지 로딩"])
                
            case DMParams.smsAllowed.rawValue, DMParams.emailAllowed.rawValue:
                inputView.updateView(key: key, data: dataBundle, inputType: .switch)
                
            default:
                inputView.updateView(key: key, data: dataBundle, inputType: .text)
                
            }
        
            stackView.addArrangedSubview(inputView)
        }
        
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func addParameter(_ sender: Any) {
        let newInputView = CustomInputView()
        newInputView.updateView(key: "", data: dataBundle, inputType: .text)
        stackView.addArrangedSubview(newInputView)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func submitData(_ sender: Any) {
        var collectedData: [String: Any] = [:]

        for subview in stackView.arrangedSubviews {
            if let inputView = subview as? CustomInputView {
                let key = inputView.getKey()
                let value = inputView.getValue()
                
                if !key.isEmpty && !value.isEmpty {
                    if key.uppercased().contains("QTY") || key.uppercased().contains("QUANTITY") || key.uppercased().contains("PRICE") {
                        collectedData[key] = Int(value) ?? 0
                    }
                    else {
                        collectedData[key] = value
                    }
                }
            }
        }

        if !products.isEmpty {
            collectedData["products"] = products
        }
        
        collectedData[PresetData.titleNameKey] = dataBundle[PresetData.titleNameKey]
        collectedData[DMDefaultParams.type.rawValue] = dataBundle[DMDefaultParams.type.rawValue]
        
        guard let eventModel = DataConverter.shared.convertData(data: collectedData) else {
            return
        }
        
        print("Data JSON is ------------------------------------------")
        print("\(eventModel.toDictionary(parentKey: "")?.jsonString ?? "Empty....")")
        print("-------------------------------------------------------")
        
        DataManagerSDK.addEvent(event: eventModel)
    }
    
    
    
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.height
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)

        // ScrollView의 inset을 조정
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        // ScrollView의 inset 복원
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
        }
    }
}
