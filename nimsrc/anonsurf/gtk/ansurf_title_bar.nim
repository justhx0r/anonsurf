import gintro / [gtk, gobject]
import ansurf_icons
import widgets / [about_widget, options_widget]


proc btnSettings(): Button =
  let
    btnSettings = newButton("")
  
  btnSettings.setImage(newImageFromIconName("preferences-desktop", 4))
  btnSettings.connect("clicked", onClickOptions)

  return btnSettings


proc btnAbout(): Button =
  let
    btnAbout = newButton("")
    imgAbout = newImageFromPixbuf(aboutIcon)
  
  btnAbout.setImage(imgAbout)
  btnAbout.connect("clicked", onClickAbout)
  return btnAbout


proc surfTitleBar*(): HeaderBar =
  let
    titleBar = newHeaderBar()

  titleBar.setShowCloseButton(true)
  titleBar.settitle("AnonSurf GUI")
  titleBar.add(btnSettings())
  titleBar.add(btnAbout())
  
  return titleBar
