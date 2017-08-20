BUILDDIR      = build
TOOLSDIR      = tools
FLOPPYIMG     = $(BUILDDIR)/bootfloppy.img
XOSLFILES     = $(BUILDDIR)/xosl-files
FLOPPYMASTER  = $(TOOLSDIR)/FDOEM.144.gz
XOSLFLOPPYDIR = ::\XOSL
RESULTFILE    = $(BUILDDIR)/RESULT
XOSLSRCBIN    = src/Arch

define CheckDosBoxResult
	[ -f $(RESULTFILE) ] && [ "$$(tr -d '\015' < $(RESULTFILE))" = "0" ]
endef

.PHONY: all compile floppy clean
.INTERMEDIATE: $(foreach x,build clean,$(BUILDDIR)/$x-gen.conf)

all: floppy

floppy: $(FLOPPYIMG)

$(FLOPPYIMG): compile
	gunzip < $(FLOPPYMASTER) > $(FLOPPYIMG)
	mmd -i $(FLOPPYIMG) $(XOSLFLOPPYDIR)
	mcopy -i $(FLOPPYIMG) $(XOSLFILES)/* $(XOSLFLOPPYDIR)

compile: $(BUILDDIR)/build-gen.conf
	cd $(BUILDDIR) && dosbox -conf build-gen.conf
	$(call CheckDosBoxResult)
	install -D -t $(XOSLFILES) $(XOSLSRCBIN)/*

clean: $(BUILDDIR)/clean-gen.conf
	cd $(BUILDDIR) && dosbox -conf clean-gen.conf
	$(call CheckDosBoxResult)
	rm -rf $(BUILDDIR)/*

$(BUILDDIR)/%-gen.conf: $(TOOLSDIR)/dosbox.conf $(TOOLSDIR)/%.conf
	cat $^ > $@

# vi: set noet ts=4:
