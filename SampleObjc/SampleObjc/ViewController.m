//
//  ViewController.m
//  SampleObjc
//
//  Created by Enliple on 2/13/25.
//

#import "ViewController.h"
#import "DataManagerSDK/DataManagerSDK.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
 

- (IBAction)sendButtonClicked:(id)sender {
    
    DMProduct *product = [[DMProduct alloc] init];
    [product setImageUrl:@"product image url"];
    [product setProductId:@"product_id"];
    [product setProductName:@"product_name"];
    [product setProductPrice:1000];
    [product setProductQty:1];
    [product setProductUrl:@"product_url"];
    
    
    DMOrder *order = [[DMOrder alloc] init];
    [order setOrderId:@"order_id"];
    [order setProducts:@[ product]];
    [order setTotalPrice:10000];
    [order setZipCode:@"zip_code"];
    [order setPhoneNumber:@"phone_number"];
    [order setAddress:@"address"];
    [order setTotalQty:5];
    [order setPaymentMethod:@"payment_method"];
    [order setMemberId:@"member_id"];
    [order setMemberName:@"member_name"];
    [order setEmail:@"email"];
    
        
    // 미리 정의된 Key값으로 데이터 추가 (예시)
    [order addCustomDataWithParam:DMParamsPvInName value:@"pv_in_name"];
    
    // 커스텀 Key값으로 데이터 추가 (예시)
    [order addCustomDataWithKey:@"test_custom_key" value:@"test_custom_value"];
    
    [DataManagerSDK addEventWithEvent:order];
    
}


@end
