#
#  SheetController.rb
#  photouploader
#
#  Created by orta on 18/05/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#


class SheetController
  
  attr_accessor :mainWindow, :sheet, :uploadController
  
  def open_sheet(sender)
    NSApp.beginSheet sheet, modalForWindow: mainWindow, modalDelegate: self, didEndSelector: nil, contextInfo: nil

  end
  
  def cancel_sheet(sender)
    NSApp.endSheet sheet
    sheet.orderOut self

  end
  
  def sheet_did_end
    puts "uh?" 
  end
  
end