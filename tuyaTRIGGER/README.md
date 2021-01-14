# tuyaTRIGGER 

_A real device WiFI, having  a big unused numerical parameter, say a 'counter', writable for both **Tuya** and **node-red**, is all the required hardware to implement a robust bilateral event communication (**TRIGGER**)._

The 'counter' is used as a dual port register: a sender (_tuya-cloud/node-red_) set the counter to some XX value, the receiver gets the XX value, acts accordingly, and resets the counter to 0 (ACK action): the _node-red_ read/write actions are performed by **tuyaTRIGGER** flow, the _Tuya-cloud_ actions are performed by ad hoc automations, one for TRIGGER.


 - _node-red => tuya_: **node-red** write a predefined value in the 'counter' and that fires a specific **Tuya** automation: first the automation must reset the 'counter' to 0, then it can do anything.
 Tuya automation, say `trigger1010`:   _If "counter:1010" do "counter:0" and "any-action..."_ 

 - _tuya => node-red_: A tuya **scene** (user action) or **automation** (event) sets  a predefined value on the 'counter' (e.g. 2030), and when node-red read that, it must first reset  the "counter' to 0, then it can do anything.
 Tuya automation,  say `trigger2030`: _If "any-event" do "counter:2030"_ 

This **TRIGGER** mechanism, implemented in **tuyaTRIGGER**, allow a better _tuya <=> node-red_ integration in **tuyaDAEMON**:
 - _node-red_ can set/get status for _all devices and data point_ not found by `node-red-contrib-tuya-smart-device`.
 - _node-red_ can fire automation on _tuya-cloud_ 
 - _tuya scene_ can control _node-red flows_, so a node-red user can employ _smartlife_ as remote control (from anywhere).
 - _tuya automations_ can fire flows in _node-red_, implementing this way any control strategy not allowed by Tuya.
 - user can fire _node-red flows_ with vocal control (`Googlehome`)

[TuyaSmart App and SmartLife App limits (2021-01-07)](https://support.tuya.com/en/help/_detail/K9q79msw3accz)

````
  Item                             Description                                                               Limit
Device Schedule quantity         The maximum number of timers that can be added to a single device         30
Number of household devices      Maximum number of devices that can be added in a single home              120
Number of scenes                 The maximum number of Tap-to-Run that a single home can create            100
Number of automations            Maximum number of Automations that can be created in a single home        100
Number of scene actions          The maximum number of tasks that can be added in a Tap-to-Run             150
Number of automation actions     The maximum number of tasks that can be added in an Automation            150
Number of automation conditions  The maximum number of conditions that can be added in an Automation       10
Number of multi-terminal logins  The maximum number of mobile devices that 
                                                can simultaneously log in to an account                    200
Number of homes                  The maximum number of Homes that can be created by a single App account   20
Number of home members           The maximum number of home members that can be added in a single home     20
Number of rooms                  The maximum number of rooms that a single home can create                 20
Number of room equipment         The maximum number of devices that can be added in a single room          50
Number of equipment groups       The maximum number of devices that can be added in a single device group  100
Number of home equipment groups  The maximum number of device groups that a single home can create         20
Number of users                  The maximum number of each device group that
     shared by device group                     can be shared with other users                             20
Number of users sharing devices  The maximum number of each device that can be shared with other users     20
Number of homes invited          The maximum number of each App account that can be invited by other homes 20
 ````
 more
- [Number of Zigbee devices](https://support.tuya.com/en/help/_detail/K8xu0c86wlte1) : gateway theoretical limit is 128 wired, and 50 WiFi.

###  system:_trgPing
An extestion of `_system` fake device is in tuyaTRIGGER, and manages the property `_trgPing`: i.e. a measure of the time consumed by a complete _TRIGGER round trip_:
  1) a `TRIGGER800` is sent by node-red
  2) The `tuya_bridge:counter` is set to 800 by node-red
  3) An automation is found and fired by _tuya-cloud_ "`if "tuya_bridge"countdown:800, "tuya_bridge"countdown:0`"
  4) `tuya_bridge:counter` is set to 0 by tuya-cloud 
  5) `TRIGGER0` is caught by _node-red_ and decoded.

On my PC I get the result (in ms):
````
_trgPing: object
    count: 5
      avg: 209
      max: 312
      min: 145
````

### Actual (example) triggers map in **tuyaTRIGGER** flow:

