# TuyaDAEMON project


_A two-way bridge between Tuya-cloud and node-red for custom extensions of Tuya ecosystem._

TuyaDAEMON isolates your **custom node-red flows** from all details of _tuya/node-red data and commands exchanges_:
- allows bidirectional exchanges to/from _all tuya devices and Tuya automations_.
- decodes and transforms incominig Tuya data  to _standard units_.
- manages all codifications and checks before sending your _commands to Tuya cloud_.
- updates the `global.tuyastatus` structure (_device:property:value_) with _status messages from all Tuya devices_.
- logs all events in the mySQL` 'tuyathome:messages'` table 
- uses _frendly names_ for all devices and properties, in any language

_If you are interested in the reasons behind tuyaDAEMON's project choices, you can read [why-tuyaDEAMON](why-tuyaDEAMON.pdf) - In italiano: [perché-tuyaDAEMON](perchè-tuyaDEAMON.pdf). note: To make links work, download the pdf file and use your viewer._
### INPUT
  Only one public entry point, for user commands (SET/GET/SCHEMA/MULTIPLE), the _'IN commands link'_ node (see). Command example (SET), it uses only _frendly names_:
  ````
  {  "device":"USB siren",
     "property":"alarm",
     "value":"ON"   }
  ````
  
### OUTPUT
  none: a client flow CAN get device data polling the `global.tuyastatus` structure, RT updated or CAN get historical data from the `messages` DB table.
 
_User can define:_
- TUYA TRIGGERS from _smartlife scene/event/alarm_ to fire custom _node-red flows_
- RED TRIGGERS from _node-red_ to fire _smartlife automations_.

Many internal I/O connections are available for private use and for tuyaDAEMON extensions.

