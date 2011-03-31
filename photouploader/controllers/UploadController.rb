#
#  UploadController.rb
#  photouploader
#
#  Created by orta on 27/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

require 'ThumbnailController'
require 'AlbumThumbnailController'

class UploadController
  attr_accessor :photoController, :albumTitle, :albumDescription
    
  def photos
    photoController.images
  end

  def test(sender)
    server = NSUserDefaults.standardUserDefaults.stringForKey "server"
    response = RestClient.get server + '/clienttest'
    if response.to_str == "yep"
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
      safe_name = albumTitle.strip.downcase.gsub(" ", '_') 
      thumbnail_path = AlbumThumbnailController.generateWithPhotos self.photos, safe_name

      begin
        response = RestClient.post server + '/albums/new', { :album => { :title => albumTitle, :description => albumDescription },
                                                             :thumbnail => File.new(thumbnail_path, 'rb') }
        rescue => e
        puts e.response
      end

      puts response.to_str
    end
    
    
    #thumbnail_path = ThumbnailController.thumbnailForPhoto self.photos[1]

  end
end
