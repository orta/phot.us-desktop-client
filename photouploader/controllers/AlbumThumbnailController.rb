#
#  ThumbnailController.rb
#  photouploader
#
#  Created by orta on 27/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

# To make the thumbnails we need 10 images
# they all need to be landscape
# and chopped vertically together ( 260 x 146 each )
# this then needs uploading

class AlbumThumbnailController
  
  def self.generateWithPhotos(photos, name)
    filenames = photos.shuffle
    thumbnail = NSImage.alloc.initWithSize(NSMakeSize(260, 1460))
    
    thumbnail.lockFocus 
    NSGraphicsContext.currentContext.setImageInterpolation NSImageInterpolationHigh
    j = 0
    10.times do |i|
      image = NSImage.alloc.initWithContentsOfFile(filenames[j].filepath)
      count = 0
      until image.size.width > image.size.height
        count = count + 1
        if count == photos.count 
          return;
        end
        j = [j+1, photos.count].min
        image = NSImage.alloc.initWithContentsOfFile(filenames[j].imageUID)
      end

      j = [j+1, photos.count].min
      point = NSMakePoint(0, i * 146)
      image.setScalesWhenResized true
      image.setSize NSMakeSize(260, 146)
      image.compositeToPoint(point, operation:NSCompositeSourceOver)
    end

    thumbnail.unlockFocus 

    properties = NSDictionary.dictionaryWithObject( 0.3, forKey: NSImageCompressionFactor)
    bitmap = NSBitmapImageRep.imageRepWithData thumbnail.TIFFRepresentation
    jpg_data = bitmap.representationUsingType( NSJPEGFileType,  properties:properties )
    jpg_data.writeToFile("/tmp/#{name}.jpg", atomically:true)
    "/tmp/#{name}.jpg"
  end
end