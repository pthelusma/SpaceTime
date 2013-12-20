//
//  DetailsTVC.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/2/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "DetailsTVC.h"
#import "LocationCDTVC.h"
#import "RadiusCDTVC.h"
#import "DueDateVC.h"
#import "FormatHelper.h"
#import "Location.h"
#import "Radius.h"
#import "TaskLocation.h"
#import "TaskLocation+Cloud.h"
#import "Location+Cloud.h"
#import "Radius+Cloud.h"
#import "Context.h"
#import "NetworkActivity.h"
#import "CloudTask.h"
#import "LocationManager.h"


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
    
    if(!self.context)
    {
        [Context createContext:^(NSManagedObjectContext *context){
            self.context = context;
        } refresh:^{
            [self updateUI];
        }];
    } else
    {
        [self updateUI];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
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
        
        TaskLocation *taskLocation = [TaskLocation retrieveTaskLocation:[self.task.task_id doubleValue] context:self.context];
        
        if(self.location || self.radius)
        {
        } else if(taskLocation)
        {
            self.location = [Location retrieveLocation:[taskLocation.location_id integerValue] context:self.context];
            self.radius = [Radius retrieveRadius:[taskLocation.radius_id integerValue] context:self.context];
        }
        
        self.locationCell.detailTextLabel.text = [self.location title];
        self.radiusCell.detailTextLabel.text = [self.radius radius_description];
        
        self.locationCell.textLabel.text = @"Location:";
        self.radiusCell.textLabel.text = @"Radius:";

    }
    else
    {
        self.deleteButton.enabled = NO;
        
        self.txtTitle.placeholder = [self getPlaceHolderTitle];
        
        self.createDateCell.textLabel.text = @"Create Date:";
        self.createDateCell.detailTextLabel.text = [FormatHelper formatDate:[[NSDate alloc]init]];
        
        self.updateDateCell.textLabel.text = @"Update Date:";
        self.updateDateCell.detailTextLabel.text = [FormatHelper formatDate:[[NSDate alloc]init]];
        
        self.dueDateCell.textLabel.text = @"Due Date:";
        self.dueDateCell.detailTextLabel.text = [FormatHelper formatDate:self.dueDate];
        
        self.locationCell.textLabel.text = @"Location:";
        self.locationCell.detailTextLabel.text = self.location.title;
        
        self.radiusCell.textLabel.text = @"Radius:";
        self.radiusCell.detailTextLabel.text = self.radius.radius_description;
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
                    [segue.destinationViewController performSelector:@selector(setLocation:) withObject:self.location];
                }
            }
            
            if([segue.identifier isEqualToString:@"Radius"])
            {
                if([segue.destinationViewController respondsToSelector:@selector(setRadius:)])
                {
                    [segue.destinationViewController performSelector:@selector(setRadius:) withObject:self.radius];
                }
            }
        }
    }
}

- (IBAction)doneDueDate:(UIStoryboardSegue *) segue
{
    DueDateVC *vc = [segue sourceViewController];
    
    if(vc.dueDate)
    {
        self.dueDate = vc.dueDate;
    }
    
    self.dueDateCell.detailTextLabel.text = [FormatHelper formatDate:self.dueDate];
}

- (IBAction)cancelDueDate:(UIStoryboardSegue *) segue
{
    //Do nothing intentionally
}

- (IBAction)doneLocation:(UIStoryboardSegue *) segue
{
    LocationCDTVC *vc = [segue sourceViewController];
    
    if(vc.location)
    {
        self.location = vc.location;
    }
    
    [self updateUI];
}

- (IBAction)cancelLocation:(UIStoryboardSegue *) segue
{
    //Do nothing intentionally
}

- (IBAction)doneRadius:(UIStoryboardSegue *) segue
{
    RadiusCDTVC *vc = [segue sourceViewController];
    
    if(vc.radius)
    {
        self.radius = vc.radius;
    }
    
    [self updateUI];
}

- (IBAction)cancelRadius:(UIStoryboardSegue *) segue
{
    //Do nothing intentionally
}

- (NSString *) getTitle
{
    return self.txtTitle.text;
}

- (NSString *) getDueDate
{
    return self.dueDateCell.detailTextLabel.text;
}

- (NSString *) getPlaceHolderTitle
{
    NSString *cityState = nil;
    //CLLocation *currentLocation = [[LocationManager sharedLocationManager] currentLocation];
    
    [NetworkActivity startIndicator];
    cityState = [[LocationManager sharedLocationManager] cityState];
    [NetworkActivity stopIndicator];
    
    return [NSString stringWithFormat:@"New Task @ %@ ", cityState];
}

@end
