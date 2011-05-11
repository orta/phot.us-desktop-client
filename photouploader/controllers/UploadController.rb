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
      return
    end
    
    if !albumDescription
      puts "no description"
      return
    end
    
    if server
      flickbook_path = AlbumThumbnailController.generateWithPhotos self.photos, safe_name
      flickbook_url = Uploader.toS3 flickbook_path, safe_name + "_flickbook.jpg"
      
      album_id = 0
      RestClient.post( server + '/albums',{ :album => { :name => albumTitle, :description => albumDescription, :safe_name => safe_name, :flickbook_url => flickbook_url} })  do  |response, request, result| 
        album_id = response.to_str
      
        if album_id
          puts "creating album " + album_id

          uploadPhotosWithID album_id
        end
      end
    end
  end
  
  def safe_name
    albumTitle.strip.downcase.gsub(" ", '_')
  end
  
  def uploadPhotosWithID album_id
    puts "photos"
    server = NSUserDefaults.standardUserDefaults.stringForKey "server"
    self.photos.each do |photo|

      # new_photo_address = server + '/api/album/' + album_id + '/photo/new'
      # response =  RestClient.get new_photo_address
      # photo_id = response.to_str
      # 
      # photo_address = server + '/api/album/' + album_id + '/photo/' + photo_id

      # photo_name = safe_name + "_photo_320_" + photo_id
      # thumbnail_path = ThumbnailController.thumbnailForPhoto photo, photo_name, 320, 320
      # Uploader.toS3 thumbnail_path, name
      
      # RestClient.post photo_address + '/thumb', :file => File.new(thumbnail_path, 'rb')

      # thumbnail_path = ThumbnailController.thumbnailForPhoto photo, safe_name + "_photo_32_" + photo_id, 32, 32
      # RestClient.post photo_address + '/tiny', :file => File.new(thumbnail_path, 'rb')

      #only one for now PLZ
      return
    end
  end
  
end
