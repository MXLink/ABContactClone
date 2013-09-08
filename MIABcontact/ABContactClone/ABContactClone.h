//
//  ABContactClone.h
//  MIABcontact
//
//  Created by Hai Nguyen on 9/8/13.
//  Copyright (c) 2013 Mobile Injector. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABContactClone : NSObject

+ (ABContactClone*)shared;

/**
 *	All Address book record converted to ABContact model array
 *
 */
- (void)allContacts:(void(^)(NSArray *result, NSError *error))complete;

/**
 *	Search contact with phone number
 *
 *	@param	phoneNo
 *
 *	@return	
 */
- (NSArray*)contactsWithPhoneNo:(NSString*)phoneNo;

@end
