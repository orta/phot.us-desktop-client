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

  def awakeFromNib
    self.connect self
  end
  
  
  def connect(sender)
    @fbConnection = MKFacebook.facebookWithAppID "218224341540328", delegate: self
    @fbConnection.loginWithPermissions ["offline_access", "photo_upload"], forSheet: false
  end  
  
  def userLoginSuccessful
    # self.makeAlbum "test album", "ignore me's"
    puts "connected to facebook"
  end
  
  def makeAlbum name, description
    params = { :uid => @fbConnection.uid, :name => name, :description => description, :visible => "everyone" }
    mk_request = MKFacebookRequest.requestWithDelegate:self
    mk_request.method = "photos.createAlbum"
    mk_request.parameters = params
    mk_request.delegate = self
    mk_request.sendRequest
  end
  
  
  def postPhoto( name, photo_filepath )
    photo_request = MKPhotosRequest.requestWithDelegate self
    image = NSImage.alloc.initWithContentsOfFile photo_filepath 
    
    photo_request.photosUpload image, aid: @album_id, caption: name
  end
  
  def facebookRequest request, responseReceived: response
    xmlresponse = response.XMLStringWithOptions NSXMLNodePrettyPrint
    doc = Document.new xmlresponse
    
    if request.method == "photos.createAlbum"
      #it comes through as a weird XML object
      @album_id = "#{ doc.root.elements["aid"].texts[0]}"
      postPhoto "See original here: xxx", "/tmp/xzczxczxczcx_photo_1024_0.jpg"
    end
    
    if request.method == "photos.upload"
      puts "put up a photo"
      
    end
  
  end  
  
  def facebookRequest request, errorReceived: error
    puts "DED"
  end
  
  def facebookRequest request, failed: error
    puts "DEDED"
  end
end