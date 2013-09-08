//
//  ABContactClone.m
//  MIABcontact
//
//  Created by Hai Nguyen on 9/8/13.
//  Copyright (c) 2013 Mobile Injector. All rights reserved.
//

#import "ABContactClone.h"
#import <AddressBook/AddressBook.h>
#import "ABContact.h"

@interface ABContactClone (){
    ABAddressBookRef addressbook;
    NSMutableArray *_contacts;
    BOOL _loaded;
}

@end

@implementation ABContactClone

+ (ABContactClone*)shared{
    static ABContactClone *_Share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_Share) {
            _Share = [[ABContactClone alloc] init];
        }
    });
    
    return _Share;
}

#pragma mark - initial

- (id)init{
    if (self = [super init]) {
        _contacts = [NSMutableArray new];
        _loaded = NO;
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)allContacts:(void(^)(NSArray *result, NSError *error))complete{
    if (_loaded) {
        complete(_contacts, NULL);
    }
    else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0) {
            switch (ABAddressBookGetAuthorizationStatus()) {
                case kABAuthorizationStatusAuthorized:{
                    CFErrorRef *error = NULL;
                    addressbook = ABAddressBookCreateWithOptions(NULL, error);
                    NSArray *allPeople = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressbook);
                    for (NSInteger i = 0; i < [allPeople count]; i++) {
                        ABRecordRef record = (__bridge ABRecordRef)[allPeople objectAtIndex:i];
                        NSString *firstname = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                        NSString *middlename = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonMiddleNameProperty);
                        NSString *lastname = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
                        
                        NSMutableArray *phones = nil;
                        ABMultiValueRef abphones = ABRecordCopyValue(record, kABPersonPhoneProperty);
                        if (abphones) {
                            phones = [NSMutableArray new];
                            for (NSInteger i = 0 ; i < ABMultiValueGetCount(abphones); i++) {
                                NSString *phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(abphones, i);
                                [phones addObject:phone];
                            }
                        }
                        
                        NSMutableArray *emails = nil;
                        ABMultiValueRef abEmails = ABRecordCopyValue(record, kABPersonEmailProperty);
                        if (abEmails) {
                            emails = [NSMutableArray new];
                            for (NSInteger i = 0; i < ABMultiValueGetCount(abEmails); i++) {
                                NSString *email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(abEmails, i);
                                [emails addObject:email];
                            }
                        }
                        int refId = (int)ABRecordGetRecordID(record);
                        ABContact *contact = [[ABContact alloc] initWithId:refId firstname:firstname middlename:middlename lastname:lastname phones:phones emails:emails];
                        [_contacts addObject:contact];
                    }
                    complete(_contacts, NULL);
                }
                    break;
                case kABAuthorizationStatusNotDetermined:{
                    ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error) {
                        if (granted) {
                            NSLog(@"Address book granted");
                        }
                        else{
                            NSLog(@"Not grant address book");
                        }
                        if (addressbook) {
                            CFRelease(addressbook);
                        }
                    });
                    complete(nil, [NSError errorWithDomain:@"Addressbook access is Determined" code:404 userInfo:nil]);
                }
                    break;
                case kABAuthorizationStatusDenied:{
                    complete(nil, [NSError errorWithDomain:@"Addressbook access is denied" code:404 userInfo:nil]);complete(_contacts, NULL);
                }
                    break;
                case kABAuthorizationStatusRestricted:{
                    complete(nil, [NSError errorWithDomain:@"Addressbook access is restrict" code:404 userInfo:nil]);
                }
                    break;
            }
        }
        else{
            addressbook = ABAddressBookCreate();
            NSArray *allPeople = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressbook);
            for (NSInteger i = 0; i < [allPeople count]; i++) {
                ABRecordRef record = (__bridge ABRecordRef)[allPeople objectAtIndex:i];
                NSString *firstname = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                NSString *middlename = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                NSString *lastname = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                
                NSMutableArray *phones = nil;
                ABMultiValueRef abphones = ABRecordCopyValue(record, kABPersonPhoneProperty);
                if (abphones) {
                    phones = [NSMutableArray new];
                    for (NSInteger i = 0 ; i < ABMultiValueGetCount(abphones); i++) {
                        NSString *phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(abphones, i);
                        [phones addObject:phone];
                    }
                }
                
                NSMutableArray *emails = nil;
                ABMultiValueRef abEmails = ABRecordCopyValue(record, kABPersonEmailProperty);
                if (abEmails) {
                    emails = [NSMutableArray new];
                    for (NSInteger i = 0; i < ABMultiValueGetCount(abEmails); i++) {
                        NSString *email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(abEmails, i);
                        [emails addObject:email];
                    }
                }
                int refId = (int)ABRecordGetRecordID(record);
                ABContact *contact = [[ABContact alloc] initWithId:refId firstname:firstname middlename:middlename lastname:lastname phones:phones emails:emails];
                [_contacts addObject:contact];
            }
            complete(_contacts, NULL);
        }
    }
}

/**
 *	Search contact with phone number
 *
 *	@param	phoneNo
 *
 *	@return
 */
- (NSArray*)contactsWithPhoneNo:(NSString*)phoneNo{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phonesString contains[cd] %@", phoneNo];
    NSArray *result = [_contacts filteredArrayUsingPredicate:predicate];
    if ([result count]) {
        return result;
    }
    
    return nil;
}

@end
