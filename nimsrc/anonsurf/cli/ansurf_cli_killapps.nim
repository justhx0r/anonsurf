import .. / cores / activities / kill_apps_actions
import .. / cores / commons / ansurf_objects


proc cli_kill_apps*(callback_send_msg: callback_send_messenger) =
  #while true:
  echo("[!] Killing dangerous applications...")
    #if input == "y" or input == "Y":
  ansurf_kill_apps(callback_send_msg)
    #elif input == "n" or input == "N":
  return  
  #  return
    #else:
    #  callback_send_msg("Apps killer", "Invalid option! Please use Y / N", SecurityMedium)
