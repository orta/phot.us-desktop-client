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
      RestClient.post( server + '/albums',{ :album => { :name => albumTitle, :description => albumDescription, :safe_name => safe_name, :flickbook_url => flickbook_url} },  {:accept => :json})  do  |response, request, result| 
        album_json = JSON.parse response.to_str
        if album_json
          uploadPhotosWithID album_json["id"]
        end
      end
    end
  end

  def safe_name
    albumTitle.strip.downcase.gsub(" ", '_')
  end

  def scale_photo(photo_url, new_photo_path, options={} )
    if( options[:width] )
      output_url = "/tmp/#{new_photo_path}"
      `sips -s format jpeg #{photo_url} --resampleWidth 1024 --out #{output_url}`

      output_url
    end
  end

  def uploadPhotosWithID album_id
    server = NSUserDefaults.standardUserDefaults.stringForKey "server"

    self.photos.each_with_index do |photo, i|

      image = NSImage.alloc.initWithContentsOfFile(photo.filepath)
      is_landscape = image.size.width > image.size.height ? true : false

      photo_name = "#{safe_name}_photo_1024_#{i}.jpg"
      thumbnail_path = scale_photo photo.filepath, photo_name, {:width => 1024}
      thumb_1024_url = Uploader.toS3 thumbnail_path, photo_name

      photo_name = "#{safe_name}_photo_320_#{i}.jpg"
      thumbnail_path = ThumbnailController.thumbnailForPhoto photo, photo_name, 320, 320
      thumb_320_url = Uploader.toS3 thumbnail_path, photo_name

      photo_name = "#{safe_name}_photo_32_#{i}.jpg"
      thumbnail_path = ThumbnailController.thumbnailForPhoto photo, photo_name, 32, 32
      thumb_32_url = Uploader.toS3 thumbnail_path, photo_name

      RestClient.post( "#{server}/albums/#{album_id}/photos", 
      { :photo => {  

        :thumbnail_32_url => thumb_32_url, 
        :thumbnail_320_url => thumb_320_url, 
        :thumbnail_1024_url => thumb_1024_url, 
        :is_landscape => is_landscape,
        :album_id => album_id,
      } 

      },{:accept => :json})      

      #only one for now PLZ
      return
    end
  end
end
