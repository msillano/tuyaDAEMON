![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/toolkit02.jpg)

## Installation ##
This **_Toolkit_** is developed in 'php' and you need a WEB server. I use [*xampp*](https://www.apachefriends.org/it/index.htm), a quick install bundle with *Apache, php, MariaDB, phpmyadmin* ), but you can use any *web server* with *php*.
 - Unzip the `tuyadaemontoolkit.zip` file in `/htdocs` (web root): the start page is: `/htdocs/tuyadaemontoolkit/index.php` ( http://localhost/tuyadaemontoolkit/ ).
 - Import (using _phpmyadmin_) the `DB-full.2.0.sql` file to create the required DB `tuyathome`. You will found also some device data in '/devicedata/' dir.
 - Change (using _phpmyadmin_) the default value for field `'copynotice'` (table `'deviceinfos'`) with the actual year and your email.

![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/toolkit01.jpg)

For the toolkit use, see the [wiki](https://github.com/msillano/tuyaDAEMON/wiki/90.-tuyaDAEMON-toolkit).

------------------------
Last version:  tuyadaemontoolkit.2.0.zip (13/05/2021) The sql with data is the file DB-full.2.0.sql.