### IMPLEMENTATION

 To interact with _Tuya devices_ I chose [`node-red-contrib-tuya-smart-device`](https://github.com/vinodsr/node-red-contrib-tuya-smart-device), which uses [tuyapi](https://github.com/codetheweb/tuyapi), the most interesting software on **tuya<=>node-red** integration that I have found.
 They do their job well, but there are some limitations:
 
  
  1) The capabilities of the Tuya communication are very variable for different devices: e.g. I have found very few devices that respond to `schema` request, or data exchanges are not MQTT (e.g. infrared universal control).

  2) Some devices are unreachables: **TuyAPI** does not support some sensors due to the fact that they only connect to the network when their state changes. Usually are WiFi devices battery-powered ([see note](https://github.com/codetheweb/tuyapi#-notes)).
 
 3) _Tuya devices_ can update  their own firmware version via **OTA**: for the user, this is an investment guarantee, but it can introduce problems when the software (`tuyapi` and `tuya-smart-device`) is not updated: some device messages can't be decoded (see [issue#17](https://github.com/vinodsr/node-red-contrib-tuya-smart-device/issues/27)).
 
 4) Tuyapi sometimes finds an error message from devices: `"json obj data unvalid"`: the source of this is not clear (see [issue#246](https://github.com/codetheweb/tuyapi/issues/246)), but the best interpretation is "_the required operation is not available_".
 
 5) **Tuyapi** throws some errors at the moment not caught by **tuya-smart-device**: `"Error: Error from socket"` and `"find () timeout. Is the device turned on and the correct ID or IP?"`  (see [issue#35](https://github.com/vinodsr/node-red-contrib-tuya-smart-device/issues/35)).
 Because now a **tuya-smart-device** can't be disabled, these useless messages can be very frequent. In normal use, some devices can stay disconnected long time, such as power sockets or power strips used only on request.

 _To manage such a rapidly changing environment, I choose to use a data structure in **tuyaDAEMON** to describe individual devices and single datapoint capabilities, so that all operations that are actually not managed or bogous can be intercepted and not sent to the device, giving stable and reliable operations with no surprises. And if the evolution of the SW offers us new features, it is easy to update the behavior of tuyaDAEMON._
 
  _A smart workaround, implemented in [**tuyaTRIGGER**](tuyaTRIGGER) module, allows the bidirectional event communication also with all devices unreachables by `tuyapi` (WiFi sensors, IR controls etc.)._ _**The TuyaDAEMON user is guaranteed that in all cases all tuya devices will be integrated.**_
  
### customization
**TuyaDAEMON** is very sperimental, the CORE module MUST be modified by user for every new device. 
 
 _Any effort is made to make it modular, small, easy to modify and fully documented.
 All contributions and criticisms are welcome._ 
 
 
 In **tuyaDAEMON** we have now four modules:
 
 ![](pics/tuyadaemon01.jpg)
 ![](pics/tuyadaemon02.jpg)
 
 - **tuyaDEAMON CORE:** the main flow, for communication with many tuya `'real' devices`, and also with devices using a _gateway_ (`'virtual' devices`) e.g. Zigbee sensors.
 - [**tuyaTRIGGER module**](tuyaTRIGGER) _give us some important features:_
   - The start of **tuya automations** from _node-red_.
   - The ability to fire **node-red flows** from _smartlife_, enabling _node-red remote_ and _vocal_ control.
   - The management RT of `'mirror' devices` for _all devices not caught by **tuyapi**_.
   
   This module, optional, uses a smart trick on a partially dedicated HW device. 
 - **Connection module:** add to all _real device_ the new property 'connected' to report RT the device status. Optional.
 - **System module:** Offerts a `'fake' device` (_system) with some useful RT properties: _Alarms_ in case of WiFi, Lan or AC power down, _list of unconned devices_ etc. 
   Optional, requires the  _'Connection module'_.
 - _Extra flow_: ["siren mirror"](extra/siren%20mirror/), a `'mirror' devices` study case.
 - _Extra flow_: ["test devices"](extra/test%20devices) with some examples of device tests
 - _Extra flow_: ["tuyapiTRIGGER-minimal"](extra/tuyaTRIGGER%20for%20node-red%20users),  to add remote and voice control to node-red (no home automation).

### configuration

In addition to usual configuration requirements for the nodes `mySQL` and `tuya-smart-device`:
     
1) _CORE_ includes `global.alldevices`, a big JSON structure with all required information on `real/virtual/fake` devices, that control the _CORE_ behavior on device/dps basis. Any new device must be added to it. To update/modify/edit this structure:
    - you can edit it directly using the _'alldevices'_ config node.
    - you can export it to the file `alldevices.json` for backup or to edit it using external editors (e.g. _Notepad++_ and _'JSON Viewer'_ plugin) and back with cut-paste.
    - Soon an application can produce an `'alldevice'` scheletron starting from a _DB of tuya device definitions_.
    - For detailed definitions see _global alldevices_ comment node
    
    
2) To reduce the workload in the production environment:
     - `debug` nodes can control the _debug pad_ content: enabling/disabling them the user can modulate the visible information.
     - `filters` can reduce the info and the DB writing charge. 
     - see _'Debug pad options'_ comment node.
 
 ### installation
   0. Precondition: _mySQL_ server running: import the  `tuyamessages.sql`  to create the required table.
   0. Precondition: at least a _Tuya device_ installed and working with _smartlife_ app. You MUST know the `ID` and `Key` for your Tuya device(s): see [here](https://github.com/codetheweb/tuyapi/blob/master/docs/SETUP.md) for detailed instructions.
   1. Install in node-red the nodes (I use 'manage pallette'): 
        - [node-red-contrib-tuya-smart-device](https://flows.nodered.org/node/node-red-contrib-tuya-smart-device)
        - [node-red-node-mysql](https://flows.nodered.org/node/node-red-node-mysql)
        - [node-red-contrib-config](https://flows.nodered.org/node/node-red-contrib-config)
   2. Import `tuyaDAEMON.json` file in node-red.
   3. Configure in tuyaDAEMON the DB node `append to DB`
   4. Add to tuyaDAEMON your device(s). See step-by-step instructions on _`Add a new smart devices 1/2`_ comment nodes. 
   5. You can delete the unused modules and `example` nodes.
   
--------------------
**versions**

_tuyaDAEMON version 1.0_ (15/01/2021)
- node-red-contrib-tuya-smart-device 2.0.0
- tuyapi ver. 6.1.1

Initial version     
