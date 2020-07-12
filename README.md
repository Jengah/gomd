# gomd

Quickly display formatted markdown files in your browser.  

![working-app](https://github.com/wojciechkepka/gomd/blob/master/gomd.gif)

## About
`gomd` sets up a http server rendering markdown files in selected flavour and theme.  
By default when running `gomd` it will look for files in `.` and bind to `127.0.0.1:5001`.

To change default port and address use `--bind-port` and `--bind-addr`.
For example:
    `gomd --bind-port 1337 --bind-addr 192.168.0.1`

To view a different directory use:
    `gomd --dir /some/different/directory`

You can view the files in dark and light mode.