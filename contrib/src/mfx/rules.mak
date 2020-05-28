# mfx (Media SDK)

mfx_GITURL := https://github.com/lu-zero/mfx_dispatch.git
MFX_GITHASH := c51a54c15f51579804030c70592c0a26065f1242

ifeq ($(call need_pkg,"mfx"),)
PKGS_FOUND += mfx
endif
ifdef HAVE_WIN32
ifeq ($(filter arm aarch64, $(ARCH)),)
PKGS += mfx
endif
endif

MFX_CFLAGS := $(CFLAGS)
MFX_CXXFLAGS := $(CFLAGS)

ifdef HAVE_WINSTORE
MFX_CFLAGS   += -DMEDIASDK_UWP_LOADER -DMEDIASDK_UWP_PROCTABLE
MFX_CXXFLAGS += -DMEDIASDK_UWP_LOADER -DMEDIASDK_UWP_PROCTABLE
endif

$(TARBALLS)/mfx-$(MFX_GITHASH).tar.xz:
	$(call download_git,$(mfx_GITURL),,$(MFX_GITHASH))

.sum-mfx: mfx-$(MFX_GITHASH).tar.xz
	$(call check_githash,$(MFX_GITHASH))
	touch $@

mfx: mfx-$(MFX_GITHASH).tar.xz .sum-mfx
	$(UNPACK)
	cd $(UNPACK_DIR) && autoreconf -ivf
	$(MOVE)

.mfx: mfx
	cd $< && $(HOSTVARS) CFLAGS="$(MFX_CFLAGS)" CXXFLAGS="$(MFX_CXXFLAGS)" ./configure $(HOSTCONF)
	cd $< && $(MAKE) install
	touch $@
