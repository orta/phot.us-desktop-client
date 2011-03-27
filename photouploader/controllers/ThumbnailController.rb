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

class ThumbnailController
  
  def self.generateWithPhotos(photos)
    filenames = photos.shuffle
    thumbnail = NSImage.alloc.initWithSize(NSMakeSize(260, 1460))
    
    thumbnail.lockFocus 
    NSGraphicsContext.currentContext.setImageInterpolation NSImageInterpolationHigh
    
    10.times do |i|
  
      point = NSMakePoint(0, i * 146)
      image = NSImage.alloc.initWithContentsOfFile(filenames[i].imageUID)
      image.setScalesWhenResized true
      image.setSize NSMakeSize(260, 146)
      image.compositeToPoint(point, operation:NSCompositeSourceOver)
  
  # thumbnail.drawInRect(NSMakeRect(, 0, 260, 146), fromRect: NSZeroRect, operation: NSCompositeCopy, fraction: 1.0)
    end

  thumbnail.unlockFocus 

  properties = NSDictionary.dictionaryWithObject( 0.3, forKey: NSImageCompressionFactor)
  bitmap = NSBitmapImageRep.imageRepWithData thumbnail.TIFFRepresentation
  jpg_data = bitmap.representationUsingType( NSJPEGFileType,  properties:properties )
  jpg_data.writeToFile('/tmp/thumbnail.jpg', atomically:true)
  "/tmp/thumbnail.jpg"
  end
end