//
//  LoginWindow.h
//  MKAbeFook
//
//  Created by Mike on 10/11/06.
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
#import <WebKit/WebKit.h>

extern NSString *MKLoginRedirectURI;

@interface MKLoginWindow : NSWindowController  {
	NSString *path;
	IBOutlet WebView *loginWebView;
	IBOutlet NSButton *closeWindowButton; 
	
	BOOL _loginWindowIsSheet;
	
	IBOutlet NSProgressIndicator *loadingWindowProgressIndicator; //used to display activity while setting up everything needed before facebook login page can even be requested.  auth token etc... added in 0.7.7
	
	IBOutlet NSProgressIndicator *loadingWebViewProgressIndicator;
	
	id _delegate; //the place where userLoginSuccessfull will be called
	
	BOOL runModally;
}

@property BOOL _loginWindowIsSheet;
@property (nonatomic, retain) id _delegate;
@property BOOL runModally;

-(id)init;



-(void)displayLoadingWindowIndicator;
-(void)hideLoadingWindowIndicator;

-(void)loadURL:(NSURL *)loginURL;
-(IBAction)closeWindow:(id)sender;
-(void)windowWillClose:(NSNotification *)aNotification;
-(void)setWindowSize:(NSSize)windowSize;


#pragma mark WebView Delegate Methods
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame;
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame;
@end
