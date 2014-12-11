import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.EwmhDesktops (fullscreenEventHook)
import System.IO
--import XMonad.Actions.CycleWindows
import XMonad.Actions.CycleRecentWS
import qualified XMonad.StackSet as W
 
myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    ]
 
myModMask = mod1Mask

main = do

    spawn "xrdb -merge .Xresources"
    spawn "gnome-settings-daemon"
    spawn "gnome-keyring-daemon"
    spawn "xloadimage -onroot -fullscreen ~/.xmonad/background.jpg"
    spawn "gnome-screensaver"
    spawn "nm-applet --sm-disable"
    spawn "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"
    spawn "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x191970 --height 14"
    spawn "synergy"
    spawn "/home/yihuang/src/goagent-goagent-9b05ae9/local/goagent-gtk.py"

    xmproc <- spawnPipe "xmobar ~/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above
                        <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = myModMask     -- Rebind Mod to the Windows key
        , terminal = "gnome-terminal"
        , workspaces = ["1:work", "2:web", "3:server", "4:code", "5:chat"]++(map show [6..10])
        , handleEventHook = fullscreenEventHook
        } `additionalKeys`
        [
        -- Print Screen
          ((0              , xK_Print), spawn "gnome-screenshot")
        , ((myModMask .|. shiftMask, xK_Print), spawn "gnome-screenshot -a")
        -- Save Session
        --, ((myModMask .|. shiftMask, xK_q), spawn "gnome-session-save --shutdown-dialog")
        --, ((myModMask .|. shiftMask, xK_w), spawn "gnome-session-save --logout-dialog")
        -- switch to last workspace
        , ((myModMask, xK_quoteleft), windows W.focusDown)
        , ((myModMask, xK_Tab), cycleRecentWS [xK_Alt_L] xK_Tab xK_grave)
        ]
