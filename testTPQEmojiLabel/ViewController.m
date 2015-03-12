//
//  ViewController.m
//  testTPQEmojiLabel
//
//  Created by Piao Piao on 14/12/8.
//  Copyright (c) 2014年 Piao Piao. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "WebViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,TPQEmojiLabelV2Delegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* contents;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.emojiLabel.backgroundColor = [UIColor redColor];
    self.emojiLabel.emojiText = @"aaaafjdjajfkdajfkajfjshfajdshafjahsfjashfjashdfjdsh[撇嘴][撇嘴][撇嘴]fashfdjshajsahfkasfhjasdhashfashashjsahjs";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.contents = @[@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890www.sina.com",
                      @"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]",
@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]",@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]",@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]",@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]",@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]",@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]",@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]",@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]",@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]",@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 www.sina.com[撇嘴][撇嘴][撇嘴]"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches begin");
    
    
    UITouch* touch = [touches anyObject];
    CGPoint point =  [touch locationInView:self.emojiLabel];
    point = CGPointMake(point.x - self.emojiLabel.textContainerInset.left, point.y - self.emojiLabel.textContainerInset.top);
    NSLog(@"point :%@",NSStringFromCGPoint(point));
    NSLog(@"length:%d",[self.emojiLabel.attributedText length]);
    NSInteger index = [self.emojiLabel.layoutManager characterIndexForPoint:point inTextContainer:self.emojiLabel.textContainer  fractionOfDistanceBetweenInsertionPoints:NULL];
    NSLog(@"index :%d",index);
    
    NSLog(@"url:%@",[self.emojiLabel linksForCharacterIndex:index]);

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"string:%@",self.emojiLabel.attributedText.string);
//        NSLog(@"string len:%d",[self.emojiLabel.attributedText length]);
//
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, cell.frame.size.height);
    cell.emojiLabel.textContent = [self.contents objectAtIndex:indexPath.row];
    [cell layoutIfNeeded];
    CGSize size =  [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"row ：%d size:%@",indexPath.row,NSStringFromCGSize(size) );
    return size.height ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.emojiLabel.textContent = [self.contents objectAtIndex:indexPath.row];
    cell.emojiLabel.urlClickDelegate = self;
    return cell;
}

- (void)didSelectUrl:(NSString *)url
{
    url =[NSString stringWithFormat:@"http://%@",url];
    WebViewController* ctrl = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    ctrl.url = url;
    [self.navigationController pushViewController:ctrl animated:YES];
}



@end
