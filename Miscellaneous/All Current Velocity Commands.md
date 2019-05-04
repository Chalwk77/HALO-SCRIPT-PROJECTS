## Admin Chat:
`/achat on|off|status|-s [me | id */all]`
>  'status' or '-s' tells you whether the target's achat is enabled/disabled.
- - - -

## Alias System:
`/alias [me | id] [page id]`
- - - -

## Block Object Pickup:
`/block [me | id | */all]`<br/>
`/unblock [me | id | */all]`
> Prevents players from picking up objects.
- - - -

## Enter Vehicle:
`/enter <<item>> [me | id | */all] (optional: height/distance)`
>  Optional Flags: 'height' = height from ground, 'distance' = distance from player.<br/>
>  You can optionally specify how high off the ground the object spawns, and the distance it spawns from the player's standing position.
- - - -

## Give:
`/give <<item>> [me | id | */all]`
- - - -

## Infinity Ammo:
`/infammo [me | id | */all] [multiplier or off] ( optional: {flag} )`
>  You can optionally execute this command silently for other players by specifying the '-s' command parameter.
- - - -

## Item Spawner:
`/spawn <<item>> [me | id | */all] [amount]`<br/>
`/itemlist`
>  /itemlist shows a list of valid items for the current map.
- - - -

## Lurker:
`/lurker [me | id | */all] on|off`
>  If 'on|off' parameter is not specified, it will show you the target's current lurker setting (enabled/disabled).
- - - -

## Mute System:
`/mute [id | */all] ( optional: [time diff] )`
> If `[time diff]` parameter is not specified, the player will be muted permanently.<br/>
> You cannot execute `/mute` or `/unmute` on yourself.<br/>
`/unmute [id | */all]`<br/>
`/mutelist ( optional: {flag} )`<br/>
> If you specify the '-o' flag, this command will only show you muted players who are currently online.
- - - -

## Player List (4 command aliases):
`/pl, players, playerlist, playeslist`
- - - -

## Portal Gun:
`/portalgun on|off [me | id | */all]`
> If `on|off` parameter is not specified, it will show you the target's current portalgun setting (enabled/disabled).
- - - -

## Private Messaging System:
`/pm [id | ip] {message}`<br/>
`/readmail [page id]`<br/>
`/delpm [#mail id]`
> FYI: The `[#mail id]` is inserted 'before' the senders name on the `/readmail page`.
- - - -

## Respawn Time:
`/setrespawn [me | id | */all] [time diff]`
>  If `[time diff]` parameter is not specified, it will show you the target's current respawn time setting.
- - - -

## Respawn:
`/respawn [me | id | */all]`
- - - -

## Special Commands:
`/plugins [page id]`<br/>
`/enable [id]`<br/>
`/disable [id]`
> "/plugins [page id]" will show you a list of all individual features and tells you which ones are enabled or disabled.

> You can enable or disable any feature at any time with /enable [id], /disable [id].

`/clean [me | id | */all] 1` > (cleans up "Enter Vehicle" objects)<br/>
`/clean [me | id | */all] 2` > (cleans up "Item Spawner" objects)<br/>
`/clean [me | id | */all] *` > (cleans up "everything")<br/>

`/velocity`
> If update checking is disabled this command will only display the current version.<br/>
> If update checking is enabled this command will send an http query to the gitpage for Velocity and tell you if an update is available. (returns current version of both version match)

`/clear`
> Clears the chat (useful if someone says something negative or derogatory)
- - - -

## Suggestion Box:
`/suggestion {message}`
>  Players can suggest features or maps (or report bugs) with this command.
- - - -

## Teleport Manager:
`/setwarp <<warp name>>`<br/>
`/warp <<warp name>>`<br/>
`/back`<br/>
`/warplist`<br/>
`/warplistall`<br/>
`/delwarp [warp id]`
- - - -

## What Cute Things Did You Do Today:
`/cute [id */all]`
>  You cannot execute this command on yourself.
- - - -
