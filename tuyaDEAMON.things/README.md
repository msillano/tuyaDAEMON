**tuyaDAEMON things project**
 
 An application for managing Tuya and custom things used in one or more tuyaDAEMON servers. <br>
 Definitions:
  - *device*: an IOT _class_ of tuya or custom gadgets, defined via DPs and capabilities using tuyadaemon-toolkit.
  - *thing*: a single device instance, with its own ID, KEY, quirks, extra properties (attributes), and share (methods)

_Used data resources, all in the 'BASEPATH' dir_:
1. the 'device_xxxxx.json' files with device definitions, from tuyadaemon-toolkit.
1. the 'alldevices.server.json' file, exported from node-red tuyaDAEMON servers
1. the 'wizard.out.txt' file, from tuya-cli wizard console output.
 
_Database: 'tuyathome', tables_:
 -    'allthings'    : defines a thing: name, type, device etc...
 -    'specialthing' : defines a single thing's quirks as a delta from the device's capabilities.
 -    'sharewthing'  : describes a single thing's actions using the 'share' tuyaDAEMON feature.

***Goals:***

  - Populate and update the 'tuyathome' DB from resources in a simple and iterable way.
  - Thing's definition and management with accessible CRUD forms.
  - export of 'alldevices.server.json' for one or more tuyaDAEMON servers.
  - documentation production.
