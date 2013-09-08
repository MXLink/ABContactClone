//
//  ABContact.m
//  MIABcontact
//
//  Created by Hai Nguyen on 9/8/13.
//  Copyright (c) 2013 Mobile Injector. All rights reserved.
//

#import "ABContact.h"

@interface ABContact (){
    NSArray *_phones, *_emails;
}

@end

@implementation ABContact

- (id)initWithId:(int)recordId firstname:(NSString*)firstname middlename:(NSString*)middlename lastname:(NSString*)lastname phones:(NSArray*)phones emails:(NSArray*)emails{
    if (self = [super init]) {
        _abRecordId = recordId;
        self.firstname = firstname;
        self.middlename = middlename;
        self.lastname = lastname;
        _phones= phones?[NSArray arrayWithArray:phones]:nil;
        _emails= emails?[NSArray arrayWithArray:emails]:nil;
    }
    
    return self;
}

- (NSArray*)phones{
    return _phones;
}

- (NSArray*)emails{
    return _emails;
}

- (NSString*)phonesString{
    if (_phones) {
        NSMutableString *string = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < [_phones count]; i++) {
            [string setString:[string stringByAppendingFormat:@"%@,",[_phones objectAtIndex:i]]];
        }
        return [string substringToIndex:[string length] - 1];
    }
    else{
        return nil;
    }
    
    return nil;
}

@end