1) _TUYATRG (1000-1990) are used to handle 'mirror' devices._

   - the device changes status
   - an automation is fired by this event and it sends a TUYATRG to _node-red_.
   - on receiving the TUYATRG, _node-red_ remaps the trigger as a usual device message, to log them,  using a fake dps         (convention: same as the trigger value). The mirror device and dps must be defined in `global.alldevice.fake` branch.
   - _node-red_ sends an ACK (reset the 'counter' to 0)
   
    example in tuyaTRIGGER: 

    the WiFi '_Motion Detector_' device is battery powered. But a trigger is send at any status change by _tuya-cloud_ to _tuyaDAEMON_:

    - **TUYATRG1010**: is mapped as `Motion Detector [123410408caab8e79837]:alarm[dps:1010]:OFF`

      In Tuya Automation we need: _`If sensore di movimento:normale, tuya-bridge:countdown:1010`_ 

    - **TUYATRG1020**: is mapped as `Motion Detector [123410408caab8e79837]:alarm[dps:1010]:ON`

      In Tuya Automation we need: _`If "sensore di movimento:Allarme", tuya-bridge:countdown:1020`_ 

    See also ["siren mirror"](./../extra) extra flow.

2) _TUYATRG (1000-1990) are also used fired by_ smartlife _to signal some  user/device/weather/geolocation action_ 

    example in tuyaTRIGGER:

   - **TUYATRG1030**: free
   - **TUYATRG1040**: free

3) _REDTRG (2000-2990) can be fired by_ node-red, _to activate_ smartlife _automations:_  

    example in tuyaTRIGGER:
   - **REDTRG2010**: free
   - **REDTRG2020**: free

4) _more TRIGGERS, with conditions defined by the user, can fire node-red flows asynchronously, without `global.alldevices` polling, or implement conditions not allowed by_ smartlife _automatitions._

   example in tuyaTRIGGER:
   - **EVNTRIGGER00A**: fired if temperature > 20 °C  (from a virtual device)
   - **EVNTRIGGER00B**: fired on PIR alarm (from a mirror device)


### implementation

_This tick can be used with any device, named in the flow and in `alldevices` "tuya_bridge".

1) _I choose first the_ [Switch MS-104](https://www.aliexpress.com/item/33012114855.html) (USD 8) _because its countdown (`dp` = 102) is with a large range [0-86400s, i.e. 24H] and still the device can be used as a WiFi switch, because only the countdown function is used by this implementation, plus it is small and cheap. 

   The unique problem is the lack of a battery backup.

2) _Now I'm waiting for another device, a wifi switch_ [TYWR 7-32](https://www.aliexpress.com/item/1005001292469801.html) (USD 10) _with a micro USB power input. When I get it I will update here after some tests_.

3) 'TuyaTrigger' value is placed in `msg.payload.tuyatrigger`.  The conversion `data.dp["102"] ==>  msg.payload.tuyatrigger` is done by `"dp converter"` change node. _To config your own `tuya-bridge` device, and to use any `dp`:_
     - modify the  `"dp converter"` change node. 
     - modify the code in `"red trigger"` sub-flow.


**note**
 
 - analog values can't be sent from tuya this way, because tuya does not allow the use of calculated values. But comparations are allowed: e.g. send trigger if `'temperature < 16'`. (Available: `<`; `=`; `>`). We can 'mirror' `BOOLEAN` dp (2 automations) `ENUM` dp: [0|1|2]  (3 automations) or also `INT`, but converted to ENUM when required: `{<15|16-20|21-25|26-30|31-35|36-40|>40}` but many automations are required (12 for this example).

 - using a countdown as a trigger, as _Switch MS-104_ does, requires REDTRG with numbers greater (e.g. 2000+) than TUYATRG (e.g. 1000..1999]): so, if _node-red_ is down, a Tuya TRIGGER not caught can't trigger a fake REDTRG.
 
 - If the used counter is a time counter (countdown in case of  _Switch MS-104_ ) you must choose trigger values at least separated by 10s, to allow the ACK action.

 - for fallback, MUST exist a Tuya Automation fired when the countdown is less than any trigger value (e.g. 800), to reset the countdown to 0 without ACK: so the countdown never interferes with the logic of the switch (this automation is also deployed by `_trgPing` implementation). Required automation:  `if "tuya_bridge"countdown:800, "tuya_bridge"countdown:0` 
 
- this implementation does not verify the ACKs presence and timing, and not uses any handshake strategy, so it is theoretically possible to have some interferences.

--------------------
**Versions**

_tuyaTRIGGER version 1.0_ (15/01/2021)
  - tuyaDAEMON ver 1.0

Initial version     
