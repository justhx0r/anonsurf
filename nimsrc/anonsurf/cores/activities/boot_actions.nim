import osproc
import strformat
import .. / commons / services_status


proc ansurf_boot_enable*(sudo: string): int =
  #[
    Use Init system to start AnonSurf at boot
    Args:
      sudo: string: either "gksudo" or "sudo" for cli / gui
    Return: int: error code of systemctl commmand
  ]#
  const
    command = "/usr/bin/systemctl enable anonsurfd"
  let output_enable_anonsurfd = execCmd(fmt"{sudo} {command}")
  let output_disable_tor = execCmd(fmt"{sudo} /usr/bin/systemctl disable tor")
  let output_enable_vanguards = execCmd(fmt"{sudo} /usr/bin/systemctl enable vanguards")
  return output_enable_anonsurfd

proc ansurf_boot_disable*(sudo: string): int =
  #[
    Use Init system to disable AnonSurf at boot.
    Args:
      sudo: string: either "gksudo" or "sudo" for cli / gui
    Return: int: error code of systemctl commmand
  ]#
  const
    command = "/usr/bin/systemctl disable anonsurfd"
  let output_disable_anonsurfd = execCmd(fmt"{sudo} {command}")
  let output_enable_tor = execCmd(fmt"{sudo} /usr/bin/systemctl enable tor")
  return output_disable_anonsurfd

proc ansurf_boot_status*(): bool =
  #[
    Check if a service is enabled at boot
  ]#
  return isServEnabled("anonsurfd.service")
