//
//  TPQEmojiLabelV2.h
//  testTPQEmojiLabel
//
//  Created by Piao Piao on 15/3/10.
//  Copyright (c) 2015年 Piao Piao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPQEmojiLabelV2Delegate <NSObject>

- (void)didSelectUrl:(NSString*)url;
@end

@interface TPQEmojiLabelV2 : UIView
@property(nonatomic,strong) UITextView* textView;
@property(nonatomic,strong) NSString* textContent;
@property(nonatomic,strong) NSMutableArray* linksRangeArray;
@property(nonatomic,strong) NSMutableArray* linksUrlArray;
@property(nonatomic,weak) id<TPQEmojiLabelV2Delegate> urlClickDelegate;
- (NSString*)linksForCharacterIndex:(NSInteger) index;
@end
