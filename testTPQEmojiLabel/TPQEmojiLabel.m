//
//  TPQEmojiLabel.m
//  testTPQEmojiLabel
//
//  Created by Piao Piao on 14/12/8.
//  Copyright (c) 2014年 Piao Piao. All rights reserved.
//

#import "TPQEmojiLabel.h"
const NSInteger  kEmotionCount = 105;
const NSInteger  KEmojiCount = 60;
static NSString* const QZONE_REGEXSTR =@"(\\[[\u4e00-\u9fa5A-Za-z]{1,3}\\])";

@interface MMTextAttachment : NSTextAttachment

{
    
    
    
}



@end



@implementation MMTextAttachment



//I want my emoticon has the same size with line's height

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)

{
    return CGRectMake( 0 , -5 , lineFrag.size.height , lineFrag.size.height );
}





@end
@interface EmojiManager : NSObject
@property(nonatomic,strong) NSArray* kEmotionStringArray;
+ (instancetype)shareInstance;
@end


@implementation EmojiManager
+ (instancetype)shareInstance
{
    static EmojiManager *g_EmojiManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_EmojiManager = [[self alloc] init];
    });
    return g_EmojiManager;
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.kEmotionStringArray  = @[
                                      @"[微笑]",@"[撇嘴]",@"[色]",@"[发呆]",@"[得意]",@"[流泪]",@"[害羞]",
                                      @"[闭嘴]",@"[睡]",@"[大哭]",@"[尴尬]",@"[发怒]",@"[调皮]",@"[呲牙]",
                                      @"[惊讶]",@"[难过]",@"[酷]",@"[冷汗]",@"[抓狂]",@"[吐]",@"[偷笑]",
                                      @"[愉快]",@"[白眼]",@"[傲慢]",@"[饥饿]",@"[困]",@"[惊恐]",@"[流汗]",
                                      
                                      @"[憨笑]",@"[悠闲]",@"[奋斗]",@"[咒骂]",@"[疑问]",@"[嘘]",@"[晕]",
                                      @"[疯了]",@"[衰]",@"[骷髅]",@"[敲打]",@"[再见]",@"[擦汗]",@"[抠鼻]",
                                      @"[鼓掌]",@"[糗大了]",@"[坏笑]",@"[左哼哼]",@"[右哼哼]",@"[哈欠]",@"[鄙视]",
                                      @"[委屈]",@"[快哭了]",@"[阴险]",@"[亲亲]",@"[吓]",@"[可怜]",@"[菜刀]",
                                      
                                      @"[西瓜]",@"[啤酒]",@"[篮球]",@"[乒乓]",@"[咖啡]",@"[饭]",@"[猪头]",
                                      @"[玫瑰]",@"[凋谢]",@"[嘴唇]",@"[爱心]",@"[心碎]",@"[蛋糕]",@"[闪电]",
                                      @"[炸弹]",@"[刀]",@"[足球]",@"[瓢虫]",@"[便便]",@"[月亮]",@"[太阳]",
                                      @"[礼物]",@"[拥抱]",@"[强]",@"[弱]",@"[握手]",@"[胜利]",@"[抱拳]",
                                      
                                      @"[勾引]",@"[拳头]",@"[差劲]",@"[爱你]",@"[NO]",@"[OK]",@"[爱情]",@"[飞吻]",
                                      @"[跳跳]",@"[发抖]",@"[怄火]",@"[转圈]",@"[磕头]",@"[回头]",@"[跳绳]",
                                      @"[投降]",@"[激动]",@"[乱舞]",@"[献吻]",@"[左太极]",@"[右太极]"
                                      ];
    }
    
    return self;
}


/*localIndex转换成string*/
- (NSString*)emotionStringFromLocalIndex:(NSInteger)localIndex
{
    NSInteger index = [self.kEmotionStringArray indexOfObject:@(localIndex)];
    if (index != NSNotFound) {
        return self.kEmotionStringArray[index];
    }
    
    return nil;
}

/*string转换成localIndex*/
- (NSInteger)emotionLocalIndexFromEmotionString:(NSString*)emotionString
{
    NSInteger index = [self.kEmotionStringArray indexOfObject:emotionString];
    if (index != NSNotFound) {
        return index;
    }
    
    return -1;
}
@end





@implementation TPQEmojiLabel
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setEmojiText:(NSString *)emojiText
{
    NSMutableAttributedString* string =[[NSMutableAttributedString alloc] initWithString:@"" attributes:nil];

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:QZONE_REGEXSTR options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array = nil;
    array = [regex matchesInString:emojiText options:0 range:NSMakeRange(0, [emojiText length])];
//    NSRange lastEmojiRange = NSMakeRange(0, [emojiText length]);
//    NSMutableString* string
    NSInteger lastFindEmojiIndex = 0;
    for (NSTextCheckingResult* result in array)
    {
        NSString* name = [emojiText substringWithRange:result.range];
        
        if (result.range.location != lastFindEmojiIndex)
        {
            NSString* normalString = [emojiText substringWithRange:NSMakeRange(lastFindEmojiIndex, result.range.location - lastFindEmojiIndex)];
            
            [string insertAttributedString:[[NSAttributedString alloc] initWithString:normalString attributes:nil] atIndex:[string length]];
                                      
        }
        NSInteger index = [[EmojiManager shareInstance] emotionLocalIndexFromEmotionString:name];
        if (index != -1)
        {
            NSString* imageName = [NSString stringWithFormat:@"Expression_%ld",(long)index + 1];
            UIImage* image = [UIImage imageNamed:imageName];
            
            MMTextAttachment* attach = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
            attach.image = image;
            
            NSAttributedString* textAttributeString = [ NSAttributedString attributedStringWithAttachment:attach];
            [string insertAttributedString:textAttributeString atIndex:[string length]];

            
        }
        else
        {
            [string insertAttributedString:[[NSAttributedString alloc] initWithString:name attributes:nil] atIndex:[string length]];
        }
        
        lastFindEmojiIndex = result.range.location + result.range.length;
    }
    
    if (lastFindEmojiIndex < [emojiText length])
    {
        NSString* normalString = [emojiText substringWithRange:NSMakeRange(lastFindEmojiIndex, [emojiText length] - lastFindEmojiIndex)];
        
        [string insertAttributedString:[[NSAttributedString alloc] initWithString:normalString attributes:nil] atIndex:[string length]];
    }
    
    self.attributedText = string;
}
@end
