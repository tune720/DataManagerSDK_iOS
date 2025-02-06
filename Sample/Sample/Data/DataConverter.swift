//
//  DataConverter.swift
//  Sample
//
//  Created by Enliple on 2024/12/17
//  Copyright ⓒ 2024 Enliple. All rights reserved.
//
    

import Foundation
import DataManagerSDK


class DataConverter {
    
    public static let shared = DataConverter()
    
    
    func convertData(data: [String: Any]) -> EventModel? {
        guard let type = data[DMDefaultParams.type.rawValue] as? String else {
            return nil
        }
        
        switch type {
        case DMEventType.pageView.rawValue:             return convertPageViewPageViewEvent(data: data);
        case DMEventType.visit.rawValue:                return convertVisitEvent(data: data);
        case DMEventType.out.rawValue:                  return convertOutEvent(data: data);
        case DMEventType.install.rawValue:              return convertInstallEvent(data: data);
        case DMEventType.signUp.rawValue:               return convertSignUpEvent(data: data);
        case DMEventType.signIn.rawValue:               return convertSignInEvent(data: data);
        case DMEventType.signOut.rawValue:              return convertSignOutEvent(data: data);
        case DMEventType.modifyUser.rawValue:           return convertModifyUserEvent(data: data);
        case DMEventType.viewedProduct.rawValue:        return convertViewedProductEvent(data: data);
        case DMEventType.cart.rawValue:                 return convertCartEvent(data: data);
        case DMEventType.favorite.rawValue:             return convertFavoriteEvent(data: data);
        case DMEventType.order.rawValue:                return convertOrderEvent(data: data);
        case DMEventType.orderOut.rawValue:             return convertOrderOutEvent(data: data);
        case DMEventType.orderCancel.rawValue:          return convertOrderCancelEvent(data: data);
        case DMEventType.custom.rawValue:               return convertCustomEvent(data: data);
        default:
            return nil
        }
    }
    
    
    
