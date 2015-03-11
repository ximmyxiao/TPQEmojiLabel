//
//  TPQEmojiLabelV2.m
//  testTPQEmojiLabel
//
//  Created by Piao Piao on 15/3/10.
//  Copyright (c) 2015年 Piao Piao. All rights reserved.
//

#import "TPQEmojiLabelV2.h"
#import "EmojiManager.h"


@interface TPQEmojiLabelV2()
@property(nonatomic,strong) NSDictionary* vs;
@property(nonatomic,strong) NSLayoutConstraint* textViewHeightConstraint;
@property(nonatomic,strong) NSMutableArray* constraints;
@end

@implementation TPQEmojiLabelV2

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
        [self commonInit];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}


- (void)commonInit
{
    
    NSTextContainer* container = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    self.textView = [[UITextView alloc] initWithFrame:self.bounds];
    self.textView.backgroundColor = [UIColor redColor];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.userInteractionEnabled = NO;
    [self addSubview:self.textView];
    self.vs = NSDictionaryOfVariableBindings(_textView);


//    [self.textView addConstraint:self.textViewHeightConstraint];
}


- (void)updateConstraints
{
    [self removeConstraints:self.constraints];
    self.constraints = [NSMutableArray array];
    NSArray* HConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|" options:0 metrics:nil views:self.vs];
    [self addConstraints:HConstrains];
    [self.constraints addObjectsFromArray:HConstrains];
    NSArray* VConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView]|" options:0 metrics:nil views:self.vs];
    [self addConstraints:VConstrains];
    [self.constraints addObjectsFromArray:VConstrains];

    self.textViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:10];
    [super updateConstraints];
}

- (void)setTextContent:(NSString *)textContent
{
    _textContent = textContent;
    
    [self generateAttributeString:textContent];
    
    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
    
}



- (void)generateAttributeString:(NSString *)emojiText
{
    if ([emojiText length] == 0)
    {
        self.textView.attributedText = nil;
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
    self.textView.attributedText = string;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self.textView removeConstraint:self.textViewHeightConstraint];
//    
//    CGSize size = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, MAXFLOAT)];
//    self.textViewHeightConstraint.constant = size.height;
//    [self.textView addConstraint:self.textViewHeightConstraint];

}

- (CGSize)intrinsicContentSize
{
    CGSize size = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, MAXFLOAT)];

    return CGSizeMake(self.bounds.size.width, size.height);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches begin");
    
    
    UITouch* touch = [touches anyObject];
    CGPoint point =  [touch locationInView:self];
    point = CGPointMake(point.x - self.textView.textContainerInset.left, point.y - self.textView.textContainerInset.top);
    NSLog(@"point :%@",NSStringFromCGPoint(point));
    NSLog(@"length:%d",[self.textView.attributedText length]);
    NSInteger index = [self.textView.layoutManager characterIndexForPoint:point inTextContainer:self.textView.textContainer  fractionOfDistanceBetweenInsertionPoints:NULL];
    NSLog(@"index :%d",index);
    
    NSString*url = [self linksForCharacterIndex:index];
    if ([url length] > 0)
    {
        if ([self.urlClickDelegate respondsToSelector:@selector(didSelectUrl:)])
        {
            [self.urlClickDelegate didSelectUrl:url];
        }
    }
}

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

@end
