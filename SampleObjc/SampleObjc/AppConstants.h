//
//  AppConstants.h
//  SampleObjc
//
//  Created by Enliple on 2/13/25.
//

#ifndef AppConstants_h
#define AppConstants_h


@interface AppConstants : NSObject

extern NSString *const DataManagerAppKey;
extern BOOL const EnableLog;

@end

@implementation AppConstants

NSString *const DMAppKey = @"{App Key}";
BOOL const DMEnableLog = NO;

@end


#endif /* AppConstants_h */
