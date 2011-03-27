#
#  UploadController.rb
#  photouploader
#
#  Created by orta on 27/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#


class UploadController
  attr_accessor :photoController, :albumTitle, :albumDescription
    
  def photos
    photoController.images
  end

  def test(sender)
    server = NSUserDefaults.standardUserDefaults.stringForKey "server"
    reply = open(server + "/clienttest").read
    if reply == "yes"
      puts "it's OK!"
    end
  end
  
  def submit(sender)
    server = NSUserDefaults.standardUserDefaults.stringForKey "server"
    if !albumTitle
      puts "no title"
    end
    
    if !albumDescription
      puts "no description"
    end
    
    if server
      response = RestClient.post server + '/albums/new', :album => { :title => albumTitle, :description => albumDescription }
      puts response.to_str
    end
  end
  
  def setAlbumDescription string
    self.albumDescription = string
  end
end
