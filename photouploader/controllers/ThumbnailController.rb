#
#  ThumbnailController.rb
#  photouploader
#
#  Created by orta on 27/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#


class ThumbnailController
  
  def self.thumbnailForPhoto photo
    size = 256

    image = NSImage.alloc.initWithContentsOfFile(photo.filepath)
    scaledImage = NSImage.alloc.initWithSize(NSMakeSize(size, size))
    scaledImage.lockFocus
    NSGraphicsContext.currentContext.setImageInterpolation NSImageInterpolationHigh
    if photo.crop
      image.drawInRect(NSMakeRect(0, 0, size, size), fromRect: photo.crop, operation: NSCompositeCopy, fraction: 1.0)
    else
      image.drawInRect(NSMakeRect(0, 0, size, size), fromRect: NSZeroRect, operation: NSCompositeCopy, fraction: 1.0)
    end
    scaledImage.unlockFocus
    
    properties = NSDictionary.dictionaryWithObject( 0.7, forKey: NSImageCompressionFactor)
    bitmap = NSBitmapImageRep.imageRepWithData scaledImage.TIFFRepresentation
    jpg_data = bitmap.representationUsingType( NSJPEGFileType,  properties:properties )
    jpg_data.writeToFile('/tmp/thumbnail.jpg', atomically:true)
    "/tmp/thumbnail.jpg"
  end
end