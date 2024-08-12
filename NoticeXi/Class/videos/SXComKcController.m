//
//  SXComKcController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXComKcController.h"
#import "CBAutoScrollLabel.h"
#import "KMTagListView.h"
#import "NoticeComLabelModel.h"
@interface SXComKcController ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) UIView *kcView;
@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic, strong) NSMutableArray *imgViewArr;
@property (nonatomic, strong) NSArray *imgNomArr;
@property (nonatomic, strong) NSArray *imgSelArr;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) KMTagListView *labeView;
@property (nonatomic, strong) NSMutableArray *tagsArr;
@property (nonatomic, strong) UIView *inputBackView;
@property (nonatomic, strong) UITextView *nameField;
@end

@implementation SXComKcController

{
    UILabel *_plaL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.headerView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-10)];
    [self.headerView addSubview:self.kcView];
    [self.headerView addSubview:self.scoreView];
    
    NSArray *arr = @[@"直戳心坎",@"超强情绪价值",@"解决方法实际",@"思路清晰细致",@"物超所值",@"醍醐灌顶"];
    self.tagsArr = [[NSMutableArray alloc] init];
    for (NSString *title in arr) {
        NoticeComLabelModel *tagM = [[NoticeComLabelModel alloc] init];
        tagM.title = title;
        [self.tagsArr addObject:tagM];
    }
  
    KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.scoreView.frame), DR_SCREEN_WIDTH-20, 0)];
    tagV.moreClick = YES;
    tagV.ySpace = 10;
    [tagV setupCustomeMoreSubViewsWithTitles:self.tagsArr];
    self.labeView = tagV;
    [self.headerView addSubview:tagV];
    
    CGRect rect = tagV.frame;
    rect.size.height = tagV.contentSize.height;
    tagV.frame = rect;
     
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.labeView.frame)+30, DR_SCREEN_WIDTH-30, 150)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.headerView addSubview:backView];
    self.inputBackView = backView;
    
    self.nameField = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, DR_SCREEN_WIDTH-40, 30)];
    self.nameField.backgroundColor = backView.backgroundColor;
    self.nameField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
    self.nameField.delegate = self;
    self.nameField.font = FOURTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
    [backView addSubview:self.nameField];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 14)];
    _plaL.text = @"内容符合你的预期吗？有什么想分享的吗？";
    _plaL.font = FOURTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [backView addSubview:_plaL];
    
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *inputT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputBecom)];
    [backView addGestureRecognizer:inputT];
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.upButton = [[UIButton  alloc] initWithFrame:CGRectMake(68, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-10, DR_SCREEN_WIDTH-68*2, 50)];
    self.upButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [self.upButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    self.upButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.upButton setTitle:@"提交评价" forState:UIControlStateNormal];
    [self.view addSubview:self.upButton];
    [self.upButton setAllCorner:25];
    [self.upButton addTarget:self action:@selector(upClick) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
}

- (void)inputBecom{
    [self.nameField becomeFirstResponder];
}

- (UIView *)kcView{
    if (!_kcView) {
        _kcView = [[UIView  alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 84)];
        _kcView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFC"];
        [_kcView setAllCorner:10];
        
        UIImageView *coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 48, 64)];
        [coverImageView setAllCorner:2];
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        coverImageView.clipsToBounds = YES;
        [_kcView addSubview:coverImageView];
        
        CBAutoScrollLabel *_titleL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(66,20,DR_SCREEN_WIDTH-30-70, 21)];
        _titleL.font = FIFTHTEENTEXTFONTSIZE;
        _titleL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [_kcView addSubview:_titleL];
        
        UILabel *_markL = [[UILabel alloc] initWithFrame:CGRectMake(66,48,DR_SCREEN_WIDTH-30-70, 16)];
        _markL.font = ELEVENTEXTFONTSIZE;
        _markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [_kcView addSubview:_markL];
        
        _markL.text = [NSString stringWithFormat:@"共%@课时",self.paySearModel.episodes];
        _titleL.text = self.paySearModel.series_name;
   
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:self.paySearModel.simple_cover_url]];
    }
    return _kcView;
}

