import gintro / [gtk, gobject]
import .. / ansurf_types
import kill_apps_activities


# proc onClickExit(w: Window) =
#   mainQuit()
type
  KillArgs = object
    cb_send_msg: callback_send_messenger
    d: Dialog


proc do_not_kill(b: Button, d: Dialog) =
  d.destroy()


proc do_kill(b: Button, args: KillArgs) =
  ansurf_kill_apps(args.cb_send_msg)
  args.d.destroy()


# proc do_exit(b: Button) =
#   mainQuit()
#   # TODO do not start anonsurf instead of just call


proc box_kill_app(callback_send_msg: callback_send_messenger, d: Dialog): Box =
  let
    boxAppKill = newBox(Orientation.vertical, 3)
    labelAsk = newLabel("Do you want to kill apps and clear cache?")
    boxButtons = newBox(Orientation.horizontal, 3)
    btnKill = newButton("Kill")
    btnDoNotKill = newButton("Don't kill")
    # btnCancel = newButton("Cancel")
    pass_args = KillArgs(
      cb_send_msg: callback_send_msg,
      d: d
    )
  
  btnKill.connect("clicked", do_kill, pass_args)
  boxButtons.add(btnKill)

  btnDoNotKill.connect("clicked", do_not_kill, d)
  boxButtons.packEnd(btnDoNotKill, false, true, 3)

  # btnCancel.connect("clicked", do_exit)
  # boxButtons.add(btnCancel)

  boxAppKill.add(labelAsk)
  boxAppkill.add(boxButtons)
  return boxAppKill


proc dialog_kill_app*(callback_send_msg: callback_send_messenger) =
  # FIXME broken
  let
    retDialog = newDialog()
    dialogArea = retDialog.getContentArea()
    boxDialog = box_kill_app(callback_send_msg, retDialog)
  retDialog.setTitle("Kill dangerous application")
  dialogArea.add(boxDialog)
  retDialog.showAll()
  discard retDialog.run()
  retDialog.destroy()
