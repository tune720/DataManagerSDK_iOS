//
//  PresetData.swift
//  Sample
//
//  Created by Enliple on 2024/12/17
//  Copyright ⓒ 2024 Enliple. All rights reserved.
//
    

import Foundation
import DataManagerSDK


struct PresetData {
    static let titleNameKey = "list_title"
    static let webViewTestTitle = "WebView Test"
    
    // MARK: - 기본 데이터
    private static func makeDefaultData(type: String) -> [String: Any] {
        return [DMDefaultParams.type.rawValue: type]
    }
    
    private static func addProductList() -> [String: Any] {
        return [
            DMParams.productId.rawValue: "product_id",
            DMParams.productName.rawValue: "product_name",
            DMParams.productPrice.rawValue: 10000,
            DMParams.productImageUrl.rawValue: "product_image_url",
            DMParams.productUrl.rawValue: "product_url",
            DMParams.productQty.rawValue: 1
        ]
    }
    
    // MARK: - 웹뷰 데이터
    static func makeWebViewData() -> [String: Any] {
        return [titleNameKey: webViewTestTitle]
    }
    
    // MARK: - 상품 데이터
    static func makeProductData() -> [String: Any] {
        return addProductList()
    }
    
    static func makeCustomData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.custom.rawValue)
        data[titleNameKey] = "커스텀 이벤트"
        data[DMDefaultParams.id.rawValue] = "custom_event_id"
        data[DMParams.eventName.rawValue] = "마이페이지 이탈"
        return data
    }
    
    static func makeCartData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.cart.rawValue)
        data[titleNameKey] = "장바구니"
        data.merge(addProductList(), uniquingKeysWith: { current, _ in current })
        return data
    }
    
    static func makeFavoriteData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.favorite.rawValue)
        data[titleNameKey] = "찜 상품"
        data.merge(addProductList(), uniquingKeysWith: { current, _ in current })
        return data
    }
    
    static func makeOrderData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.order.rawValue)
        data[titleNameKey] = "주문"
        data[DMParams.products.rawValue] = ""
        data[DMParams.orderId.rawValue] = "order_id"
        data[DMParams.zipCode.rawValue] = "zip_code"
        data[DMParams.phoneNumber.rawValue] = "phone_number"
        data[DMParams.address.rawValue] = "address"
        data[DMParams.totalPrice.rawValue] = 10000
        data[DMParams.totalQuantity.rawValue] = 5
        data[DMParams.paymentMethod.rawValue] = "payment_method"
        data[DMParams.memberName.rawValue] = "member_name"
        data[DMParams.email.rawValue] = "email"
        data[DMParams.memberId.rawValue] = "member_id"
        return data
    }
    
    static func makeOrderCancelData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.orderCancel.rawValue)
        data[titleNameKey] = "주문취소"
        data[DMParams.products.rawValue] = ""
        data[DMParams.memberId.rawValue] = "member_id"
        data[DMParams.orderId.rawValue] = "order_id"
        return data
    }
    
    static func makeOrderOutData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.orderOut.rawValue)
        data[titleNameKey] = "주문-이탈"
        data[DMParams.products.rawValue] = ""
        data[DMParams.memberId.rawValue] = "member_id"
        return data
    }
    
    static func makeViewedProductData() -> [String: Any] {
            var data = makeDefaultData(type: DMEventType.viewedProduct.rawValue)
            data[titleNameKey] = "본 상품"
            data.merge(addProductList(), uniquingKeysWith: { current, _ in current })
            return data
        }
        
    static func makeModifyUserData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.modifyUser.rawValue)
        data[titleNameKey] = "회원정보 수정"
        data[DMParams.memberId.rawValue] = "member_id"
        data[DMParams.memberName.rawValue] = "member_name"
        data[DMParams.phoneNumber.rawValue] = ""
        data[DMParams.email.rawValue] = ""
        data[DMParams.smsAllowed.rawValue] = false
        data[DMParams.emailAllowed.rawValue] = false
        data[DMParams.birthDay.rawValue] = "birthday"
        data[DMParams.gender.rawValue] = "남"
        return data
    }
    
    static func makeSignInData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.signIn.rawValue)
        data[titleNameKey] = "로그인"
        data[DMParams.memberId.rawValue] = "member_id"
        return data
    }
    
    static func makeSignOutData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.signOut.rawValue)
        data[titleNameKey] = "회원탈퇴"
        data[DMParams.memberId.rawValue] = "member_id"
        return data
    }
    
    static func makeSignUpData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.signUp.rawValue)
        data[titleNameKey] = "회원가입"
        data[DMParams.memberId.rawValue] = "member_id"
        data[DMParams.memberName.rawValue] = "member_name"
        data[DMParams.phoneNumber.rawValue] = ""
        data[DMParams.email.rawValue] = ""
        data[DMParams.smsAllowed.rawValue] = false
        data[DMParams.emailAllowed.rawValue] = false
        data[DMParams.birthDay.rawValue] = "birthday"
        data[DMParams.gender.rawValue] = "gender"
        return data
    }
    
    static func makeVisitData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.visit.rawValue)
        data[titleNameKey] = "실행"
        data[DMParams.pvInName.rawValue] = "page_name_in"
        data[DMParams.deeplink.rawValue] = "deep_link"
        return data
    }
    
    static func makePageViewData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.pageView.rawValue)
        data[titleNameKey] = "방문(PageView)"
        data[DMParams.pvInName.rawValue] = "page_name_in"
        data[DMParams.pvOutName.rawValue] = "page_name_out"
        return data
    }
    
    static func makeOutData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.out.rawValue)
        data[titleNameKey] = "종료"
        data[DMParams.pvOutName.rawValue] = "out_name"
        return data
    }
    
    static func makeInstallData() -> [String: Any] {
        var data = makeDefaultData(type: DMEventType.install.rawValue)
        data[titleNameKey] = "설치"
        data[DMParams.referrer.rawValue] = "referrer"
        return data
    }
}
