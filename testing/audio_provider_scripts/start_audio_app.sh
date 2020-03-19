#!/system/bin/sh
echo "Starting audio application"
monkey -p "com.android.music" -s 2 -v 5000
