//
//  MKFacebookSession.h
//  MKAbeFook
//
//  Created by Mike Kinney on 9/19/09.
//  Copyright 2009 Mike Kinney. All rights reserved.
//
/*
 Copyright (c) 2009, Mike Kinney
 All rights reserved.
 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
 Neither the name of MKAbeFook nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import <Cocoa/Cocoa.h>
#import "SynthesizeSingleton.h"

extern NSString *MKFacebookAccessTokenKey;

//Handles saving session information to disk and loading existing sessions.
@interface MKFacebookSession : NSObject {
	
    NSString *appID;
    NSString *accessToken;
	BOOL _validSession;
    NSString *_uid;

}

@property (nonatomic, retain) NSString *appID;
@property (nonatomic, retain) NSString *accessToken;
@property (readonly, getter = uid) NSString *_uid;

+ (MKFacebookSession *)sharedMKFacebookSession;


// Accepts an access_token from oAuth login and saves it to the application defaults
- (void)saveAccessToken:(NSString *)aToken;

/*
Logs in a user from a saved session.
 
Attempts to load a stored infinte session for the application.  This method checks NSUserDefaults for a stored access token.  It uses a synchronous request to try to authenticate the stored token.  Used internally when login or loginWithPermissions:forSheet: are called.
 
Returns true if stored session information is valid and a user id is successfully returned from Facebook otherwise it returns false.
*/
- (BOOL)loadAccessToken;



// Destroys any saved token.
- (void)destroyAccessToken;


// Checks to see if session looks valid. Uses loadAccessToken to validate the stored access token.
- (BOOL)validAccessToken;


//Uses a synchronous request to fetch the uid associated with the access token.
- (NSString *)uid;

@end
