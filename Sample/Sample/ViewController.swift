//
//  ViewController.swift
//  Sample
//
//  Created by Enliple on 2024/11/20
//  Copyright ⓒ 2024 Enliple. All rights reserved.
//
    

import UIKit
import DataManagerSDK




class ViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    var dataSources: [[String: Any]] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MainVCCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        let views: [String: Any] = ["tableView": tableView]
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: views)
        ].flatMap { $0 })
        
        loadDatas()
        tableView.reloadData()
    }

    
    func loadDatas() {
        dataSources.append(PresetData.makeSignUpData())
        dataSources.append(PresetData.makeSignInData())
        dataSources.append(PresetData.makeSignOutData())
        dataSources.append(PresetData.makeModifyUserData())
        dataSources.append(PresetData.makeViewedProductData())
        dataSources.append(PresetData.makeFavoriteData())
        dataSources.append(PresetData.makeCartData())
        dataSources.append(PresetData.makeOrderData())
        dataSources.append(PresetData.makeOrderCancelData())
        dataSources.append(PresetData.makeOrderOutData())
        dataSources.append(PresetData.makeInstallData())
        dataSources.append(PresetData.makeVisitData())
        dataSources.append(PresetData.makePageViewData())
        dataSources.append(PresetData.makeOutData())
        dataSources.append(PresetData.makeCustomData())
        dataSources.append(PresetData.makeWebViewData())
    }
    
    

}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCell", for: indexPath)
        
        guard dataSources.count > indexPath.row else {
            return cell
        }
        
        let data = dataSources[indexPath.row]
        cell.textLabel?.text = data[PresetData.titleNameKey] as? String ?? ""
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard dataSources.count > indexPath.row else {
            return
        }
        
        let data = dataSources[indexPath.row]
        let title = data[PresetData.titleNameKey] as? String ?? ""
        
        
        var presentVC: UIViewController? = nil
        
        if title == PresetData.webViewTestTitle {
            presentVC = WebViewTestViewController.create()
        }
        else {
            presentVC = DataInputViewController.create(data: data)
            
        }
        
        guard let vc = presentVC else { return }
        self.present(vc, animated: true)
    }
    
    
}