    func convertProduct(data: [String: Any]) -> [DMProduct] {
        var products: [DMProduct] = []
        
        guard let productsData = data[DMParams.products.rawValue] as? [[String: Any]], !productsData.isEmpty else {
            return products
        }
        
        products = productsData.map { productData in
            let product = DMProduct()
            
            product.productId = productData[DMParams.productId.rawValue] as? String ?? ""
            product.productName = productData[DMParams.productName.rawValue] as? String ?? ""
            product.productPrice = productData[DMParams.productPrice.rawValue] as? Int ?? 0
            product.imageUrl = productData[DMParams.productImageUrl.rawValue] as? String ?? ""
            product.productUrl = productData[DMParams.productUrl.rawValue] as? String ?? ""
            product.productQty = productData[DMParams.productQty.rawValue] as? Int ?? 0
            
            // Custom Data 처리
            productData.forEach { key, value in
                if ![DMParams.products.rawValue, DMDefaultParams.type.rawValue,
                     DMParams.productId.rawValue, DMParams.productName.rawValue,
                     DMParams.productPrice.rawValue, DMParams.productImageUrl.rawValue,
                     DMParams.productUrl.rawValue, DMParams.productQty.rawValue].contains(key) {
                    product.addCustomData(key: key, value: value as? String ?? "")
                }
            }
            
            return product
        }
        
        return products
    }
    
    
    func convertCustomEvent(data: [String: Any]) -> EventModel? {
        let customEvent = DMCustomEvent(eventName: data[DMParams.eventName.rawValue] as? String ?? "")
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey].contains(key) {
                if key == DMParams.products.rawValue {
                    customEvent.addCustomData(key: DMParams.products.rawValue, value: convertProduct(data: data))
                }
                else {
                    customEvent.addCustomData(key: key, value: value as? String ?? "")
                }
            }
        }
        
        return customEvent
    }
    
    func convertPageViewPageViewEvent(data: [String: Any]) -> EventModel? {
        
        let pageView = DMPageView(pvInName: data[DMParams.pvInName.rawValue] as? String ?? "",
                                  pvOutName: data[DMParams.pvOutName.rawValue] as? String ?? "")
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.pvInName.rawValue, DMParams.pvOutName.rawValue].contains(key) {
                if key == DMParams.products.rawValue {
                    pageView.addCustomData(key: DMParams.products.rawValue, value: convertProduct(data: data))
                }
                else {
                    pageView.addCustomData(key: key, value: value as? String ?? "")
                }
            }
        }
        
        return pageView
    }
    
    func convertOutEvent(data: [String: Any]) -> EventModel? {
        let out = DMOut(pvOutName: data[DMParams.pvOutName.rawValue] as? String ?? "")
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey].contains(key) {
                out.addCustomData(key: key, value: value as? String ?? "")
            }
        }
        
        return out
        
    }
    
    
    func convertInstallEvent(data: [String: Any]) -> EventModel? {
        let install = DMInstall(referrer: data[DMParams.referrer.rawValue] as? String ?? "")
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.referrer.rawValue].contains(key) {
                install.addCustomData(key: key, value: value as? String ?? "")
            }
        }
        
        return install
    }
    
    
    
    func convertVisitEvent(data: [String: Any]) -> EventModel? {
        let visit = DMVisit(pvInName: data[DMParams.pvInName.rawValue] as? String ?? "")
        visit.deepLink = data[DMParams.deeplink.rawValue] as? String ?? ""
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.pvInName.rawValue, DMParams.deeplink.rawValue].contains(key) {
                visit.addCustomData(key: key, value: value as? String ?? "")
            }
        }
        
        return visit
    }
    
    
    
    func convertSignUpEvent(data: [String: Any]) -> EventModel? {
        let signUp = DMSignUp()
        signUp.memberId = data[DMParams.memberId.rawValue] as? String ?? ""
        signUp.memberName = data[DMParams.memberName.rawValue] as? String ?? ""
        signUp.phoneNumber = data[DMParams.phoneNumber.rawValue] as? String ?? ""
        signUp.email = data[DMParams.email.rawValue] as? String ?? ""
        signUp.smsAllowed = data[DMParams.smsAllowed.rawValue] as? Bool ?? false
        signUp.emailAllowed = data[DMParams.emailAllowed.rawValue] as? Bool ?? false
        signUp.birthday = data[DMParams.birthDay.rawValue] as? String ?? ""
        signUp.gender = data[DMParams.gender.rawValue] as? String ?? ""
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.memberId.rawValue, DMParams.memberName.rawValue,
                 DMParams.phoneNumber.rawValue, DMParams.email.rawValue,
                 DMParams.smsAllowed.rawValue, DMParams.emailAllowed.rawValue,
                 DMParams.birthDay.rawValue, DMParams.gender.rawValue].contains(key) {
                signUp.addCustomData(key: key, value: value as? String ?? "")
            }
        }
        
        return signUp
    }
    
    
    func convertSignInEvent(data: [String: Any]) -> EventModel? {
        let signIn = DMSignIn()
        signIn.memberId = data[DMParams.memberId.rawValue] as? String ?? ""
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.memberId.rawValue].contains(key) {
                signIn.addCustomData(key: key, value: value as? String ?? "")
            }
        }
        
        return signIn
    }
    
    func convertSignOutEvent(data: [String: Any]) -> EventModel? {
        let signOut = DMSignOut()
        signOut.memberId = data[DMParams.memberId.rawValue] as? String ?? ""
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.memberId.rawValue].contains(key) {
                signOut.addCustomData(key: key, value: value as? String ?? "")
            }
        }
        
        return signOut
    }
    
    
    func convertModifyUserEvent(data: [String: Any]) -> EventModel? {
        let modifyUser = DMModifyUserInfo()
        modifyUser.memberId = data[DMParams.memberId.rawValue] as? String ?? ""
        modifyUser.memberName = data[DMParams.memberName.rawValue] as? String ?? ""
        modifyUser.phoneNumber = data[DMParams.phoneNumber.rawValue] as? String ?? ""
        modifyUser.email = data[DMParams.email.rawValue] as? String ?? ""
        modifyUser.smsAllowed = data[DMParams.smsAllowed.rawValue] as? Bool ?? false
        modifyUser.emailAllowed = data[DMParams.emailAllowed.rawValue] as? Bool ?? false
        modifyUser.birthDay = data[DMParams.birthDay.rawValue] as? String ?? ""
        modifyUser.gender = data[DMParams.gender.rawValue] as? String ?? ""
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.memberId.rawValue, DMParams.memberName.rawValue,
                 DMParams.phoneNumber.rawValue, DMParams.email.rawValue,
                 DMParams.smsAllowed.rawValue, DMParams.emailAllowed.rawValue,
                 DMParams.birthDay.rawValue, DMParams.gender.rawValue].contains(key) {
                modifyUser.addCustomData(key: key, value: value as? String ?? "")
            }
        }
        
        
        return modifyUser
    }
    
    
    
    func convertViewedProductEvent(data: [String: Any]) -> EventModel? {
        let viewedProduct = DMViewedProduct()
        viewedProduct.productId = data[DMParams.productId.rawValue] as? String ?? ""
        viewedProduct.productName = data[DMParams.productName.rawValue] as? String ?? ""
        viewedProduct.productPrice = data[DMParams.productPrice.rawValue] as? Int ?? 0
        viewedProduct.imageUrl = data[DMParams.productImageUrl.rawValue] as? String ?? ""
        viewedProduct.productUrl = data[DMParams.productUrl.rawValue] as? String ?? ""
        viewedProduct.productQty = data[DMParams.productQty.rawValue] as? Int ?? 0
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.productId.rawValue, DMParams.productName.rawValue,
                 DMParams.productPrice.rawValue, DMParams.productImageUrl.rawValue,
                 DMParams.productUrl.rawValue, DMParams.productQty.rawValue].contains(key) {
                viewedProduct.addCustomData(key: key, value: value as? String ?? "")
            }
        }
        
        return viewedProduct
    }
    
    
    func convertCartEvent(data: [String: Any]) -> EventModel? {
        let cart = DMCart()
        cart.productId = data[DMParams.productId.rawValue] as? String ?? ""
        cart.productName = data[DMParams.productName.rawValue] as? String ?? ""
        cart.productPrice = data[DMParams.productPrice.rawValue] as? Int ?? 0
        cart.productImageUrl = data[DMParams.productImageUrl.rawValue] as? String ?? ""
        cart.productUrl = data[DMParams.productUrl.rawValue] as? String ?? ""
        cart.productQty = data[DMParams.productQty.rawValue] as? Int ?? 0
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.productId.rawValue, DMParams.productName.rawValue,
                 DMParams.productPrice.rawValue, DMParams.productImageUrl.rawValue,
                 DMParams.productUrl.rawValue, DMParams.productQty.rawValue].contains(key) {
                cart.addCustomData(key: key, value: value as? String ?? "")
            }
        }
        
        return cart
    }
    
    
    
    func convertFavoriteEvent(data: [String: Any]) -> EventModel? {
        let favorite = DMFavorite()
        favorite.productId = data[DMParams.productId.rawValue] as? String ?? ""
        favorite.productName = data[DMParams.productName.rawValue] as? String ?? ""
        favorite.productPrice = data[DMParams.productPrice.rawValue] as? Int ?? 0
        favorite.imageUrl = data[DMParams.productImageUrl.rawValue] as? String ?? ""
        favorite.productUrl = data[DMParams.productUrl.rawValue] as? String ?? ""
        favorite.productQty = data[DMParams.productQty.rawValue] as? Int ?? 0
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.productId.rawValue, DMParams.productName.rawValue,
                 DMParams.productPrice.rawValue, DMParams.productImageUrl.rawValue,
                 DMParams.productUrl.rawValue, DMParams.productQty.rawValue].contains(key) {
                favorite.addCustomData(key: key, value: value as? String ?? "")
            }
        }
        
        return favorite
    }
    
    
    
    func convertOrderEvent(data: [String: Any]) -> EventModel? {
        let order = DMOrder()
        order.address = data[DMParams.address.rawValue] as? String ?? ""
        order.email = data[DMParams.email.rawValue] as? String ?? ""
        order.memberId = data[DMParams.memberId.rawValue] as? String ?? ""
        order.memberName = data[DMParams.memberName.rawValue] as? String ?? ""
        order.orderId = data[DMParams.orderId.rawValue] as? String ?? ""
        order.paymentMethod = data[DMParams.paymentMethod.rawValue] as? String ?? ""
        order.phoneNumber = data[DMParams.phoneNumber.rawValue] as? String ?? ""
        order.totalPrice = data[DMParams.totalPrice.rawValue] as? Int ?? 0
        order.totalQty = data[DMParams.totalQuantity.rawValue] as? Int ?? 0
        order.zipCode = data[DMParams.zipCode.rawValue] as? String ?? ""
        
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.address.rawValue,
                 DMParams.email.rawValue, DMParams.memberId.rawValue,
                 DMParams.memberName.rawValue, DMParams.orderId.rawValue,
                 DMParams.paymentMethod.rawValue, DMParams.phoneNumber.rawValue,
                 DMParams.totalPrice.rawValue, DMParams.totalQuantity.rawValue,
                 DMParams.zipCode.rawValue].contains(key) {
                
                if (key == DMParams.products.rawValue) {
                    order.products = convertProduct(data: data)
                }
                else {
                    order.addCustomData(key: key, value: value as? String ?? "")
                }
            }
        }
        
        return order
    }
    
    
    
    func convertOrderCancelEvent(data: [String: Any]) -> EventModel? {
        let orderCancel = DMOrderCancel()
        orderCancel.memberId = data[DMParams.memberId.rawValue] as? String ?? ""
        orderCancel.orderId = data[DMParams.orderId.rawValue] as? String ?? ""
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.memberId.rawValue, DMParams.orderId.rawValue].contains(key) {
                
                if (key == DMParams.products.rawValue) {
                    orderCancel.products = convertProduct(data: data)
                }
                else {
                    orderCancel.addCustomData(key: key, value: value as? String ?? "")
                }
            }
        }
        
        return orderCancel
    }
    
    
    
    func convertOrderOutEvent(data: [String: Any]) -> EventModel? {
        let orderOut = DMOrderOut()
        orderOut.memberId = data[DMParams.memberId.rawValue] as? String ?? ""
        
        data.forEach { key, value in
            if ![DMDefaultParams.type.rawValue, PresetData.titleNameKey,
                 DMParams.memberId.rawValue].contains(key) {
                
                if (key == DMParams.products.rawValue) {
                    orderOut.products = convertProduct(data: data)
                }
                else {
                    orderOut.addCustomData(key: key, value: value as? String ?? "")
                }
            }
        }
        
        return orderOut
    }

    
}


