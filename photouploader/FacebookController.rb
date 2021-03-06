#
#  FacebookController.rb
#  photouploader
#
#  Created by orta on 16/05/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

framework 'MKAbeFook'

require "rexml/document"
include REXML

class FacebookController
  attr_accessor :uploadController, :connected
  
  def awakeFromNib
    self.connect self
  end
        
  def connect(sender)
    @fbConnection = MKFacebook.facebookWithAppID "218224341540328", delegate: self
    @fbConnection.loginWithPermissions ["offline_access", "photo_upload"], forSheet: false
  end  
  
  def userLoginSuccessful
    puts "connected to facebook"
    @connected = true
  end
    
  def makeAlbum name, description, location    
    unless make_facebook?
      puts "skipping facebook album"
      continue
      return
    end
    
    params = { :uid => @fbConnection.uid, :name => name, :description => description, :location => location, :visible => "everyone" }
    mk_request = MKFacebookRequest.requestWithDelegate:self
    mk_request.method = "photos.createAlbum"
    mk_request.parameters = params
    mk_request.delegate = self
    mk_request.sendRequest
    log "making facebook album #{ name }"
  end
  
  
  def postPhoto( name, photo_filepath )
    unless make_facebook?
      puts "skipping facebook photo"
      continue
      return
    end
    
    photo_request = MKPhotosRequest.requestWithDelegate self
    image = NSImage.alloc.initWithContentsOfFile photo_filepath 
    
    photo_request.photosUpload image, aid: @album_id, caption: name
  end
  
  def facebookRequest request, responseReceived: response
    xmlresponse = response.XMLStringWithOptions NSXMLNodePrettyPrint
    doc = Document.new xmlresponse
    
    if request.method == "photos.createAlbum"
      puts doc.root.elements["link"].texts[0]
      #it comes through as a weird XML object
      @album_id = "#{ doc.root.elements["aid"].texts[0]}"
    end
    
    if request.method == "photos.upload"
      puts "put up a photo"
    end
    
    continue
  end  
  
  private
  
  def facebookRequest request, errorReceived: error
    puts "DED"
  end
  
  def facebookRequest request, failed: error
    puts "DEDED"
  end
  
  def make_facebook?
    NSUserDefaults.standardUserDefaults.boolForKey "make_facebook"
  end
  
  def continue
    uploadController.performSelectorInBackground :'next_photo:', withObject:nil
  end

end