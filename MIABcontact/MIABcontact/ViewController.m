//
//  ViewController.m
//  MIABcontact
//
//  Created by Hai Nguyen on 9/8/13.
//  Copyright (c) 2013 Mobile Injector. All rights reserved.
//

#import "ViewController.h"
#import "ABContactClone.h"
#import "ABContact.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *_tableView;
    NSMutableArray *_contacts;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"ABContactClone";
    [[ABContactClone shared] allContacts:^(NSArray *result, NSError *error) {
        if (!error) {
            _contacts = [NSMutableArray arrayWithArray:result];
        }
        [_tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_contacts count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"CellID";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    ABContact *contact = [_contacts objectAtIndex:indexPath.row];
cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstname?contact.firstname:@"", contact.lastname?contact.lastname:@""];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", contact.phonesString?contact.phonesString:@""];

return cell;
}

@end
