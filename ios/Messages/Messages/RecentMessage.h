//
//  RecentMessage.h
//  Messages
//
//  Created by Giovanni Amati on 17/07/14.
//  Copyright (c) 2014 Messagenet.it. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MessageStatusCode_incoming			 = 0 ,
    MessageStatusCode_sent				 = 1 ,
    MessageStatusCode_delivered			 = 2 ,
    MessageStatusCode_delivery_error     = 3 ,
} MessageStatusCode;

@interface RecentMessage : NSObject

@property (nonatomic) NSInteger             message_id;
@property (nonatomic) NSInteger             conversation_id;
@property (nonatomic) NSString              *message_uuid;
@property (nonatomic) NSDate                *message_timestamp;
@property (nonatomic) MessageStatusCode     message_status;
@property (nonatomic) NSString              *message_body;
//@property (nonatomic) MessageTransportCode  message_transport;
@property (nonatomic) NSString              *message_sender;
@property (nonatomic) NSDate                *message_status_timestamp;
//@property (nonatomic) RecentConversation    *parentConversation;

@end
