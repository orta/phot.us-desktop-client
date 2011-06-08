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
  attr_accessor :photoController, :albumTitle, :albumDescription, :albumLocation, :facebookController, :sheetController

  def photos
    photoController.images
  end
  
  def log message
    sheetController.message = message
  end

  def submit(sender)
    sheetController.enabled = false
    @album_id = nil
    @stopEverything = nil
    
    performSelectorInBackground :'start_uploading:', withObject:nil
  end
  
  def start_uploading now_plox
    log "making flickbook"

    @server = NSUserDefaults.standardUserDefaults.stringForKey "server"
    @photographer = NSUserDefaults.standardUserDefaults.stringForKey "photographer"
    @i = 0
    sheetController.photo_count = photos.count
    sheetController.photo_index = @i
    
    if @server
      log "uploading flickbook"
      flickbook_path = AlbumThumbnailController.generateWithPhotos self.photos, safe_name
      flickbook_url = Uploader.toS3 flickbook_path, safe_name + "_flickbook.jpg"
      log "making album on #{ @server }"
      
      album_id = 0
      RestClient.post( @server + '/albums',{ 
                      :album => { 
                        :name => albumTitle, 
                        :photographer => @photographer, 
                        :description => albumDescription, 
                        :safe_name => safe_name, 
                        :flickbook_url => flickbook_url
                      } },  {:accept => :json})  do  |response, request, result| 
        album_json = JSON.parse response.to_str
        if album_json
          log "made album on #{ @server }"
          @album_id = album_json["id"]
          facebookController.makeAlbum albumTitle, albumDescription, albumLocation
        end
      end
    end
  end
  
  def next_photo please
    return if @stopEverything
    
    photo = photos.shift
    @i = @i + 1
    sheetController.photo_index = @i
    
    
    image = NSImage.alloc.initWithContentsOfFile(photo.filepath)
    sheetController.current_photo = image
    is_landscape = image.size.width > image.size.height ? true : false
    
    photo_1024_name = "#{safe_name}_photo_1024_#{ @i }.jpg"
    scale_photo photo.filepath, photo_1024_name, {:width => 1024}
    thumb_1024_url = Uploader.toS3 "/tmp/#{photo_1024_name}", photo_1024_name
    log "#{ @i }: uploaded 1024"

    
    is_cropped = photo.crop ? true : false
    if is_cropped
      photo_name = "#{safe_name}_photo_320_#{ @i }.jpg"
      thumbnail_path = ThumbnailController.thumbnailForPhoto photo, photo_name, 320, 320
      thumb_320_url = Uploader.toS3 thumbnail_path, photo_name
      log "#{ @i }: uploaded 320"

      
      photo_name = "#{safe_name}_photo_32_#{ @i }.jpg"
      thumbnail_path = ThumbnailController.thumbnailForPhoto photo, photo_name, 32, 32
      thumb_32_url = Uploader.toS3 thumbnail_path, photo_name
      log "#{ @i }: uploaded 32"

    end
    
    RestClient.post( "#{ @server }/albums/#{@album_id}/photos", 
    { :photo => {  

      :thumbnail_32_url => thumb_32_url, 
      :thumbnail_320_url => thumb_320_url, 
      :thumbnail_1024_url => thumb_1024_url, 
      :is_landscape => is_landscape,
      :is_cropped => is_cropped,
      :album_id => @album_id,
    } 

    },{:accept => :json})  do  |response, request, result| 
      log "#{ @i }: added another photo to the server "
      facebookController.postPhoto "See original here: #{ @server }/albums/#{@album_id} ", "/tmp/#{photo_1024_name}"
    end     
  end
  
  def stopEverything!
    @stopEverything = true
  end

  private
  def scale_photo(photo_url, new_photo_path, options={} )
    if( options[:width] )
      output_url = "/tmp/#{new_photo_path}"
      `sips -s format jpeg #{photo_url} --resampleWidth 1024 --out #{output_url}`
    end
  end
  
  def safe_name
    albumTitle.strip.downcase.gsub(" ", '_')
  end
end
