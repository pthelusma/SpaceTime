//
//  DueDateVC.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/3/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "DueDateVC.h"
#import "FormatHelper.h"

@interface DueDateVC ()

@property (weak, nonatomic) IBOutlet UIDatePicker *dpDueDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDueDate;

@end

@implementation DueDateVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.dpDueDate setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.dpDueDate addTarget:self action:@selector(updateDueDate:) forControlEvents:UIControlEventValueChanged];
    [self.lblDueDate setFont:[UIFont systemFontOfSize:12.0]];
    [self.lblDueDate setTextAlignment:NSTextAlignmentCenter];
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setDueDate:(NSDate *)dueDate
{
    _dueDate = dueDate;
    [self updateUI];
}

- (void) updateUI
{
    if(self.dueDate)
    {
        [self.lblDueDate setText:[FormatHelper formatDate:self.dueDate]];
        [self.dpDueDate setDate:self.dueDate];
    } else
    {
        [self.lblDueDate setText:[FormatHelper formatDate: self.dpDueDate.date]];
    }
}

- (void) updateDueDate:(id) sender
{
    self.dueDate = self.dpDueDate.date;
    [self updateUI];
}

@end
