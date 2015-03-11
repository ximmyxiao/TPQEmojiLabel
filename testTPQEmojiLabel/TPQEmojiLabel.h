//
//  TPQEmojiLabel.h
//  testTPQEmojiLabel
//
//  Created by Piao Piao on 14/12/8.
//  Copyright (c) 2014年 Piao Piao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiManager.h"

@interface TPQEmojiLabel : UITextView
@property(nonatomic,strong) NSString* emojiText;
@property(nonatomic,strong) NSMutableArray* linksRangeArray;
@property(nonatomic,strong) NSMutableArray* linksUrlArray;
- (NSString*)linksForCharacterIndex:(NSInteger) index;
@end