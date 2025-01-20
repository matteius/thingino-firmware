WIFI_SSV6X5X_SITE_METHOD = git
WIFI_SSV6X5X_SITE = https://github.com/jimsmt/ssv6x5x

# Determine the branch based on selected chip model
# Group A: pid_6000 branch chips (default)
SSV6X5X_PID6000_CHIPS := \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SSV6051P) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6151P) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6152P) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6155P) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6156P) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6166F) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6167Q) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6245) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6255P) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6256P) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6267Q)

# Group B: pid_6011 branch chips
SSV6X5X_PID6011_CHIPS := \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6115) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6318) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6355) \
	$(BR2_PACKAGE_WIFI_SSV6X5X_SV6358)

# Default values (pid_6000 group)
WIFI_SSV6X5X_SITE_BRANCH = pid_6000
WIFI_SSV6X5X_VERSION = 9c561443ab98352f028950636b24e86d484a2d4e

# Override for pid_6011 branch chips
ifneq ($(filter y,$(SSV6X5X_PID6011_CHIPS)),)
	WIFI_SSV6X5X_SITE_BRANCH = pid_6011
	WIFI_SSV6X5X_VERSION = caac9e093548e1a8ff0d5d9b391b52062b23d830
endif

$(info SSV6X5X branch is $(WIFI_SSV6X5X_SITE_BRANCH))

# $(shell git ls-remote $(WIFI_SSV6X5X_SITE) $(WIFI_SSV6X5X_SITE_BRANCH) | head -1 | cut -f1)

WIFI_SSV6X5X_LICENSE = GPL-2.0
WIFI_SSV6X5X_LICENSE_FILES = COPYING

define WIFI_SSV6X5X_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_WLAN)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WIRELESS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WIRELESS_EXT)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WEXT_CORE)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WEXT_PROC)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WEXT_PRIV)
	$(call KCONFIG_SET_OPT,CONFIG_CFG80211,y)
	$(call KCONFIG_SET_OPT,CONFIG_MAC80211,y)
	$(call KCONFIG_ENABLE_OPT,CONFIG_MAC80211_RC_MINSTREL)
	$(call KCONFIG_ENABLE_OPT,CONFIG_MAC80211_RC_MINSTREL_HT)
	$(call KCONFIG_ENABLE_OPT,CONFIG_MAC80211_RC_DEFAULT_MINSTREL)
	$(call KCONFIG_SET_OPT,CONFIG_MAC80211_RC_DEFAULT,"minstrel_ht")
endef

define WIFI_SSV6X5X_COPY_CONFIG
	$(INSTALL) -m 755 -d $(TARGET_DIR)/usr/share/wifi
	$(INSTALL) -m 644 $(WIFI_SSV6X5X_PKGDIR)/files/* $(TARGET_DIR)/usr/share/wifi
endef

WIFI_SSV6X5X_PRE_CONFIGURE_HOOKS += WIFI_SSV6X5X_COPY_CONFIG

$(eval $(kernel-module))
$(eval $(generic-package))
