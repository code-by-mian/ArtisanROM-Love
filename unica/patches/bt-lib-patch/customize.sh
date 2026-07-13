# ==============================================================================
#
# MOD_NAME="Bluetooth library patcher"
# MOD_AUTHOR="3arthur6 & duhansysl "
# MOD_DESC="Fixes Bluetooth JNI issues for ArtisanROM source (skip missing sequences)."
#
# ==============================================================================

# Extract libbluetooth_jni.so if missing
if [ ! -f "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" ]; then
    LOG_STEP_IN "- Extracting libbluetooth_jni.so from com.android.bt.apex"

    [ -d "$TMP_DIR" ] && EVAL "rm -rf \"$TMP_DIR\""
    mkdir -p "$TMP_DIR"

    EVAL "unzip -j \"$WORK_DIR/system/system/apex/com.android.bt.apex\" \"apex_payload.img\" -d \"$TMP_DIR\""

    if ! sudo -n -v &> /dev/null; then
        LOG "\033[0;33m! Asking user for sudo password\033[0m"
        if ! sudo -v 2> /dev/null; then
            ABORT "Root permissions are required to unpack APEX image"
        fi
    fi

    mkdir -p "$TMP_DIR/tmp_out"
    EVAL "sudo mount -o ro \"$TMP_DIR/apex_payload.img\" \"$TMP_DIR/tmp_out\""
    EVAL "sudo cat \"$TMP_DIR/tmp_out/lib64/libbluetooth_jni.so\" > \"$WORK_DIR/system/system/lib64/libbluetooth_jni.so\""

    EVAL "sudo umount \"$TMP_DIR/tmp_out\""
    rm -rf "$TMP_DIR"

    SET_METADATA "system" "system/lib64/libbluetooth_jni.so" 0 0 644 "u:object_r:system_lib_file:s0"

    LOG_STEP_OUT
fi

# Apply patches for SDK 36
if [ "$SOURCE_PLATFORM_SDK_VERSION" -eq 36 ]; then
    # Disable VaultKeeper support (S22 Ultra base)
    # Before: 00122a0140395f01086b00020054
    # After:  00122a0140395f01086bde030014
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "00122a0140395f01086b00020054" "00122a0140395f01086bde030014" || LOG "- Skipping missing S22 Ultra patch"

    # Disable VaultKeeper support (S22 base)
    # Before: 2897773948050037
    # After:  289777392a000014
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "2897673948050037" "289777392a000014" || LOG "- Skipping missing S22 base patch"

else
    LOG "\033[0;33m! Unsupported SDK/API level: $SOURCE_PLATFORM_SDK_VERSION — skipping Bluetooth patch\033[0m"
fi
