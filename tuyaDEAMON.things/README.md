**tuyaDAEMON things project**
 
An application for managing Tuya and custom things used in one or more tuyaDAEMON servers. <br>
_When the tuyaDAEMON system grows, the management of 'alldevices' becomes complicated: the differences between the standard definition of the devices and the data actually present increase, due to 'hide', 'share' etc. After the test phase, in which variations and tests are frequent, the management operation, such as updating the keys, is awkward in a large JSON structure and easily leads to errors._

 Definitions:
  - *device*: an IOT _class_ of tuya or custom gadgets, defined via DPs and capabilities using [tuyadaemon-toolkit](https://github.com/msillano/tuyaDAEMON/wiki/90.-tuyaDAEMON-toolkit).
  - *thing*: a single device instance, with its own ID, KEY, quirks, extra properties (dp or attributes), and share (methods)

_Used data resources, all in the 'BASEPATH' dir (&lt;path>/tuyadaemontoolkit/devicedata)_:
1. the 'device_xxxxx.json' files with device definitions, from tuyadaemon-toolkit, step 3: "JSON creation".
1. the 'alldevices.server.json' file, exported from node-red tuyaDAEMON servers
1. the 'wizard.out.txt' file, from tuya-cli wizard console output.
 
_Database: 'tuyathome', tables_:
 -    'allthings'    : defines a thing: name, type, device etc...
 -    'specialthing' : defines a single thing's quirks or extra dP as a delta from the device's capabilities.
 -    'sharewthing'  : describes a single thing's actions using the 'share' tuyaDAEMON feature.

_New Constraints, syntax update_ :
1. in 'alldevices' the 'device' field is required (references the thing's device). If missed, all dPs go to 'specialthings'.
2. In the absence of the 'id', when not required by TuyaDAEMON (e.g. virtual devices), it is replaced by the name or by TuyaID from the wizard.

***Goals:***

  - Populate and update the 'tuyathome' DB from resources in a simple and iterable way.
  - Thing's definition and management with accessible CRUD forms.
  - export of 'alldevices.server.json' for one or more tuyaDAEMON servers.
  - documentation production.
