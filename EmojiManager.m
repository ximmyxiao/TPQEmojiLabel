//
//  EmojiManager.m
//  testTPQEmojiLabel
//
//  Created by Piao Piao on 15/3/10.
//  Copyright (c) 2015年 Piao Piao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EmojiManager.h"

const NSInteger  kEmotionCount = 105;
const NSInteger  KEmojiCount = 60;
 NSString* const QZONE_REGEXSTR =@"(\\[[\u4e00-\u9fa5A-Za-z]{1,3}\\])";





@implementation MMTextAttachment



//I want my emoticon has the same size with line's height

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)

{
    return CGRectMake( 0 , 0 , lineFrag.size.height , lineFrag.size.height );
}





@end

@implementation UrlParseManager
+ (instancetype)shareInstance
{
    static UrlParseManager *g_UrlManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_UrlManager = [[self alloc] init];
    });
    return g_UrlManager;
}

- (NSArray *)parseURL:(NSString*)string
{
    static NSRegularExpression* linkDetector = nil;
    
    if (linkDetector == nil)
    {
        NSString* matchString = @"((?:(http|https|Http|Https|rtsp|Rtsp):\\/\\/(?:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)"
        "\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,64}(?:\\:(?:[a-zA-Z0-9\\$\\-\\_"
        "\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,25})?\\@)?)?"
        "((?:(?:["
        "a-zA-Z0-9" // GOOD_IRI_CHAR
        "]["
        "a-zA-Z0-9" // GOOD_IRI_CHAR
        "\\-]{0,64}\\.)+" // named host
        
        // TOP_LEVEL_DOMAIN_STR_FOR_WEB_URL
        "(?:"
        "(?:aero|arpa|asia|a[cdefgilmnoqrstuwxz])"
        "|(?:biz|b[abdefghijmnorstvwyz])"
        "|(?:cat|com|coop|c[acdfghiklmnoruvxyz])"
        "|(?:sng|mig|local)"
        "|d[ejkmoz]"
        "|(?:edu|e[cegrstu])"
        "|f[ijkmor]"
        "|(?:gov|g[abdefghilmnpqrstuwy])"
        "|h[kmnrtu]"
        "|(?:info|int|i[delmnoqrst])"
        "|(?:jobs|j[emop])"
        "|k[eghimnprwyz]"
        "|l[abcikrstuvy]"
        "|(?:mil|mobi|museum|m[acdeghklmnopqrstuvwxyz])"
        "|(?:name|net|n[acefgilopruz])"
        "|(?:org|om)"
        "|(?:pro|p[aefghklmnrstwy])"
        "|qa"
        "|r[eosuw]"
        "|s[abcdeghijklmnortuvyz]"
        "|(?:tel|travel|t[cdfghjklmnoprtvwz])"
        "|u[agksyz]"
        "|v[aceginu]"
        "|w[fs]"
        "|(?:xn\\-\\-0zwm56d|xn\\-\\-11b5bs3a9aj6g|xn\\-\\-80akhbyknj4f|xn\\-\\-9t4b11yi5a|xn\\-\\-deba0ad|xn\\-\\-g6w251d|xn\\-\\-hgbk6aj7f53bba|xn\\-\\-hlcj6aya9esc7a|xn\\-\\-jxalpdlp|xn\\-\\-kgbechtv|xn\\-\\-zckzah)"
        "|y[etu]"
        "|z[amw]))"
        
        "|(?:(?:25[0-5]|2[0-4]" // or ip address
        "[0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(?:25[0-5]|2[0-4][0-9]"
        "|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1]"
        "[0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}"
        "|[1-9][0-9]|[0-9])))"
        "(?:\\:\\d{1,5})?)" // plus option port number
        "(\\/(?:(?:(["
        "a-zA-Z0-9" // GOOD_IRI_CHAR
        "\\;\\/\\?\\:\\@\\&\\=\\#\\~" // plus option query params
        
        "\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_])|(?:\\%[a-fA-F0-9]{2}))|(?:\\[(?=(?:(["
        "a-zA-Z0-9"
        "\\;\\/\\?\\:\\@\\&\\=\\#\\~"
        
        "\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_])|(?:\\%[a-fA-F0-9]{2})))))*)?"
        "(?![a-zA-Z0-9])"; // and finally, a
        //"(?:\\b|$)"; // and finally, a
        // word boundary or
        // end of
        // input. This is to
        // stop foo.sure from
        // matching as foo.su
        
        linkDetector = [NSRegularExpression regularExpressionWithPattern:matchString options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    // 先匹配URL
    NSArray* matches = [linkDetector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    //    for (NSTextCheckingResult* match in matches) {
    //        if (match.range.location == NSNotFound) {
    //            continue;
    //        }
    //
    //        NSString* url = [string substringWithRange:match.range];
    //        //if ([url isEqualToString:@"yy.pada"] || [url isEqualToString:@"pada"] || [url isEqualToString:@"padaxu"]) {
    //        //        if ([url caseInsensitiveCompare:@"pada"] == NSOrderedSame || [url caseInsensitiveCompare:@"padaxu"] == NSOrderedSame) {
    //        //            url = @"http://www.flickr.com/photos/padaxu/";
    //        //        }
    //        ParseRange* newRange = [ParseRange rangeWithLocation:match.range.location length:match.range.length];
    //        newRange.url = url;
    //        newRange.stringType = kChatStringTypeUrl;
    //        [passArray addObject:newRange];
    //    }
    
    return matches;
}

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
    if (localIndex < [self.kEmotionStringArray count])
    {
        return self.kEmotionStringArray[localIndex];
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
