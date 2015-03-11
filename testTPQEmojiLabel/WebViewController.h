//
//  WebViewController.h
//  testTPQEmojiLabel
//
//  Created by Piao Piao on 15/3/10.
//  Copyright (c) 2015年 Piao Piao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong) NSString* url;
@end
