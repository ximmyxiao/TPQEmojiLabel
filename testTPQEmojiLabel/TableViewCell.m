//
//  TableViewCell.m
//  testTPQEmojiLabel
//
//  Created by Piao Piao on 15/3/10.
//  Copyright (c) 2015年 Piao Piao. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.emojiLabel = [[TPQEmojiLabelV2 alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.emojiLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.emojiLabel];
    }
    return self;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.emojiLabel = [[TPQEmojiLabelV2 alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.emojiLabel];
    }
    return self;
}

- (void)updateConstraints
{
    NSDictionary* vs = NSDictionaryOfVariableBindings(_emojiLabel);
    
    NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=20)-[_emojiLabel]|" options:0 metrics:nil views:vs];
    [self.contentView addConstraints:constraints];
    
    NSArray* Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_emojiLabel]|" options:0 metrics:nil views:vs];
    [self.contentView addConstraints:Vconstraints];
    
    [super updateConstraints];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
