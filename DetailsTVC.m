//
//  DetailsTVC.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/2/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "DetailsTVC.h"
#import "DueDateVC.h"
#import "FormatHelper.h"

@interface DetailsTVC ()

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITableViewCell *createDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *updateDateCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *dueDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *radiusCell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

@end

@implementation DetailsTVC

- (NSString *) getTitle
{
    return self.txtTitle.text;
}

- (NSDate *) getDueDate
{
    return [FormatHelper formatString: self.dueDateCell.detailTextLabel.text];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtTitle.delegate = self;
    [self updateUI];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtTitle resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField)
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTask:(Task *) task
{
    _task = task;
    [self updateUI];
}

- (void) updateUI
{
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.createDateCell.textLabel.font = [UIFont systemFontOfSize:12.0];
    self.createDateCell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
    
    self.updateDateCell.textLabel.font = [UIFont systemFontOfSize:12.0];
    self.updateDateCell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
    
    self.dueDateCell.textLabel.font = [UIFont systemFontOfSize:12.0];
    self.dueDateCell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
    
    self.locationCell.textLabel.font = [UIFont systemFontOfSize:12.0];
    self.locationCell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
    
    self.radiusCell.textLabel.font = [UIFont systemFontOfSize:12.0];
    self.radiusCell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
    
    if(self.task)
    {
        
        self.deleteButton.enabled = YES;
        
        self.txtTitle.text = self.task.title;
        
        self.createDateCell.textLabel.text = @"Create Date:";
        self.createDateCell.detailTextLabel.text = [FormatHelper formatDate:self.task.create_date];
        
        self.updateDateCell.textLabel.text = @"Update Date:";
        self.updateDateCell.detailTextLabel.text = [FormatHelper formatDate:self.task.update_date];
        
        self.dueDateCell.textLabel.text = @"Due Date:";
        self.dueDateCell.detailTextLabel.text = [FormatHelper formatDate:self.task.due_date];
        
        self.locationCell.textLabel.text = @"Location:";
        self.locationCell.detailTextLabel.text = [FormatHelper formatDate:self.task.due_date];
        
        self.radiusCell.textLabel.text = @"Radius:";
        self.radiusCell.detailTextLabel.text = [FormatHelper formatDate:self.task.due_date];
    }
    else
    {
        self.deleteButton.enabled = NO;
        
        self.createDateCell.textLabel.text = @"Create Date:";
        self.createDateCell.detailTextLabel.text = [FormatHelper formatDate:[[NSDate alloc]init]];
        
        self.updateDateCell.textLabel.text = @"Update Date:";
        self.updateDateCell.detailTextLabel.text = [FormatHelper formatDate:[[NSDate alloc]init]];
        
        self.dueDateCell.textLabel.text = @"Due Date:";
        self.dueDateCell.detailTextLabel.text = [FormatHelper formatDate:self.task.due_date];
        
        self.locationCell.textLabel.text = @"Location:";
        self.locationCell.detailTextLabel.text = [FormatHelper formatDate:self.task.due_date];
        
        self.radiusCell.textLabel.text = @"Radius:";
        self.radiusCell.detailTextLabel.text = [FormatHelper formatDate:self.task.due_date];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        if(indexPath)
        {
            if([segue.identifier isEqualToString:@"Due Date"])
            {
                if([segue.destinationViewController respondsToSelector:@selector(setDueDate:)])
                {
                    NSDate *dueDate = [FormatHelper formatString:self.dueDateCell.detailTextLabel.text];
                    
                    [segue.destinationViewController performSelector:@selector(setDueDate:) withObject:dueDate];
                }
            }
            
            if([segue.identifier isEqualToString:@"Location"])
            {
                if([segue.destinationViewController respondsToSelector:@selector(setLocation:)])
                {
                    
                }
            }
            
            if([segue.identifier isEqualToString:@"Radius"])
            {
                if([segue.destinationViewController respondsToSelector:@selector(setRadius:)])
                {
                    
                }
            }
        }
    }
}

- (IBAction)returnFromDueDatePicker:(UIStoryboardSegue *) segue
{
 
    DueDateVC *vc = [segue sourceViewController];
    self.dueDateCell.detailTextLabel.text = [FormatHelper formatDate:vc.dueDate];
    
}

- (IBAction)cancelFromDueDatePicker:(UIStoryboardSegue *) segue
{
    //Do nothing
}



@end