- (UIView *)scoreView{
    if (!_scoreView) {
        _scoreView = [[UIView  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.kcView.frame), DR_SCREEN_WIDTH, 196)];
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 92)];
        label.font = XGTwentyBoldFontSize;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.text = @"课程看了有什么感受？";
        [_scoreView addSubview:label];

        self.labelArr = [NSMutableArray new];
        self.imgViewArr = [NSMutableArray new];
                
        NSArray *titleArr = @[@"挺难评",@"不太行",@"一般吧",@"挺不错",@"超满意"];
        NSArray *imgArr = @[@"sxkcscore0_img",@"sxkcscore1_img",@"sxkcscore2_img",@"sxkcscore3_img",@"sxkcscore4_img"];
        self.imgNomArr = imgArr;
        self.imgSelArr = @[@"sxkcscore0_img1",@"sxkcscore1_img1",@"sxkcscore2_img1",@"sxkcscore3_img1",@"sxkcscore4_img1"];
        CGFloat space = (DR_SCREEN_WIDTH-48*5)/6;
        for (int i = 0; i < 5; i++) {
            
            UIView *tapV = [[UIView  alloc] initWithFrame:CGRectMake(space+(48+space)*i, 92, 48, 48+4+20)];
            [_scoreView addSubview:tapV];
            
            tapV.tag = i;
            tapV.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scoreTap:)];
            [tapV addGestureRecognizer:tap1];
            
            UIImageView *imageV = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
            imageV.image = UIImageNamed(imgArr[i]);
            [tapV addSubview:imageV];
            imageV.userInteractionEnabled = YES;
       
            [self.imgViewArr addObject:imageV];
            
            UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+4, 48, 20)];
            markL.text = titleArr[i];
            markL.font = THRETEENTEXTFONTSIZE;
            markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
            markL.textAlignment = NSTextAlignmentCenter;
            [tapV addSubview:markL];
            markL.userInteractionEnabled = YES;
            [self.labelArr addObject:markL];
        }
    }
    return _scoreView;
}

- (void)scoreTap:(UITapGestureRecognizer *)tap{
    UIView *tapView = (UIView *)tap.view;
    for (UILabel * label in self.labelArr) {
        label.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    }
    
    int i = 0 ;
    for (UIImageView *imgV in self.imgViewArr) {
        
        imgV.image = UIImageNamed(self.imgNomArr[i]);
        i++;
    }
    
    UILabel *selL = self.labelArr[tapView.tag];
    selL.textColor = [UIColor colorWithHexString:@"#14151A"];
    
    UIImageView *selImageV = self.imgViewArr[tapView.tag];
    selImageV.image = UIImageNamed(self.imgSelArr[tapView.tag]);
    
}

- (void)upClick{
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    CGRect frame = textView.frame;
    float height;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            height = [self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    if (height > 150) {
        height = 150;
    }
    
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        textView.frame = frame;
    } completion:nil];
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length) {
        _plaL.text = @"";
    }else{
        _plaL.text = @"内容符合你的预期吗？有什么想分享的吗？";
    }

}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}


-(void)keyboardWillChangeFrame:(NSNotification *)notification{
 

    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if(CGRectGetMaxY(self.inputBackView.frame)+30+NAVIGATION_BAR_HEIGHT > DR_SCREEN_HEIGHT-keyboardF.size.height){
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT-(CGRectGetMaxY(self.inputBackView.frame)+30 + NAVIGATION_BAR_HEIGHT - (DR_SCREEN_HEIGHT-keyboardF.size.height)), DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-10);
    }
}

- (void)keyboardDiddisss{
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-10);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    if(scrollView == self.tableView){
        [self.nameField resignFirstResponder];
    }
}


@end
