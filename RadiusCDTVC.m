//
//  RadiusCDTVC.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/10/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "RadiusCDTVC.h"
#import "Context.h"

@interface RadiusCDTVC ()

@end

@implementation RadiusCDTVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.context)
    {
        [Context createContext:^(NSManagedObjectContext *context){
            self.context = context;
        } refresh:^{
            nil;
        }];
    }
}

- (void) setRadius:(Radius *)radius
{
    _radius = radius;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Radius"];
    
    Radius *radius = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
    
    cell.textLabel.text = radius.radius_description;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(radius.radius_id == self.radius.radius_id)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.radius = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    return cell;
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    
    if(context)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Radius"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"radius_description" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    } else
    {
        self.fetchedResultsController = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSIndexPath *currentIndexPath = [self.fetchedResultsController indexPathForObject:self.radius];
    
    if (currentIndexPath == indexPath) {
        return;
    }
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.radius = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:currentIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
