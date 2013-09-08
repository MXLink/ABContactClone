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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[ABContactClone shared] allContacts:^(NSArray *result, NSError *error) {        
        for (ABContact *contact in result) {
            NSLog(@"name : %@ phone: %@", contact.firstname, contact.phonesString);
        }
        NSLog(@"Search : %@", [[ABContactClone shared] contactsWithPhoneNo:@"(707) 555-1854"]);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
