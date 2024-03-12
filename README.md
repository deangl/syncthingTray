## syncthingTray

把syncthingTray.exe放到syncthing的文件夹中就可以用。
功能说明：
* 在syncthingTray存活的期间，会保持syncthing alive
* 右键关闭syncthingTray，可选择只关Tray还是也关server
* 会定期查找变化，如果有，在Tray提示，默认2秒一次
* 文件夹里如果有 _trayconf.json，会使用其中的配置，配置项有：consoleUrl；configFile；checkInterval
* 双击打开控制台
