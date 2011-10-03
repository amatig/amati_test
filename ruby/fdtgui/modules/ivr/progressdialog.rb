class ProgressDialog
  
  def ProgressDialog.create(parent, title = "Export")  
    dlg = Qt::Dialog.new(parent) do
      setWindowTitle(title)
      
      resize(425, 80 + 40 * 2 + 10) # ridimensionamento finestra
      
      cancel = Qt::PushButton.new(self)
      cancel.setText("Cancel")
      cancel.move(265, 30 + 40 * 2 + 10)
      Qt::Object.connect(cancel, SIGNAL(:clicked), Qt::Application.instance) { reject() }
    end
    
    return dlg
  end
  
end
