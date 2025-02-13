# DataManager iOS SDK

[![CI Status](https://img.shields.io/travis/datamanager/DataManagerSDK.svg?style=flat)](https://travis-ci.org/datamanager/DataManagerSDK)
[![Version](https://img.shields.io/cocoapods/v/DataManagerSDK.svg?style=flat)](https://cocoapods.org/pods/DataManagerSDK)
[![License](https://img.shields.io/cocoapods/l/DataManagerSDK.svg?style=flat)](https://cocoapods.org/pods/DataManagerSDK)
[![Platform](https://img.shields.io/cocoapods/p/DataManagerSDK.svg?style=flat)](https://cocoapods.org/pods/DataManagerSDK)



|지원 환경|
|---:|
| Deployment Target: iOS 13.0 이상 |
| 최신 버전의 Xcode (Xcode 16.2 / Swift 5.3) |

DataManager SDK는 Swift로 개발되었습니다. Swift 기반의 프로젝트에서 DataManager SDK를 사용하시려면 반드시 최신 버전의 Xcode를 사용해주세요.

## 최신 버전 및 변경사항
- 최신버전 : 1.0.1
- 변경사항
  - Objective-C 지원
<br>
<br><br>


## 1. SDK 설치하기
### 1) Cocoapods 사용하여 설치
#### 프로젝트의 Podfile에 'DataManagerSDK' 를 추가합니다.
```swift
pod 'DataManagerSDK'
```

### 2) 수동 설치
 - DataManagerSDK.framework를 다운로드 받습니다.  
 - DataManagerSDK.framework를 앱 프로젝트의 General > Embeded Binaries 항목으로 끌어서 놓습니다.  


## 2. 프로젝트 설정

### 1) iOS 9 ATS(App Transport Security) 처리
iOS 9부터 ATS(App Transport Security) 기능이 기본적으로 활성화 되어 있으며, 암호화된 HTTPS 방식의 통신만 허용됩니다.  
따라서 아래의 사항을 앱 프로젝트의 Info.plist 파일에 적용하여 주시기 바랍니다.  

```swift
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```
### 2) Objective-C 프로젝트
DataManager SDK는 Swift 기반으로 개발되었으나, Objective-C 또한 지원 하도록 구현되어 있습니다.  
다만 가이드 문서는 Swift를 기준으로 설명하고 있으며, 해당 내용을 참고하여 Objective-C에서도 활용하시면 됩니다.



### 4) ATT(App Tracking Transparency) framework 적용
iOS14 타겟팅된 앱은 IDFA 식별자를 얻기 위해서는 ATT Framework를 반드시 적용해야 합니다.  
IDFA값을 사용하지 못 할 경우 VenderID를 사용하도록 되어 있으나 보다 정확한 데이터 수집을 위해 IDFA값을 활용 할 수 있도록 하는 것을 권장 드립니다.


####  (1) Info.plist 수정
앱이 사용자 또는 장치를 추적하기 위해 데이터 권한을 요청하는 이유를 사용자에게 알리는 메세지를 추가해야 합니다.  
```swift
<key> NSUserTrackingUsageDescription </key>
<string> 사용자 활동 분석을 위한 식별을 위해 해당 데이터가 사용됩니다. </string>
```


####  (2) ATTrackingManager 코드 적용

```swift
if #available(iOS 14, *) {
    ATTrackingManager.requestTrackingAuthorization { (status) in
        if status == .authorized {
          // idfa 사용 승인된 경우
        }
    }
}
else {
  // iOS 14.0 미만 버전의 경우
}
```


####  (2) User Script Sandboxing 옵션 변경
App TARGET의 Buid Setting 에서 User Script Sandboxing을 검색, 'No' 로 변경시켜 줍니다.   
* 빌드시 특별히 에러가 발생하지 않는다면 적용하지 않아도 됩니다.


## 3. SDK 초기화 및 사용방법

### 1. SDK 추가 및 초기화

```swift
import DataManagerSDK		// DataManagerSDK 추가
```

SDK의 초기화는 아래와 같이 AppDelegate 또는 SceneDelegate등 앱 실행시 가장 먼저 이벤트를 받을 수 있는 곳에 구현하는 것을 권장드립니다.  
AppKey의 경우 DataManager 관리자 페이지에서 확인 가능 합니다.

```swift
//in ApppDelegate
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    DataManagerSDK.initSDK(appKey: "{발급받은 AppKey}")
    
    return true
}
```



### 2. 이벤트 생성 및 전달
* 기본 이벤트  
  기본 이벤트는 본 SDK를 사용하는데 있어 대표적인 기능들에 대해 미리 생성해둔 이벤트에 해당 합니다.  
  아래와 같이 미리 생성된 클래스를 활용하셔서 이벤트를 생성 전달 하실 수 있습니다.  
  ```swift
  let cart: DMCart = DMCart()

  //기본 파라메터 설정
  cart.productId = "{product id}"
  cart.productName = "{product anme}"
  cart.productPrice = 10000
  cart.productImageUrl = "{product image url}"
  cart.productUrl = "{product url}"
  cart.productQty = 1
  
  //커스텀 파라메터 추가
  cart.addCustomData(key: "커스텀 key", value: "커스텀 value")

  //생성된 이벤트 전달
  DataManagerSDK.addEvent(event: cart)
  ```
  <br>

* 커스텀 이벤트  
  커스텀 이벤트는 사용자가 별도로 생성한 이벤트를 말합니다.    
  해당 이벤트의 경우 아래와 같이 DMCustomEvent를 이용하여 이벤트를 생성 후 전달 하시면 됩니다.  
  커스텀 이벤트의 경우 다수 생성될 수 있으므로, 해당 이벤트의 구분을 위해 EventName을 추가로 전달 받습니다.  
  EventName의 경우 커스텀 이벤트를 생성하실때 사용하신 이벤트명을 넣어 주시면 됩니다.
  ```swift
  let customEvent: DMCustomEvent = DMCustomEvent(eventName: "EventName")
  
  //커스텀 파라메터 추가
  customEvent.addCustomData(key: "커스텀 key", value: "커스텀 value")

  //생성된 이벤트 전달
  DataManagerSDK.addEvent(event: customEvent)
  ```
  <br>


* 이벤트 전달  
  모든 이벤트 관련 클래스는 EventModel을 상속받고 있으므로 아래와 같이 생성된 이벤트들을 전달하시면 됩니다.
  ```swift
  let cart: DMCart = DMCart()
  DataManagerSDK.addEvent(event: cart)
  ```
  <br>

* 이벤트와 파라메터는 아래 <b>3)이벤트 타입</b> 과 <b>4)파라메터 종류</b>를 참고하시면 되며,  
  기본 이벤트의 경우 set 함수를 통해 기본 설정 값들에 대해 지원 하고 있으니 참고 바랍니다.  
  파라메터의 경우 커스텀하여 추가된 Key값을 가지는 경우 제공된 값을 사용하지 않고  
  아래 <b>'커스텀 파라메터 추가'</b>와 같이 직접 입력하시면 됩니다. 
  <br>

* 커스텀 파라메터의 추가  
  사용자 지정된 커스텀 파라메터의 경우 아래 함수를 통해 추가하시면 됩니다.
  ```swift
  customEvent.addCustomData(key: "커스텀 key", value: "커스텀 value")
  ```
  예시의 경우 Value에서 String데이터를 세팅하도록 되어 있으나 다양한 타입을 지원하고 있습니다.
  <br>

### 3) 이벤트 타입
| 클래스             | 구분            |        설명         |
| :-------          | :--------:    | :------------------------ |
| DMSignIn          |   기본         | 사용자 로그인 |
| DMSignOut         |   기본         | 회원 탈퇴 |
| DMSignUp          |   기본         | 회원 가입 |
| DMModifyUserInfo  |   기본         | 사용자 정보 수정  |
| DMProduct         |   기본         | 상품관련 이벤트에서 상품정보를 담아준다. |
| DMViewedProduct   |   기본         | 상품에 대한 상세 보기등을 처리하기 위한 이벤트 |
| DMFavorite        |   기본         | 상품에 대한 좋아요(즐겨찾기) 관련 이벤트  |
| DMCart            |   기본         | 장바구니 이벤트  |
| DMOrder           |   기본         | 상품 구매 이벤트(구매 화면으로 이동) |
| DMOrderCancel     |   기본         | (결제한)구매 취소  |
| DMOrderOut        |   기본         | 구매 화면에서 결제를 하지 않고 빠져나간 경우 |
| DMCustomEvent     |   사용자 지정    | 사용자 지정 이벤트  |
| DMInstall         |   SDK 자체 처리 | 앱 설치 이벤트  |
| DMVisit           |   SDK 자체 처리 | 앱 실행 (외부에서 앱 진입 등) |
| DMPageView        |   SDK 자체 처리 | 화면 전환 이벤트 ( Activity 단위 처리) |
| DMOut             |   SDK 자체 처리 | 앱 종료 이벤트 |
 
* SDK 자체 처리 타입의 경우 특별한 경우가 아니라면 직접 이벤트를 만들어서 전달하실 필요가 없습니다.
<br><br>


### 4) 파라메터
* Parameter
  | 구분             |        설명         |
  | :-------        | :------------------------ |
  | birthDay        | 생일  |
  | email           | E-Mail 주소  |
  | emailAllowed    | E-Mail 수신 동의 여부  |
  | eventName       | 이벤트 명. 커스텀 이벤트들의 구분을 위해 활용  |
  | gender          | 성별  |
  | memberId        | 사용자 아이디  |
  | memberName      | 사용자 이름  |
  | orderNo         | 주문 번호  |
  | paymentAmount   | 총 결제 금액  |
  | paymentMethod   | 결제 수단  |
  | phoneNumber     | 핸드폰(전화) 번호  |
  | productId       | 상품 코드  |
  | productImageUrl | 상품 이미지 URL  |
  | productName     | 상품명  |
  | productPrice    | 상품 가격  |
  | productQty      | 상품 수량  |
  | products        | 상품 목록에 대한 키값 (상품과 관련된 이벤트에서 상품 목록 관리)  |
  | productUrl      | 상품 URL  |
  | smsAllowed      | SMS 수신 동의 여부  |
  | zipCode         | 우편 번호  |
  | address         | 집 주소  |
  | totalPrice      | 상품 총 가격  |
  | totalQuantity   | 상품 총 수량  |

<br>

### 5) WebView를 사용하는 하이브리드 앱에서의 설정
웹 기반의 하이브리드앱의 경우 이미 삽입된 Script에 의해 데이터를 수집하게 됩니다.  
다만, 웹브라우져가 아닌 앱으로 접속한것임을 구분하기 위한 일부 설정이 필요하게 되며, 이를 위해 아래와 같이 설정해 주셔야 합니다.

```swift

String url = "웹뷰에 로딩할 Url"

// 페이지 로딩전 아래와 같이 호출해 주셔야 합니다.
DataManagerSDK.setWebView(webView: webView, hostUrl: defaultUrl)

let requestUrl = URL(string: url) {
  webView.load(URLRequest(url: requestUrl))
}

// 페이지 로딩이 완료되었음을 SDK에 전달해 주셔야 합니다.
func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    DataManagerSDK.webViewLoadFinished(webView: webView, currentUrl: webView.url?.absoluteString ?? "")
}

```

<br>
<br>
<br>


# DataManager iOS SDK Release History
 | version |        Description        |
 | :-----: | :------------------------ |
 | 1.0.1   |  Objective-C 지원        |
 | 1.0.0   |  first Release        |