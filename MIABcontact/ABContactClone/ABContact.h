//
//  ABContact.h
//  MIABcontact
//
//  Created by Hai Nguyen on 9/8/13.
//  Copyright (c) 2013 Mobile Injector. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABContact : NSObject

@property (readonly, nonatomic) int abRecordId;
@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *middlename;
@property (strong, nonatomic) NSString *lastname;

- (id)initWithId:(int)recordId firstname:(NSString*)firstname middlename:(NSString*)middlename lastname:(NSString*)lastname phones:(NSArray*)phones emails:(NSArray*)emails;

- (NSArray*)phones;
- (NSArray*)emails;
- (NSString*)phonesString;

@end
