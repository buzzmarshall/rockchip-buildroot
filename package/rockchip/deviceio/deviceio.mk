DEVICEIO_SITE = $(TOPDIR)/../external/deviceio
DEVICEIO_SITE_METHOD = local
DEVICEIO_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_CYPRESS_BSA), y)
DEVICEIO_CYPRESS_BSA = $(TOPDIR)/../external/bluetooth_bsa/3rdparty/embedded/bsa_examples/linux
DEVICEIO_CONF_OPTS += -DBSA=TRUE -DCYPRESS=TRUE \
		-DCMAKE_C_FLAGS="${CMAKE_C_FLAGS} -I$(DEVICEIO_CYPRESS_BSA)/libbsa/include -I$(DEVICEIO_CYPRESS_BSA)/app_common/include" \
		-DCMAKE_CXX_FLAGS="${CMAKE_C_FLAGS} -I$(DEVICEIO_CYPRESS_BSA)/libbsa/include -I$(DEVICEIO_CYPRESS_BSA)/app_common/include"
DEVICEIO_DEPENDENCIES += cypress_bsa
else ifeq ($(BR2_PACKAGE_BROADCOM_BSA), y)
#DEVICEIO_CONF_OPTS += -DBSA=TRUE -DBROADCOM=TRUE

# use cypress first, to avoid can't compile if select broadcom bsa
DEVICEIO_CYPRESS_BSA = $(TOPDIR)/../external/bluetooth_bsa/3rdparty/embedded/bsa_examples/linux
DEVICEIO_CONF_OPTS += -DBSA=TRUE -DCYPRESS=TRUE \
		-DCMAKE_C_FLAGS="${CMAKE_C_FLAGS} -I$(DEVICEIO_CYPRESS_BSA)/libbsa/include -I$(DEVICEIO_CYPRESS_BSA)/app_common/include" \
		-DCMAKE_CXX_FLAGS="${CMAKE_C_FLAGS} -I$(DEVICEIO_CYPRESS_BSA)/libbsa/include -I$(DEVICEIO_CYPRESS_BSA)/app_common/include"
DEVICEIO_DEPENDENCIES += cypress_bsa
else
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS), y)
DEVICEIO_CONF_OPTS += -DBLUEZ5_UTILS=TRUE
endif

DEVICEIO_CONF_OPTS += -DBLUEZ=TRUE
DEVICEIO_DEPENDENCIES += bluez5_utils libglib2
endif

ifeq ($(call qstrip,$(BR2_ARCH)), arm)
DEVICEIO_BUILD_TYPE = arm
else ifeq ($(call qstrip, $(BR2_ARCH)), aarch64)
DEVICEIO_BUILD_TYPE = arm64
endif

DEVICEIO_CONF_OPTS += -DCPU_ARCH=$(BR2_ARCH) -DBUILD_TYPE=$(DEVICEIO_BUILD_TYPE)

DEVICEIO_DEPENDENCIES += wpa_supplicant alsa-lib

$(eval $(cmake-package))
