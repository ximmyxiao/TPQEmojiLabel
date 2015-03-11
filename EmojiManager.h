//
//  EmojiManager.h
//  testTPQEmojiLabel
//
//  Created by Piao Piao on 15/3/10.
//  Copyright (c) 2015年 Piao Piao. All rights reserved.
//

#ifndef testTPQEmojiLabel_EmojiManager_h
#define testTPQEmojiLabel_EmojiManager_h

extern const NSInteger  kEmotionCount ;
extern const NSInteger  KEmojiCount;
extern NSString* const QZONE_REGEXSTR;

@interface MMTextAttachment : NSTextAttachment
{
    
    
    
}



@end

@interface UrlParseManager : NSObject
@property(nonatomic,strong) NSArray* kUrlStringArray;
+ (instancetype)shareInstance;
- (NSArray *)parseURL:(NSString*)string;
@end

@interface EmojiManager : NSObject
@property(nonatomic,strong) NSArray* kEmotionStringArray;
+ (instancetype)shareInstance;
/*localIndex转换成string*/
- (NSString*)emotionStringFromLocalIndex:(NSInteger)localIndex;
/*string转换成localIndex*/
- (NSInteger)emotionLocalIndexFromEmotionString:(NSString*)emotionString;
@end
#endif
