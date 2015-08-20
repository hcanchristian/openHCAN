##############################################################################
##  This file is part of the HCAN tools suite.
##
##  HCAN is free software; you can redistribute it and/or modify it under
##  the terms of the GNU General Public License as published by the Free
##  Software Foundation; either version 2 of the License, or (at your
##  option) any later version.
##
##  HCAN is distributed in the hope that it will be useful, but WITHOUT
##  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
##  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
##  for more details.
##
##  You should have received a copy of the GNU General Public License along
##  with HCAN; if not, write to the Free Software Foundation, Inc., 51
##  Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
##
##  (c) 2010 by Martin Kramer and Ingo Lages, i (dot) lages (at) gmx (dot) de
##############################################################################

include ./ARCH.inc

alles:
	make clean
	make dep
	make all
	make install


clean:
	make strukturen xx=clean
	make cDienste xx=clean
	make cppDienste xx=clean
	make firmware xx=clean parm2=MCU=atmega32
	make firmware xx=clean parm2=MCU=atmega644
	make firmwareOhneEds xx=clean
	cd hcanweb; make clean 

dep:
	make cppDienste xx=dep

all:
	make strukturen xx=all
	make cDienste xx=all
	make cppDienste xx=all
	make firmware xx=all parm2=MCU=atmega32
	make firmware xx=clean MCU=atmega644; make firmware xx=all MCU=atmega644
	make firmwareOhneEds xx=clean; make firmwareOhneEds xx=all
	make hcanweb_client
	make hcanweb_server
	
install:
	make strukturen xx=install
	make cDienste xx=install
	make cppDienste xx=install
	##############################################################################
	# Nun kann die Firmware geladen werden (Bootloader flashen, Firmware loaden) #
	##############################################################################


strukturen:
	cd xml; make $(xx)

cDienste: 
	#@ per Datei ./ARCH.inc   echo "export ARCH = i386" > ARCH.inc #i386 statt arm
	cd hcand/; make $(xx)
	cd hcanhid/; make $(xx)
	cd hcanaddressd/; make $(xx)

cppDienste:	
	cd libhcan++/; make $(xx)
	cd telican/; make $(xx)
	cd libhcandata/; make dep; make $(xx)
	cd hcanswd/; make dep; make $(xx)
	cd hcandq/; make dep; make $(xx)
	
hcanweb_client: 
	cd hcanweb; make zip ver=unlabeled

hcanweb_server:
	cd hcanweb/server/C1612server; make clean; make all

firmware: 
	cd hcanbl; make $(xx) $(parm2)
	cd firmwares/controllerboard-1612-v01; make $(xx) $(parm2)
	cd firmwares/userpanel-v01; make $(xx) $(parm2)

firmwareOhneEds:	
	cd firmwares/hostinterface-v02; make $(xx)
	cd firmwares/usv-modul; make $(xx)



release: 
	cd firmwares/controllerboard-1612-v01; make release MCU=atmega32
	cd firmwares/controllerboard-1612-v01; make release MCU=atmega644
	cd firmwares/userpanel-v01; make release MCU=atmega32
	cd firmwares/userpanel-v01; make release MCU=atmega644
	cd firmwares/hostinterface-v02; make release
	cd firmwares/usv-modul; make release	
