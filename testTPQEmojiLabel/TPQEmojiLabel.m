//
//  TPQEmojiLabel.m
//  testTPQEmojiLabel
//
//  Created by Piao Piao on 14/12/8.
//  Copyright (c) 2014年 Piao Piao. All rights reserved.
//

#import "TPQEmojiLabel.h"
#import "EmojiManager.h"









@implementation TPQEmojiLabel
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = NO;
    }
    return self;
}
- (void)setEmojiText:(NSString *)emojiText
{
    _emojiText = emojiText;
    [self generateAttributeString:emojiText];
}

- (void)generateAttributeString:(NSString *)emojiText
{
    if ([emojiText length] == 0)
    {
        self.attributedText = nil;
    }
    
    self.linksRangeArray = [NSMutableArray array];
    self.linksUrlArray = [NSMutableArray array];
    
    NSMutableAttributedString* string =[[NSMutableAttributedString alloc] initWithString:@"" attributes:nil];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:QZONE_REGEXSTR options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array = nil;
    array = [regex matchesInString:emojiText options:0 range:NSMakeRange(0, [emojiText length])];
    BOOL hasEmoji = NO;
    BOOL hasNormal = NO;
    NSMutableArray* arrayForTextAttributes = [NSMutableArray array];
    //    NSRange lastEmojiRange = NSMakeRange(0, [emojiText length]);
    //    NSMutableString* string
    NSInteger lastFindEmojiIndex = 0;
    for (NSTextCheckingResult* result in array)
    {
        NSString* name = [emojiText substringWithRange:result.range];
        
        if (result.range.location != lastFindEmojiIndex)
        {
            NSString* normalString = [emojiText substringWithRange:NSMakeRange(lastFindEmojiIndex, result.range.location - lastFindEmojiIndex)];
            NSMutableAttributedString* normalAttributeString = [[NSMutableAttributedString alloc] initWithString:normalString attributes:nil];
            
            
            NSArray* urlArrays = [[UrlParseManager shareInstance] parseURL:normalString];
            for (NSTextCheckingResult* urlResult in urlArrays)
            {
                [normalAttributeString setAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:1]} range:urlResult.range];
                
                [self.linksRangeArray addObject:[NSValue valueWithRange:NSMakeRange([string length] + urlResult.range.location, urlResult.range.length)]];
                [self.linksUrlArray addObject:[normalString substringWithRange:urlResult.range]];

            }
            
            [string insertAttributedString:normalAttributeString atIndex:[string length]];
            
            hasNormal = YES;
            
        }
        NSInteger index = [[EmojiManager shareInstance] emotionLocalIndexFromEmotionString:name];
        if (index != -1)
        {
            NSString* imageName = [NSString stringWithFormat:@"Expression_%ld",(long)index + 1];
            UIImage* image = [UIImage imageNamed:imageName];
            
            MMTextAttachment* attach = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
            attach.image = image;
            
            NSMutableAttributedString* textAttributeString = [[ NSAttributedString attributedStringWithAttachment:attach] mutableCopy];
            
            //            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
            //            paragraphStyle.firstLineHeadIndent =140;
            //            paragraphStyle.paragraphSpacing = 0;
            //            paragraphStyle.lineSpacing = 0;
            //
            //            [textAttributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textAttributeString length])];
            [arrayForTextAttributes addObject:@{@"str":textAttributeString,@"index":@([string length])}];
            [string insertAttributedString:textAttributeString atIndex:[string length]];
            hasEmoji = YES;
            
            
        }
        else
        {
            hasNormal = YES;
            
            NSMutableAttributedString* normalAttributeString = [[NSMutableAttributedString alloc] initWithString:name attributes:nil];
            
            
            NSArray* urlArrays = [[UrlParseManager shareInstance] parseURL:name];
            for (NSTextCheckingResult* urlResult in urlArrays)
            {
                [normalAttributeString setAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:1]} range:urlResult.range];
                [self.linksRangeArray addObject:[NSValue valueWithRange:NSMakeRange([string length] + urlResult.range.location, urlResult.range.length)]];
                [self.linksUrlArray addObject:[name substringWithRange:urlResult.range]];
            }
            
            [string insertAttributedString:normalAttributeString atIndex:[string length]];
            
        }
        
        lastFindEmojiIndex = result.range.location + result.range.length;
    }
    
    if (lastFindEmojiIndex < [emojiText length])
    {
        hasNormal = YES;
        
        NSString* normalString = [emojiText substringWithRange:NSMakeRange(lastFindEmojiIndex, [emojiText length] - lastFindEmojiIndex)];
        
        NSMutableAttributedString* normalAttributeString = [[NSMutableAttributedString alloc] initWithString:normalString attributes:nil];
        NSArray* urlArrays = [[UrlParseManager shareInstance] parseURL:normalString];
        for (NSTextCheckingResult* urlResult in urlArrays)
        {
            [normalAttributeString setAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:1]} range:urlResult.range];
            [self.linksRangeArray addObject:[NSValue valueWithRange:NSMakeRange([string length] + urlResult.range.location, urlResult.range.length)]];
            [self.linksUrlArray addObject:[normalString substringWithRange:urlResult.range]];
        }
        
        [string insertAttributedString:normalAttributeString atIndex:[string length]];
        
    }
    
    if (hasNormal == YES && hasEmoji == YES)
    {
        for (NSDictionary* dic in arrayForTextAttributes)
        {
            NSMutableAttributedString*textAttributeString  = [dic objectForKey:@"str"];
            NSInteger index = [[dic objectForKey:@"index"] integerValue];
            [textAttributeString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-4] range:NSMakeRange(0, textAttributeString.length)];
            [string replaceCharactersInRange:NSMakeRange(index, textAttributeString.length) withAttributedString:textAttributeString];
        }
    }
    
    
    NSDictionary* attri = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [string addAttributes:attri range:NSMakeRange(0, [string length])];
    self.attributedText = string;

}

//- (CGSize)intrinsicContentSize
//{
//    NSLog(@"size prefer is :%f",self.preferredMaxLayoutWidth);
//    CGSize size = [super intrinsicContentSize];
//    NSLog(@"size is %@--content:%@",NSStringFromCGSize(size),self.emojiText);
//    return size;
//}

- (NSString*)linksForCharacterIndex:(NSInteger) index
{
    NSInteger i = 0;
    for (NSValue* value in self.linksRangeArray)
    {
        NSRange range = [value rangeValue];
        if (index > range.location && index <= range.location + range.length)
        {
            return [self.linksUrlArray objectAtIndex:i];
        }
        
        i++;
    }
    return @"";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    NSLog(@"self:%@ :fit size:%@",NSStringFromCGRect(self.frame),NSStringFromCGSize(size))  ;
    
//    if (self.heightConstraint)
//    {
//        [self removeConstraint:self.heightConstraint];
//    }
//    
//    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:2 constant:size.height];
//    [self addConstraint:self.heightConstraint];
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y , self.frame.size.width, size.height);
}


@end
