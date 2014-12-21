//
//  AppDelegate.h
//  DotCam
//
//  Created by Cam on 14-12-18.
//  Copyright (c) 2014年 Cam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

#define kAppKey @"2582352523";
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html";

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString* wbtoken;
@property (strong, nonatomic) NSString* wbCurrentUserID;
@end
