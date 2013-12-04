//
//  DetailsTVC.h
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/2/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task+Cloud.h"

@interface DetailsTVC : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) Task *task;
@property (nonatomic, strong) NSManagedObjectContext *context;

- (NSString *) getTitle;
- (NSDate *) getDueDate;

@end
