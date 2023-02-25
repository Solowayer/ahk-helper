#Maxthreadsperhotkey, 2

#NoEnv
SetWorkingDir %A_ScriptDir%

#SingleInstance, force

#IfWinActive ahk_class grcWindow ;Disables hotkeys when alt-tabbed or GTA is closed.

  ;DELAYS
  wlDelay := 175 ;weapon locker delay
  IntMenuDelay := 75
  IntPhoneMenuDelay := 850
  IntPhoneMenuDelay2 := 100
  IntKeySendDelay := 20 ;delay between send key commands.
  IntKeyPressDuration := 5 ;duration each key press is held down.

  ;ADDITIONAL
  IsOrgActive := false

  ;HOTKEYS
  toggleOrgStatusKey := "F4"
  weaponLockerSetupKey := "PrintScreen"

  openSnackMenuKey := "-"
  openAmmoMenuKey := "="
  openArmorMenuKey := "\"

  armorDropKey := "NumpadDot"
  bstDropKey := "Numpad0"
  ceoStartKey := "Numpad1"
  mcStartKey := "Numpad2"
  leaveOrgKey := "Numpad3"
  passiveModeKey := "Numpad7"
  ceoGhostKey := "Numpad9"

  vehiclesKey := "NumpadSub"
  servicesKey := "NumpadAdd"

  callMechKey := "^1"
  callMorsMutualKey := "^2"
  callLesterKey := "^3"
  callPegasusKey := "^4"
  callFranklinKey := "^5"

  ;HOTKEY MAPPING
  Hotkey, %toggleOrgStatusKey%, toggleOrgStatus
  Hotkey, %weaponLockerSetupKey%, weaponLockerSetup

  Hotkey, %openSnackMenuKey%, openSnackMenu
  Hotkey, %openAmmoMenuKey%, openAmmoMenu
  Hotkey, %openArmorMenuKey%, openArmorMenu

  Hotkey, %armorDropKey%, armorDrop
  Hotkey, %bstDropKey%, bstDrop
  Hotkey, %ceoStartKey%, ceoStart
  Hotkey, %mcStartKey%, mcStart
  Hotkey, %passiveModeKey%, passiveMode
  Hotkey, %ceoGhostKey%, ceoGhost
  Hotkey, %leaveOrgKey%, leaveOrg

  Hotkey, %vehiclesKey%, vehicles
  Hotkey, %servicesKey%, services

  Hotkey, %callMechKey%, callMech
  Hotkey, %callMorsMutualKey%, callMorsMutual
  Hotkey, %callLesterKey%, callLester
  Hotkey, %callPegasusKey%, callPegasus
  Hotkey, %callFranklinKey%, callFranklin

  setkeydelay, IntKeySendDelay, IntKeyPressDuration
  return

  ; === FUNCTIONS ===

  goDown(scrollCount, confirm) {
    global IntMenuDelay

    Loop %scrollCount% {
      Send {Down}
      sleep, IntMenuDelay
    }
    if (confirm){
      Send {Enter}
      sleep, IntMenuDelay
    }
  }

  goUp(scrollCount, confirm) {
    global IntMenuDelay
    Loop %scrollCount% {
      Send {Up}
      sleep, IntMenuDelay
    }
    if (confirm){
      Send {Enter}
    }
  }

  openInventory() {
    global IsOrgActive
    global IntMenuDelay
    Send {m}
    sleep, IntMenuDelay
    if (IsOrgActive) {
      goDown(3,true)
      sleep, IntMenuDelay
    } else {
      goDown(2,true)
      sleep, IntMenuDelay
    }
  }

  ceoAbilities() {
    global IntMenuDelay
    Send {m}
    sleep, IntMenuDelay
    Send {Enter}
    goUp(3,true)
  }

  makeCall(scrollDirection, scrollCount) {
    global IntMenuDelay
    global IntPhoneMenuDelay
    global IntPhoneMenuDelay2

    Send {Mbutton}
    sleep, IntPhoneMenuDelay
    Loop 2 {
      Send {WheelUp}
      sleep, IntPhoneMenuDelay2
    }
    Send {Enter}
    sleep, IntPhoneMenuDelay2

    if (scrollDirection = "Up") {
      Loop %scrollCount% {
        Send {WheelUp}
        sleep, IntMenuDelay
      }
    }
    else if (scrollDirection = "Down") {
      Loop %scrollCount% {
        Send {WheelDown}
        sleep, IntMenuDelay
      }
    }

    Send {Enter}
  }

  ;WEAPON LOCKER FUNCTIONS

  wlSwitch(switchCount, skipCount, back = false) {
    global wlDelay

    Loop %switchCount% {
      Send {Down}
      sleep, wlDelay
      Send {Right}
      sleep, wlDelay
    }

    if (skipCount) {
      Loop %skipCount% {
        Send {Down}
        sleep, wlDelay
      }
    }

    if (back) {
      Send {Backspace}
      sleep, wlDelay
      goDown(1,true)
    }

  }

  ;ORGS

  ceoStart:
    global IntMenuDelay
    Send {m}
    sleep, IntMenuDelay
    goUp(10,true)
    Send {Enter}
    IsOrgActive := true
  return

  mcStart:
    global IntMenuDelay
    Send {m}
    sleep, IntMenuDelay
    goUp(9,true)
    Send {Enter}
    IsOrgActive := true
  return

  leaveOrg:
    global IntMenuDelay
    Send {m}
    sleep, IntMenuDelay
    Send {Enter}{Up}{Enter}
    IsOrgActive := false
  return

  ;PASSIVE MODE

  passiveMode:
    global IntMenuDelay
    Send {m}
    sleep, IntMenuDelay
    Send {Up}{Enter}{m}
  return

  ;INVENTORY

  openSnackMenu:
    openInventory()
    goDown(5,true)
  return

  openAmmoMenu:
    openInventory()
    goDown(6,true)
  return

  openArmorMenu:
    openInventory()
    goDown(4,true)
    goUp(3,false)
  return

  ;WEAPON LOCKER

  weaponLockerSetup:
    global wlDelay

    ;MELEE
    Send {Enter}
    sleep, wlDelay
    ;skip SwitchBlade
    wlSwitch(8, 1)
    wlSwitch(1, 0, true)

    ;PISTOLS
    ;skip AP Pistol
    wlSwitch(2,1)
    ;skip Atomizer
    wlSwitch(7,1,true)

    ;MACHINE GUNS
    ;skip SMG MK 2
    wlSwitch(0,1)
    ;skip Combat MG MK 2
    wlSwitch(1,1,true)

    ;RIFLES
    ;skip Special Carbine MK 2
    wlSwitch(4,1)
    wlSwitch(1, 0, true)

    ;SHOTGUNS
    ;skip Pump Shotgun MK 2
    wlSwitch(0, 1)
    ;skip Assault Shotgun
    wlSwitch(1, 1)
    wlSwitch(1, 0, true)

    ;SNIPER RIFLES
    ;skip Heavy Sniper & Marksman Rifle MK 2
    wlSwitch(1, 2, true)

    ;HEAVY WEAPONS
    ;skip All
    wlSwitch(0,6,true)

    ;EXPLOSIVES
    wlSwitch(0,4,false)
    ;skip all but Jerry Can
    wlSwitch(1,2,false)

    Loop 2 {
      sleep, 300
      Send {Esc}
    }

  return

  ;TRANSPORT

  vehicles:
    global IntMenuDelay
    Send {m}
    sleep, IntMenuDelay
    if (IsOrgActive) {
      goDown(5,true)
    } else {
      goDown(4,true)
    }
  return

  services:
    global IntMenuDelay
    Send {m}
    sleep, IntMenuDelay
    if (IsOrgActive) {
      goDown(6,true)
    } else {
      goDown(5,true)
    }
  return

  ;CEO-ABILITIES

  ceoGhost:
    ceoAbilities()
    goUp(3,true)
  return

  bstDrop:
    ceoAbilities()
    Send {Down}{Enter}
  return

  armorDrop:
    ceoAbilities()
    goDown(3,true)
  return

  ;PHONE CALLS

  callMech:
    makeCall("Down",8)
  return

  callMorsMutual:
    makeCall("Up",6)
  return

  callLester:
    makeCall("Down",7)
  return

  callPegasus:
    makeCall("Up",4)
  return

  callFranklin:
    makeCall("Down",5)
  return

  toggleOrgStatus:
    IsOrgActive := !IsOrgActive
  return

  ScrollLock:
    Reload