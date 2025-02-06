//
//  WebViewTestViewController.swift
//  Sample
//
//  Created by Enliple on 2024/12/18
//  Copyright ⓒ 2024 Enliple. All rights reserved.
//
    

import Foundation
import UIKit
import WebKit

import DataManagerSDK



class WebViewTestViewController: UIViewController {
    
    static func create() -> WebViewTestViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc: WebViewTestViewController? = storyBoard.instantiateViewController(withIdentifier: "WebViewTestViewController") as? WebViewTestViewController
        vc?.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    
    
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textViewTitle: UILabel!
    
    @IBOutlet weak var textFieldUrl: UITextField!
    @IBOutlet weak var textViewLog: UITextView!
    
    let defaultUrl: String = "https://m.shopbot2.com"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        
        enableLog()
        DataManagerSDK.setWebView(webView: webView, hostUrl: defaultUrl)
        
        textFieldUrl.text = defaultUrl
        loadUrl(url: defaultUrl)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 터치 이벤트가 다른 뷰에도 전달되도록 설정
        textViewTitle.isUserInteractionEnabled = true
        textViewTitle.addGestureRecognizer(tapGesture)
    }
    
    
    func loadUrl(url: String) {
        guard let requestUrl = URL(string: url) else { return }
        webView.load(URLRequest(url: requestUrl))
    }
    
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func loadUrl(_ sender: Any) {
        guard let url = textFieldUrl.text else { return }
        loadUrl(url: url)
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func enableLog() {
        let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
        let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(script)
        webView.configuration.userContentController.add(self, name: "logHandler")
    }
}


extension WebViewTestViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DataManagerSDK.webViewLoadFinished(webView: webView, currentUrl: webView.url?.absoluteString ?? "")
    }
    
}




extension WebViewTestViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        textViewLog.text.append("\(message.body)\n")
        
        let bottom = NSRange(location: textViewLog.text.count - 1, length: 1)
        textViewLog.scrollRangeToVisible(bottom)
    }
    
}
