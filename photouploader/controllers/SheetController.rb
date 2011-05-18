#
#  SheetController.rb
#  photouploader
#
#  Created by orta on 18/05/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#


class SheetController
  
  attr_accessor :mainWindow, :sheet, :uploadController, :current_photo, :message, :photo_index, :photo_count, :enabled
  
  def open_sheet(sender)
    setup_defaults
    NSApp.beginSheet sheet, modalForWindow: mainWindow, modalDelegate: self, didEndSelector: nil, contextInfo: nil
    enabled = true
  end
  
  def cancel_sheet(sender)
    NSApp.endSheet sheet
    sheet.orderOut self
  end
  
  
  private
  
  def setup_defaults
    self.photo_count = uploadController.photos.count
    
    image = NSImage.alloc.initWithContentsOfFile(uploadController.photos.first.filepath)
    self.current_photo = image
    self.photo_index = 0
  end
  
  
end