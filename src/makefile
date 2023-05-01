# Borland C++ 3.1

ENTER=cd
LEAVE=$(ENTER) ..
COPY=copy
DELETE=del

all: build release

#------------------------- BUILD ------------------------- #

build: xosl xoslload install ipl

xosl: exesplit
    $(ENTER) xosl
    $(MAKEDIR)\make
    ..\exesplit\split
    $(LEAVE)

exesplit:
    $(ENTER) exesplit
    $(MAKEDIR)\make
    $(LEAVE)

xoslload:
    $(ENTER) xoslload
    $(MAKEDIR)\make
    $(LEAVE)

install:
    $(ENTER) install
    $(MAKEDIR)\make
    $(LEAVE)

ipl:
    $(ENTER) ipl
    $(ENTER) ipl_brec
    $(MAKEDIR)\make
    $(LEAVE)
    $(ENTER) ipl_mbr
    $(MAKEDIR)\make
    $(LEAVE)
    $(LEAVE)

#------------------------- RELEASE ------------------------- #

release:
    $(COPY) "xosl\*.xxf" "D:\"
    $(COPY) "xoslload\xoslload.xcf" "D:\"
    $(COPY) "install\install.exe" "D:\"
    $(COPY) "ipl\ipl_brec\*.bin" "D:\"
    $(COPY) "ipl\ipl_mbr\*.bin" "D:\"
    $(COPY) "resource\*.*" "D:\"

#------------------------- CLEAN ------------------------- #

clean: clean_release clean_xosl clean_xoslload clean_install clean_ipl clean_exesplit

clean_release:
    $(DELETE) "D:\*.xxf"
    $(DELETE) "D:\*.xcf"
    $(DELETE) "D:\*.xff"
    $(DELETE) "D:\*.xbf"
    $(DELETE) "D:\*.exe"
    $(DELETE) "D:\*.bin"
    $(DELETE) "D:\*.mbr"
    $(DELETE) "D:\*.txt"
    $(LEAVE)

clean_xosl:
    $(ENTER) xosl
    $(MAKEDIR)\make clean
    $(DELETE) XOSLIMG*.XXF
    $(LEAVE)

clean_xoslload:
    $(ENTER) xoslload
    $(MAKEDIR)\make clean
    $(LEAVE)

clean_install:
    $(ENTER) install
    $(MAKEDIR)\make clean
    $(LEAVE)

clean_ipl:
    $(ENTER) ipl
    $(ENTER) ipl_brec
    $(MAKEDIR)\make clean
    $(LEAVE)
    $(ENTER) ipl_mbr
    $(MAKEDIR)\make clean
    $(LEAVE)
    $(LEAVE)

clean_exesplit:
    $(ENTER) exesplit
    $(MAKEDIR)\make clean
    $(LEAVE)