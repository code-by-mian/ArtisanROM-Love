LOG_STEP_IN "- Add AirCommand"
ADD_TO_WORK_DIR "$SRC_DIR/prebuilts/extras" "system" "system/priv-app/AirCommand/AirCommand.apk" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding SPen SEC Feature"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.spen_usp_level40.xml" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT
